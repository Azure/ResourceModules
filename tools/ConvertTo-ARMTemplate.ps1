Function ConvertTo-ARMTemplate {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [string] $Path = 'arm',
        [switch] $CleanUp
    )

    $RootFolderPath = $PSScriptRoot
    $workflowFolderPath = Join-Path -Path $RootFolderPath -ChildPath '.github\workflows'

    # Get all bicep files, map with workflow and json
    $BicepFiles = Get-ChildItem -Path $Path -Filter deploy.bicep -Recurse

    foreach ($BicepFile in $BicepFiles) {
        $BicepFilePath = $BicepFile.FullName
        $ModuleFolderPath = $BicepFile.Directory.FullName
        $JSONFilePath = Join-Path -Path $ModuleFolderPath -ChildPath 'deploy.json'
        $bicepFolderPath = Join-Path -Path $ModuleFolderPath -ChildPath '.bicep'
        $RelativePath = $BicepFilePath.replace($RootFolderPath, '')
        $RootFolderPath
        $BicepFilePath
        $RelativePath

        # Remove existing deploy.json
        if (Test-Path -Path $JSONFilePath) {
            Remove-Item -Path $JSONFilePath -Force
        }

        # Convert bicep to json
        az bicep build --file $BicepFilePath --outfile $JSONFilePath

        # Cleanup bicep files
        if ($CleanUp) {
            Remove-Item -Path $BicepFilePath -Force -Verbose
            Remove-Item -Path $bicepFolderPath -Force -Recurse -Verbose
        }
    }
}

ConvertTo-ARMTemplate
