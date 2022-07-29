<#
    .SYNOPSIS
    Copy a VHD baked from a given image template to a given destination storage account blob container

    .DESCRIPTION
    Copy a VHD baked from a given image template to a given destination storage account blob container

    .PARAMETER ImageTemplateName
    Mandatory. The name of the image template

    .PARAMETER ImageTemplateResourceGroup
    Mandatory. The resource group name of the image template

    .PARAMETER DestinationStorageAccountName
    Mandatory. The name of the destination storage account

    .PARAMETER DestinationContainerName
    Optional. The name of the existing destination blob container

    .EXAMPLE
    Copy-VhdToStorageAccount -imageTemplateName '' -imageTemplateResourceGroup '' -destinationStorageAccountName ''

    Copy a VHD baked from a given image template to a given destination storage account in a blob container named 'vhds'
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $true)]
    [string] $ImageTemplateName,

    [Parameter(Mandatory = $true)]
    [string] $ImageTemplateResourceGroup,

    [Parameter(Mandatory = $true)]
    [string] $DestinationStorageAccountName,

    [Parameter(Mandatory = $false)]
    [string] $DestinationContainerName = 'vhds',

    [Parameter(Mandatory = $false)]
    [string] $VhdName = $ImageTemplateName,

    [Parameter(Mandatory = $false)]
    [switch] $WaitForComplete
)

begin {
    Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

    # Install required modules
    $currentVerbosePreference = $VerbosePreference
    $VerbosePreference = 'SilentlyContinue'
    $requiredModules = @(
        'Az.ImageBuilder',
        'Az.Storage'
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
    # Retrieving and initializing parameters before the blob copy
    Write-Verbose 'Initializing source storage account parameters before the blob copy' -Verbose
    $imgtRunOutput = Get-AzImageBuilderRunOutput -ImageTemplateName $imageTemplateName -ResourceGroupName $imageTemplateResourceGroup | Where-Object ArtifactUri -NE $null
    $sourceUri = $imgtRunOutput.ArtifactUri
    $sourceStorageAccountName = $sourceUri.Split('//')[1].Split('.')[0]
    $sourceStorageAccount = Get-AzStorageAccount | Where-Object StorageAccountName -EQ $sourceStorageAccountName
    $sourceStorageAccountContext = $sourceStorageAccount.Context
    $sourceStorageAccountRGName = $sourceStorageAccount.ResourceGroupName
    Write-Verbose ('Retrieving artifact uri {0} stored in resource group {1}' -f $sourceUri, $sourceStorageAccountRGName) -Verbose

    Write-Verbose 'Initializing destination storage account parameters before the blob copy' -Verbose
    $destinationStorageAccount = Get-AzStorageAccount | Where-Object StorageAccountName -EQ $destinationStorageAccountName
    $destinationStorageAccountContext = $destinationStorageAccount.Context
    $destinationBlobName = "$vhdName.vhd"
    Write-Verbose ('Planning for destination blob name {0} in container {1} and storage account {2}' -f $destinationBlobName, $destinationContainerName, $destinationStorageAccountName) -Verbose

    # Copying the VHD to a destination blob container
    Write-Verbose 'Copying the VHD to a destination blob container' -Verbose
    $resourceActionInputObject = @{
        AbsoluteUri   = $sourceUri
        Context       = $sourceStorageAccountContext
        DestContext   = $destinationStorageAccountContext
        DestBlob      = $destinationBlobName
        DestContainer = $destinationContainerName
        Force         = $true
    }
    $destBlob = Start-AzStorageBlobCopy @resourceActionInputObject

    if ($WaitForComplete){
        $destBlob | Get-AzStorageBlobCopyState -WaitForComplete
    }

}

end {
    Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
}

