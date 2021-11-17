# Note: The installation commands in this script are optimized for Linux

#region Helper Functions
<#
    .SYNOPSIS
    Installes given PowerShell modules

    .DESCRIPTION
    Installes given PowerShell modules

    .PARAMETER Module
    Modules to be installed, must be Object
    @{
        Name = 'Name'
        Version = '1.0.0' # Optional
    }

    .EXAMPLE
    Install-CustomModule @{ Name = 'Pester' } C:\Modules

    Installes pester and saves it to C:\Modules
#>
function Install-CustomModule {

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [Hashtable] $Module
    )

    # Remove exsisting module in session
    if (Get-Module $Module -ErrorAction SilentlyContinue) {
        try {
            Remove-Module $Module -Force
        } catch {
            Write-Error ("Unable to remove module $($Module.Name)  : $($_.Exception) found, $($_.ScriptStackTrace)")
        }
    }

    # Install found module
    $moduleImportInputObject = @{
        name       = $Module.Name
        Repository = 'PSGallery'
    }
    if ($module.Version) {
        $moduleImportInputObject['RequiredVersion'] = $module.Version
    }
    $foundModules = Find-Module @moduleImportInputObject
    foreach ($foundModule in $foundModules) {

        $localModuleVersions = Get-Module $foundModule.Name -ListAvailable
        if ($localModuleVersions -and $localModuleVersions.Version -contains $foundModule.Version ) {
            Write-Verbose ('Module [{0}] already installed with version [{1}]' -f $foundModule.Name, $foundModule.Version) -Verbose
            continue
        }
        if ($module.ExcludeModules -and $module.excludeModules.contains($foundModule.Name)) {
            Write-Verbose ('Module {0} is configured to be ignored.' -f $foundModule.Name) -Verbose
            continue
        }

        Write-Verbose ('Install module [{0}] with version [{1}]' -f $foundModule.Name, $foundModule.Version) -Verbose
        if ($PSCmdlet.ShouldProcess('Module [{0}]' -f $foundModule.Name, 'Install')) {
            $foundModule | Install-Module -Force -SkipPublisherCheck -AllowClobber
            if ($installed = Get-Module -Name $foundModule.Name -ListAvailable) {
                Write-Verbose ('Module [{0}] is installed with version [{1}]' -f $installed.Name, $installed.Version) -Verbose
            } else {
                Write-Error ('Installation of module [{0}] failed' -f $foundModule.Name)
            }
        }
    }
}
#endregion

<#
.SYNOPSIS
Configure the current agent

.DESCRIPTION
Configure the current agent with e.g. the necessary PowerShell modules.

.PARAMETER Modules
Optional. The PowerShell modules that should be installed on the agent. Installs default set if not provided.
@{
    Name = 'Name'
    Version = '1.0.0' # Optional
}

.EXAMPLE
Set-EnvironmentOnAgent

Install the default PowerShell modules to configure the agent
#>
function Set-EnvironmentOnAgent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Hashtable[]] $Modules = @(
            @{ Name = 'Az.Accounts' },
            @{ Name = 'Az.Resources' },
            @{ Name = 'Az.NetAppFiles' },
            @{ Name = 'Az.Network' },
            @{ Name = 'Az.ContainerRegistry' },
            @{ Name = 'Az.KeyVault' },
            @{ Name = 'Pester'; Version = '5.3.0' }
        )
    )

    ###########################
    ##   Install Azure CLI   ##
    ###########################

    # AzCLI is pre-installed on GitHub hosted runners.
    # https://github.com/actions/virtual-environments#available-environments

    az --version
    <#
    Write-Verbose ("Install azure cli start") -Verbose
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    Write-Verbose ("Install azure cli end") -Verbose
    #>

    ##############################
    ##   Install Bicep for CLI   #
    ##############################

    # Bicep CLI is pre-installed on GitHub hosted runners.
    # https://github.com/actions/virtual-environments#available-environments

    bicep --version
    <#
    Write-Verbose ("Install bicep start") -Verbose
    # Fetch the latest Bicep CLI binary
    curl -Lo bicep 'https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64'

    # Mark it as executable
    chmod +x ./bicep

    # Add bicep to your PATH (requires admin)
    sudo mv ./bicep /usr/local/bin/bicep
    Write-Verbose ("Install bicep end") -Verbose
    #>

    ###############################
    ##   Install Extensions CLI   #
    ###############################

    # Azure CLI extension for DevOps is pre-installed on GitHub hosted runners.
    # https://github.com/actions/virtual-environments#available-environments

    az extension list | ConvertFrom-Json | Select-Object -Property name, version, preview, experimental

    <#
    Write-Verbose ('Install cli exentions start') -Verbose
    $Extensions = @(
        'azure-devops'
    )
    foreach ($extension in $Extensions) {
        if ((az extension list-available -o json | ConvertFrom-Json).Name -notcontains $extension) {
            Write-Verbose "Adding CLI extension '$extension'" -Verbose
            az extension add --name $extension
        }
    }
    Write-Verbose ('Install cli exentions end') -Verbose
    #>

    ####################################
    ##   Install PowerShell Modules   ##
    ####################################

    $count = 1
    Write-Verbose ('Try installing:') -Verbose
    $modules | ForEach-Object {
        Write-Verbose ('- {0}. [{1}]' -f $count, $_.Name) -Verbose
        $count++
    }

    Write-Verbose ('Install-CustomModule start') -Verbose
    $count = 1
    Foreach ($Module in $Modules) {
        Write-Verbose ('=====================') -Verbose
        Write-Verbose ('HANDLING MODULE [{0}/{1}] [{2}] ' -f $count, $Modules.Count, $Module.Name) -Verbose
        Write-Verbose ('=====================') -Verbose
        # Installing New Modules and Removing Old
        $null = Install-CustomModule -Module $Module
        $count++
    }
    Write-Verbose ('Install-CustomModule end') -Verbose
}
