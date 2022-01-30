#region Helper functions

<#
.SYNOPSIS
Get modified files between two commits.

.PARAMETER Commit
Optional. A git reference to base the comparison on.

.PARAMETER CompareCommit
A git reference to compare with.

.EXAMPLE
Get-ModifiedFile -Commit "HEAD^" -CompareCommit "HEAD"

    Directory: C:\Repo\Azure\ResourceModules\utilities\pipelines\resourcePublish

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          08.12.2021    15:50           7133 Script.ps1

Get modified files between previous and current commit.
#>
function Get-ModifiedFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $Commit = 'HEAD',

        [Parameter(Mandatory = $false)]
        [string] $CompareCommit = 'HEAD^'
    )

    Write-Verbose "Gathering modified files between [$Commit] and [$CompareCommit]" -Verbose
    $Diff = git diff --name-only --diff-filter=AM $Commit $CompareCommit
    $ModifiedFiles = $Diff | Get-Item
    Write-Verbose 'The following files have been modified:' -Verbose
    $ModifiedFiles | ForEach-Object {
        Write-Verbose (' - [{0}]' -f $_.FullName) -Verbose
    }

    return $ModifiedFiles
}

<#
.SYNOPSIS
Find the closest deploy.bicep/json file to the current directory/file.

.DESCRIPTION
This function will search the current directory and all parent directories for a deploy.bicep/json file.

.PARAMETER Path
Required. Path to the folder/file that should be searched

.EXAMPLE
Find-TemplateFile -Path "C:\Repos\Azure\ResourceModules\arm\Microsoft.Storage\storageAccounts\tableServices\tables\.bicep\nested_cuaId.bicep"

    Directory: C:\Repos\Azure\ResourceModules\arm\Microsoft.Storage\storageAccounts\tableServices\tables

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          05.12.2021    22:45           1230 deploy.bicep

Gets the closest deploy.bicep/json file to the current directory.
#>
function Find-TemplateFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    $FolderPath = Split-Path $Path -Parent
    $FolderName = Split-Path $Path -Leaf
    if ($FolderName -eq 'arm') {
        return $null
    }

    #Prioritizing the bicep file
    $TemplateFilePath = Join-Path -Path $FolderPath -ChildPath 'deploy.bicep'
    if (-not (Test-Path $TemplateFilePath)) {
        $TemplateFilePath = Join-Path -Path $FolderPath -ChildPath 'deploy.json'
    }

    if (-not (Test-Path $TemplateFilePath)) {
        return Find-TemplateFile -Path $FolderPath
    }

    return $TemplateFilePath | Get-Item
}

<#
.SYNOPSIS
Find the closest deploy.bicep/json file to the changed files in the module folder structure.

.DESCRIPTION
Find the closest deploy.bicep/json file to the changed files in the module folder structure.

.PARAMETER ModuleFolderPath
Path to the main/parent module folder.

.EXAMPLE
Get-TemplateFileToUpdate -ModuleFolderPath "C:\Repos\Azure\ResourceModules\arm\Microsoft.Storage\storageAccounts\"

C:\Repos\Azure\ResourceModules\arm\Microsoft.Storage\storageAccounts\tableServices\tables\deploy.bicep

Gets the closest deploy.bicep/json file to the changed files in the module folder structure.
Assuming there is a changed file in 'Microsoft.Storage\storageAccounts\tableServices\tables'
the function would return the deploy.bicep file in the same folder.

#>
function Get-TemplateFileToUpdate {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModuleFolderPath
    )

    $ModifiedFiles = Get-ModifiedFile -Verbose
    Write-Verbose "Looking for modified files under: [$ModuleFolderPath]"
    $ModifiedModuleFiles = $ModifiedFiles | Where-Object { $_.FullName -like "*$ModuleFolderPath*" }

    $TemplateFilesToUpdate = $ModifiedModuleFiles | ForEach-Object {
        Find-TemplateFile -Path $_.FullName -Verbose
    } | Sort-Object -Property FullName -Unique -Descending

    if ($TemplateFilesToUpdate.Count -eq 0) {
        Write-Verbose 'No template file found in the modified module.'
    }

    Write-Verbose ('Modified modules found: [{0}]' -f $TemplateFilesToUpdate.count)
    $TemplateFilesToUpdate | ForEach-Object {
        Write-Verbose " - $($_.FullName)"
    }

    return $TemplateFilesToUpdate
}

<#
.SYNOPSIS
Gets the parent deploy.bicep/json file(s) to the changed files in the module folder structure.

.DESCRIPTION
Gets the parent deploy.bicep/json file(s) to the changed files in the module folder structure.

.PARAMETER TemplateFilePath
Required. Path to a deploy.bicep/json file.

.PARAMETER Recurse
Optional. If true, the function will recurse up the folder structure to find the closest deploy.bicep/json file.

.EXAMPLE
Get-ParentModuleTemplateFile -TemplateFilePath 'C:\Repos\Azure\ResourceModules\arm\Microsoft.Storage\storageAccounts\tableServices\tables\deploy.bicep' -Recurse

    Directory: C:\Repos\Azure\ResourceModules\arm\Microsoft.Storage\storageAccounts\tableServices

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          05.12.2021    22:45           1427 deploy.bicep

    Directory: C:\Repos\Azure\ResourceModules\arm\Microsoft.Storage\storageAccounts

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          02.12.2021    13:19          10768 deploy.bicep

