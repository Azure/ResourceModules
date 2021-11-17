
#region functions
function Set-DefinedPSRepository {

    <#
.SYNOPSIS
Add a given repository as a source for modules

.DESCRIPTION
Add a given repository as a source for modules

.PARAMETER Feedurl
Url to the feed to add

.PARAMETER SystemAccessToken
Access token required to access the feed

.PARAMETER QueueById
Id/Email of the instance that wants to access the feed

.EXAMPLE
Set-DefinedPSRepository -FeedName "Release-Modules" -Feedurl $Feedurl -SystemAccessToken $SystemAccessToken -QueueById $QueueById

Set the feed Release-Modules as a nuget and repo source with the specified Credentials
#>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FeedName,
        [Parameter(Mandatory = $true)]
        [string] $Feedurl,
        [Parameter(Mandatory = $true)]
        [string] $SystemAccessToken,
        [Parameter(Mandatory = $true)]
        [PSCredential] $Credential,
        [Parameter(Mandatory = $true)]
        [string] $QueueById
    )

    Write-Verbose "Register sources with feed-url [$Feedurl]"

    Write-Verbose 'Check registerd nuget sources'
    if ($isLinux) {
        # Assume linux with dotnet installation
        $nugetSources = dotnet nuget list source
    } else {
        # Assume windows with nuget installation
        $nugetSources = nuget sources
    }

    if (-not ("$nugetSources" -Match $FeedName)) {
        if ($PSCmdlet.ShouldProcess("Nuget source definition [$FeedName]", 'Add')) {
            if ($isLinux) {
                # Assume linux with dotnet installation
                dotnet nuget add source $Feedurl -n $FeedName -u $QueueById -p $SystemAccessToken --store-password-in-clear-text
            } else {
                # Assume windows with nuget installation
                nuget sources add -name $FeedName -Source $Feedurl -Username $QueueById -Password $SystemAccessToken
            }
        }
    } else {
        Write-Verbose "NuGet source $FeedName already registered"
    }

    if ($isLinux) {
        # Assume linux with dotnet installation
        dotnet nuget list source # Print registered
    } else {
        # Assume windows with nuget installation
        nuget sources # Print registered
    }

    Write-Verbose 'Check registered repositories'
    Import-Module 'PackageManagement' -Verbose:$false # Explicit import to suppress verbose
    Import-Module 'PowerShellGet' -Verbose:$false # Explicit import to suppress verbose
    $regRepos = (Get-PSRepository).Name
    if ($regRepos -notcontains $FeedName) {
        if ($PSCmdlet.ShouldProcess('PSRepository', 'Register new')) {
            Write-Verbose 'Registering script folder as Nuget repo'
            $registrationInputObject = @{
                Name                      = $FeedName
                SourceLocation            = $Feedurl
                PublishLocation           = $Feedurl
                Credential                = $Credential
                InstallationPolicy        = 'Trusted'
                PackageManagementProvider = 'Nuget'
            }
            Register-PSRepository @registrationInputObject
            Write-Verbose "Repository $FeedName registered"
        }
    } else {
        Write-Verbose "Repository $FeedName already registered"
    }

    Write-Verbose ('Available PS repositories:')
    (Get-PSRepository) | Select-Object Name, SourceLocation | Format-Table
}

