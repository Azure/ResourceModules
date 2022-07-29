var vhdName = 'adp-<<namePrefix>>-vhd-imgt-001'
var userMsiName = 'adp-<<namePrefix>>-az-msi-x-001'

// Retrieve existing MSI
resource userMsi 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: userMsiName
}

// Deploy destination storage account
module destinationStorageAccount '../../../../../modules/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-storageAccounts'
  params: {
    name: 'adp<<namePrefix>>azsavhd001'
    allowBlobPublicAccess: false
    blobServices: {
      containers: [
        {
          name: 'vhds'
        }
      ]
    }
  }
}

// Deploy image template
module imageTemplate '../../../../../modules/Microsoft.VirtualMachineImages/imageTemplates/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-imageTemplates'
  params: {
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
    name: vhdName
    userMsiName: userMsi.name
    buildTimeoutInMinutes: 0
    osDiskSizeGB: 127
    unManagedImageName: 'adp-<<namePrefix>>-az-umi-x-001'
    vmSize: 'Standard_D2s_v3'
  }
}

// Trigger VHD creation
module triggerImageDeploymentScript '../../../../../modules/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-triggerImageDeploymentScript'
  params: {
    name: 'adp-<<namePrefix>>-vhd-ds-triggerImage'
    arguments: '-imageTemplateName \\"${imageTemplate.outputs.name}\\" -imageTemplateResourceGroup \\"${imageTemplate.outputs.resourceGroupName}\\"'
    azPowerShellVersion: '6.4'
    cleanupPreference: 'OnSuccess'
    kind: 'AzurePowerShell'
    retentionInterval: 'P1D'
    runOnce: false
    scriptContent: loadTextContent('deploymentScripts/Start-ImageTemplate.ps1')
    timeout: 'PT30M'
    userAssignedIdentities: {
      '${userMsi.id}': {}
    }
  }
}

// Copy VHD to destination storage account
module copyVhdDeploymentScript '../../../../../modules/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-copyVhdDeploymentScript'
  params: {
    name: 'adp-<<namePrefix>>-vhd-ds-copyVhdToStorage'
    arguments: '-ImageTemplateName \\"${imageTemplate.outputs.name}\\" -ImageTemplateResourceGroup \\"${imageTemplate.outputs.resourceGroupName}\\" -DestinationStorageAccountName \\"${destinationStorageAccount.outputs.name}\\" -VhdName \\"${vhdName}\\" -WaitForComplete'
    azPowerShellVersion: '6.4'
    cleanupPreference: 'OnSuccess'
    kind: 'AzurePowerShell'
    retentionInterval: 'P1D'
    runOnce: false
    scriptContent: loadTextContent('deploymentScripts/Copy-VhdToStorageAccount.ps1')
    timeout: 'PT30M'
    userAssignedIdentities: {
      '${userMsi.id}': {}
    }
  }
  dependsOn: [ triggerImageDeploymentScript ]
}

// Remove image template
module removeImageTemplate '../../../../../modules/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-removeImageTemplate'
  params: {
    name: 'adp-<<namePrefix>>-vhd-ds-removeImageTemplate'
    arguments: '-ImageTemplateName \\"${imageTemplate.outputs.name}\\" -ImageTemplateResourceGroup \\"${imageTemplate.outputs.resourceGroupName}\\"'
    azPowerShellVersion: '6.4'
    cleanupPreference: 'OnSuccess'
    kind: 'AzurePowerShell'
    retentionInterval: 'P1D'
    runOnce: false
    scriptContent: loadTextContent('deploymentScripts/Remove-ImageTemplate.ps1')
    timeout: 'PT30M'
    userAssignedIdentities: {
      '${userMsi.id}': {}
    }
  }
  dependsOn: [ copyVhdDeploymentScript ]
}
