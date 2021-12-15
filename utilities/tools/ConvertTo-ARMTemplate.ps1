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
    [switch] $SkipChildResources
)

#region Helper functions

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
function Remove-JSONMetadata {
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

<#
.SYNOPSIS
Gets the folder objects for the child resources of the provided parent folder.

.DESCRIPTION
Gets the folder objects for the child resources of the provided parent folder.
This will check for the existence of the child resources and if found, will return the folder objects.
The criteria for the child resource folder is that the folder contains a 'deploy.json' file.

.PARAMETER Path
Path to the parent resource folder.

.EXAMPLE
Get-ChildResourceFolder -Path 'C:\Repos\Azure\ResourceModules\arm\Microsoft.Storage\storageAccounts'

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----          15.12.2021    15:27                blobServices
l----          15.12.2021    15:27                fileServices
l----          15.12.2021    15:27                managementPolicies
l----          15.12.2021    15:27                queueServices
l----          15.12.2021    15:27                tableServices

Gets the folder objects for the child resources of the provided parent folder.

#>
function Get-ChildResourceFolder {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    return Get-ChildItem -Path $Path -Filter 'deploy.json' -Recurse -Depth 1 -Force | Select-Object -ExpandProperty 'Directory' | Get-Item

}

#endregion

$rootPath = Get-Item -Path $Path | Select-Object -ExpandProperty 'FullName'
$armFolderPath = Join-Path -Path $rootPath -ChildPath 'arm'


# Remove existing json files
Write-Verbose "Removing existing deploy.json files"
Get-ChildItem -Path $armFolderPath -Filter 'deploy.json' -Recurse -Force | ForEach-Object {
    if ($PSCmdlet.ShouldProcess("File in path [$($_.FullName)]", 'Remove')) {
        Remove-Item -Path $_.FullName -Force
    }
}
Write-Verbose "$bicepFilePath - Removing existing deploy.json files - Done"

# Process all deploy.bicep files
$bicepFiles = Get-ChildItem -Path $armFolderPath -Filter 'deploy.bicep' -Recurse -Force -Depth 2
Write-Verbose "Convert bicep to json - $($bicepFiles.count) files"
foreach ($bicepFile in $bicepFiles) {
    $bicepFilePath = $bicepFile.FullName
    Write-Verbose "$bicepFilePath - Processing"
    $moduleFolderPath = $bicepFile.Directory.FullName
    Write-Verbose "$bicepFilePath - ModuleFolderPath - $moduleFolderPath"
    $bicepFolderPath = Join-Path -Path $moduleFolderPath -ChildPath '.bicep'
    $JSONFilePath = Join-Path -Path $moduleFolderPath -ChildPath 'deploy.json'
    Write-Verbose "$bicepFilePath - JSONFilePath - $JSONFilePath"


    # Convert bicep to json
    Write-Verbose "$bicepFilePath - Convert bicep to json"
    $BicepFilesToConvert = $bicepFile
    if ($SkipChildResources) {

    } else {
        Get-ChildItem -Path $bicepFolderPath -Filter 'deploy.bicep' -Recurse -Force
    }

    if ($PSCmdlet.ShouldProcess("File in path [$bicepFilePath]", 'Convert')) {
        Invoke-Expression "az bicep build --file '$bicepFilePath' --outfile '$JSONFilePath'"
    }
    Write-Verbose "$bicepFilePath - Convert bicep to json - Done"


    # Remove Bicep metadata from json
    Write-Verbose "$bicepFilePath - Remove Bicep metadata from json"
    if (Test-Path -Path $JSONFilePath) {
        $JSONFileContent = Get-Content -Path $JSONFilePath
        $JSONObj = $JSONFileContent | ConvertFrom-Json
        Remove-JSONMetadata -TemplateObject $JSONObj
        $JSONFileContent = $JSONObj | ConvertTo-Json -Depth 100
        if ($PSCmdlet.ShouldProcess("File in path [$JSONFilePath]", 'Overwrite')) {
            Set-Content -Value $JSONFileContent -Path $JSONFilePath
        }
        Write-Verbose "$bicepFilePath - Remove Bicep metadata from json - Done"
    } else {
        Write-Verbose "$bicepFilePath - Remove Bicep metadata from json - Skipped - File not found (deploy.json)"
    }

    # Remove bicep files and folders
    if ($CleanUp) {
        Write-Verbose "$bicepFilePath - Clean up bicep files"
        if ($PSCmdlet.ShouldProcess("File in path [$bicepFilePath]", 'Remove')) {
            Remove-Item -Path $bicepFilePath -Force
        }
        Write-Verbose "$bicepFilePath - Clean up bicep files - Removed deploy.bicep"
        if (Test-Path -Path $bicepFolderPath) {
            if ($PSCmdlet.ShouldProcess("File in path [$bicepFolderPath]", 'Remove')) {
                Remove-Item -Path $bicepFolderPath -Recurse -Force
            }
            Write-Verbose "$bicepFilePath - Clean up bicep files - Removed .bicep folder"
        }
    }
}

# Replace .bicep with .json in workflow files
$workflowFolderPath = Join-Path -Path $rootPath -ChildPath '.github\workflows'
$workflowFiles = Get-ChildItem -Path $workflowFolderPath -Filter 'ms.*.yml' -File -Force
Write-Verbose "Update workflow files - $($workflowFiles.count) files"
foreach ($workflowFile in $workflowFiles) {
    Write-Verbose "$workflowFile - Processing"
    $content = Get-Content -Path $workflowFile
    $content = $content.Replace("deploy.bicep'", "deploy.json'")
    if ($PSCmdlet.ShouldProcess("File in path [$workflowFile]", 'Overwrite')) {
        Set-Content -Value $content -Path $workflowFile
    }
    Write-Verbose "$workflowFile - Processing - Done"
}
Write-Verbose "Update workflow files - $($workflowFiles.count) files - Done"
