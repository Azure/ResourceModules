<#
.SYNOPSIS
Publish a new version of a given module to a private bicep registry

.DESCRIPTION
Publish a new version of a given module to a private bicep registry
The function will take evaluate which version should be published based on the provided input parameters (customVersion, versioningOption) and the version currently deployed to the private bicep registry
If the customVersion is higher than the current latest, it has the highest priority over the other options
Otherwise, one of the provided version options is chosen and applied with the default being 'patch'

.PARAMETER moduleName
Mandatory. The name of the module to publish. It will be the name of the private bicep registry.

.PARAMETER templateFilePath
Mandatory. Path to the module deployment file from root.

.PARAMETER componentBicepRegistryName
Mandatory. Name of the private bicep registry to publish to.

.PARAMETER componentBicepRegistryRGName
Mandatory. ResourceGroup of the private bicep registry to publish to.

.PARAMETER customVersion
Optional. A custom version that can be provided by the UI. '-' represents an empty value.

.PARAMETER versioningOption
Optional. A version option that can be specified in the UI. Defaults to 'patch'

.EXAMPLE
Publish-ModuleToPrivateBicepRegistry -moduleName 'KeyVault' -templateFilePath 'C:/KeyVault/deploy.json' -componentBicepRegistryRGName 'artifacts-rg' -customVersion '3.0.0'

Try to publish the KeyVault module with version 3.0.0 to a private bicep registry called KeyVault based on a value provided in the UI
#>
function Publish-ModuleToPrivateBicepRegistry {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $moduleName,

        [Parameter(Mandatory)]
        [string] $templateFilePath,

        [Parameter(Mandatory)]
        [string] $componentBicepRegistryRGName,

        [Parameter(Mandatory)]
        [string] $componentBicepRegistryName,

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
        if (-not (Get-AzContainerRegistry -ResourceGroupName $componentBicepRegistryRGName -Name $componentBicepRegistryName -ErrorAction 'SilentlyContinue')) {
            if ($PSCmdlet.ShouldProcess("Container Registry [$componentBicepRegistryName] to resource group [$componentBicepRegistryRGName]", 'Deploy')) {
                New-AzContainerRegistry -ResourceGroupName $componentBicepRegistryRGName -Name $componentBicepRegistryName -Sku 'Basic'
            }
        }

        #################################
        ##    FIND AVAILABLE VERSION   ##
        #################################
        if ($PSCmdlet.ShouldProcess("Latest available version in private bicep registry [$moduleName]", 'Fetch')) {
            $res = Get-AzTemplateSpec -ResourceGroupName $componentBicepRegistryRGName -Name $moduleName -ErrorAction 'SilentlyContinue'
        }
        if (-not $res) {
            Write-Verbose "No version detected in private bicep registry [$moduleName]. Creating new."
            $latestVersion = New-Object System.Version('0.0.0')
        } else {
            $uniqueVersions = $res.Versions.Name | Get-Unique | Where-Object { $_ -like '*.*.*' } # remove Where-object for working example
            $latestVersion = (($uniqueVersions -as [Version[]]) | Measure-Object -Maximum).Maximum
            Write-Verbose "Published versions detected in private bicep registry [$moduleName]. Fetched latest [$latestVersion]."
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
            throw ('The provided custom version [{0}] must be higher than the current latest version [{1}] published in the private bicep registry [{2}]' -f $newVersionObject.ToString(), $latestVersion.ToString(), $moduleName)
        }

        #############################################
        ##    Publish to private bicep registry    ##
        #############################################
        if ($PSCmdlet.ShouldProcess("Private bicep registry entry [$moduleName] version [$newVersion]", 'Publish')) {
            bicep publish $templateFilePath --target 'br:{0}.azurecr.io/bicep/modules/{1}:v{2}' -f $componentBicepRegistryName, $moduleName, $newVersion
        }
        Write-Verbose 'Publish complete'
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
