# 1. Remove existing json files
# 2.a Convert bicep to json
# 2.b Cleanup json, remove metadate property in json
# 3. Remove bicep files and folders
# 4. Replace deploy.bicep with deploy.json in workflow files

[CmdletBinding(SupportsShouldProcess)]
param (
    [string] $Path,
    [switch] $CleanUp
)

$RootPath = Get-Item -Path $Path | Select-Object -ExpandProperty FullName
$armFolderPath = Join-Path -Path $RootPath -ChildPath 'arm'

# Get all bicep files
$BicepFiles = Get-ChildItem -Path $armFolderPath -Filter deploy.bicep -Recurse
foreach ($BicepFile in $BicepFiles) {
    $BicepFilePath = $BicepFile.FullName
    Write-Verbose "$BicepFilePath - Processing"
    $ModuleFolderPath = $BicepFile.Directory.FullName
    Write-Verbose "$BicepFilePath - ModuleFolderPath - $ModuleFolderPath"
    $JSONFilePath = Join-Path -Path $ModuleFolderPath -ChildPath 'deploy.json'
    Write-Verbose "$BicepFilePath - JSONFilePath - $JSONFilePath"
    $bicepFolderPath = Join-Path -Path $ModuleFolderPath -ChildPath '.bicep'

    # 1. Remove existing json files
    Write-Verbose "$BicepFilePath - Removing deploy.json"
    if (Test-Path -Path $JSONFilePath) {
        Remove-Item -Path $JSONFilePath -Force -Verbose
        Write-Verbose "$BicepFilePath - Removing deploy.json - Done"
    } else {
        Write-Verbose "$BicepFilePath - Removing deploy.json - Skipped - Nothing to delete"
    }

    # 2.a Convert bicep to json
    Write-Verbose "$BicepFilePath - Convert to json"
    az bicep build --file $BicepFilePath --outfile $JSONFilePath
    Write-Verbose "$BicepFilePath - Convert to json - Done"

    # 2.b Cleanup json, remove metadate property in json
    $JSONFileContent = Get-Content -Path $JSONFilePath
    $JSONObj = $JSONFileContent | ConvertFrom-Json
    $JSONObj.metadata = $null
    $JSONFileContent = $JSONObj | ConvertTo-Json


    # 3. Remove bicep files and folders
    if ($CleanUp) {
        Remove-Item -Path $BicepFilePath -Force -Verbose
        if (Test-Path -Path $bicepFolderPath) {
            Remove-Item -Path $bicepFolderPath -Force -Recurse -Verbose
        }
    }
}

# 4. Replace deploy.bicep with deploy.json in workflow files
$workflowFolderPath = Join-Path -Path $RootPath -ChildPath '.github\workflows'
$workflowFiles = Get-ChildItem -Path $workflowFolderPath -Filter 'ms.*.yml' -File
$workflowFiles | ForEach-Object -ThrottleLimit 20 -Parallel {
    $workflowFile = $_
    $Content = Get-Content -Path $workflowFile
    $Content = $Content.Replace('deploy.bicep', 'deploy.json')
    Set-Content -Value $Content -Path $workflowFile
}
