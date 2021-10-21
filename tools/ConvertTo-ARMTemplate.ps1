[CmdletBinding(SupportsShouldProcess)]
param (
    [string] $Path,
    [switch] $CleanUp
)

$Path = Get-Item -Path $Path | Select-Object -ExpandProperty FullName
$Path
$workflowFolderPath = Join-Path -Path $Path -ChildPath '.github\workflows'
$workflowFolderPath
$armFolderPath = Join-Path -Path $Path -ChildPath 'arm'
$armFolderPath

# Get all bicep files, map with workflow and json
$BicepFiles = Get-ChildItem -Path $armFolderPath -Filter deploy.bicep -Recurse

foreach ($BicepFile in $BicepFiles) {
    $BicepFilePath = $BicepFile.FullName
    $BicepFilePath
    $ModuleFolderPath = $BicepFile.Directory.FullName
    $JSONFilePath = Join-Path -Path $ModuleFolderPath -ChildPath 'deploy.json'
    $bicepFolderPath = Join-Path -Path $ModuleFolderPath -ChildPath '.bicep'

    # Generate workflow file name
    $RelativePath = [IO.Path]::GetRelativePath($armFolderPath, $ModuleFolderPath)
    $ResourceProvider = $RelativePath.ToLower().replace('microsoft', 'ms').replace([IO.Path]::DirectorySeparatorChar, '.')
    $workflowFileName = "$ResourceProvider.yml"
    $workflowFilePath = Join-Path -Path $workflowFolderPath -ChildPath $workflowFileName
    if (Test-Path -Path $workflowFilePath) {
        Write-Output $workflowFilePath
    } else {
        Write-Warning $workflowFilePath
    }

    # Remove existing deploy.json
    if (Test-Path -Path $JSONFilePath) {
        Remove-Item -Path $JSONFilePath -Force
    }

    # Convert bicep to json
    #az bicep build --file $BicepFilePath --outfile $JSONFilePath

    # Cleanup bicep files
    if ($CleanUp) {
        Remove-Item -Path $BicepFilePath -Force -Verbose
        Remove-Item -Path $bicepFolderPath -Force -Recurse -Verbose
    }
}