function Confirm-CustomVersionIfSet {
    <#
.SYNOPSIS
Validate if a given custom version is higher than a given current version

.DESCRIPTION
Validate if a given custom version is higher than a given current version.
E.g.
- 0.0.1 > 0.0.2
- 2.3.5 > 2.1.6

.PARAMETER CustomVersion
The selected custom version that must be higher than the given current version

.PARAMETER CurrentRemoteVersion
The given current version that must be lower than the selected custom version

.EXAMPLE
Confirm-CustomVersionIfSet -CustomVersion "1.0.0" -CurrentRemoteVersion "0.0.15"

Check if the selected version "1.0.0" is valid with regards to the current version "0.0.15"
#>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $false)]
        [string] $CustomVersion,
        [Parameter(Mandatory = $true)]
        [System.Version] $CurrentRemoteVersion
    )

    # Check CustomVersion if set
    if ([string]::IsNullOrEmpty($CustomVersion) -or ($CustomVersion -eq '-')) {
        Write-Verbose 'Custom Version not set. Skip check'
        return;
    }

    Write-Verbose '### Get custom version'
    Write-Verbose "Specified version is $CustomVersion"
    $singleValues = $CustomVersion.Split('.')
    $customBuild = $singleValues[2]
    $customMinor = $singleValues[1]
    $customMajor = $singleValues[0]

    $oldBuild = $CurrentRemoteVersion.Build
    $oldMinor = $CurrentRemoteVersion.Minor
    $oldMajor = $CurrentRemoteVersion.Major

    Write-Verbose 'Compare Versions'
    if ($customMajor -gt $oldMajor) {
        Write-Verbose 'Specified version is valid'
        return $true
    } elseif ($customMajor -lt $oldMajor) {
        throw "Specified major version must not be older than than the existing version: Specified $CustomVersion > Current $CurrentRemoteVersion"
    } else {
        if ($customMinor -gt $oldMinor) {
            Write-Verbose 'Specified version is valid'
            return $true
        } elseif ($customMinor -lt $oldMinor) {
            throw "Specified minor version must not be older than than the existing version: Specified $CustomVersion > Current $CurrentRemoteVersion"
        } else {
            if ($customBuild -gt $oldBuild) {
                Write-Verbose 'Specified version is valid'
                return $true
            } else {
                throw "Specified build version must be newer than than the existing version: Specified $CustomVersion > Current $CurrentRemoteVersion"
            }
        }
    }
}

function Get-CurrentVersion {
    <#
.SYNOPSIS
Search for a certain module in the given feed to check it's version.

.DESCRIPTION
Search for a certain module in the given feed to check it's version. If no module can be found, version 0.0.0 is returned

.PARAMETER FeedName
Name of the feed to search in

.PARAMETER ModuleName
Name of the module to search for

.PARAMETER Credential
The Credentials required to access the feed

.EXAMPLE
$CurrentRemoteVersion = Get-CurrentVersion -ModuleName "aks" -FeedName "moduleFeed" -Credential $Credential

Search for module AKS in the feed moduleFeed to receive its version
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FeedName,
        [Parameter(Mandatory = $true)]
        [string] $ModuleName,
        [Parameter(Mandatory = $true)]
        [PSCredential] $Credential
    )

    Write-Verbose "Search for module [$ModuleName] in feed [$FeedName]"
    try {
        $module = Find-Module -Name $ModuleName -Repository $FeedName -Credential $Credential
        return $module.Version
    } catch {
        if ($_.Exception.Message -like '*No match was found*') {
            Write-Verbose "Module $ModuleName not found. Assuming first deployment"
            return New-Object System.Version('0.0.0')
        } else {
            throw $_
        }
    }
}

