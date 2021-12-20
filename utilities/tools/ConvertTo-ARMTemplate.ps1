<#
.SYNOPSIS
This script converts the module library from bicep to json based ARM templates.

.DESCRIPTION
The script finds all 'deploy.bicep' files and tries to convert them to json based ARM templates
by using the following steps.
1. Remove existing deploy.json files
2. Convert bicep files to json
3. Remove Bicep metadata from json
4. Remove bicep files and folders
5. Update workflow files - Replace .bicep with .json in workflow files

.PARAMETER Path
Optional. The path to the root of the repo.

.PARAMETER ConvertChildren
Optional. Convert child resource modules to bicep.

.PARAMETER SkipMetadataCleanup
Optional. Skip Cleanup of Bicep metadata from json files

.PARAMETER SkipBicepCleanUp
Optional. Skip removal of bicep files and folders

.PARAMETER SkipWorkflowUpdate
Optional. Skip replacing .bicep with .json in workflow files

.EXAMPLE
. .\utilities\tools\ConvertTo-ARMTemplate.ps1

Converts top level bicep modules to json based ARM template, cleaning up all bicep files and folders and updating the workflow files to use the json files.

.EXAMPLE
. .\utilities\tools\ConvertTo-ARMTemplate.ps1 -ConvertChildren -SkipMetadataCleanup -SkipBicepCleanUp -SkipWorkflowUpdate

Only converts top level bicep modules to json based ARM template, keeping metadata in json, keeping all bicep files and folders, and not updating workflows.

#>
[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $false)]
    [string] $Path = (Get-Location).Path,

    [Parameter(Mandatory = $false)]
    [switch] $ConvertChildren,

    [Parameter(Mandatory = $false)]
    [switch] $SkipMetadataCleanup,

    [Parameter(Mandatory = $false)]
    [switch] $SkipBicepCleanUp,

    [Parameter(Mandatory = $false)]
    [switch] $SkipWorkflowUpdate
)

$rootPath = Get-Item -Path $Path | Select-Object -ExpandProperty 'FullName'
$armFolderPath = Join-Path -Path $rootPath -ChildPath 'arm'
if ($ConvertChildren) {
    $BicepFilesToConvert = Get-ChildItem -Path $armFolderPath -Filter 'deploy.bicep' -Recurse -Force
} else {
    $BicepFilesToConvert = Get-ChildItem -Path $armFolderPath -Filter 'deploy.bicep' -Recurse -Force -Depth 2
}

#region Remove existing deploy.json files
Write-Verbose 'Remove existing deploy.json files'

$JsonFilesToRemove = Get-ChildItem -Path $armFolderPath -Filter 'deploy.json' -Recurse -Force -File
Write-Verbose "Remove existing deploy.json files - Remove [$($JsonFilesToRemove.count)] file(s)"
if ($PSCmdlet.ShouldProcess("[$($JsonFilesToRemove.count)] deploy.json files(s) in path [$armFolderPath]", 'Remove-Item')) {
    $JsonFilesToRemove | Remove-Item -Force
}

Write-Verbose 'Remove existing deploy.json files - Done'
#endregion

#region Convert bicep files to json
Write-Verbose 'Convert bicep files to json'

Write-Verbose "Convert bicep files to json - Processing [$($BicepFilesToConvert.count)] file(s)"
if ($PSCmdlet.ShouldProcess("[$($BicepFilesToConvert.count)] deploy.bicep file(s) in path [$armFolderPath]", 'az bicep build')) {
    $BicepFilesToConvert | ForEach-Object -Parallel {
        Invoke-Expression -Command "az bicep build --file '$_'"
    }
}

Write-Verbose 'Convert bicep files to json - Done'
#endregion

