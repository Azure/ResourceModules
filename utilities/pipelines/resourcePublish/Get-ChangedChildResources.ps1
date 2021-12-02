function Get-ChangedFiles {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string] $Commit = 'HEAD^',

        [Parameter(Position = 1)]
        [string] $CompareCommit = 'HEAD'
    )
    $Diff = git diff --name-only --diff-filter=AM $Commit $CompareCommit
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

# Read version file
Get-ChangedModuleFiles | ForEach-Object {
    $ModuleName = $_.FullName | Get-ModuleName
    $ModuleVersion = $_.FullName | Get-ModuleVersion

    Write-Output "Update: $ModuleName - $ModuleVersion"
    $ParentModules = $_.FullName | Get-ParentModule
    Update-ChangedModule $ParentModules
}