function Get-NewVersion {
    <#
.SYNOPSIS
Get a new version object

.DESCRIPTION
This function handels different cases:
- If the custom version is set, it is returned as a version object
- If the custom version is not set, but the local manifest version is higher than the current feed version, the local manifest version is returned
- If the custom version is not set, and the feed has the highest available version, this version is increased and returned as a version object

.PARAMETER CustomVersion
The optionally set custom version

.PARAMETER VersioningOption
The version update. Patch, Minor or Major.

.PARAMETER CurrentRemoteVersion
The current version of the module

.PARAMETER ModuleBase
The root folder of the module

.PARAMETER ModuleName
The name of the module

.EXAMPLE
Get-NewVersion -CustomVersion '-' -CurrentRemoteVersion 0.0.4 -ModuleBase "c:\modules\aks" -ModuleName "aks"

If the current manifest version is 1.0.0 the function returns the 1.0.0 version object
else get the new version 0.0.5

.EXAMPLE
Get-NewVersion -CustomVersion 0.0.6 -CurrentRemoteVersion 0.0.4 -ModuleBase "c:\modules\aks" -ModuleName "aks"

Get the new version 0.0.6
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $CustomVersion,

        [Parameter(Mandatory = $false)]
        [ValidateSet('patch', 'minor', 'major')]
        [string] $VersioningOption = 'patch',

        [Parameter(Mandatory = $true)]
        [version] $CurrentRemoteVersion,

        [Parameter(Mandatory = $true)]
        [string] $ModuleBase,

        [Parameter(Mandatory = $true)]
        [string] $ModuleName
    )

    $localVersion = (Import-LocalizedData -BaseDirectory "$ModuleBase" -FileName "$ModuleName.psd1").ModuleVersion

    if ((-not ([string]::IsNullOrEmpty($CustomVersion))) -and (-not ($CustomVersion -eq '-'))) {
        Write-Verbose "Apply custom version $CustomVersion"
        $NewVersion = New-Object System.Version($CustomVersion)
    } elseif ($localVersion -gt $CurrentRemoteVersion.ToString()) {
        Write-Verbose "Apply local manifest version $localVersion"
        $NewVersion = $localVersion
    } else {
        Write-Verbose "Versioning option is set to [$VersioningOption]. Applying."
        $build = $CurrentRemoteVersion.Build
        $minor = $CurrentRemoteVersion.Minor
        $major = $CurrentRemoteVersion.Major

        if ($VersioningOption -eq 'patch') {
            $build++
        } elseif ($VersioningOption -eq 'minor') {
            $minor++
            $build = 0
        } else {
            $major++
            $minor = 0
            $build = 0
        }

        $NewVersion = New-Object System.Version('{0}.{1}.{2}' -f $major, $minor, $build)
    }
    return $NewVersion
}
function Publish-NuGetModule {

    <#
.SYNOPSIS
Publish a given module to specified feed

.DESCRIPTION
Publish a given module to specified feed

.PARAMETER FeedName
Nanm of the feed to push to

.PARAMETER Credential
Credentials required by the feed

.EXAMPLE
Publish-NuGetModule -FeedName "Release-Modules" -Credential $Credential -ModuleName "Aks"

Push the module AKS to the feed 'Release-Modules'
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FeedName,
        [Parameter(Mandatory = $true)]
        [PSCredential] $Credential,
        [Parameter(Mandatory = $true)]
        [string] $ModuleBase,
        [Parameter(Mandatory = $true)]
        [string] $ModuleName
    )

    try {
        Write-Verbose "Try pushing module [$ModuleName] from base [$ModuleBase] to feed [$FeedName]"
        Publish-Module -Path "$ModuleBase" -NuGetApiKey 'VSTS' -Repository $FeedName -Credential $Credential -Force
        Write-Verbose 'Published module'
    } catch {
        Write-Verbose ('Unable to  upload module {0}' -f (Split-Path $PSScriptRoot -Leaf))
        $_.Exception | Format-List -Force
    }
}
function Set-LocalVersion {
    <#
.SYNOPSIS
Set the specified version to the module manifest

.DESCRIPTION
Set the specified version to the module manifest

.PARAMETER NewVersion
The version to set

.PARAMETER ModuleBase
The root folder of the module

.PARAMETER ModuleName
The name of the module

.EXAMPLE
Set-LocalVersion -NewVersion $NewVersion -ModuleBase "c:\modules\aks" -ModuleName "aks"

Set the provided moduleVersion to the manifest of module aks in the folder 'c:\modules\aks'
#>
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [version] $NewVersion,
        [Parameter(Mandatory = $true)]
        [string] $ModuleBase,
        [Parameter(Mandatory = $true)]
        [string] $ModuleName
    )

    $modulefile = "$ModuleBase/$ModuleName.psd1"
    if ($PSCmdlet.ShouldProcess('Module manifest', 'Update')) {
        Update-ModuleManifest -Path $modulefile -ModuleVersion $NewVersion -Verbose
    }
}
function Update-ManifestExportedFunction {
    <#
.SYNOPSIS
Add the module's public functions to its manifest

.DESCRIPTION
Extracts all functions in the module's public folder to add them as 'FunctionsToExport' int he manifest

.PARAMETER ModuleBase
The root folder of the module

.PARAMETER ModuleName
The name of the module

.EXAMPLE
Update-ManifestExportedFunction  -ModuleBase "c:\modules\aks" -ModuleName "aks"

Add all public functions of module AKS to its manifest
#>
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleBase,
        [Parameter(Mandatory = $true)]
        [string] $ModuleName
    )

    $publicFunctions = (Get-ChildItem -Path "$ModuleBase\Public" -Filter '*.ps1').BaseName

    $modulefile = "$ModuleBase\$ModuleName.psd1"
    if ($PSCmdlet.ShouldProcess('Module manifest', 'Update')) {
        Write-Verbose "Update Manifest $moduleFile"
        Update-ModuleManifest -Path $modulefile -FunctionsToExport $publicFunctions -Verbose | Out-Null
    }
}
#endregion

