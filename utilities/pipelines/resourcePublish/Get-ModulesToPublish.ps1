#region Helper functions

<#
.SYNOPSIS
Get modified files between previous and current commit depending on if you are running on main/master or a custom branch.

.EXAMPLE
Get-ModifiedFileList

    Directory: C:\Repo\Azure\ResourceModules\utilities\pipelines\resourcePublish

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          08.12.2021    15:50           7133 Script.ps1

Get modified files between previous and current commit depending on if you are running on main/master or a custom branch.
#>
function Get-ModifiedFileList {
    $CurrentBranch = Get-GitBranchName
    if (($CurrentBranch -eq 'main') -or ($CurrentBranch -eq 'master')) {
        Write-Verbose 'Gathering modified files from the pull request' -Verbose
        $Diff = git diff --name-only --diff-filter=AM HEAD^ HEAD
    } else {
        Write-Verbose 'Gathering modified files between current branch and main' -Verbose
        $Diff = git diff --name-only --diff-filter=AM origin/main
        if ($Diff.count -eq 0) {
            Write-Verbose 'Gathering modified files between current branch and master' -Verbose
            $Diff = git diff --name-only --diff-filter=AM origin/master
        }
    }
    $ModifiedFiles = $Diff | Get-Item -Force

    return $ModifiedFiles
}

<#
.SYNOPSIS
Get the name of the current checked out branch.

.DESCRIPTION
Get the name of the current checked out branch. If git cannot find it, best effort based on environment variables is used.

.EXAMPLE
Get-CurrentBranch

feature-branch-1

Get the name of the current checked out branch.

#>
function Get-GitBranchName {
    [CmdletBinding()]
    param ()

    # Get branch name from Git
    $BranchName = git branch --show-current

    # If git could not get name, try GitHub variable
    if ([string]::IsNullOrEmpty($BranchName) -and (Test-Path env:GITHUB_REF_NAME)) {
        $BranchName = $env:GITHUB_REF_NAME
    }

    # If git could not get name, try Azure DevOps variable
    if ([string]::IsNullOrEmpty($BranchName) -and (Test-Path env:BUILD_SOURCEBRANCHNAME)) {
        $BranchName = $env:BUILD_SOURCEBRANCHNAME
    }

    return $BranchName
}

<#
.SYNOPSIS
Find the closest main.bicep/json file to the current directory/file.

.DESCRIPTION
This function will search the current directory and all parent directories for a main.bicep/json file.

.PARAMETER Path
Mandatory. Path to the folder/file that should be searched

.EXAMPLE
Find-TemplateFile -Path "C:\Repos\Azure\ResourceModules\modules\storage\storage-accounts\table-services\tables\.bicep\nested_roleAssignments.bicep"

    Directory: C:\Repos\Azure\ResourceModules\modules\storage\storage-accounts\table-services\tables

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          05.12.2021    22:45           1230 main.bicep

Gets the closest main.bicep/json file to the current directory.
#>
function Find-TemplateFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    $FolderPath = Split-Path $Path -Parent
    $FolderName = Split-Path $Path -Leaf
    if ($FolderName -eq 'modules') {
        return $null
    }

    #Prioritizing the bicep file
    $TemplateFilePath = Join-Path $FolderPath 'main.bicep'
    if (-not (Test-Path $TemplateFilePath)) {
        $TemplateFilePath = Join-Path $FolderPath 'main.json'
    }

    if (-not (Test-Path $TemplateFilePath)) {
        return Find-TemplateFile -Path $FolderPath
    }

    return $TemplateFilePath | Get-Item
}

<#
.SYNOPSIS
Find the closest main.bicep/json file to the changed files in the module folder structure.

.DESCRIPTION
Find the closest main.bicep/json file to the changed files in the module folder structure.

.PARAMETER ModuleFolderPath
Mandatory. Path to the main/parent module folder.

.EXAMPLE
Get-TemplateFileToPublish -ModuleFolderPath "C:\Repos\Azure\ResourceModules\modules\storage\storage-accounts\"

C:\Repos\Azure\ResourceModules\modules\storage\storage-accounts\table-services\tables\main.bicep

Gets the closest main.bicep/json file to the changed files in the module folder structure.
Assuming there is a changed file in 'Microsoft.Storage\storageAccounts\tableServices\tables'
the function would return the main.bicep file in the same folder.

