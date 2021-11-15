<#
.SYNOPSIS
Publish a new version of a given module to a template spec

.DESCRIPTION
Publish a new version of a given module to a template spec
The function will take evaluate which version should be published based on the provided input parameters (customVersion, versioningOption) and the version currently deployed to the template spec
If the customVersion is higher than the current latest, it has the highest priority over the other options
Otherwise, one of the provided version options is chosen and applied with the default being 'patch'

The template spec is set up if not already existing.

.PARAMETER templateFilePath
Mandatory. Path to the module deployment file from root.

.PARAMETER templateSpecsRgName
Mandatory. ResourceGroup of the template spec to publish to.

.PARAMETER templateSpecsRgLocation
Mandatory. Location of the template spec resource group.

.PARAMETER templateSpecsDescription
Mandatory. The description of the parent template spec.

.PARAMETER customVersion
Optional. A custom version that can be provided by the UI. '-' represents an empty value.

.PARAMETER versioningOption
Optional. A version option that can be specified in the UI. Defaults to 'patch'

.EXAMPLE
Publish-ModuleToTemplateSpec -templateFilePath 'C:/KeyVault/deploy.json' -templateSpecsRgName 'artifacts-rg' -templateSpecsRgLocation 'West Europe' -templateSpecsDescription 'iacs key vault' -customVersion '3.0.0'

Try to publish the KeyVault module with version 3.0.0 to a template spec called KeyVault based on a value provided in the UI
#>
function Publish-ModuleToTemplateSpec {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $templateFilePath,

        [Parameter(Mandatory)]
        [string] $templateSpecsRgName,

        [Parameter(Mandatory)]
        [string] $templateSpecsRgLocation,

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
        $moduleIdentifier = (Split-Path $templateFilePath -Parent).Replace('\', '/').Split('/arm/')[1]
        $templateSpecIdentifier = $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()

        #############################
        ##    EVALUATE RESOURCES   ##
        #############################
        if (-not (Get-AzResourceGroup -Name $templateSpecsRgName -ErrorAction 'SilentlyContinue')) {
            if ($PSCmdlet.ShouldProcess("Resource group [$templateSpecsRgName] to location [$templateSpecsRgLocation]", 'Deploy')) {
                New-AzResourceGroup -Name $templateSpecsRgName -Location $templateSpecsRgLocation
            }
        }

        #################################
        ##    FIND AVAILABLE VERSION   ##
        #################################
        if ($templateSpec = Get-AzTemplateSpec -ResourceGroupName $templateSpecsRgName -Name $templateSpecIdentifier -ErrorAction 'SilentlyContinue') {
            $uniqueVersions = $templateSpec.Versions.Name | Get-Unique | Where-Object { $_ -like '*.*.*' } # remove Where-object for working example
            $latestVersion = (($uniqueVersions -as [Version[]]) | Measure-Object -Maximum).Maximum
            Write-Verbose "Published versions detected in template spec [$templateSpecIdentifier]. Fetched latest [$latestVersion]."
        } else {
            Write-Verbose "No version detected in template spec [$templateSpecIdentifier]. Creating new."
            $latestVersion = New-Object System.Version('0.0.0')
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
                    $newVersion = (New-Object -TypeName System.Version -ArgumentList ($latestVersion.Major + 1), 0, 0).ToString()
                    break
                }
                'minor' {
                    Write-Verbose 'Apply version update on "minor" level'
                    $newVersion = (New-Object -TypeName System.Version -ArgumentList $latestVersion.Major, ($latestVersion.Minor + 1), 0).ToString()
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
            throw ('The provided custom version [{0}] must be higher than the current latest version [{1}] published in the template spec [{2}]' -f $newVersionObject.ToString(), $latestVersion.ToString(), $templateSpecIdentifier)
        }

        ################################
        ##    Create template spec    ##
        ################################
        if ($PSCmdlet.ShouldProcess("Template spec [$templateSpecIdentifier] version [$newVersion]", 'Publish')) {
            $templateSpecInputObject = @{
                ResourceGroupName = $templateSpecsRgName
                Name              = $templateSpecIdentifier
                Version           = $newVersion
                Description       = $templateSpecsDescription
                Location          = $templateSpecsRgLocation
                TemplateFile      = $templateFilePath
            }
            New-AzTemplateSpec @templateSpecInputObject -Force
        }
        Write-Verbose 'Publish complete'
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
