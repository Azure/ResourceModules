function Resolve-ExistingTemplateContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath
    )

    if (-not (Test-Path $TemplateFilePath)) {
        return
    }

    $templateContent = Get-Content -Path $TemplateFilePath

    # Any keyword when moving from the current line up to indicate that it's a new declaration
    $newLogicIdentifiersUp = @(
        '^targetScope.+$',
        '^param .+$',
        '^var .+$',
        '^resource .+$',
        '^module .+$',
        '^output .+$',
        '^//.*$'
        '^\s*$'
    )
    # Any keyword when moving from the current line down to indicate that it's a new declaration
    $newLogicIdentifiersDown = @(
        '^param .+$',
        '^var .+$',
        '^resource .+$',
        '^module .+$',
        '^output .+$',
        '^//.*$',
        '^@.+$',
        '^\s+$'
    )

    ############################
    ##   Extract Parameters   ##
    ############################
    $existingParametersBlock = @()

    $paramIndexes = @()
    for ($index = 0; $index -lt $templateContent.Count; $index++) {
        if ($templateContent[$index] -like 'param *') {
            $paramIndexes += $index
        }
    }

    foreach ($paramIndex in $paramIndexes) {

        # Let's go 'up' until the param declarations end
        $paramStartIndex = $paramIndex
        while ($templateContent[$paramStartIndex] -eq $templateContent[$paramIndex] -or (($newLogicIdentifiersUp | Where-Object { $templateContent[$paramStartIndex] -match $_ }).Count -eq 0 -and $paramStartIndex -ne 0)) {
            $paramStartIndex--
        }
        # Logic always counts one too far
        $paramStartIndex++

        # The param line is always the last line of a param
        $paramEndIndex = $paramIndex

        $existingParametersBlock += @{
            content    = $templateContent[$paramStartIndex .. $paramIndex]
            startIndex = $paramStartIndex
            endIndex   = $paramEndIndex
        }
    }

    ###########################
    ##   Extract Variables   ##
    ###########################
    $existingVariablesBlock = @()
    $existingdeploymentBlock = @()
    $existingOutputsBlock = @()
}
Resolve-ExistingTemplateContent -TemplateFilePath 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules\Microsoft.Storage\storageAccounts\deploy.bicep'
