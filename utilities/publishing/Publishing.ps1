function Get-ChangedFiles {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string] $Commit = 'HEAD^',

        [Parameter(Position = 1)]
        [string] $CompareCommit = 'HEAD'
    )
    $Diff = git diff --name-only $Commit $CompareCommit
    $ChangedFiles = $Diff | Get-Item
    return $ChangedFiles
}

function Get-ChangedModuleFiles {
    [CmdletBinding()]
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
    $FolderPath = Split-Path -Path $Path -Parent
    $ModuleName = $FolderPath.Replace('/','\').Split('\arm\')[-1].Replace('\', '.').ToLower()
    return $ModuleName
}

function Get-ModuleVersion {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $Path
    )
    $FolderPath = Split-Path -Path $Path -Parent
    $VersionFilePath = Join-Path $FolderPath 'version.json'
    if (-not (Test-Path -Path $VersionFilePath)) {
        throw "No version file found at: $VersionFilePath"
    }
    $VersionFileContent = Get-Content $VersionFilePath | ConvertFrom-Json
    $Version = $VersionFileContent.version
    return $Version
}

function Get-ParentModule {
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $Path,

        [Parameter()]
        [switch] $Recurse

    )

    $File = Get-Item -Path $Path
    $ParentDeployFilePath = Join-Path $File.Directory.Parent.FullName 'deploy.bicep'
    if (-not (Test-Path -Path $ParentDeployFilePath)) {
        Write-Verbose "No parent deploy file found at: $ParentDeployFilePath"
        return
    }
    $ParentModules = @($ParentDeployFilePath)
    if ($Recurse) {
        $ParentModules += Get-ParentModule $ParentDeployFilePath -Recurse
    }
    return $ParentModules
}

function Update-ChangedModule {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Path = 'C:\Repos\Azure\ResourceModules\arm\Microsoft.Storage\storageAccounts\tableServices\tables\deploy.bicep',
    )

    $ModulePath = $Path
    $ModuleName = Get-ModuleName -Path $ModulePath
    $ModuleVersion = Get-ModuleVersion -Path $ModulePath -ErrorAction Stop
    $SourceReadMeFileName = Get-ModuleReadme -Path $ModulePath
    $DestinationReadmeFileName = "$ModuleName-$ModuleVersion.md"
    if ($PSCmdlet.ShouldProcess("$ReadmeFileName", 'Copy')) {
        $ReadmeFileName # Export/Copy it?
    }
    $ParentModules = Get-ParentModule $ModulePath
    Update-ChangedModule $ParentModules
}

# Read version file
Get-ChangedModuleFiles | ForEach-Object {
    $ModuleName = $_.FullName | Get-ModuleName
    $ModuleVersion = $_.FullName | Get-ModuleVersion

    Write-Output "Version file found for module: $ModuleName - $ModuleVersion"
    $ParentModules = $_.FullName | Get-ParentModule
    Update-ChangedModule $ParentModules

    # Publish module and/or readme file

    # Gather info on modules to publish
}
