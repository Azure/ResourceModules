<#
.SYNOPSIS
Get the name specified in the given pipeline/workflow file.

.DESCRIPTION
Get the name specified in the given pipeline/workflow file.

.PARAMETER PipelineFilePath
Mandatory. The path to the pipeline/workflow to fetch the name from.

.EXAMPLE
Get-PipelineNameFromFile -FilePath 'C:/ResourceModules/.github/workflows/platform.assignPrToAuthor.yml'

Extract the name of the GitHub workflows specified in the file 'platform.assignPrToAuthor.yml'
#>
function Get-PipelineNameFromFile {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('WorkflowFilePath', 'PipelineFilePath')]
        [string] $FilePath
    )

    $lineIndex = 0
    $contentArray = Get-Content -Path $FilePath

    while ($contentArray[$lineIndex] -notlike 'name: *' -and $lineIndex -le $contentArray.count) {
        $lineIndex++
    }

    if ($lineIndex -eq $contentArray.count) {
        throw "Unable to find the name specification in pipeline/workflow file [$FilePath]"
    }

    if ($contentArray[$lineIndex] -match "name: ['|`"](.+)['|`"]") {
        return $Matches[1].Trim()
    } else {
        throw "Unable to determine name of pipeline in path [$FilePath]. The name should start with [name: ]"
    }
}