Gets the parent deploy.bicep/json file(s) to the changed files in the module folder structure.

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
    $ParentTemplateFilePath = Join-Path -Path $ParentFolderPath -ChildPath 'deploy.bicep'
    if (-not (Test-Path $TemplateFilePath)) {
        $ParentTemplateFilePath = Join-Path -Path $ParentFolderPath -ChildPath 'deploy.json'
    }

    if (-not (Test-Path -Path $ParentTemplateFilePath)) {
        Write-Verbose "No parent template file found at: [$ParentTemplateFilePath]"
        return
    }

    Write-Verbose "Parent template file found at: [$ParentTemplateFilePath]"
    $ParentTemplateFilesToUpdate = [System.Collections.ArrayList]@()
    $ParentTemplateFilesToUpdate += $ParentTemplateFilePath | Get-Item

    if ($Recurse) {
        $ParentTemplateFilesToUpdate += Get-ParentModuleTemplateFile $ParentTemplateFilePath -Recurse
    }

    return $ParentTemplateFilesToUpdate
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
Gets the version from the version file from the corresponding deploy.bicep/json file.

.DESCRIPTION
Gets the version file from the corresponding deploy.bicep/json file.
The file needs to be in the same folder as the template file itself.

.PARAMETER TemplateFilePath
Required. Path to a deploy.bicep/json file.

.EXAMPLE
Get-ModuleVersionFromFile -TemplateFilePath 'C:\Repos\Azure\ResourceModules\arm\Microsoft.Storage\storageAccounts\tableServices\tables\deploy.bicep'

0.3

Get the version file from the specified deploy.bicep file.
#>
function Get-ModuleVersionFromFile {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath
    )

    $ModuleFolder = Split-Path -Path $TemplateFilePath -Parent
    $VersionFilePath = Join-Path -Path $ModuleFolder -ChildPath 'version.json'

    if (-not (Test-Path -Path $VersionFilePath)) {
        throw "No version file found at: $VersionFilePath"
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
Required. Path to a deploy.bicep/json file.

.EXAMPLE
Get-NewModuleVersion -TemplateFilePath 'C:\Repos\Azure\ResourceModules\arm\Microsoft.Storage\storageAccounts\tableServices\tables\deploy.bicep'

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

    $CurrentBranch = git symbolic-ref --short 'HEAD'
    #$CurrentBranch = git branch --show-current
    Write-Verbose "Current branch: [$CurrentBranch]" -Verbose
    if (($CurrentBranch -ne 'main') -or ($CurrentBranch -ne 'master') ) {
        $PreRelease = $CurrentBranch -replace '[^a-zA-Z0-9\.\-_]'
        Write-Verbose "PreRelease: [$PreRelease]" -Verbose
        $NewVersion = "$NewVersion-prerelease".ToLower()
        #$NewVersion = "$NewVersion-prerelease-$PreRelease"
        Write-Verbose "New version: [$NewVersion]" -Verbose
    }

    return $NewVersion
}

#endregion

<#
.SYNOPSIS
Generates a hashtable with template file paths to update with a new version.

.DESCRIPTION
Generates a hashtable with template file paths to update with a new version.

.PARAMETER TemplateFilePath
Required. Path to a deploy.bicep/json file.

.EXAMPLE
Get-ModulesToUpdate -TemplateFilePath 'C:\Repos\Azure\ResourceModules\arm\Microsoft.Storage\storageAccounts\tableServices\tables\deploy.bicep'


#TODO: Generates a hashtable with template file paths to update with a new version.
#>#
function Get-ModulesToUpdate {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath
    )

    $ModuleFolderPath = Split-Path $TemplateFilePath -Parent
    $TemplateFilesToUpdate = Get-TemplateFileToUpdate -ModuleFolderPath $ModuleFolderPath | Sort-Object FullName -Descending

    $ModulesToUpdate = [System.Collections.ArrayList]@()
    foreach ($TemplateFileToUpdate in $TemplateFilesToUpdate) {
        $ModuleVersion = Get-NewModuleVersion -TemplateFilePath $TemplateFileToUpdate.FullName -Verbose
        $ModulesToUpdate += @{
            Version          = $ModuleVersion
            TemplateFilePath = $TemplateFileToUpdate.FullName
        }

        $ParentTemplateFilesToUpdate = Get-ParentModuleTemplateFile -TemplateFilePath $TemplateFileToUpdate.FullName -Recurse
        Write-Verbose "Found [$($ParentTemplateFilesToUpdate.count)] parent template files to update"
        foreach ($ParentTemplateFileToUpdate in $ParentTemplateFilesToUpdate) {
            $ParentModuleVersion = Get-NewModuleVersion -TemplateFilePath $ParentTemplateFileToUpdate.FullName

            $ModulesToUpdate += @{
                Version          = $ParentModuleVersion
                TemplateFilePath = $ParentTemplateFileToUpdate.FullName
            }
        }
    }

    $ModulesToUpdate = $ModulesToUpdate | Sort-Object TemplateFilePath -Descending -Unique

    Write-Verbose 'Update the following modules:'
    $ModulesToUpdate | ForEach-Object {
        Write-Verbose (' - [{0}] [{1}] ' -f $_.Version, $_.TemplateFilePath)
    }

    return $ModulesToUpdate
}
