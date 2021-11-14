
#region functions
function Set-DefinedPSRepository {

    <#
.SYNOPSIS
Add a given repository as a source for modules

.DESCRIPTION
Add a given repository as a source for modules

.PARAMETER feedurl
Url to the feed to add

.PARAMETER systemAccessToken
Access token required to access the feed

.PARAMETER queueById
Id/Email of the instance that wants to access the feed

.EXAMPLE
Set-DefinedPSRepository -feedname "Release-Modules" -feedurl $feedurl -systemAccessToken $systemAccessToken -queueById $queueById

Set the feed Release-Modules as a nuget and repo source with the specified credentials
#>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $feedname,
        [Parameter(Mandatory = $true)]
        [string] $feedurl,
        [Parameter(Mandatory = $true)]
        [string] $systemAccessToken,
        [Parameter(Mandatory = $true)]
        [PSCredential] $credential,
        [Parameter(Mandatory = $true)]
        [string] $queueById
    )

    Write-Verbose "Register sources with feed-url [$feedurl]"

    Write-Verbose "Check registerd nuget sources"
    if ($isLinux) {
        # Assume linux with dotnet installation
        $nugetSources = dotnet nuget list source
    }
    else {
        # Assume windows with nuget installation
        $nugetSources = nuget sources
    }
    
    if (-not ("$nugetSources" -Match $feedName)) {
        if ($PSCmdlet.ShouldProcess("Nuget source definition [$feedname]", "Add")) {
            if ($isLinux) {
                # Assume linux with dotnet installation
                dotnet nuget add source $feedurl -n $feedName -u $queueById -p $systemAccessToken --store-password-in-clear-text
            }
            else {
                # Assume windows with nuget installation
                nuget sources add -name $feedname -Source $feedurl -Username $queueById -Password $systemAccessToken
            }
        }
    }
    else {
        Write-Verbose "NuGet source $feedname already registered"
    }

    if ($isLinux) {
        # Assume linux with dotnet installation
        dotnet nuget list source # Print registered
    }
    else {
        # Assume windows with nuget installation
        nuget sources # Print registered
    }

    Write-Verbose 'Check registered repositories'
    Import-Module 'PackageManagement' -Verbose:$false # Explicit import to suppress verbose
    Import-Module 'PowerShellGet' -Verbose:$false # Explicit import to suppress verbose
    $regRepos = (Get-PSRepository).Name
    if ($regRepos -notcontains $feedName) {
        if ($PSCmdlet.ShouldProcess("PSRepository", "Register new")) {
            Write-Verbose 'Registering script folder as Nuget repo'
            $registrationInputObject = @{
                Name                      = $feedname 
                SourceLocation            = $feedurl 
                PublishLocation           = $feedurl 
                Credential                = $credential 
                InstallationPolicy        = 'Trusted'
                PackageManagementProvider = 'Nuget'
            }
            Register-PSRepository @registrationInputObject
            Write-Verbose "Repository $feedname registered"
        }
    }
    else {
        Write-Verbose "Repository $feedname already registered"
    }

    Write-Verbose ("Available PS repositories:")
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

.PARAMETER currentFeedVersion
The selected custom version that must be higher than the given current version

.PARAMETER currentVersion
The given current version that must be lower than the selected custom version

.EXAMPLE
Confirm-CustomVersionIfSet -customVersion "1.0.0" -currentVersion "0.0.15"

