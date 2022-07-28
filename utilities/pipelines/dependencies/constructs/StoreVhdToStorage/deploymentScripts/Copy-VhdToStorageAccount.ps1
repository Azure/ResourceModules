<#
.SYNOPSIS
Copy a VHD baked from a given image template to a given destination storage account blob container

.DESCRIPTION
Copy a VHD baked from a given image template to a given destination storage account blob container

.PARAMETER imageTemplateName
Mandatory. The name of the image template

.PARAMETER imageTemplateResourceGroup
Mandatory. The resource group name of the image template

.PARAMETER destinationStorageAccountName
Mandatory. The name of the destination storage account

.PARAMETER destinationContainerName
Optional. The name of the existing destination blob container

.EXAMPLE
Copy-VhdToStorageAccount -imageTemplateName '' -imageTemplateResourceGroup '' -destinationStorageAccountName ''

Copy a VHD baked from a given image template to a given destination storage account in a blob container named 'vhds'

#>
function Copy-VhdToStorageAccount {

    param (
        [Parameter(Mandatory = $true)]
        [string] $imageTemplateName,

        [Parameter(Mandatory = $true)]
        [string] $imageTemplateResourceGroup,

        [Parameter(Mandatory = $true)]
        [string] $destinationStorageAccountName,

        [Parameter(Mandatory = $false)]
        [string] $destinationContainerName = 'vhds'
    )

    # [CmdletBinding(SupportsShouldProcess)]

    # Install required modules
    Install-Module -Name Az.ImageBuilder -Force
    Install-Module -Name Az.Storage -Force

    $output = 'Copying vhd created by {0} in {1} to {2} in {3}.' -f $imageTemplateName, $imageTemplateResourceGroup, $destinationStorageAccountName, $destinationContainerName
    Write-Verbose $output -Verbose
    $DeploymentScriptOutputs = @{}
    $DeploymentScriptOutputs["text"] = $output

    # Retrieving and initializing parameters before the blob copy
    Write-Verbose 'Initializing source storage account parameters before the blob copy' -Verbose
    $imgtRunOutput = Get-AzImageBuilderRunOutput -ImageTemplateName $imageTemplateName -ResourceGroupName $imageTemplateResourceGroup | Where-Object ArtifactUri -NE $null
    $sourceUri = $imgtRunOutput.ArtifactUri
    $sourceStorageAccountName = $sourceUri.Split('//')[1].Split('.')[0]
    $sourceStorageAccount = Get-AzStorageAccount | Where-Object StorageAccountName -EQ $sourceStorageAccountName
    $sourceStorageAccountContext = $sourceStorageAccount.Context
    $sourceStorageAccountRGName = $sourceStorageAccount.ResourceGroupName
    Write-Verbose "Retrieving artifact uri $sourceUri stored in resource group $sourceStorageAccountRGName" -Verbose

    Write-Verbose 'Initializing destination storage account parameters before the blob copy' -Verbose
    $destinationStorageAccountName = $storageAccountParameters.name.value
    $destinationStorageAccount = Get-AzStorageAccount | Where-Object StorageAccountName -EQ $destinationStorageAccountName
    $destinationStorageAccountContext = $destinationStorageAccount.Context
    $destinationContainerName = 'vhds'
    $destinationBlobName = $imageTemplateParameters.name.value
    $destinationBlobName = "$destinationBlobName.vhd"
    Write-Verbose "Planning for destination blob name $destinationBlobName in container $destinationContainerName and storage account $destinationStorageAccountName" -Verbose

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
    Start-AzStorageBlobCopy @resourceActionInputObject
}
