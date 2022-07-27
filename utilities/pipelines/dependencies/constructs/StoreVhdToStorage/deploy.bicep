// Image template
module imageTemplates '../../../../../modules/Microsoft.VirtualMachineImages/imageTemplates/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-imageTemplates'
  params: {
    // Required parameters
    customizationSteps: [
      {
        restartTimeout: '30m'
        type: 'WindowsRestart'
      }
    ]
    imageSource: {
      offer: 'Windows-10'
      publisher: 'MicrosoftWindowsDesktop'
      sku: '19h2-evd'
      type: 'PlatformImage'
      version: 'latest'
    }
    name: 'adp-<<namePrefix>>-az-imgt-rke-001'
    userMsiName: 'adp-<<namePrefix>>-az-msi-x-001'
    // Non-required parameters
    buildTimeoutInMinutes: 0
    osDiskSizeGB: 127
    unManagedImageName: 'adp-<<namePrefix>>-az-umi-x-001'
    userMsiResourceGroup: 'validation-rg'
    vmSize: 'Standard_D2s_v3'
  }
}

// module deploymentScripts '../../../../../modules/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
//   name: '${uniqueString(deployment().name)}-deploymentScripts'
//   params: {
//     // Required parameters
//     name: 'adp-<<namePrefix>>-az-ds-rke-001'
//     // Non-required parameters
//     azPowerShellVersion: '3.0'
//     cleanupPreference: 'Always'
//     kind: 'AzurePowerShell'
//     lock: 'CanNotDelete'
//     retentionInterval: 'P1D'
//     runOnce: false
//     scriptContent: imageTemplates.outputs.runThisCommandNew
//     timeout: 'PT30M'
//     // userAssignedIdentities: {
//     //   '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
//     // }
//   }
// }

module deploymentScripts2 '../../../../../modules/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-deploymentScripts'
  params: {
    // Required parameters
    name: 'adp-<<namePrefix>>-az-ds-rke2-001'
    // Non-required parameters
    azPowerShellVersion: '3.0'
    cleanupPreference: 'Always'
    kind: 'AzurePowerShell'
    lock: 'CanNotDelete'
    retentionInterval: 'P1D'
    runOnce: false
    environmentVariables: [
      {
        name: 'imageTemplateName'
        value: imageTemplates.outputs.name
      }
      {
        name: 'imageTemplateName2'
        value: imageTemplates.outputs.name
      }
    ]
    scriptContent: '''
      Write-Verbose "Retrieving parameters from previous module" -Verbose
      Write-Verbose "The imageTemplateName is ${Env:imageTemplateName}" -Verbose
    '''
    timeout: 'PT30M'
    // userAssignedIdentities: {
    //   '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    // }
  }
}

// Write-Verbose "Retrieving parameters from previous job outputs" -Verbose
//   #           $imageTemplateName = '${{ needs.job_deploy_imgt.outputs.imageTemplateName }}'
//   #           $imageTemplateResourceGroup = '${{ needs.job_deploy_imgt.outputs.imageTemplateResourceGroup }}'

//   #           Write-Verbose "Retrieving parameters from storage account parameter files" -Verbose
//   #           $parameterFilePath = Join-Path $env:GITHUB_WORKSPACE '${{ env.dependencyPath }}' '${{ env.saNamespace }}' 'parameters' 'parameters.json'
//   #           $null = Convert-TokensInFile @ConvertTokensInputs -FilePath $parameterFilePath -Verbose
//   #           $storageAccountParameters = (ConvertFrom-Json (Get-Content -path $parameterFilePath -Raw)).parameters

//   #           Write-Verbose "Retrieving parameters from image template parameter files" -Verbose
//   #           $parameterFilePath = Join-Path $env:GITHUB_WORKSPACE '${{ env.dependencyPath }}' '${{ env.imgtNamespace }}' 'parameters' 'parameters.json'
//   #           $null = Convert-TokensInFile @ConvertTokensInputs -FilePath $parameterFilePath -Verbose
//   #           $imageTemplateParameters = (ConvertFrom-Json (Get-Content -path $parameterFilePath -Raw)).parameters

//   #           # Initializing parameters before the blob copy
//   #           Write-Verbose "Initializing source storage account parameters before the blob copy" -Verbose
//   #           $imgtRunOutput = Get-AzImageBuilderRunOutput -ImageTemplateName $imageTemplateName -ResourceGroupName $imageTemplateResourceGroup | Where-Object ArtifactUri -NE $null
//   #           $sourceUri = $imgtRunOutput.ArtifactUri
//   #           $sourceStorageAccountName = $sourceUri.Split('//')[1].Split('.')[0]
//   #           $sourceStorageAccount = Get-AzStorageAccount | Where-Object StorageAccountName -EQ $sourceStorageAccountName
//   #           $sourceStorageAccountContext = $sourceStorageAccount.Context
//   #           $sourceStorageAccountRGName = $sourceStorageAccount.ResourceGroupName
//   #           Write-Verbose "Retrieving artifact uri $sourceUri stored in resource group $sourceStorageAccountRGName" -Verbose

//   #           Write-Verbose "Initializing destination storage account parameters before the blob copy" -Verbose
//   #           $destinationStorageAccountName = $storageAccountParameters.name.value
//   #           $destinationStorageAccount = Get-AzStorageAccount | Where-Object StorageAccountName -EQ $destinationStorageAccountName
//   #           $destinationStorageAccountContext = $destinationStorageAccount.Context
//   #           $destinationContainerName = 'vhds'
//   #           $destinationBlobName = $imageTemplateParameters.name.value
//   #           $destinationBlobName = "$destinationBlobName.vhd"
//   #           Write-Verbose "Planning for destination blob name $destinationBlobName in container $destinationContainerName and storage account $destinationStorageAccountName" -Verbose

//   #           # Copying the vhd to a destination blob container
//   #           Write-Verbose "Copying the vhd to a destination blob container" -Verbose
//   #           $resourceActionInputObject = @{
//   #               AbsoluteUri   = $sourceUri
//   #               Context       = $sourceStorageAccountContext
//   #               DestContext   = $destinationStorageAccountContext
//   #               DestBlob      = $destinationBlobName
//   #               DestContainer = $destinationContainerName
//   #               Force         = $true
//   #           }
//   #           Start-AzStorageBlobCopy @resourceActionInputObject
