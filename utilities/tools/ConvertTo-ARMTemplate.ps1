<#
.SYNOPSIS
This script converts the module library from bicep to json based ARM templates.

.DESCRIPTION
The script finds all 'main.bicep' files and converts them to json based ARM templates
by using the following steps:
1. Remove existing main.json files (unless RemoveExistingTemplates is disabled)
2. Convert bicep files to json
3. Remove Bicep metadata from json (unless SkipMetadataCleanup is enabled)
4. Remove bicep files and folders (unless SkipBicepCleanUp is enabled)
5. Update workflow files - Replace .bicep with .json in workflow files (unless SkipPipelineUpdate is enabled)

.PARAMETER RootPath
Optional. The full path to the root of the repository.

.PARAMETER ModulePath
Optional. The relative path to the folder hosting bicep templates to convert. Defaults to the whole library.

.PARAMETER SkipTest
Optional. Skip convertion of 'main.test.bicep' files.

.PARAMETER SkipMetadataCleanup
Optional. Skip cleanup of Bicep metadata from json files.

.PARAMETER SkipBicepCleanUp
Optional. Skip removal of bicep files and folders.

.PARAMETER SkipPipelineUpdate
Optional. Skip replacing .bicep with .json in workflow files.

.PARAMETER RemoveExistingTemplates
Optional. Remove existing 'main.json' and 'main.test.json' files in the given path.

.PARAMETER RunSynchronous
Optional. Don't run the code using multiple threads. May be necessary if context does not support it

.EXAMPLE
ConvertTo-ARMTemplate

Converts bicep modules to json-based ARM template, cleaning up all bicep files and folders and updating the workflow files to use the json files.

.EXAMPLE
ConvertTo-ARMTemplate -RemoveExistingTemplates -SkipMetadataCleanup -SkipBicepCleanUp -SkipPipelineUpdate -SkipTest -Verbose

Regenerates compiled 'main.json' for the whole library.

.EXAMPLE
ConvertTo-ARMTemplate -ModuleRelativePath "modules\desktop-virtualization\application-groups" -RemoveExistingTemplates -SkipMetadataCleanup -SkipBicepCleanUp -SkipPipelineUpdate -SkipTest -Verbose

Regenerates compiled 'main.json' for the provided ModuleRelativePath folder.

