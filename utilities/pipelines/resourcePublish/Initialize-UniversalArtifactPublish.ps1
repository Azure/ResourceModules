<#
.SYNOPSIS
Prepare to publish a module as an universal package to a DevOps artifact feed

.DESCRIPTION
Prepare to publish a module as an universal package to a DevOps artifact feed
The function will take evaluate which version should be published based on the provided input parameters (customVersion, versioningOption) and the version currently deployed to the feed
The customVersion is considered only if it is higher than the latest version deployed to the artifact feed
Otherwise, one of the provided version options is chosen and applied with the default being 'patch'

The function returns
- the name of the artifact to publish
- the version option to be applied if applicable
- the version to be applied if applicable

.PARAMETER templateFilePath
Mandatory. Path to the module deployment file from root.

.PARAMETER vstsOrganization
Mandatory. Name of the organization hosting the artifacts feed.

.PARAMETER vstsProject
Optional. Name of the project hosting the artifacts feed. May be empty.

.PARAMETER vstsFeedName
Mandatory. Name to the feed to publish to.

.PARAMETER customVersion
Optional. A custom version the can be provided as a value in the pipeline file.

.PARAMETER versioningOption
Optional. A version option that can be specified in the UI. Defaults to 'patch'

.EXAMPLE
Initialize-UniversalArtifactPublish -templateFilePath 'C:/KeyVault/deploy.json' -vstsOrganization 'servicescode' -vstsProject '$(System.TeamProject)' -vstsFeedName 'Modules' -customVersion '3.0.0'

Try to publish the key vault module with version 3.0.0 to the module feed 'servicescode/$(System.TeamProject)/Modules' based on a value provided in the UI

.EXAMPLE
Initialize-UniversalArtifactPublish -templateFilePath 'C:/KeyVault/deploy.json' -vstsOrganization 'servicescode' -vstsProject '$(System.TeamProject)' -vstsFeedName 'Modules' -customVersion '1.0.0'

Try to publish the key vault module with version 1.0.0 to the module feed 'servicescode/$(System.TeamProject)/Modules' based on a value provided in the pipeline file

.EXAMPLE
Initialize-UniversalArtifactPublish -templateFilePath 'C:/KeyVault/deploy.json' -vstsOrganization 'servicescode' -vstsProject '$(System.TeamProject)' -vstsFeedName 'Modules'

Try to publish the next key vault module version to the module feed 'servicescode/$(System.TeamProject)/Modules' based on the default versioning behavior
#>
function Initialize-UniversalArtifactPublish {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $templateFilePath,

        [Parameter(Mandatory)]
        [string] $vstsOrganization,

        [Parameter(Mandatory = $false)]
        [string] $vstsProject = '',

        [Parameter(Mandatory)]
        [string] $vstsFeedName,

        [Parameter(Mandatory = $false)]
        [string] $customVersion = '0.0.1',

        [Parameter(Mandatory = $false)]
        [ValidateSet('Major', 'Minor', 'Patch', 'Custom')]
        [string] $versioningOption = 'Patch'
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        # For function output
        $resultSet = @{}

        $moduleIdentifier = (Split-Path $templateFilePath -Parent).Replace('\', '/').Split('/arm/')[1]
        $universalPackageModuleName = $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()
        $resultSet['universalPackageModuleName'] = $universalPackageModuleName

        #################################
        ##    FIND AVAILABLE VERSION   ##
        #################################
        try {
            $head = @{ Authorization = "Bearer $env:TOKEN" }
            $url = "https://feeds.dev.azure.com/$vstsOrganization/$vstsProject/_apis/packaging/Feeds/$vstsFeedName/packages?packageNameQuery=$universalPackageModuleName&api-version=6.0-preview"
            $packages = Invoke-RestMethod -Uri $url -Method Get -Headers $head -ContentType application/json
            if ($packages) {
                if ($packages.value.id.count -gt 1) {
                    # Handle the case where multiple modules in the feed start with with the same packageName. In this case we have to filter the result of the REST query even further.
                    $packages.value = $packages.value | Where-Object { $_.Name -eq $universalPackageModuleName }
                }

                $latestFeedVersion = ($packages.value.versions.Where( { $_.isLatest -eq $True })).version
                Write-Verbose ('Package Id of [{0}] is [{1}]' -f $universalPackageModuleName, $packages.value.Id) -Verbose
                Write-Verbose "The latest version is [$latestFeedVersion]" -Verbose
            } else {
                Write-Verbose "No packages via url [$url] found" -Verbose
            }
        } catch {
            $_
        }

        ############################
        ##    EVALUATE VERSION    ##
        ############################

        if ([String]::IsNullOrEmpty($latestFeedVersion)) {
            Write-Verbose ('No version for module [{0}] found in feed [{1}]. Assuming intial publish' -f $universalPackageModuleName, $vstsFeedName) -Verbose
            $latestFeedVersion = New-Object System.Version('0.0.1')
        } elseif (-not (([String]::IsNullOrEmpty($customVersion)) -or ([String]::IsNullOrEmpty($latestFeedVersion))) -and ((New-Object System.Version($customVersion)) -gt (New-Object System.Version($latestFeedVersion))) ) {
            Write-Verbose "A custom version [$customVersion] was specified in the pipeline script and is higher than the current latest. Using it." -Verbose
            $versioningOption = 'custom'
            $newVersion = $customVersion
        } else {
            Write-Verbose 'No custom version set. Using default versioning.'
        }

        # Test if mode custom
        # -------------------
        if ($versioningOption -eq 'custom') {
            $newVersionObject = New-Object System.Version($newVersion)
            $latestFeedVersionObject = New-Object System.Version($latestFeedVersion)
            if ($newVersionObject -lt $latestFeedVersionObject -or $newVersionObject -eq $latestFeedVersionObject) {
                throw ('The provided custom version [{0}] must be higher than the current latest version [{1}] published in the artifacts feed [{2}]' -f $newVersionObject.ToString(), $latestFeedVersionObject.ToString(), $vstsFeedName)
            }
            Write-Verbose "Using publish version [$newVersionObject]" -Verbose
            $resultSet['newVersionObject'] = $newVersionObject
        }
        Write-Verbose "Using publish mode [$versioningOption]" -Verbose
        $resultSet['publishingMode'] = $versioningOption

        return $resultSet
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)

    }
}
