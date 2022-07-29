<#
    .SYNOPSIS
    Create artifacts from a given image template

    .DESCRIPTION
    Create artifacts from a given image template

    .PARAMETER ImageTemplateName
    Mandatory. The name of the image template

    .PARAMETER ImageTemplateResourceGroup
    Mandatory. The resource group name of the image template

    .PARAMETER NoWait
    Optional. Run the command asynchronously

    .EXAMPLE
    Start-AzImageBuilderTemplate -ImageTemplateName '' -ImageTemplateResourceGroup ''

    Create artifacts from a given image template and wait for its completion

    .EXAMPLE
    Start-AzImageBuilderTemplate -ImageTemplateName '' -ImageTemplateResourceGroup '' -NoWait

    Start the creation of artifacts from a given image template and do not wait for its completion
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
    # Create artifacts from existing image template
    $resourceActionInputObject = @{
        ImageTemplateName   = $imageTemplateName
        ResourceGroupName   = $imageTemplateResourceGroup
    }
    if ($NoWait) {
        $resourceActionInputObject['NoWait'] = $true
    }
    if ($PSCmdlet.ShouldProcess('Image template [{0}]' -f $imageTemplateName, 'Start')) {
        $null = Start-AzImageBuilderTemplate @resourceActionInputObject
        Write-Verbose ('Create artifacts from image template [{0}] in resource group [{1}]' -f $imageTemplateName, $imageTemplateResourceGroup) -Verbose
    }
}

end {
    Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
}
