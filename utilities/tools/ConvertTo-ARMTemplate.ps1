<#
.SYNOPSIS
This script converts the module library from bicep to json based ARM templates.

.DESCRIPTION
The script finds all 'deploy.bicep' files and tries to convert them to json based ARM templates
by using the following steps.
1. Remove existing deploy.json files (to avoid collision)
2.a Convert deploy.bicep to deploy.json using bicep build
2.b Clean up the json file, i.e removing the metadata property
3. Remove bicep files and folders
4. Replace deploy.bicep with deploy.json in workflow files

.PARAMETER Path
Mandatory. The path to the root of the repo.

.PARAMETER CleanUp
Optional. Perform cleanup of bicep files after conversion.

.EXAMPLE
. .\utilities\tools\ConvertTo-ARMTemplate.ps1 -Path . -CleanUp -Verbose

Converts bicep modules to json based ARM template, cleaning up all bicep files after conversion.
#>
[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter()]
    [string] $Path = (Get-Location).Path,

    [Parameter()]
    [switch] $CleanUp,

    [Parameter()]
    [switch] $KeepChildResources
)

$rootPath = Get-Item -Path $Path | Select-Object -ExpandProperty 'FullName'
$armFolderPath = Join-Path -Path $rootPath -ChildPath 'arm'
if ($KeepChildResources) {
    $BicepFilesToConvert = Get-ChildItem -Path $armFolderPath -Filter 'deploy.bicep' -Recurse -Force
} else {
    $BicepFilesToConvert = Get-ChildItem -Path $armFolderPath -Filter 'deploy.bicep' -Recurse -Force -Depth 2
}

#region Remove existing json files
Write-Verbose 'Removing existing deploy.json files'
Get-ChildItem -Path $armFolderPath -Filter 'deploy.json' -Recurse -Force | Remove-Item -Force
Write-Verbose 'Removing existing deploy.json files - Done'
#endregion

#region Convert bicep files to json
Write-Verbose "Convert bicep files to json - Processing [$($BicepFilesToConvert.count)] files"
if ($PSCmdlet.ShouldProcess("[$($BicepFilesToConvert.count)] bicep file(s) in path [$armFolderPath]", 'az bicep build')) {
    $BicepFilesToConvert | ForEach-Object -ThrottleLimit $env:NUMBER_OF_PROCESSORS -Parallel {
        Invoke-Expression -Command "az bicep build --file '$_'"
    }
}
Write-Verbose 'Convert bicep files to json - Done'
#endregion

#region Remove Bicep metadata from json
Write-Verbose "$bicepModuleName - Remove Bicep metadata from json - Processing [$($BicepFilesToConvert.count)] files"
if ($PSCmdlet.ShouldProcess("[$($BicepFilesToConvert.count)] file(s) in path [$armFolderPath]", 'Set Content')) {
    $BicepFilesToConvert | ForEach-Object -ThrottleLimit $env:NUMBER_OF_PROCESSORS -Parallel {

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
            Write-Verbose "$bicepModuleName - Remove Bicep metadata from json - Done"
        } else {
            Write-Verbose "$bicepModuleName - Remove Bicep metadata from json - Skipped - File not found (deploy.json)"
        }
    }
}
Write-Verbose "$bicepModuleName - Remove Bicep metadata from json - Done"
#endregion

#region Remove bicep files and folders
if ($CleanUp) {
    Write-Verbose 'Remove bicep files and folders'

    $dotBicepFolders = Get-ChildItem -Path $armFolderPath -Filter '.bicep' -Recurse -Force -Directory
    Write-Verbose "Remove bicep files and folders - Remove [$($dotBicepFolders.count)] .bicep folders"
    if ($PSCmdlet.ShouldProcess("[$($dotBicepFolders.count)] .bicep folder(s) in path [$armFolderPath]", 'Remove')) {
        $dotBicepFolders | Remove-Item -Recurse -Force
    }
    Write-Verbose 'Remove bicep files and folders - Remove .bicep folders - Done'

    $BicepFilesToRemove = Get-ChildItem -Path $armFolderPath -Filter '*.bicep' -Recurse -Force -File
    Write-Verbose "Remove bicep files and folders - Remove [$($BicepFilesToRemove.count)] *.bicep files"
    if ($PSCmdlet.ShouldProcess("[$($BicepFilesToRemove.count)] *.bicep file(s) in path [$armFolderPath]", 'Remove')) {
        $BicepFilesToRemove | Remove-Item -Force
    }
    Write-Verbose 'Remove bicep files and folders - Remove all *.bicep files - Done'
}
#endregion

#region Replace .bicep with .json in workflow files
Write-Verbose 'Update workflow files'

$workflowFolderPath = Join-Path -Path $rootPath -ChildPath '.github\workflows'
$workflowFiles = Get-ChildItem -Path $workflowFolderPath -Filter 'ms.*.yml' -File -Force
Write-Verbose ('Update workflow files - Processing [{0}] files' -f $workflowFiles.count)
if ($PSCmdlet.ShouldProcess("[$($workflowFiles.count)] yml file(s) in path [$armFolderPath]", 'Set Content')) {
    $workflowFiles | ForEach-Object -ThrottleLimit $env:NUMBER_OF_PROCESSORS -Parallel {
        $content = $_ | Get-Content
        $content = $content.Replace("deploy.bicep", "deploy.json")
        $_ | Set-Content -Value $content
    }
}
Write-Verbose "Update workflow files - $($workflowFiles.count) files - Done"
#endregion
