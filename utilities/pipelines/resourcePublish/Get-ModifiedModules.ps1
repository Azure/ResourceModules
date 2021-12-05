function Get-ModifiedFiles {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string] $Commit = 'HEAD^',

        [Parameter(Position = 1)]
        [string] $CompareCommit = 'HEAD'
    )
    $Diff = git diff --name-only --diff-filter=AM $Commit $CompareCommit
    $ModifiedFiles = $Diff | Get-Item
    Write-Verbose 'The following files have been modified:'
    $ModifiedFiles | ForEach-Object {
        Write-Verbose "   $($_.FullName)"
    }
    return $ModifiedFiles
}

function Find-ModuleFile {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Path
    )

    $FolderPath = Split-Path $Path -Parent
    $FolderName = Split-Path $Path -Leaf
    if ($FolderName -eq 'arm') {
        return $null
    }
    $ModuleFilePath = Join-Path -Path $FolderPath -ChildPath 'deploy.bicep'
    if (-not (Test-Path $ModuleFilePath)) {
        return Find-ModuleFile $FolderPath
    }

    return $ModuleFilePath | Get-Item
}

function Get-ModifiedModuleFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModuleFolderPath
    )
    $ModifiedFiles = Get-ModifiedFiles -Verbose
    Write-Verbose "Looking for modified modules under : '$ModuleFolderPath'"
    $ModifiedModuleAuxFiles = $ModifiedFiles | Where-Object { $_.FullName -like "*$ModuleFolderPath*" }

    $ModifiedModuleFiles = $ModifiedModuleAuxFiles | ForEach-Object {
        Find-ModuleFile -Path $($_.FullName) -Verbose
    } | Sort-Object -Property FullName -Unique -Descending

    if ($ModifiedModuleFiles.Count -eq 0) {
        throw 'No Modified module files found.'
    }

    Write-Verbose "Modified modules found : $($ModifiedModuleFiles.count)"
    $ModifiedModuleFiles | ForEach-Object {
        Write-Verbose "   $($_.FullName)"
    }

    return $ModifiedModuleFiles
}

function Get-ParentModule {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $ModuleFilePath,

        [Parameter()]
        [switch] $Recurse

    )

    $ModuleFolderPath = Split-Path $ModuleFilePath -Parent
    $ParentFolderPath = Split-Path $ModuleFolderPath -Parent
    $ParentDeployFilePath = Join-Path $ParentFolderPath 'deploy.bicep'
    if (-not (Test-Path -Path $ParentDeployFilePath)) {
        Write-Verbose "No parent deploy file found at: $ParentDeployFilePath"
        return
    }
    Write-Verbose "Parent deploy file found at: $ParentDeployFilePath"
    $ParentModuleFiles = New-Object -TypeName System.Collections.ArrayList
    $ParentModuleFiles += $ParentDeployFilePath | Get-Item
    if ($Recurse) {
        $ParentModuleFiles += Get-ParentModule $ParentDeployFilePath -Recurse
    }
    return $ParentModuleFiles
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
    $CurrentBranch = git branch --show-current
    if ($CurrentBranch -ne 'main') {
        $Patch = "$Patch-$CurrentBranch".Replace('\','').Replace('/','')
    }
    $NewVersion = [System.Version]"$Version.$Patch"
    return $NewVersion.ToString()
}

function Get-ModifiedModules {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $ModuleFilePath
    )

    $ModuleFolderPath = Split-Path $ModuleFilePath -Parent

    $ModifiedModuleFiles = Get-ModifiedModuleFiles -ModuleFolderPath $ModuleFolderPath

    $ModulesToUpdate = New-Object -TypeName System.Collections.ArrayList
    $ModifiedModuleFiles | Sort-Object FullName -Descending | ForEach-Object {
        $ModuleVersion = Get-NewModuleVersion -ModuleFilePath $_.FullName
        $ModulesToUpdate += [pscustomobject]@{
            Version = $ModuleVersion
            ModulePath = $_.FullName
        }
        Write-Output "Update: $ModuleName - $ModuleVersion"

        Write-Output 'Checking for parent modules'
        $ParentModuleFiles = Get-ParentModule -ModuleFilePath $_ -Recurse
        Write-Output "Checking for parent modules - Found $($ParentModuleFiles.Count)"
        $ParentModuleFiles
        $ParentModuleFiles | ForEach-Object {
            $ParentModuleVersion = Get-NewModuleVersion -ModuleFilePath $_.FullName

            $ModulesToUpdate += [pscustomobject]@{
                Version    = $ParentModuleVersion
                ModulePath = $_.FullName
            }
            Write-Output "Update parent: $ParentModuleName - $ParentModuleVersion"
        }
    }

    $ModulesToUpdate = $ModulesToUpdate | Sort-Object Name -Descending -Unique

    return $ModulesToUpdate
}
