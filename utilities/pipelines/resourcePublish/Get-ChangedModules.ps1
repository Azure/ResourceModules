function Get-ChangedFiles {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string] $Commit = 'HEAD^',

        [Parameter(Position = 1)]
        [string] $CompareCommit = 'HEAD'
    )
    $Diff = git diff --name-only --diff-filter=AM $Commit $CompareCommit
    $Diff
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
        $ModuleFilePath
    )
    $FolderPath = Split-Path -Path $ModuleFilePath -Parent
    $ModuleName = $FolderPath.Replace('/','\').Split('\arm\')[-1].Replace('\', '.').ToLower()
    return $ModuleName
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
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $ModulePath = 'C:\Repos\Azure\ResourceModules\arm\Microsoft.Storage\storageAccounts\tableServices\tables\deploy.bicep'
    )

    $ModulePath = $Path
    $ModuleName = Get-ModuleName -Path $ModulePath

    $ParentModules = Get-ParentModule $ModulePath
    Update-ChangedModule $ParentModules
}

function Get-GitDistance {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string] $Commit = 'HEAD^',

        [Parameter(Position = 1)]
        [string] $CompareCommit = 'HEAD'
    )
    $Distance = (git rev-list $Commit $CompareCommit).count - 1
    return $Distance
}

function Get-ModuleVersion {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $ModuleFilePath
    )
    $ModuleFile = Get-Item -Path $ModuleFilePath
    $ModuleFolder = Split-Path -Path $ModuleFile -Parent
    $VersionFilePath = Join-Path $ModuleFolder 'version.json'

    if (-not (Test-Path -Path $VersionFilePath)) {
        throw "No version file found at: $VersionFilePath"
    }

    $VersionFileContent = Get-Content $VersionFilePath | ConvertFrom-Json
    $Version = $VersionFileContent.version

    return $Version
}

function Get-NewModuleVersion {
    [CmdletBinding()]
    param (
        $ModuleFilePath
    )
    $Version = Get-ModuleVersion -ModuleFilePath $ModuleFilePath
    $Patch = Get-GitDistance
    $NewVersion = [System.Version]"$Version.$Patch"
    return $NewVersion.ToString()
}

function Get-ChangedModules {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $ModuleFilePath
    )
    # Read version file
    $ChangedModuleFiles = Get-ChangedModuleFiles
    $ChangedModuleFiles

    $ChangedModuleFiles | ForEach-Object {
        $ModuleName = Get-ModuleName -$_.FullName | Get-ModuleName
        $ModuleVersion = Get-NewModuleVersion -ModuleFilePath $_.FullName

        Write-Output "Update: $ModuleName - $ModuleVersion"
        $ParentModules = $_.FullName | Get-ParentModule
        $ParentModules | ForEach-Object {
            $ParentModuleName = $_.FullName | Get-ModuleName
            $ParentModuleVersion = Get-NewModuleVersion -ModuleFilePath $_.FullName
            Write-Output "Update parent: $ParentModuleName - $ParentModuleVersion"
        }
    }
}