#region Remove Bicep metadata from json
if (-not $SkipMetadataCleanup) {
    Write-Verbose 'Remove Bicep metadata from json'

    Write-Verbose "Remove Bicep metadata from json - Processing [$($BicepFilesToConvert.count)] file(s)"
    if ($PSCmdlet.ShouldProcess("[$($BicepFilesToConvert.count)] deploy.bicep file(s) in path [$armFolderPath]", 'Set-Content')) {
        $BicepFilesToConvert | ForEach-Object -Parallel {

            function Remove-JSONMetadata {
                <#
            .SYNOPSIS
            A function to recursively remove 'metadata' property from a provided object.
            This object is expected to be an ARM template converted to a PowerShell custom object.
            The function uses the object reference rather than recreating/copying the object.

            .PARAMETER TemplateObject
            Mandatory. The ARM template converted to a PowerShell custom object.

            .EXAMPLE
            $JSONFileContent = Get-Content -Path $JSONFilePath
            $JSONObj = $JSONFileContent | ConvertFrom-Json
            Remove-JSONMetadata -TemplateObject $JSONObj

            Reads content from a ARM/JSON file, converts it to a PSCustomObject and removes 'metadata' property under the template and recursively on all nested deployments.

            #>

                [CmdletBinding()]
                param (
                    [Parameter(Mandatory)]
                    [psobject] $TemplateObject
                )
                $TemplateObject.PSObject.Properties.Remove('metadata')
                $TemplateObject.resources | Where-Object { $_.type -eq 'Microsoft.Resources/deployments' } | ForEach-Object {
                    Remove-JSONMetadata -TemplateObject $_.properties.template
                }
            }

            $moduleFolderPath = $_.Directory.FullName
            $JSONFilePath = Join-Path -Path $moduleFolderPath -ChildPath 'deploy.json'
            if (Test-Path -Path $JSONFilePath) {
                $JSONFileContent = Get-Content -Path $JSONFilePath
                $JSONObj = $JSONFileContent | ConvertFrom-Json
                Remove-JSONMetadata -TemplateObject $JSONObj
                $JSONFileContent = $JSONObj | ConvertTo-Json -Depth 100
                Set-Content -Value $JSONFileContent -Path $JSONFilePath
            } else {
                Write-Warning "Remove Bicep metadata from json - Skipped $JSONFilePath - File not found (deploy.json)"
            }
        }
    }

    Write-Verbose 'Remove Bicep metadata from json - Done'
}
#endregion

#region Remove bicep files and folders
if (-not $SkipBicepCleanUp) {
    Write-Verbose 'Remove bicep files and folders'

    $dotBicepFoldersToRemove = Get-ChildItem -Path $armFolderPath -Filter '.bicep' -Recurse -Force -Directory
    Write-Verbose "Remove bicep files and folders - Remove [$($dotBicepFoldersToRemove.count)] .bicep folder(s)"
    if ($PSCmdlet.ShouldProcess("[$($dotBicepFoldersToRemove.count)] .bicep folder(s) in path [$armFolderPath]", 'Remove-Item')) {
        $dotBicepFoldersToRemove | Remove-Item -Recurse -Force
    }

    $BicepFilesToRemove = Get-ChildItem -Path $armFolderPath -Filter '*.bicep' -Recurse -Force -File
    Write-Verbose "Remove bicep files and folders - Remove [$($BicepFilesToRemove.count)] *.bicep file(s)"
    if ($PSCmdlet.ShouldProcess("[$($BicepFilesToRemove.count)] *.bicep file(s) in path [$armFolderPath]", 'Remove-Item')) {
        $BicepFilesToRemove | Remove-Item -Force
    }

    Write-Verbose 'Remove bicep files and folders - Done'
}
#endregion

#region Update workflow files - Replace .bicep with .json in workflow files
if (-not $SkipWorkflowUpdate) {
    Write-Verbose 'Update workflow files'

    $workflowFolderPath = Join-Path -Path $rootPath -ChildPath '.github\workflows'
    $workflowFilesToUpdate = Get-ChildItem -Path $workflowFolderPath -Filter 'ms.*.yml' -File -Force
    Write-Verbose "Update workflow files - Processing [$($workflowFilesToUpdate.count)] file(s)"
    if ($PSCmdlet.ShouldProcess("[$($workflowFilesToUpdate.count)] ms.*.yml file(s) in path [$armFolderPath]", 'Set-Content')) {
        $workflowFilesToUpdate | ForEach-Object -Parallel {
            $content = $_ | Get-Content
            $content = $content.Replace('deploy.bicep', 'deploy.json')
            $_ | Set-Content -Value $content
        }
    }

    Write-Verbose 'Update workflow files - Done'
}
#endregion
