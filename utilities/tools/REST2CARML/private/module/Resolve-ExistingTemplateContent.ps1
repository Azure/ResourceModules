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
        '^\s*$'
    )

    ############################
    ##   Extract Parameters   ##
    ############################
    $existingParameterBlocks = @()

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

        $existingParameterBlocks += @{
            content    = $templateContent[$paramStartIndex .. $paramEndIndex]
            startIndex = $paramStartIndex
            endIndex   = $paramEndIndex
        }
    }

    ###########################
    ##   Extract Variables   ##
    ###########################
    $existingVariableBlocks = @()

    $varIndexes = @()
    for ($index = 0; $index -lt $templateContent.Count; $index++) {
        if ($templateContent[$index] -like 'var *') {
            $varIndexes += $index
        }
    }

    foreach ($varIndex in $varIndexes) {

        # The var line is always the first line of a var
        $varStartIndex = $varIndex


        # Let's go 'down' until the var declarations end
        $varEndIndex = $varIndex
        while ($templateContent[$varEndIndex] -eq $templateContent[$varIndex] -or (($newLogicIdentifiersDown | Where-Object { $templateContent[$varEndIndex] -match $_ }).Count -eq 0 -and $varEndIndex -ne $templateContent.Count)) {
            $varEndIndex++
        }
        # Logic always counts one too far
        $varEndIndex--

        $existingVariableBlocks += @{
            content    = $templateContent[$varStartIndex .. $varEndIndex]
            startIndex = $varStartIndex
            endIndex   = $varEndIndex
        }
    }

    ###########################
    ##   Extract Resources   ##
    ###########################
    $existingdeploymentBlock = @()


    #########################
    ##   Extract Outputs   ##
    #########################
    $existingOutputBlocks = @()

    $outputIndexes = @()
    for ($index = 0; $index -lt $templateContent.Count; $index++) {
        if ($templateContent[$index] -like 'output *') {
            $outputIndexes += $index
        }
    }

    foreach ($outputIndex in $outputIndexes) {

        # Let's go 'up' until the output declarations end
        $outputStartIndex = $outputIndex
        while ($templateContent[$outputStartIndex] -eq $templateContent[$outputIndex] -or (($newLogicIdentifiersUp | Where-Object { $templateContent[$outputStartIndex] -match $_ }).Count -eq 0 -and $outputStartIndex -ne 0)) {
            $outputStartIndex--
        }
        # Logic always counts one too far
        $outputStartIndex++

        # The output line is always the last line of a output
        $outputEndIndex = $outputIndex

        $existingOutputBlocks += @{
            content    = $templateContent[$outputStartIndex .. $outputEndIndex]
            startIndex = $outputStartIndex
            endIndex   = $outputEndIndex
        }
    }

    return @{
        parameters = $existingParameterBlocks
        variables  = $existingVariableBlocks
        resources  = $existingVariableBlocks
        outputs    = $existingOutputBlocks
    }
}
Resolve-ExistingTemplateContent -TemplateFilePath 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules\Microsoft.Storage\storageAccounts\deploy.bicep'
