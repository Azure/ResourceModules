#region Helper
<#
.SYNOPSIS
Asserts that the given version string it semver 2.0 compatible

.DESCRIPTION
Asserts that the given version string it semver 2.0 compatible

.PARAMETER Version
The version to check

.EXAMPLE
Assert-SemVerCompatability -Version '1.0.0'

True

Checks if the version '1.0.0' is semver 2.0 compatible

#>
function Assert-SemVerCompatability {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Version
    )

    return $Version -match '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'
}
#endregion

<#
.SYNOPSIS
Publish a new version of a given module to an Azure DevOps artifact feed as a universal package.

.DESCRIPTION
Publish a new version of a given module to an Azure DevOps artifact feed as a universal package.

.PARAMETER TemplateFilePath
Mandatory. Path to the module deployment file from root.
Example: 'C:\modules\key-vault\vaults\main.bicep'

.PARAMETER ModuleVersion
Mandatory. Version of the module to publish, following SemVer convention.
Example: '1.0.0', '2.1.5-alpha.1', '0.0.5-beta.1'

.PARAMETER VstsOrganizationUri
Mandatory. Azure DevOps organization URL hosting the artifacts feed.
Example: 'https://dev.azure.com/fabrikam/'.

.PARAMETER VstsFeedProject
Optional. Name of the project hosting the artifacts feed. May be empty.
Example: 'IaC'.

.PARAMETER VstsFeedName
Mandatory. Name to the feed to publish to.
Example: 'Artifacts'.

.PARAMETER BearerToken
Optional. The bearer token to use to authenticate the request. If not provided it MUST be existing in your environment as `$env:TOKEN`

.EXAMPLE
Publish-ModuleToUniversalArtifactsFeed -TemplateFilePath 'C:\modules\key-vault\vaults\main.bicep' -ModuleVersion '3.0.0-alpha' -vstsOrganizationUri 'https://dev.azure.com/fabrikam' -VstsProject 'IaC' -VstsFeedName 'Artifacts'

Try to publish the KeyVault module with version 3.0.0-alpha to a Universal Package Feed called 'Artifacts' under the project 'IaC'.
#>
function Publish-ModuleToUniversalArtifactsFeed {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory)]
        [string] $VstsOrganizationUri,

        [Parameter(Mandatory = $false)]
        [string] $VstsFeedProject = '',

        [Parameter(Mandatory)]
        [string] $VstsFeedName,

        [Parameter(Mandatory = $false)]
        [string] $BearerToken = $env:TOKEN,

        [Parameter(Mandatory)]
        [string] $ModuleVersion
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper functions
        . (Join-Path $PSScriptRoot 'Get-UniversalArtifactsName.ps1')
    }

    process {
        if (-not (Assert-SemVerCompatability -Version $ModuleVersion)) {
            Write-Warning "Invalid module version: [$ModuleVersion] - Skipping"
            return
        }

        #################################
        ##    Generate package name    ##
        #################################
        $universalPackageModuleName = Get-UniversalArtifactsName -TemplateFilePath $TemplateFilePath

        ###########################
        ##    Find feed scope    ##
        ###########################
        $feedScope = 'organization'

        if (-not [string]::IsNullOrEmpty($VstsFeedProject)) {
            $feedScope = 'project'
        }
        Write-Verbose "The package feed scope is [$feedScope]" -Verbose

        #############################################
        ##    Publish to Universal Package Feed    ##
        #############################################
        if ($PSCmdlet.ShouldProcess("Universal Package Feed entry [$universalPackageModuleName] version [$ModuleVersion] to feed [$VstsOrganizationUri/$VstsFeedProject/$VstsFeedName]", 'Publish')) {
            $env:AZURE_DEVOPS_EXT_PAT = $BearerToken
            $inputObject = @(
                '--organization', $VstsOrganizationUri,
                '--feed', $VstsFeedName,
                '--scope', $feedScope,
                '--name', $universalPackageModuleName,
                '--version', $ModuleVersion,
                '--path', (Split-Path $TemplateFilePath -Parent),
                '--description', "$universalPackageModuleName Module",
                '--verbose'
            )

            if (-not [string]::IsNullOrEmpty($VstsFeedProject)) {
                $inputObject += @('--project', "$VstsFeedProject")
            }

            try {
                az artifacts universal publish @inputObject
            } catch {
                Write-Warning "Failed to publish module to Universal Package Feed [$VstsOrganizationUri/$VstsFeedProject/$VstsFeedName]"
                Write-Warning $_
            }

        }
        Write-Verbose 'Publish complete'
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
