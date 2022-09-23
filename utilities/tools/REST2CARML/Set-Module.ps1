function Set-Module {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $true)]
        [Hashtable] $ModuleData,

        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath,

        [Parameter(Mandatory = $true)]
        [string] $JSONKeyPath
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent
        $moduleRootPath = Join-Path $repoRootPath 'modules' $ProviderNamespace $ResourceType
        $templatePath = Join-Path $moduleRootPath 'deploy.bicep'

        # Load used functions
        . (Join-Path $PSScriptRoot 'extension' 'Set-DiagnosticModuleData.ps1')
        . (Join-Path $PSScriptRoot 'extension' 'Set-RoleAssignmentsModuleData.ps1')
        . (Join-Path $PSScriptRoot 'extension' 'Set-PrivateEndpointModuleData.ps1')
        . (Join-Path $PSScriptRoot 'extension' 'Set-LockModuleData.ps1')
        . (Join-Path $PSScriptRoot 'Set-ModuleTemplate.ps1')
        . (Join-Path $repoRootPath 'utilities' 'tools' 'Set-ModuleReadMe.ps1')
    }

    process {

        #################################
        ##   Collect additional data   ##
        #################################

        # Set diagnostic data
        $diagInputObject = @{
            ProviderNamespace = $ProviderNamespace
            ResourceType      = $ResourceType
            ModuleData        = $ModuleData
        }
        Set-DiagnosticModuleData @diagInputObject

        # Set Endpoint data
        $endpInputObject = @{
            JSONFilePath = $JSONFilePath
            ResourceType = $ResourceType
            ModuleData   = $ModuleData
        }
        Set-PrivateEndpointModuleData @endpInputObject

        ## Set RBAC data
        $rbacInputObject = @{
            ProviderNamespace = $ProviderNamespace
            ResourceType      = $ResourceType
            ModuleData        = $ModuleData
            ModuleRootPath    = $moduleRootPath
            ServiceApiVersion = Split-Path (Split-Path $JSONFilePath -Parent) -Leaf
        }
        Set-RoleAssignmentsModuleData @rbacInputObject

        ## Set Locks data
        $lockInputObject = @{
            JSONKeyPath  = $JSONKeyPath
            ResourceType = $ResourceType
            ModuleData   = $ModuleData
        }
        Set-LockModuleData @lockInputObject

        #############################
        ##   Update Template File   #
        #############################

        $moduleTemplateContentInputObject = @{
            ProviderNamespace = $ProviderNamespace
            ResourceType      = $ResourceType
            ModuleData        = $ModuleData
            JSONFilePath      = $JSONFilePath
            JSONKeyPath       = $JSONKeyPath
        }
        Set-ModuleTemplate @moduleTemplateContentInputObject

        #############################
        ##   Update Module ReadMe   #
        #############################
        if ($PSCmdlet.ShouldProcess(('Module ReadMe [{0}]' -f (Join-Path (Split-Path $templatePath -Parent) 'readme.md')), 'Update')) {
            Set-ModuleReadMe -TemplateFilePath $templatePath
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }

}
