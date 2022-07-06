<#
.SYNOPSIS
Get an outline of all modules features for each module contained in the given path

.DESCRIPTION
Get a list of objects that outline of all modules features for each module contained in the given path (for example child-modules, RBAC, Private Endpoints, etc.)

NOTE: Currently only supports modules using the Bicep DSL

.PARAMETER moduleFolderPath
Optional. The path to the modules.

.PARAMETER returnMarkdown
Optional. Instead of returning the list of objects, instead format them into a markdown table and return it as a string.

.PARAMETER onlyTopLevel
Optional. Only consider top-level modules (that is, no child-modules).

.EXAMPLE
Get-ModulesFeatureOutline

Get an outline of all modules in the default module path.

.EXAMPLE
Get-ModulesFeatureOutline -returnMarkdown -onlyTopLevel

Get an outline of top-level modules in the default module path, formatted in a markdown table.
#>
function Get-ModulesFeatureOutline {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $moduleFolderPath = (Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'modules'),

        [Parameter(Mandatory = $false)]
        [switch] $returnMarkdown,

        [Parameter(Mandatory = $false)]
        [switch] $onlyTopLevel
    )

    if ($onlyTopLevel) {
        $moduleTemplatePaths = (Get-ChildItem $moduleFolderPath -Recurse -Filter 'deploy.bicep' -Depth 2).FullName
    } else {
        $moduleTemplatePaths = (Get-ChildItem $moduleFolderPath -Recurse -Filter 'deploy.bicep').FullName
    }

    ####################
    #   Collect data   #
    ####################
    $moduleData = [System.Collections.ArrayList]@()
    foreach ($moduleTemplatePath in $moduleTemplatePaths) {

        $fullResourcePath = (Split-Path $moduleTemplatePath -Parent).Replace('\', '/').split('/modules/')[1]
        $moduleContentArray = Get-Content -Path $moduleTemplatePath
        $moduleContentString = Get-Content -Path $moduleTemplatePath -Raw

        # Supports RBAC
        $supportsRBAC = [regex]::Match($moduleContentString, '(?m)^\s*param roleAssignments array\s*=.+').Success

        # Supports Locks
        $supportsLocks = [regex]::Match($moduleContentString, '(?m)^\s*param lock string\s*=.+').Success

        # Supports Tags
        $supportsTags = [regex]::Match($moduleContentString, '(?m)^\s*param tags object\s*=.+').Success

        # Supports Diagnostics
        $supportsDiagnostics = [regex]::Match($moduleContentString, '(?m)^\s*param diagnosticWorkspaceId string\s*=.+').Success

        # Supports Private Endpoints
        $supportsEndpoints = [regex]::Match($moduleContentString, '(?m)^\s*param privateEndpoints array\s*=.+').Success

        # Supports PIPs
        $supportsPipDeployment = [regex]::Match($moduleContentString, '(?m)^\s*param publicIPAddressObject object\s*=.+').Success

        # Number of children
        $childFolderPaths = (Get-ChildItem -Path (Split-Path $moduleTemplatePath -Parent) -Recurse -Directory).FullName | Where-Object { $_ -and (Split-Path $_ -Leaf) -match '^\w+' }
        $levelsOfNesting = @()
        foreach ($childFolderPath in $childFolderPaths) {
            $simplifiedPath = $childFolderPath.Replace('\', '/').split("$fullResourcePath/")[1]
            $levelsOfNesting += ($simplifiedPath -split '/').Count
        }
        $groupedNesting = $levelsOfNesting | Group-Object | Sort-Object -Property 'Name'
        $numberOfChildrenFormatted = '[{0}]' -f (($groupedNesting | ForEach-Object { 'L{0}:{1}' -f $_.Name, $_.Count }) -join ', ')

        # Number of lines
        $numberOfLines = ($moduleContentArray | Where-Object { -not [String]::IsNullOrEmpty($_) }).Count + 1

        $moduleData += [ordered]@{
            Module               = $fullResourcePath -replace 'Microsoft.', 'MS.'
            'Has RBAC'           = $supportsRBAC
            'Has locks'          = $supportsLocks
            'Has tags'           = $supportsTags
            'Has diagnostics'    = $supportsDiagnostics
            'Has endpoints'      = $supportsEndpoints
            'Has Pip-Deployment' = $supportsPipDeployment
            '# children'         = $numberOfChildrenFormatted
            '# lines'            = $numberOfLines
        }
    }


    #######################
    #   Generate output   #
    #######################
    if ($returnMarkdown) {
        $markdownTable = [System.Collections.ArrayList]@(
            '| {0} |' -f ($moduleData[0].Keys -join ' | ')
            '| {0} |' -f (($moduleData[0].Keys | ForEach-Object { '-' }) -join ' | ' )
        )

        foreach ($module in $moduleData) {
            $line = '| {0} |' -f (($moduleData[0].Keys | ForEach-Object { $module[$_] }) -join ' | ')
            $line = $line -replace 'True', ':white_check_mark:'
            $line = $line -replace 'False', ''
            $line = $line -replace '\[\]', ''
            $markdownTable += $line
        }

        return $markdownTable | Out-String

    } else {
        return $moduleData | ForEach-Object {
            [PSCustomObject] @{
                Module               = $_.Module
                'Has RBAC'           = $_.'Has RBAC'
                'Has locks'          = $_.'Has locks'
                'Has tags'           = $_.'Has tags'
                'Has diagnostics'    = $_.'Has diagnostics'
                'Has endpoints'      = $_.'Has endpoints'
                'Has Pip-Deployment' = $_.'Has Pip-Deployment'
                '# children'         = $_.'# children'
                '# lines'            = $_.'# lines'
            }
        }
    }
}
