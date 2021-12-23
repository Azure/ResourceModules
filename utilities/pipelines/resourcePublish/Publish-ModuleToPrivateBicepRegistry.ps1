<#
.SYNOPSIS
Publish a new version of a given module to a private bicep registry

.DESCRIPTION
Publish a new version of a given module to a private bicep registry
The function will take evaluate which version should be published based on the provided input parameters (customVersion, versioningOption) and the version currently deployed to the private bicep registry
If the customVersion is higher than the current latest, it has the highest priority over the other options
Otherwise, one of the provided version options is chosen and applied with the default being 'patch'

.PARAMETER templateFilePath
Mandatory. Path to the module deployment file from root.

.PARAMETER bicepRegistryName
Mandatory. Name of the private bicep registry to publish to.

.PARAMETER bicepRegistryRgName
Mandatory. ResourceGroup of the private bicep registry to publish to.

.PARAMETER customVersion
Optional. A custom version that can be provided by the UI. '-' represents an empty value.

.PARAMETER versioningOption
Optional. A version option that can be specified in the UI. Defaults to 'patch'

.EXAMPLE
Publish-ModuleToPrivateBicepRegistry -templateFilePath 'C:/KeyVault/deploy.json' -bicepRegistryRgName 'artifacts-rg' -customVersion '3.0.0'

Try to publish the KeyVault module with version 3.0.0 to a private bicep registry called KeyVault based on a value provided in the UI
#>
function Publish-ModuleToPrivateBicepRegistry {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $templateFilePath,

        [Parameter(Mandatory)]
        [string] $bicepRegistryRgName,

        [Parameter(Mandatory)]
        [string] $bicepRegistryName,

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
        if ((Split-Path $templateFilePath -Extension) -ne '.bicep') {
            throw "The template in path [$templateFilePath] is no bicep template."
        }

        # Registry
        if (-not (Get-AzContainerRegistry -ResourceGroupName $bicepRegistryRgName -Name $bicepRegistryName -ErrorAction 'SilentlyContinue')) {
            if ($PSCmdlet.ShouldProcess("Container Registry [$bicepRegistryName] to resource group [$bicepRegistryRgName]", 'Deploy')) {
                New-AzContainerRegistry -ResourceGroupName $bicepRegistryRgName -Name $bicepRegistryName -Sku 'Basic'
            }
        }

        #################################
        ##    FIND AVAILABLE VERSION   ##
        #################################
        # Extracts Microsoft.KeyVault/vaults from e.g. C:\arm\Microsoft.KeyVault\vaults\deploy.bicep
        $ $moduleRegistryIdentifier = 'bicep/modules/{0}' -f $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()

        if (-not ($repositories = Get-AzContainerRegistryRepository -RegistryName $bicepRegistryName -ErrorAction 'SilentlyContinue')) {
            # No repositories yet
            $repositories = @()
        }

        if ($repositories.Contains($moduleRegistryIdentifier)) {
            $versions = (Get-AzContainerRegistryTag -RegistryName $bicepRegistryName -RepositoryName $moduleRegistryIdentifier).Tags.Name
            $latestVersion = (($versions -as [Version[]]) | Measure-Object -Maximum).Maximum
            Write-Verbose "Published versions detected in private bicep registry [$moduleIdentifier]. Fetched latest [$latestVersion]."
        } else {
            Write-Verbose "No version for module reference [$moduleRegistryIdentifier] detected in private bicep registry [$bicepRegistryName]. Creating new."
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
            throw ('The provided custom version [{0}] must be higher than the current latest version [{1}] published in the private bicep registry [{2}]' -f $newVersionObject.ToString(), $latestVersion.ToString(), $bicepRegistryName)
        }

        #############################################
        ##    Publish to private bicep registry    ##
        #############################################
        $publishingTarget = 'br:{0}.azurecr.io/{1}:{2}' -f $bicepRegistryName, $moduleRegistryIdentifier, $newVersion
        if ($PSCmdlet.ShouldProcess("Private bicep registry entry [$moduleRegistryIdentifier] version [$newVersion] to registry [$bicepRegistryName]", 'Publish')) {
            bicep publish $templateFilePath --target $publishingTarget
        }
        Write-Verbose 'Publish complete'
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
        #############################################
        ##    Publish to private bicep registry    ##
        #############################################
        $publishingTarget = 'br:{0}.azurecr.io/{1}:{2}' -f $bicepRegistryName, $moduleRegistryIdentifier, $newVersion
        if ($PSCmdlet.ShouldProcess("Private bicep registry entry [$moduleRegistryIdentifier] version [$newVersion] to registry [$bicepRegistryName]", 'Publish')) {
            bicep publish $templateFilePath --target $publishingTarget
        }
        Write-Verbose 'Publish complete'
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
