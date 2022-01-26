<#
.SYNOPSIS
Publish a new version of a given module to a DevOps artifact feed

.DESCRIPTION
Publish a new version of a given module to a DevOps artifact feed

.PARAMETER TemplateFilePath
Mandatory. Path to the module deployment file from root.
Example: 'C:\arm\Microsoft.KeyVault\vaults\deploy.bicep'

.PARAMETER ModuleVersion
Required. Version of the module to publish, following SemVer convention.
Example: '1.0.0', '2.1.5-alpha.1', '0.0.5-beta.1'

.PARAMETER VstsOrganization
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
Publish-ModuleToUniversalArtifactFeed -TemplateFilePath 'C:\arm\Microsoft.KeyVault\vaults\deploy.bicep' -ModuleVersion '3.0.0-alpha' -VstsOrganization 'https://dev.azure.com/fabrikam' -VstsProject 'IaC' -VstsFeedName 'Artifacts'

Try to publish the KeyVault module with version 3.0.0-alpha to a Universal Package Feed called KeyVault in the feed called 'Artifacts' under the project 'IaC'.
#>
function Publish-ModuleToUniversalArtifactFeed {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory)]
        [string] $VstsOrganization,

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
    }

    process {

        #################################
        ##    Generate package name    ##
        #################################

        # Universal package names => lowercase alphanumerics, dashes, dots or underscores, under 256 characters.
        # 'C:\arm\Microsoft.KeyVault\vaults\deploy.bicep' => 'microsoft.keyvault.vaults'
        $ModuleFolderPath = Split-Path $TemplateFilePath -Parent
        $universalPackageModuleName = $ModuleFolderPath.Replace('\', '/').Split('/arm/')[1]
        $universalPackageModuleName = ($universalPackageModuleName.Replace('\', '.').Replace('/', '.').toLower() -Replace '[^a-z0-9\.\-_]')[0..255] -join ''
        Write-Verbose "The universal package name is [$universalPackageModuleName]" -Verbose

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
        if ($PSCmdlet.ShouldProcess("Universal Package Feed entry [$universalPackageModuleName] version [$ModuleVersion] to feed [$VstsOrganization/$VstsFeedProject/$VstsFeedName]", 'Publish')) {
            $env:AZURE_DEVOPS_EXT_PAT = $BearerToken
            $inputObject = @(
                '--organization', "$VstsOrganization",
                '--feed', "$VstsFeedName",
                '--scope', "$feedScope",
                '--name', "$universalPackageModuleName",
                '--version', "$ModuleVersion",
                '--path', "$ModuleFolderPath",
                '--description', "$universalPackageModuleName Module",
                '--verbose'
            )
            if (-not [string]::IsNullOrEmpty($VstsFeedProject)) {
                $inputObject += @('--project', "$VstsFeedProject")
            }

            Write-Verbose 'The command to publish to the feed is:' -Verbose
            $command = "az artifacts universal publish $($inputObject -join ' ')"
            Write-Verbose $command -Verbose

            az artifacts universal publish @inputObject

        }
        Write-Verbose 'Publish complete'
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
