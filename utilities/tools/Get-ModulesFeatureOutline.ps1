<#
.SYNOPSIS
Get an outline of all modules features for each module contained in the given path

.DESCRIPTION
Get a list of objects that outline of all modules features for each module contained in the given path (for example child-modules, RBAC, Private Endpoints, etc.)

NOTE: Currently only supports modules using the Bicep DSL

.PARAMETER ModuleFolderPath
Optional. The path to the modules.

.PARAMETER ReturnMarkdown
Optional. Instead of returning the list of objects, instead format them into a markdown table and return it as a string.

.PARAMETER BreakMarkdownModuleNameAt
Optional. When `ReturnMarkdown` is set to true you can use this number to control if & where you'd want to line break the ModuleName column. Defaults to 1 (i.e., right after the provider namepsace).

.PARAMETER OnlyTopLevel
Optional. Only consider top-level modules (that is, no child-modules).

.EXAMPLE
Get-ModulesFeatureOutline

Get an outline of all modules in the default module path.

.EXAMPLE
Get-ModulesFeatureOutline -ReturnMarkdown -OnlyTopLevel

Get an outline of top-level modules in the default module path, formatted in a markdown table.

.EXAMPLE
Get-ModulesFeatureOutline -ReturnMarkdown -BreakMarkdownModuleNameAt 2

Get an outline of all modules in the default module path, formatted in a markdown table - with the module name column split after the top-level (i.e., <ProviderNamespace>/<ResourceType)

