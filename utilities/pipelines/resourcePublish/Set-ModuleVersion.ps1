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

function Set-ModuleVersion {
        [CmdletBinding()]
        param (
            $ModuleFilePath
        )
        $Version = Get-ModuleVersion -ModuleFilePath $ModuleFilePath
        $Patch = Get-GitDistance
        $NewVersion = [System.Version]"$Version.$Patch"
        return $NewVersion.ToString()
}