#>
function ConvertTo-ARMTemplate {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $RootPath = (Get-Item $PSScriptRoot).Parent.Parent.FullName,

        [Parameter(Mandatory = $false)]
        [string] $ModuleRelativePath = 'modules',

        [Parameter(Mandatory = $false)]
        [switch] $SkipTest,

        [Parameter(Mandatory = $false)]
        [switch] $SkipMetadataCleanup,

        [Parameter(Mandatory = $false)]
        [switch] $SkipBicepCleanUp,

        [Parameter(Mandatory = $false)]
        [switch] $SkipPipelineUpdate,

        [Parameter(Mandatory = $false)]
        [switch] $RemoveExistingTemplates,

        [Parameter(Mandatory = $false)]
        [switch] $RunSynchronous
    )

    $Path = Join-Path $RootPath $ModuleRelativePath

    if (-not $SkipTest) {
        $BicepFilesToConvert = (Get-ChildItem -Path $Path -Include @('main.bicep', 'main.test.bicep') -Recurse -Force).FullName
    } else {
        $BicepFilesToConvert = (Get-ChildItem -Path $Path -Include @('main.bicep') -Recurse -Force).FullName
    }

    #region Remove existing main.json and main.test.bicep files
    if ($RemoveExistingTemplates) {
        $JsonFilesToRemove = (Get-ChildItem -Path $Path -Include @('main.json', 'main.test.json') -Recurse -Force -File).FullName
        Write-Verbose "# Remove existing [main.json / main.test.json] files - Remove [$($JsonFilesToRemove.count)] file(s)"
        foreach ($jsonFileToRemove in $JsonFilesToRemove) {
            if ($PSCmdlet.ShouldProcess(('JSON File in Path [{0}]' -f (($jsonFileToRemove -replace '\\', '/') -split '/modules/')[1]), 'Remove')) {
                $null = Remove-Item -Path $jsonFileToRemove -Force
            }
            Write-Verbose '   Remove existing main.json and main.test.json files - Done'
        }
    }
    #endregion

    #region Convert bicep files to json
    Write-Verbose "# Convert bicep files to json - Processing [$($BicepFilesToConvert.count)] file(s)"
    $buildScriptBlock = {
        if (-not $RemoveExistingTemplates) {
            Write-Verbose "   Building template [$_]" -Verbose
            bicep build $_
        } else {
            Write-Verbose "   Template [$_] already existing. Skipping overwriting." -Verbose
        }
    }
    if ($PSCmdlet.ShouldProcess(('Bicep [{0}] Templates' -f ($BicepFilesToConvert.count)), 'bicep build')) {
        if ($RunSynchronous) {
            $BicepFilesToConvert | ForEach-Object $buildScriptBlock
        } else {
            $BicepFilesToConvert | ForEach-Object -ThrottleLimit 4 -Parallel $buildScriptBlock
        }
    }
    Write-Verbose '   Convert bicep files to json - Done'
    #endregion

    #region Remove Bicep metadata `_generator` property from json
    if (-not $SkipMetadataCleanup) {
        Write-Verbose "# Remove Bicep metadata from json - Processing [$($BicepFilesToConvert.count)] file(s)"

        $removeScriptBlock = {
            # helper function start
            <#
            .SYNOPSIS
            Recursively remove 'metadata' `_generator` property from a provided object.

            .DESCRIPTION
            This object is expected to be an ARM template converted to a PowerShell custom object.
            It uses the object reference rather than recreating/copying the object.

            .PARAMETER TemplateObject
            Mandatory. The ARM template converted to a PowerShell custom object.

            .EXAMPLE
            Remove-JSONMetadata -TemplateObject (ConvertFrom-Json (Get-Content -Path $JSONFilePath -Raw))

            Reads content from a ARM/JSON file, converts it to a PSCustomObject and removes 'metadata' `_generator` property under the template and recursively on all nested deployments.
            #>
            function Remove-JSONMetadata {

                [CmdletBinding()]
                param (
                    [Parameter(Mandatory = $true)]
                    [psobject] $TemplateObject
                )

                if (($TemplateObject | Get-Member -MemberType 'NoteProperty').Name -contains 'metadata' -and ($TemplateObject.metadata | Get-Member -MemberType 'NoteProperty').Name -contains '_generator') {
                    $TemplateObject.metadata.psobject.properties.Remove('_generator')
                }

                $TemplateObject.resources | Where-Object { $_.type -eq 'Microsoft.Resources/deployments' } | ForEach-Object {
                    Remove-JSONMetadata -TemplateObject $_.properties.template
                }
            }
            # helper function end

            $jsonFilePath = Join-Path (Split-Path $_ -Parent) ('{0}.json' -f (Split-Path $_ -LeafBase))

            Write-Verbose ('   Removing metadata `_generator` property from file [{0}]' -f $jsonFilePath) -Verbose

            $JSONFileContent = Get-Content -Path $JSONFilePath
            $JSONObj = $JSONFileContent | ConvertFrom-Json
            Remove-JSONMetadata -TemplateObject $JSONObj

            $JSONFileContent = $JSONObj | ConvertTo-Json -Depth 100
            Set-Content -Value $JSONFileContent -Path $JSONFilePath
        }

        if ($PSCmdlet.ShouldProcess(('Metadata from [{0}] templates' -f ($BicepFilesToConvert.count)), 'Remove')) {
            if ($RunSynchronous) {
                $BicepFilesToConvert | ForEach-Object $removeScriptBlock
            } else {
                $BicepFilesToConvert | ForEach-Object -ThrottleLimit 4 -Parallel $removeScriptBlock
            }
        }
        Write-Verbose '   Remove Bicep metadata from json - Done' -Verbose
    }
    #endregion

    #region Remove bicep files and folders
    if (-not $SkipBicepCleanUp) {
        $dotBicepFoldersToRemove = Get-ChildItem -Path $Path -Filter '.bicep' -Recurse -Force -Directory
        Write-Verbose "# Remove bicep files and folders - Remove [$($dotBicepFoldersToRemove.count)] .bicep folder(s)"
        if ($PSCmdlet.ShouldProcess("[$($dotBicepFoldersToRemove.count)] .bicep folder(s) in path [$Path]", 'Remove-Item')) {
            $dotBicepFoldersToRemove | Remove-Item -Recurse -Force
        }

        $BicepFilesToRemove = Get-ChildItem -Path $Path -Filter '*.bicep' -Recurse -Force -File
        Write-Verbose "# Remove bicep files and folders - Remove [$($BicepFilesToRemove.count)] *.bicep file(s)"
        if ($PSCmdlet.ShouldProcess("[$($BicepFilesToRemove.count)] *.bicep file(s) in path [$Path]", 'Remove-Item')) {
            $BicepFilesToRemove | Remove-Item -Force
        }
        Write-Verbose 'Remove bicep files and folders - Done'
    }
    #endregion

    #region Update pipeline files - Replace .bicep with .json in all workflow files
    if (-not $SkipPipelineUpdate) {
        # GitHub workflow files
        $ghWorkflowFolderPath = Join-Path -Path $rootPath '.github' 'workflows'
        if (Test-Path -Path $ghWorkflowFolderPath) {
            $ghWorkflowFilesToUpdate = Get-ChildItem -Path $ghWorkflowFolderPath -Filter 'ms.*.yml' -File -Force
            Write-Verbose ('# Update workflow files - Processing [{0}] file(s)' -f $ghWorkflowFilesToUpdate.count)

            $ghWorkflowUpdateScriptBlock = {
                $content = $_ | Get-Content
                $content = $content -replace 'templateFilePath:(.*).bicep', 'templateFilePath:$1.json'
                $_ | Set-Content -Value $content
            }

            if ($PSCmdlet.ShouldProcess(('[{0}] ms.*.yml file(s) in path [{1}]' -f $ghWorkflowFilesToUpdate.Count, $ghWorkflowFolderPath), 'Set-Content')) {
                if ($RunSynchronous) {
                    $ghWorkflowFilesToUpdate | ForEach-Object $ghWorkflowUpdateScriptBlock
                } else {
                    $ghWorkflowFilesToUpdate | ForEach-Object -ThrottleLimit 4 -Parallel $ghWorkflowUpdateScriptBlock
                }
            }
        }

        # Azure DevOps Pipelines
        $adoPipelineFolderPath = Join-Path -Path $rootPath '.azuredevops' 'modulePipelines'
        if (Test-Path -Path $adoPipelineFolderPath) {
            $adoPipelineFilesToUpdate = Get-ChildItem -Path $adoPipelineFolderPath -Filter 'ms.*.yml' -File -Force
            Write-Verbose ('Update Azure DevOps pipeline files - Processing [{0}] file(s)' -f $adoPipelineFilesToUpdate.count)

            $adoPipelineUpdateScriptBlock = {
                $content = $_ | Get-Content
                $content = $content -replace 'templateFilePath:(.*).bicep', 'templateFilePath:$1.json'
                $_ | Set-Content -Value $content
            }

            if ($PSCmdlet.ShouldProcess(('[{0}] ms.*.yml file(s) in path [{1}]' -f $adoPipelineFilesToUpdate.Count, $adoPipelineFolderPath), 'Set-Content')) {

                if ($RunSynchronous) {
                    $adoPipelineFilesToUpdate | ForEach-Object $adoPipelineUpdateScriptBlock
                } else {
                    $adoPipelineFilesToUpdate | ForEach-Object -ThrottleLimit 4 -Parallel $adoPipelineUpdateScriptBlock
                }
            }
        }
        Write-Verbose 'Update pipeline files - Done'
    }
    #endregion
}
#endregion