Check if the selected version "1.0.0" is valid with regards to the current version "0.0.15"
#>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $false)]
        [string] $customVersion,
        [Parameter(Mandatory = $true)]
        [System.Version] $currentFeedVersion
    )

    # Check CustomVersion if set
    if ([string]::IsNullOrEmpty($customVersion) -or ($customVersion -eq '-')) {
        Write-Verbose "Custom Version not set. Skip check"
        return;
    }

    Write-Verbose "### Get custom version"
    Write-Verbose "Specified version is $customVersion"
    $singleValues = $customVersion.Split('.')
    $customBuild = $singleValues[2]
    $customMinor = $singleValues[1]
    $customMajor = $singleValues[0]

    $oldBuild = $currentFeedVersion.Build
    $oldMinor = $currentFeedVersion.Minor
    $oldMajor = $currentFeedVersion.Major

    Write-Verbose "Compare Versions"
    if ($customMajor -gt $oldMajor) {
        Write-Verbose "Specified version is valid"
        return $true
    }
    elseif ($customMajor -lt $oldMajor) {
        throw "Specified major version must not be older than than the existing version: Specified $customVersion > Current $currentFeedVersion"
    }
    else {
        if ($customMinor -gt $oldMinor) {
            Write-Verbose "Specified version is valid"
            return $true
        }
        elseif ($customMinor -lt $oldMinor) {
            throw "Specified minor version must not be older than than the existing version: Specified $customVersion > Current $currentFeedVersion"
        }
        else {
            if ($customBuild -gt $oldBuild) {
                Write-Verbose "Specified version is valid"
                return $true
            }
            else {
                throw "Specified build version must be newer than than the existing version: Specified $customVersion > Current $currentFeedVersion"
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

.PARAMETER feedname
Name of the feed to search in

.PARAMETER moduleName
Name of the module to search for

.PARAMETER credential
The credentials required to access the feed

.EXAMPLE
$currentFeedVersion = Get-CurrentVersion -moduleName "aks" -feedname "moduleFeed" -credential $credential

Search for module AKS in the feed moduleFeed to receive its version
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $feedname,
        [Parameter(Mandatory = $true)]
        [string] $moduleName,
        [Parameter(Mandatory = $true)]
        [PSCredential] $credential
    )

    Write-Verbose "Search for module [$moduleName] in feed [$feedname]"
    try {
        $module = Find-Module -Name $moduleName -Repository $feedname -Credential $credential
        return $module.Version
    }
    catch {
        if ($_.Exception.Message -like "*No match was found*") {
            Write-Verbose "Module $moduleName not found. Assuming first deployment"
            return New-Object System.Version("0.0.0")
        }
        else {
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

.PARAMETER customVersion
The optionally set custom version

.PARAMETER versioningOption
The version update. Patch, Minor or Major.

.PARAMETER currentFeedVersion
The current version of the module

.PARAMETER moduleBase
The root folder of the module

.PARAMETER moduleName
The name of the module

.EXAMPLE
Get-NewVersion -customVersion '-' -currentFeedVersion 0.0.4 -moduleBase "c:\modules\aks" -moduleName "aks"

If the current manifest version is 1.0.0 the function returns the 1.0.0 version object
else get the new version 0.0.5

.EXAMPLE
Get-NewVersion -customVersion 0.0.6 -currentFeedVersion 0.0.4 -moduleBase "c:\modules\aks" -moduleName "aks"

Get the new version 0.0.6
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $customVersion,

        [Parameter(Mandatory = $false)]
        [ValidateSet('patch', 'minor', 'major')]
        [string] $versioningOption = 'patch',

        [Parameter(Mandatory = $true)]
        [version] $currentFeedVersion,

        [Parameter(Mandatory = $true)]
        [string] $moduleBase,

        [Parameter(Mandatory = $true)]
        [string] $moduleName
    )
    
    $localVersion = (Import-LocalizedData -BaseDirectory "$moduleBase" -FileName "$moduleName.psd1").ModuleVersion

    if ((-not ([string]::IsNullOrEmpty($customVersion))) -and (-not ($customVersion -eq '-'))) {
        Write-Verbose "Apply custom version $customVersion"
        $newVersion = New-Object System.Version($customVersion)
    }
    elseif ($localVersion -gt $currentFeedVersion.ToString()) {
        Write-Verbose "Apply local manifest version $localVersion"
        $newVersion = $localVersion
    }
    else {
        Write-Verbose "Versioning option is set to [$versioningOption]. Applying."
        $build = $currentFeedVersion.Build
        $minor = $currentFeedVersion.Minor
        $major = $currentFeedVersion.Major

        if ($versioningOption -eq 'patch') { 
            $build++ 
        }
        elseif ($versioningOption -eq 'minor') {
            $minor++
            $build = 0
        }
        else {
            $major++
            $minor = 0
            $build = 0
        }

        $newVersion = New-Object System.Version("{0}.{1}.{2}" -f $major, $minor, $build)
    }
    return $newVersion
}
function Publish-NuGetModule {

    <#
.SYNOPSIS
Publish a given module to specified feed

.DESCRIPTION
Publish a given module to specified feed

.PARAMETER feedname
Nanm of the feed to push to

.PARAMETER credential
Credentials required by the feed

.EXAMPLE
Publish-NuGetModule -feedname "Release-Modules" -credential $credential -moduleName "Aks"

Push the module AKS to the feed 'Release-Modules'
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $feedname,
        [Parameter(Mandatory = $true)]
        [PSCredential] $credential,
        [Parameter(Mandatory = $true)]
        [string] $moduleBase,
        [Parameter(Mandatory = $true)]
        [string] $moduleName
    )

    try {
        Write-Verbose "Try pushing module [$moduleName] from base [$moduleBase] to feed [$feedname]"
        Publish-Module -Path "$moduleBase" -NuGetApiKey 'VSTS' -Repository $feedname -Credential $credential -Force
        Write-Verbose "Published module"
    }
    catch {
        Write-Verbose ("Unable to  upload module {0}" -f (Split-Path $PSScriptRoot -Leaf))
        $_.Exception | format-list -force
    }
}
function Set-LocalVersion {
    <#
.SYNOPSIS
Set the specified version to the module manifest

.DESCRIPTION
Set the specified version to the module manifest

.PARAMETER newVersion
The version to set

.PARAMETER moduleBase
The root folder of the module

.PARAMETER moduleName
The name of the module

.EXAMPLE
Set-LocalVersion -newVersion $newVersion -moduleBase "c:\modules\aks" -moduleName "aks"

Set the provided moduleVersion to the manifest of module aks in the folder 'c:\modules\aks'
#>
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [version] $newVersion,
        [Parameter(Mandatory = $true)]
        [string] $moduleBase,
        [Parameter(Mandatory = $true)]
        [string] $moduleName
    )

    $modulefile = "$moduleBase/$moduleName.psd1"
    if ($PSCmdlet.ShouldProcess("Module manifest", "Update")) {
        Update-ModuleManifest -Path $modulefile -ModuleVersion $newVersion -Verbose
    }
}
function Update-ManifestExportedFunction {
    <#
.SYNOPSIS
Add the module's public functions to its manifest

.DESCRIPTION
Extracts all functions in the module's public folder to add them as 'FunctionsToExport' int he manifest

.PARAMETER moduleBase
The root folder of the module

.PARAMETER moduleName
The name of the module

.EXAMPLE
Update-ManifestExportedFunction  -moduleBase "c:\modules\aks" -moduleName "aks"

Add all public functions of module AKS to its manifest
#>
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [string] $moduleBase,
        [Parameter(Mandatory = $true)]
        [string] $moduleName
    )

    $publicFunctions = (Get-ChildItem -Path "$moduleBase\Public" -Filter '*.ps1').BaseName

    $modulefile = "$moduleBase\$moduleName.psd1"
    if ($PSCmdlet.ShouldProcess("Module manifest", "Update")) {
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

.PARAMETER feedName
Name of the feed to push the module to. By default it's 'Release-Modules'

.PARAMETER feedurl
Optional feedurl to set by pipeline. Use {0} in path to specify the feedname
e.g. "https://apps-custom.pkgs.visualstudio.com/_packaging/{0}/nuget/v2"

.PARAMETER customVersion
If the new version should not be generated you can specify a custom version. It must be higher than the latest version inside the module feed.

.PARAMETER versioningOption
The version update. Patch, Minor or Major.

.PARAMETER systemAccessToken
Personal-Access-Token provieded by the pipeline or user to interact with the module feed

.PARAMETER queueById
Name/Email/Id of the user interacting with the module feed

.PARAMETER test
An optional parameter used by tests to only run code that is required for testing

.PARAMETER moduleBase
Root folder of the modbule to publish

.PARAMETER moduleName
Name of the module to publish   
#>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "", Justification = "Is provided by the pipeline as an encoded string")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $feedName,

        [Parameter(Mandatory = $true)]
        [string] $feedurl,

        [Parameter(Mandatory = $false)]
        [string] $customVersion = '-',

        [Parameter(Mandatory = $false)]
        [ValidateSet('patch', 'minor', 'major')]
        [string] $versioningOption = 'patch',

        [Parameter(Mandatory = $true)]
        [string] $systemAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $queueById,

        [Parameter(Mandatory = $true)]
        [string] $moduleBase,

        [Parameter(Mandatory = $true)]
        [string] $moduleName
    )

    $oldPreferences = $VerbosePreference
    $VerbosePreference = "Continue"

    try {
        $feedurl = $feedurl -f $feedName
        Write-Verbose "Feed-Url: $feedurl"

        $password = ConvertTo-SecureString $systemAccessToken -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential ($queueById, $password)

        Write-Verbose "Register feed"
        Set-DefinedPSRepository -feedname $feedName -feedurl $feedurl -systemAccessToken $systemAccessToken -Credential $credential -queueById $queueById

        $currentFeedVersion = Get-CurrentVersion -feedname $feedName -moduleName $moduleName -credential $credential
        Write-Verbose "Current version of module '$moduleName' in feed '$feedName' is $currentFeedVersion"

        Confirm-CustomVersionIfSet -customVersion $customVersion -currentFeedVersion $currentFeedVersion

        $newVersion = Get-NewVersion -customVersion $customVersion -versioningOption $versioningOption -currentFeedVersion $currentFeedVersion -moduleName $moduleName -moduleBase $moduleBase
        Write-Verbose "New version is $newVersion"

        Set-LocalVersion -newVersion $newVersion -moduleName $moduleName -moduleBase $moduleBase
        Write-Verbose "Updated local version to $newVersion"

        Update-ManifestExportedFunction -moduleName $moduleName -moduleBase $moduleBase

        Test-ModuleManifest -Path "$moduleBase\$moduleName.psd1" | Format-List

        Publish-NuGetModule -feedname $feedname -credential $credential -moduleName $moduleName -moduleBase $moduleBase
    }
    finally {
        $VerbosePreference = $oldPreferences
    }
}