.NOTES
Children (if any) are displayed in format `[L1:5, L2:4, L3:1]`. Each item (separated via ',') shows the level of nesting in the front (e.g. L1) and the number of children in this level (separated by a colon ':').
In the above example, the module has 5 direct children, 4 of them have direct children themselves and 1 of them has 1 more child.
#>
function Get-ModulesFeatureOutline {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $ModuleFolderPath = (Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'modules'),

        [Parameter(Mandatory = $false)]
        [switch] $ReturnMarkdown,

        [Parameter(Mandatory = $false)]
        [int] $BreakMarkdownModuleNameAt = 1,

        [Parameter(Mandatory = $false)]
        [switch] $OnlyTopLevel
    )

    if ($OnlyTopLevel) {
        $moduleTemplatePaths = (Get-ChildItem $ModuleFolderPath -Recurse -Filter 'deploy.bicep' -Depth 2).FullName
    } else {
        $moduleTemplatePaths = (Get-ChildItem $ModuleFolderPath -Recurse -Filter 'deploy.bicep').FullName
    }

    ####################
    #   Collect data   #
    ####################
    $moduleData = [System.Collections.ArrayList]@()
    $summaryData = [ordered]@{
        supportsRBAC          = 0
        supportsLocks         = 0
        supportsTags          = 0
        supportsDiagnostics   = 0
        supportsEndpoints     = 0
        supportsPipDeployment = 0
        numberOfChildren      = 0
        numberOfLines         = 0
    }
    foreach ($moduleTemplatePath in $moduleTemplatePaths) {

        $fullResourcePath = (Split-Path $moduleTemplatePath -Parent).Replace('\', '/').split('/modules/')[1]
        $moduleContentArray = Get-Content -Path $moduleTemplatePath
        $moduleContentString = Get-Content -Path $moduleTemplatePath -Raw

        # Supports RBAC
        if ($supportsRBAC = [regex]::Match($moduleContentString, '(?m)^\s*param roleAssignments array\s*=.+').Success) {
            $summaryData.supportsRBAC++
        }

        # Supports Locks
        if ( $supportsLocks = [regex]::Match($moduleContentString, '(?m)^\s*param lock string\s*=.+').Success) {
            $summaryData.supportsLocks++
        }

        # Supports Tags
        if ( $supportsTags = [regex]::Match($moduleContentString, '(?m)^\s*param tags object\s*=.+').Success) {
            $summaryData.supportsTags++
        }

        # Supports Diagnostics
        if ($supportsDiagnostics = [regex]::Match($moduleContentString, '(?m)^\s*param diagnosticWorkspaceId string\s*=.+').Success) {
            $summaryData.supportsDiagnostics++
        }

        # Supports Private Endpoints
        if ( $supportsEndpoints = [regex]::Match($moduleContentString, '(?m)^\s*param privateEndpoints array\s*=.+').Success) {
            $summaryData.supportsEndpoints++
        }

        # Supports PIPs
        if ( $supportsPipDeployment = [regex]::Match($moduleContentString, '(?m)^\s*param publicIPAddressObject object\s*=.+').Success) {
            $summaryData.supportsPipDeployment++
        }

        # Number of children
        $childFolderPaths = (Get-ChildItem -Path (Split-Path $moduleTemplatePath -Parent) -Recurse -Directory).FullName | Where-Object { $_ -and (Split-Path $_ -Leaf) -match '^\w+' }
        $levelsOfNesting = @()
        foreach ($childFolderPath in $childFolderPaths) {
            $simplifiedPath = $childFolderPath.Replace('\', '/').split("$fullResourcePath/")[1]
            $levelsOfNesting += ($simplifiedPath -split '/').Count
        }
        $groupedNesting = $levelsOfNesting | Group-Object | Sort-Object -Property 'Name'
        $numberOfChildrenFormatted = '[{0}]' -f (($groupedNesting | ForEach-Object { 'L{0}:{1}' -f $_.Name, $_.Count }) -join ', ')
        $groupedNesting | ForEach-Object { $summaryData.numberOfChildren += $_.Count }

        # Number of lines
        $numberOfLines = ($moduleContentArray | Where-Object { -not [String]::IsNullOrEmpty($_) }).Count + 1
        $summaryData.numberOfLines += $numberOfLines

        $moduleData += [ordered]@{
            Module       = $fullResourcePath -replace 'Microsoft.', 'MS.'
            'RBAC'       = $supportsRBAC
            'Locks'      = $supportsLocks
            'Tags'       = $supportsTags
            'Diag'       = $supportsDiagnostics
            'PE'         = $supportsEndpoints
            'PIP'        = $supportsPipDeployment
            '# children' = $numberOfChildrenFormatted
            '# lines'    = $numberOfLines
        }
    }

    #######################
    #   Generate output   #
    #######################
    if ($ReturnMarkdown) {
        $markdownTable = [System.Collections.ArrayList]@(
            '| # | {0} |' -f ($moduleData[0].Keys -join ' | ')
            '| - | {0} |' -f (($moduleData[0].Keys | ForEach-Object { '-' }) -join ' | ' )
        )

        # Format module identifier
        foreach ($module in $moduleData) {
            $identifierParts = $module.Module.Replace('\', '/').split('/')
            if ($identifierParts.Count -gt $BreakMarkdownModuleNameAt) {
                $topLevelIdentifier = $identifierParts[0..($BreakMarkdownModuleNameAt - 1)] -join '/'
                $module.Module = '{0}<p>{1}' -f $topLevelIdentifier, ($module.Module -replace "$topLevelIdentifier/", '')
            }
        }

        # Add table data
        $counter = 1
        foreach ($module in ($moduleData | Sort-Object { $_.Module })) {
            $line = '| {0} | {1} |' -f $counter, (($moduleData[0].Keys | ForEach-Object { $module[$_] }) -join ' | ')
            $line = $line -replace 'True', ':white_check_mark:'
            $line = $line -replace 'False', ''
            $line = $line -replace '\[\]', ''
            $markdownTable += $line
            $counter++
        }

        $markdownTable += '| Sum | | {0} |' -f (($summaryData.Keys | ForEach-Object { $summaryData[$_] }) -join ' | ')

        return $markdownTable | Out-String

    } else {
        return @{
            data = $moduleData | ForEach-Object {
                [PSCustomObject] @{
                    Module       = $_.Module
                    'RBAC'       = $_.'RBAC'
                    'Locks'      = $_.'Locks'
                    'Tags'       = $_.'Tags'
                    'Diag'       = $_.'Diag'
                    'PE'         = $_.'PE'
                    'PIP'        = $_.'PIP'
                    '# children' = $_.'# children'
                    '# lines'    = $_.'# lines'
                }
            }
            sum  = $summaryData
        }
    }
}
