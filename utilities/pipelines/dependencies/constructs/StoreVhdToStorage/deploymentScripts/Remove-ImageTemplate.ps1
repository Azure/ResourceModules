<#
.SYNOPSIS
Remove the image templates and their temporary generated resource groups

.DESCRIPTION
Remove the image templates and their temporary generated resource groups

.PARAMETER resourcegroupName
Required. The resource group name the image template is deployed into

.PARAMETER imageTemplateName
Optional. The name of the image template. Defaults to '*'.

.PARAMETER Confirm
Request the user to confirm whether to actually execute any should process

.PARAMETER WhatIf
Perform a dry run of the script. Runs everything but the content of any should process

.EXAMPLE
Remove-ImageTemplate -resourcegroupName 'My-RG'

Search and remove the image template '*' and its generated resource group 'IT_My-RG_*'

.EXAMPLE
Remove-ImageTemplate -resourcegroupName 'My-RG' -imageTemplateName '19h2NoOffice'

Search and remove the image template '19h2NoOffice' and its generated resource group 'IT_My-RG_19h2NoOffice*'
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $true)]
    [string] $ImageTemplateName,

    [Parameter(Mandatory = $true)]
    [string] $ImageTemplateResourceGroup,

    [Parameter(Mandatory = $false)]
    [switch] $NoWait
)

begin {
    Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

    # Install required modules
    $currentVerbosePreference = $VerbosePreference
    $VerbosePreference = 'SilentlyContinue'
    $requiredModules = @(
        'Az.ImageBuilder'
    )
    foreach ($moduleName in $requiredModules) {
        if (-not ($installedModule = Get-Module $moduleName -ListAvailable)) {
            Install-Module $moduleName -Repository 'PSGallery' -Force -Scope 'CurrentUser'
            if ($installed = Get-Module -Name $moduleName -ListAvailable) {
                Write-Verbose ('Installed module [{0}] with version [{1}]' -f $installed.Name, $installed.Version) -Verbose
            }
        } else {
            Write-Verbose ('Module [{0}] already installed in version [{1}]' -f $installedModule[0].Name, $installedModule[0].Version) -Verbose
        }
    }
    $VerbosePreference = $currentVerbosePreference
}

process {
    # Remove artifacts from existing image template
    $resourceActionInputObject = @{
        ImageTemplateName   = $imageTemplateName
        ResourceGroupName   = $imageTemplateResourceGroup
    }
    if ($NoWait) {
        $resourceActionInputObject['NoWait'] = $true
    }
    if ($PSCmdlet.ShouldProcess('Image template [{0}]' -f $imageTemplateName, 'Remove')) {
        $null = Remove-AzImageBuilderTemplate @resourceActionInputObject
        Write-Verbose ('Remove image template [{0}] from resource group [{1}]' -f $imageTemplateName, $imageTemplateResourceGroup) -Verbose
    }
}

end {
    Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
}