#>
function Get-TemplateFileToPublish {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModuleFolderPath
    )
    $ModuleFolderRelPath = $ModuleFolderPath.Split('/modules/')[-1]
    $ModifiedFiles = Get-ModifiedFileList -Verbose
    Write-Verbose "Looking for modified files under: [$ModuleFolderRelPath]" -Verbose
    $ModifiedModuleFiles = $ModifiedFiles | Where-Object { $_.FullName -like "*$ModuleFolderPath*" }

    $TemplateFilesToPublish = $ModifiedModuleFiles | ForEach-Object {
        Find-TemplateFile -Path $_.FullName -Verbose
    } | Sort-Object -Property FullName -Unique -Descending

    if ($TemplateFilesToPublish.Count -eq 0) {
        Write-Verbose 'No template file found in the modified module.' -Verbose
    }

    Write-Verbose ('Modified modules found: [{0}]' -f $TemplateFilesToPublish.count) -Verbose
    $TemplateFilesToPublish | ForEach-Object {
        $RelPath = ($_.FullName).Split('/modules/')[-1]
        $RelPath = $RelPath.Split('/main.')[0]
        Write-Verbose " - [$RelPath]" -Verbose
    }

    return $TemplateFilesToPublish
}

<#
.SYNOPSIS
Gets the parent main.bicep/json file(s) to the changed files in the module folder structure.

.DESCRIPTION
Gets the parent main.bicep/json file(s) to the changed files in the module folder structure.

.PARAMETER TemplateFilePath
Mandatory. Path to a main.bicep/json file.

.PARAMETER Recurse
Optional. If true, the function will recurse up the folder structure to find the closest main.bicep/json file.

.EXAMPLE
Get-ParentModuleTemplateFile -TemplateFilePath 'C:\Repos\Azure\ResourceModules\modules\storage\storage-accounts\table-services\tables\main.bicep' -Recurse

    Directory: C:\Repos\Azure\ResourceModules\modules\storage\storage-accounts\tableServices

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          05.12.2021    22:45           1427 main.bicep

    Directory: C:\Repos\Azure\ResourceModules\modules\storage\storage-accounts

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          02.12.2021    13:19          10768 main.bicep

Gets the parent main.bicep/json file(s) to the changed files in the module folder structure.

#>
function Get-ParentModuleTemplateFile {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [switch] $Recurse
    )

    $ModuleFolderPath = Split-Path $TemplateFilePath -Parent
    $ParentFolderPath = Split-Path $ModuleFolderPath -Parent

    #Prioritizing the bicep file
    $ParentTemplateFilePath = Join-Path $ParentFolderPath 'main.bicep'
    if (-not (Test-Path $TemplateFilePath)) {
        $ParentTemplateFilePath = Join-Path $ParentFolderPath 'main.json'
    }

    if (-not (Test-Path -Path $ParentTemplateFilePath)) {
        return
    }

    $ParentTemplateFilesToPublish = [System.Collections.ArrayList]@()
    $ParentTemplateFilesToPublish += $ParentTemplateFilePath | Get-Item

    if ($Recurse) {
        $ParentTemplateFilesToPublish += Get-ParentModuleTemplateFile $ParentTemplateFilePath -Recurse
    }

    return $ParentTemplateFilesToPublish
}

<#
.SYNOPSIS
Get the number of commits following the specified commit.

.PARAMETER Commit
Optional. A specified git reference to get commit counts on.

.EXAMPLE
Get-GitDistance -Commit origin/main.

620

There are currently 620 commits on origin/main. When run as a push on main, this will be the current commit number on the main branch.
#>
function Get-GitDistance {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $Commit = 'HEAD'

    )

    return [int](git rev-list --count $Commit) + 1
}

<#
.SYNOPSIS
Gets the version from the version file from the corresponding main.bicep/json file.

.DESCRIPTION
Gets the version file from the corresponding main.bicep/json file.
The file needs to be in the same folder as the template file itself.

.PARAMETER TemplateFilePath
Mandatory. Path to a main.bicep/json file.

.EXAMPLE
Get-ModuleVersionFromFile -TemplateFilePath 'C:\Repos\Azure\ResourceModules\modules\storage\storage-accounts\table-services\tables\main.bicep'

0.3

Get the version file from the specified main.bicep file.
#>
function Get-ModuleVersionFromFile {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath
    )

    $ModuleFolder = Split-Path -Path $TemplateFilePath -Parent
    $VersionFilePath = Join-Path $ModuleFolder 'version.json'

    if (-not (Test-Path -Path $VersionFilePath)) {
        throw "No version file found at: [$VersionFilePath]"
    }

    $VersionFileContent = Get-Content $VersionFilePath | ConvertFrom-Json

    return $VersionFileContent.version
}

<#
.SYNOPSIS
Generates a new version for the specified module.

.DESCRIPTION
Generates a new version for the specified module, based on version.json file and git commit count.
Major and minor version numbers are gathered from the version.json file.
Patch version number is calculated based on the git commit count on the branch.

.PARAMETER TemplateFilePath
Mandatory. Path to a main.bicep/json file.

.EXAMPLE
Get-NewModuleVersion -TemplateFilePath 'C:\Repos\Azure\ResourceModules\modules\storage\storage-accounts\table-services\tables\main.bicep'

0.3.630

Generates a new version for the tables module.

