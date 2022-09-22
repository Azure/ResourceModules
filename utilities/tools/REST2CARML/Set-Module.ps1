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
        [string] $SpecificationFilePath,

        [Parameter(Mandatory = $true)]
        [string] $SpecificationUrl
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent
        $templatePath = Join-Path $repoRootPath 'modules' $ProviderNamespace $ResourceType 'deploy.bicep'
        # Load used functions
        . (Join-Path $PSScriptRoot 'Get-SupportsLock.ps1')
        . (Join-Path $PSScriptRoot 'Get-RoleAssignmentList.ps1')
        . (Join-Path $PSScriptRoot 'Get-DiagnosticOptionsList.ps1')
        . (Join-Path $PSScriptRoot 'Get-SupportsPrivateEndpoint.ps1')
        . (Join-Path $repoRootPath 'utilities' 'tools' 'Set-ModuleReadMe.ps1')
    }

    process {

        #################################
        ##   Collect additional data   ##
        #################################

        # Get diagnostic data
        # TODO: Clarify: Might need to be always 'All metrics' if any metric exists
        $diagnosticOptions = Get-DiagnosticOptionsList -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType

        # Get Endpoint data
        $supportsPrivateEndpoint = Get-SupportsPrivateEndpoint -SpecificationFilePath $SpecificationFilePath

        ## Get RBAC data
        $supportedRoles = Get-RoleAssignmentList -ProviderNamespace $ProviderNamespace

        ## Get Locks data
        $supportsLock = Get-SupportsLock -SpecificationUrl $SpecificationUrl

        #############################
        ##   Update Template File   #
        #############################

        # TODO: Update template file
        Set-ModuleTemplate

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
