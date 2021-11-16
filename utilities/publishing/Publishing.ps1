function Get-ChangedFiles {
    $Diff = git diff --name-only HEAD^ HEAD
    $ChangedFiles = $Diff | Get-Item
    return $ChangedFiles
}

function Get-ChangedModuleFiles {
    $ChangedModuleFiles = Get-ChangedFiles | Where-Object { $_.Name -eq 'deploy.bicep' }
    return $ChangedModuleFiles
}

function Get-ModuleName {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $Path
    )
    $FolderName = $Path.Replace('deploy.bicep', '')
    $FolderName = $FolderName.Trim('\')
    $ModuleName = $FolderName.Split('\arm\')[-1].Replace('\', '_')
    return $ModuleName
}

function Get-ModuleVersion {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $Path
    )
    $FolderName = $Path.Replace('deploy.bicep', '')
    $FolderName = $FolderName.Trim('\')
    $VersionFilePath = Join-Path $FolderName 'version.json'
    if (-not (Test-Path -Path $VersionFilePath)) {
        Write-Host "No version file found at: $VersionFilePath"
        return
    }
    $VersionFileContent = Get-Content $VersionFilePath | ConvertFrom-Json
    $Version = $VersionFileContent.version
    return $Version
}

function Get-ParentModule {
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $Path
    )

    $File = Get-Item -Path $Path
    $File
    $ParentDeployFilePath = Join-Path $File.Directory.Parent.FullName 'deploy.bicep'
    if (-not (Test-Path -Path $ParentDeployFilePath)) {
        Write-Verbose "No parent deploy file found at: $ParentDeployFilePath"
        return
    }
    $ParentModules = @($ParentDeployFilePath)
    $ParentModules += (Get-ParentModule -Path $ParentDeployFilePath)
    return $ParentModules
}

# Read version file
Get-ChangedModuleFiles | ForEach-Object {
    $ModuleName = $_.FullName | Get-ModuleName
    $ModuleVersion = $_.FullName | Get-ModuleVersion

    Write-Output "Version file found for module: $ModuleName - $ModuleVersion"
    $ParentModules = $_.FullName | Get-ParentModule
    # Find parents | Update parents
    # Construct name of readme file to publish
    # Publish module | readme file
}