function Publish-ModuleToNuget {

    <#
.SYNOPSIS
Build the current powershell module as an artifact and push it to a designated feed

.DESCRIPTION
This method adjusts the module's manifest in two ways:
- It assigns a new given or generated module version to the manifest
- It extracts all public functions from this module and lists them in the manifest

Subsequently it pushes the module as an artifact to a corresponding module feed as a nuget package where it can be downloaded from.

.PARAMETER FeedName
Name of the feed to push the module to. By default it's 'Release-Modules'

.PARAMETER Feedurl
Optional Feedurl to set by pipeline. Use {0} in path to specify the FeedName
e.g. "https://apps-custom.pkgs.visualstudio.com/_packaging/{0}/nuget/v2"

.PARAMETER CustomVersion
If the new version should not be generated you can specify a custom version. It must be higher than the latest version inside the module feed.

.PARAMETER VersioningOption
The version update. Patch, Minor or Major.

.PARAMETER SystemAccessToken
Personal-Access-Token provieded by the pipeline or user to interact with the module feed

.PARAMETER QueueById
Name/Email/Id of the user interacting with the module feed

.PARAMETER ModuleBase
Root folder of the modbule to publish

.PARAMETER ModuleName
Name of the module to publish
#>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Is provided by the pipeline as an encoded string')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FeedName,

        [Parameter(Mandatory = $true)]
        [string] $Feedurl,

        [Parameter(Mandatory = $false)]
        [string] $CustomVersion = '-',

        [Parameter(Mandatory = $false)]
        [ValidateSet('patch', 'minor', 'major')]
        [string] $VersioningOption = 'patch',

        [Parameter(Mandatory = $true)]
        [string] $SystemAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $QueueById,

        [Parameter(Mandatory = $true)]
        [string] $ModuleBase,

        [Parameter(Mandatory = $true)]
        [string] $ModuleName
    )

    $oldPreferences = $VerbosePreference
    $VerbosePreference = 'Continue'

    try {
        $Feedurl = $Feedurl -f $FeedName
        Write-Verbose "Feed-Url: $Feedurl"

        $password = ConvertTo-SecureString $SystemAccessToken -AsPlainText -Force
        $Credential = New-Object System.Management.Automation.PSCredential ($QueueById, $password)

        Write-Verbose 'Register feed'
        Set-DefinedPSRepository -FeedName $FeedName -Feedurl $Feedurl -SystemAccessToken $SystemAccessToken -Credential $Credential -QueueById $QueueById

        $CurrentRemoteVersion = Get-CurrentVersion -FeedName $FeedName -ModuleName $ModuleName -Credential $Credential
        Write-Verbose "Current version of module '$ModuleName' in feed '$FeedName' is $CurrentRemoteVersion"

        Confirm-CustomVersionIfSet -CustomVersion $CustomVersion -CurrentRemoteVersion $CurrentRemoteVersion

        $NewVersion = Get-NewVersion -CustomVersion $CustomVersion -VersioningOption $VersioningOption -CurrentRemoteVersion $CurrentRemoteVersion -ModuleName $ModuleName -ModuleBase $ModuleBase
        Write-Verbose "New version is $NewVersion"

        Set-LocalVersion -NewVersion $NewVersion -ModuleName $ModuleName -ModuleBase $ModuleBase
        Write-Verbose "Updated local version to $NewVersion"

        Update-ManifestExportedFunction -ModuleName $ModuleName -ModuleBase $ModuleBase

        Test-ModuleManifest -Path "$ModuleBase\$ModuleName.psd1" | Format-List

        Publish-NuGetModule -FeedName $FeedName -Credential $Credential -ModuleName $ModuleName -ModuleBase $ModuleBase
    } finally {
        $VerbosePreference = $oldPreferences
    }
}