#>
function Get-NewModuleVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath
    )

    $Version = Get-ModuleVersionFromFile -TemplateFilePath $TemplateFilePath
    $Patch = Get-GitDistance
    $NewVersion = "$Version.$Patch"

    $BranchName = Get-GitBranchName -Verbose

    if ($BranchName -ne 'main' -and $BranchName -ne 'master') {
        $NewVersion = "$NewVersion-prerelease".ToLower()
    }

    return $NewVersion
}

#endregion

<#
.SYNOPSIS
Generates a hashtable with template file paths to publish with a new version.

.DESCRIPTION
Generates a hashtable with template file paths to publish with a new version.

.PARAMETER TemplateFilePath
Mandatory. Path to a main.bicep/json file.

.PARAMETER PublishLatest
Optional. Publish an absolute latest version.
Note: This version may include breaking changes and is not recommended for production environments

.EXAMPLE
Get-ModulesToPublish -TemplateFilePath 'C:\Repos\Azure\ResourceModules\modules\storage\storage-accounts\main.bicep'

Name               Value
----               -----
TemplateFilePath   C:\Repos\Azure\ResourceModules\modules\storage\storage-accounts\file-services\shares\main.bicep
Version            0.3.848-prerelease
TemplateFilePath   C:\Repos\Azure\ResourceModules\modules\storage\storage-accounts\file-services\main.bicep
Version            0.3.848-prerelease
TemplateFilePath   C:\Repos\Azure\ResourceModules\modules\storage\storage-accounts\main.bicep
Version            0.3.848-prerelease

Generates a hashtable with template file paths to publish and their new versions.

#>#
function Get-ModulesToPublish {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [bool] $PublishLatest = $true

    )

    $ModuleFolderPath = Split-Path $TemplateFilePath -Parent
    $TemplateFilesToPublish = Get-TemplateFileToPublish -ModuleFolderPath $ModuleFolderPath | Sort-Object FullName -Descending

    $modulesToPublish = [System.Collections.ArrayList]@()
    foreach ($TemplateFileToPublish in $TemplateFilesToPublish) {
        $ModuleVersion = Get-NewModuleVersion -TemplateFilePath $TemplateFileToPublish.FullName -Verbose

        $modulesToPublish += @{
            Version          = $ModuleVersion
            TemplateFilePath = $TemplateFileToPublish.FullName
        }

        if ($ModuleVersion -notmatch 'prerelease') {

            # Latest Major,Minor
            $modulesToPublish += @{
                Version          = ($ModuleVersion.Split('.')[0..1] -join '.')
                TemplateFilePath = $TemplateFileToPublish.FullName
            }

            # Latest Major
            $modulesToPublish += @{
                Version          = ($ModuleVersion.Split('.')[0])
                TemplateFilePath = $TemplateFileToPublish.FullName
            }

            if ($PublishLatest) {
                # Absolute latest
                $modulesToPublish += @{
                    Version          = 'latest'
                    TemplateFilePath = $TemplateFileToPublish.FullName
                }
            }
        }

        $ParentTemplateFilesToPublish = Get-ParentModuleTemplateFile -TemplateFilePath $TemplateFileToPublish.FullName -Recurse
        foreach ($ParentTemplateFileToPublish in $ParentTemplateFilesToPublish) {
            $ParentModuleVersion = Get-NewModuleVersion -TemplateFilePath $ParentTemplateFileToPublish.FullName

            $modulesToPublish += @{
                Version          = $ParentModuleVersion
                TemplateFilePath = $ParentTemplateFileToPublish.FullName
            }

            if ($ModuleVersion -notmatch 'prerelease') {

                # Latest Major,Minor
                $modulesToPublish += @{
                    Version          = ($ParentModuleVersion.Split('.')[0..1] -join '.')
                    TemplateFilePath = $ParentTemplateFileToPublish.FullName
                }

                # Latest Major
                $modulesToPublish += @{
                    Version          = ($ParentModuleVersion.Split('.')[0])
                    TemplateFilePath = $ParentTemplateFileToPublish.FullName
                }

                if ($PublishLatest) {
                    # Absolute latest
                    $modulesToPublish += @{
                        Version          = 'latest'
                        TemplateFilePath = $ParentTemplateFileToPublish.FullName
                    }
                }
            }
        }
    }

    $modulesToPublish = $modulesToPublish | Sort-Object TemplateFilePath, Version -Descending -Unique

    if ($modulesToPublish.count -gt 0) {
        Write-Verbose 'Publish the following modules:'-Verbose
        $modulesToPublish | ForEach-Object {
            $RelPath = ($_.TemplateFilePath).Split('/modules/')[-1]
            $RelPath = $RelPath.Split('/main.')[0]
            Write-Verbose (' - [{0}] [{1}] ' -f $RelPath, $_.Version) -Verbose
        }
    } else {
        Write-Verbose 'No modules with changes found to publish.'-Verbose
    }

    return $modulesToPublish
}
