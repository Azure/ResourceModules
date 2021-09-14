#region Helper Functions
function Install-CustomModule {
    <#
    .SYNOPSIS
    Installes given PowerShell module and saves it to a local store

    .PARAMETER Module
    Module to be installed, must be Object
    @{
        Name = 'Name'
        Version = '1.0.0' # Optional
    }

    .EXAMPLE
    Install-CustomModule @{ Name = 'Pester' } C:\Modules
    Installes pester and saves it to C:\Modules
    #>
    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [Hashtable] $Module
    )

    # Remove exsisting module in session
    if (Get-Module $Module -ErrorAction SilentlyContinue) {
        try {
            Remove-Module $Module -Force
        }
        catch {
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
            Write-Verbose ("Module [{0}] already installed with latest version [{1}]" -f $foundModule.Name, $foundModule.Version) -Verbose
            continue
        }
        if ($module.ExcludeModules -and $module.excludeModules.contains($foundModule.Name)) {
            Write-Verbose ("Module {0} is configured to be ignored." -f $foundModule.Name) -Verbose
            continue
        }

        Write-Verbose ("Install module [{0}] with version [{1}]" -f $foundModule.Name, $foundModule.Version) -Verbose
        if ($PSCmdlet.ShouldProcess("Module [{0}]" -f $foundModule.Name, "Install")) {
            $foundModule | Install-Module -Force -SkipPublisherCheck -AllowClobber
            if ($installed = Get-Module -Name $foundModule.Name -ListAvailable) {
                Write-Verbose ("Module [{0}] is installed with version [{1}]" -f $installed.Name, $installed.Version) -Verbose
            }
            else {
                Write-Error ("Installation of module [{0}] failed" -f $foundModule.Name)
            }
        }
    }
}
#endregion

function Set-AgentUp {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $clientID,

        [Parameter(Mandatory)]
        [securestring] $clientSecret,

        [Parameter(Mandatory = $false)]
        [string] $tenantId = '',

        [Parameter(Mandatory = $false)]
        [string] $subscriptionId = ''
    )

    ####################################
    ##   Install PowerShell Modules   ##
    ####################################
    $Modules = @(
        @{ Name = 'Az.Accounts' }
    )
    $count = 1
    Write-Verbose ("Try installing:") -Verbose
    $modules | ForEach-Object {
        Write-Verbose ("- {0}. [{1}]" -f $count, $_.Name) -Verbose
        $count++
    }

    Write-Verbose ("Install-CustomModule start") -Verbose
    $count = 1
    Foreach ($Module in $Modules) {
        Write-Verbose ("=====================") -Verbose
        Write-Verbose ("HANDLING MODULE [{0}/{1}] [{2}] " -f $count, $Modules.Count, $Module.Name) -Verbose
        Write-Verbose ("=====================") -Verbose
        # Installing New Modules and Removing Old
        $null = Install-CustomModule -Module $Module
        $count++
    }
    Write-Verbose ("Install-CustomModule end") -Verbose

    ###############
    ##   LOGIN   ##
    ###############
    Write-Verbose "Login to environment" -Verbose
    $credential = New-Object PSCredential -ArgumentList $clientID, $clientSecret
    $loginInputObject = @{
        ServicePrincipal = $true
        Credential       = $credential
    }
    if (-not [String]::IsNullOrEmpty($tenantId)) { $loginInputObject['tenantId'] = $tenantId }
    if (-not [String]::IsNullOrEmpty($subscriptionId)) { $loginInputObject['subscriptionId'] = $subscriptionId }

    Connect-AzAccount @loginInputObject
}