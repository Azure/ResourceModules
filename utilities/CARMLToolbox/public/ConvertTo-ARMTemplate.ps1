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

.PARAMETER RepoRoot
Optional. The path to the root of the repo.

.PARAMETER ConvertChildren
Optional. Convert child resource modules to bicep.

.PARAMETER SkipMetadataCleanup
Optional. Skip Cleanup of Bicep metadata from json files

.PARAMETER SkipBicepCleanUp
Optional. Skip removal of bicep files and folders

.PARAMETER SkipPipelineUpdate
Optional. Skip replacing .bicep with .json in workflow files

.EXAMPLE
. .\utilities\tools\ConvertTo-ARMTemplate.ps1

Converts top level bicep modules to json-based ARM template, cleaning up all bicep files and folders and updating the workflow files to use the json files.

.EXAMPLE
. .\utilities\tools\ConvertTo-ARMTemplate.ps1 -ConvertChildren -SkipMetadataCleanup -SkipBicepCleanUp -SkipPipelineUpdate

Only converts top level bicep modules to json based ARM template, keeping metadata in json, keeping all bicep files and folders, and not updating workflows.

#>
function ConvertTo-ARMTemplate {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = $script:repoRoot,

        [Parameter(Mandatory = $false)]
        [switch] $ConvertChildren,

        [Parameter(Mandatory = $false)]
        [switch] $SkipMetadataCleanup,

        [Parameter(Mandatory = $false)]
        [switch] $SkipBicepCleanUp,

        [Parameter(Mandatory = $false)]
        [switch] $SkipPipelineUpdate
    )

    $modulesFolderPath = Join-Path $RepoRoot 'modules'
    if ($ConvertChildren) {
        $BicepFilesToConvert = Get-ChildItem -Path $modulesFolderPath -Filter 'deploy.bicep' -Recurse -Force
    } else {
        $BicepFilesToConvert = Get-ChildItem -Path $modulesFolderPath -Filter 'deploy.bicep' -Recurse -Force -Depth 2
    }

    #region Remove existing deploy.json files
    Write-Verbose 'Remove existing deploy.json files'

    if (Test-Path -Path (Join-Path $modulesFolderPath 'deploy.bicep')) {
        $JsonFilesToRemove = Get-ChildItem -Path $modulesFolderPath -Filter 'deploy.json' -Recurse -Force -File
        Write-Verbose "Remove existing deploy.json files - Remove [$($JsonFilesToRemove.count)] file(s)"
        if ($PSCmdlet.ShouldProcess("[$($JsonFilesToRemove.count)] deploy.json files(s) in path [$modulesFolderPath]", 'Remove-Item')) {
            $JsonFilesToRemove | Remove-Item -Force
        }
        Write-Verbose 'Remove existing deploy.json files - Done'
    }

    #endregion

    #region Convert bicep files to json
    Write-Verbose 'Convert bicep files to json'

    Write-Verbose "Convert bicep files to json - Processing [$($BicepFilesToConvert.count)] file(s)"
    if ($PSCmdlet.ShouldProcess("[$($BicepFilesToConvert.count)] deploy.bicep file(s) in path [$modulesFolderPath]", 'az bicep build')) {
        # parallelism is not supported on GitHub runners
        #$BicepFilesToConvert | ForEach-Object -ThrottleLimit $env:NUMBER_OF_PROCESSORS -Parallel {
        $BicepFilesToConvert | ForEach-Object {
            az bicep build --file $_
        }
    }

    Write-Verbose 'Convert bicep files to json - Done'
    #endregion

    #region Remove Bicep metadata from json
    if (-not $SkipMetadataCleanup) {
        Write-Verbose 'Remove Bicep metadata from json'

        Write-Verbose "Remove Bicep metadata from json - Processing [$($BicepFilesToConvert.count)] file(s)"
        if ($PSCmdlet.ShouldProcess("[$($BicepFilesToConvert.count)] deploy.bicep file(s) in path [$modulesFolderPath]", 'Set-Content')) {
            # parallelism is not supported on GitHub runners
            #$BicepFilesToConvert | ForEach-Object -ThrottleLimit $env:NUMBER_OF_PROCESSORS -Parallel {
            $BicepFilesToConvert | ForEach-Object {
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
                $JSONFilePath = Join-Path $moduleFolderPath 'deploy.json'
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

        $dotBicepFoldersToRemove = Get-ChildItem -Path $modulesFolderPath -Filter '.bicep' -Recurse -Force -Directory
        Write-Verbose "Remove bicep files and folders - Remove [$($dotBicepFoldersToRemove.count)] .bicep folder(s)"
        if ($PSCmdlet.ShouldProcess("[$($dotBicepFoldersToRemove.count)] .bicep folder(s) in path [$modulesFolderPath]", 'Remove-Item')) {
            $dotBicepFoldersToRemove | Remove-Item -Recurse -Force
        }

        $BicepFilesToRemove = Get-ChildItem -Path $modulesFolderPath -Filter '*.bicep' -Recurse -Force -File
        Write-Verbose "Remove bicep files and folders - Remove [$($BicepFilesToRemove.count)] *.bicep file(s)"
        if ($PSCmdlet.ShouldProcess("[$($BicepFilesToRemove.count)] *.bicep file(s) in path [$modulesFolderPath]", 'Remove-Item')) {
            $BicepFilesToRemove | Remove-Item -Force
        }

        Write-Verbose 'Remove bicep files and folders - Done'
    }
    #endregion

    #region Update pipeline files - Replace .bicep with .json in workflow files
    if (-not $SkipPipelineUpdate) {
        Write-Verbose 'Update pipeline files'

        # GitHub workflow files
        $ghWorkflowFolderPath = Join-Path -Path $RepoRoot '.github' 'workflows'
        if (Test-Path -Path $ghWorkflowFolderPath) {
            $ghWorkflowFilesToUpdate = Get-ChildItem -Path $ghWorkflowFolderPath -Filter 'ms.*.yml' -File -Force
            Write-Verbose ('Update workflow files - Processing [{0}] file(s)' -f $ghWorkflowFilesToUpdate.count)
            if ($PSCmdlet.ShouldProcess(('[{0}] ms.*.yml file(s) in path [{1}]' -f $ghWorkflowFilesToUpdate.Count, $ghWorkflowFolderPath), 'Set-Content')) {
                # parallelism is not supported on GitHub runners
                #$ghWorkflowFilesToUpdate | ForEach-Object -ThrottleLimit $env:NUMBER_OF_PROCESSORS -Parallel {
                $ghWorkflowFilesToUpdate | ForEach-Object {
                    $content = $_ | Get-Content
                    $content = $content -replace 'templateFilePath:(.*).bicep', 'templateFilePath:$1.json'
                    $_ | Set-Content -Value $content
                }
            }
        }

        # Azure DevOps Pipelines
        $adoPipelineFolderPath = Join-Path -Path $RepoRoot '.azuredevops' 'modulePipelines'
        if (Test-Path -Path $adoPipelineFolderPath) {
            $adoPipelineFilesToUpdate = Get-ChildItem -Path $adoPipelineFolderPath -Filter 'ms.*.yml' -File -Force
            Write-Verbose ('Update Azure DevOps pipeline files - Processing [{0}] file(s)' -f $adoPipelineFilesToUpdate.count)
            if ($PSCmdlet.ShouldProcess(('[{0}] ms.*.yml file(s) in path [{1}]' -f $adoPipelineFilesToUpdate.Count, $adoPipelineFolderPath), 'Set-Content')) {
                # parallelism is not supported on GitHub runners
                #$adoPipelineFilesToUpdate | ForEach-Object -ThrottleLimit $env:NUMBER_OF_PROCESSORS -Parallel {
                $adoPipelineFilesToUpdate | ForEach-Object {
                    $content = $_ | Get-Content
                    $content = $content -replace 'templateFilePath:(.*).bicep', 'templateFilePath:$1.json'
                    $_ | Set-Content -Value $content
                }
            }
        }

        Write-Verbose 'Update pipeline files - Done'
    }
    #endregion
}
