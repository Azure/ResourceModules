<#
.SYNOPSIS
Publish a new version of a given module to a template spec

.DESCRIPTION
Publish a new version of a given module to a template spec
The function will take evaluate which version should be published based on the provided input parameters (customVersion, versioningOption) and the version currently deployed to the template spec
If the customVersion is higher than the current latest, it has the highest priority over the other options
Otherwise, one of the provided version options is chosen and applied with the default being 'patch'

The template spec is set up if not already existing.

.PARAMETER moduleIdentifier
Mandatory. The identifier of the module to publish (ProviderNamespace/ResourceType Combination). It will be the name of the template spec.
E.g. 'Microsoft.KeyVault/vaults'

.PARAMETER templateFilePath
Mandatory. Path to the module deployment file from root.

.PARAMETER templateSpecsRGName
Mandatory. ResourceGroup of the template spec to publish to.

.PARAMETER templateSpecsRGLocation
Mandatory. Location of the template spec resource group.

.PARAMETER templateSpecsDescription
Mandatory. The description of the parent template spec.

.PARAMETER customVersion
Optional. A custom version that can be provided by the UI. '-' represents an empty value.

.PARAMETER versioningOption
Optional. A version option that can be specified in the UI. Defaults to 'patch'

.EXAMPLE
Publish-ModuleToTemplateSpec moduleIdentifier 'Microsoft.KeyVault/vaults' -templateFilePath 'C:/KeyVault/deploy.json' -templateSpecsRGName 'artifacts-rg' -templateSpecsRGLocation 'West Europe' -templateSpecsDescription 'iacs key vault' -customVersion '3.0.0'

Try to publish the KeyVault module with version 3.0.0 to a template spec called KeyVault based on a value provided in the UI
#>
function Publish-ModuleToTemplateSpec {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $moduleIdentifier,

        [Parameter(Mandatory)]
        [string] $templateFilePath,

        [Parameter(Mandatory)]
        [string] $templateSpecsRGName,

        [Parameter(Mandatory)]
        [string] $templateSpecsRGLocation,

        [Parameter(Mandatory)]
        [string] $templateSpecsDescription,

        [Parameter(Mandatory = $false)]
        [string] $customVersion = '0.0.1',

        [Parameter(Mandatory = $false)]
        [ValidateSet('Major', 'Minor', 'Patch')]
        [string] $versioningOption = 'Patch'
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        #############################
        ##    EVALUATE RESOURCES   ##
        #############################
        if (-not (Get-AzResourceGroup -Name $templateSpecsRGName -ErrorAction 'SilentlyContinue')) {
            if ($PSCmdlet.ShouldProcess("Resource group [$templateSpecsRGName] to location [$templateSpecsRGLocation]", 'Deploy')) {
                New-AzResourceGroup -Name $templateSpecsRGName -Location $templateSpecsRGLocation
            }
        }

        #################################
        ##    FIND AVAILABLE VERSION   ##
        #################################
        $moduleRegistryIdentifier = 'bicep/modules/{0}' -f $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()

        $res = Get-AzTemplateSpec -ResourceGroupName $templateSpecsRGName -Name $moduleRegistryIdentifier -ErrorAction 'SilentlyContinue'
        if (-not $res) {
            Write-Verbose "No version detected in template spec [$moduleRegistryIdentifier]. Creating new."
            $latestVersion = New-Object System.Version('0.0.0')
        } else {
            $uniqueVersions = $res.Versions.Name | Get-Unique | Where-Object { $_ -like '*.*.*' } # remove Where-object for working example
            $latestVersion = (($uniqueVersions -as [Version[]]) | Measure-Object -Maximum).Maximum
            Write-Verbose "Published versions detected in template spec [$moduleRegistryIdentifier]. Fetched latest [$latestVersion]."
        }

        ############################
        ##    EVALUATE VERSION    ##
        ############################

        if (-not ([String]::IsNullOrEmpty($customVersion)) -and ((New-Object System.Version($customVersion)) -gt (New-Object System.Version($latestVersion)))) {
            Write-Verbose "A custom version [$customVersion] was specified in the pipeline script and is higher than the current latest. Using it."
            $newVersion = $customVersion
        } else {
            Write-Verbose 'No custom version set. Using default versioning.'

            switch ($versioningOption) {
                'major' {
                    Write-Verbose 'Apply version update on "major" level'
                    $newVersion = (New-Object -TypeName System.Version -ArgumentList ($latestVersion.Major + 1), $latestVersion.Minor, $latestVersion.Build).ToString()
                    break
                }
                'minor' {
                    Write-Verbose 'Apply version update on "minor" level'
                    $newVersion = (New-Object -TypeName System.Version -ArgumentList $latestVersion.Major, ($latestVersion.Minor + 1), $latestVersion.Build).ToString()
                    break
                }
                'patch' {
                    Write-Verbose 'Apply version update on "patch" level'
                    $newVersion = (New-Object -TypeName System.Version -ArgumentList $latestVersion.Major, $latestVersion.Minor, ($latestVersion.Build + 1)).ToString()
                    break
                }
                default {
                    throw "Unsupported version option: $versioningOption."
                }
            }
        }

        $newVersionObject = New-Object System.Version($newVersion)
        if ($newVersionObject -lt $latestVersion -or $newVersionObject -eq $latestVersion) {
            throw ('The provided custom version [{0}] must be higher than the current latest version [{1}] published in the template spec [{2}]' -f $newVersionObject.ToString(), $latestVersion.ToString(), $templateSpecsName)
        }

        ################################
        ##    Create template spec    ##
        ################################
        if ($PSCmdlet.ShouldProcess("Template spec [$moduleRegistryIdentifier] version [$newVersion]", 'Publish')) {
            $templateSpecInputObject = @{
                ResourceGroupName = $templateSpecsRGName
                Name              = $moduleRegistryIdentifier
                Version           = $newVersion
                Description       = $templateSpecsDescription
                Location          = $templateSpecsRGLocation
                TemplateFile      = $templateFilePath
            }
            New-AzTemplateSpec @templateSpecInputObject
        }
        Write-Verbose 'Publish complete'
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
