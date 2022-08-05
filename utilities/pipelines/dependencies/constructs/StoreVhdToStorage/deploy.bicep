targetScope = 'subscription'

// ================ //
// Input Parameters //
// ================ //

// RG parameters
@description('Optional. The name of the resource group to deploy')
param resourceGroupName string = 'validation-rg'

// =========== //
// Deployments //
// =========== //

// Deploy user managed identity
module userMsi '../../../../../modules/Microsoft.ManagedIdentity/userAssignedIdentities/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-userAssignedIdentity'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: 'adp-<<namePrefix>>-az-msi-vhd-001'
  }
}

// Deploy role assignment
module roleAssignment '../../../../../modules/Microsoft.Authorization/roleAssignments/subscription/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-roleAssignment'
  params: {
    roleDefinitionIdOrName: 'Contributor'
    principalId: userMsi.outputs.principalId
    subscriptionId: subscription().id
  }
}

// Deploy destination storage account
module destinationStorageAccount '../../../../../modules/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-storageAccounts'
  scope: resourceGroup(resourceGroupName)
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
  scope: resourceGroup(resourceGroupName)
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
    name: 'adp-<<namePrefix>>-az-imgt-vhd-001'
    userMsiName: userMsi.outputs.name
    buildTimeoutInMinutes: 0
    osDiskSizeGB: 127
    unManagedImageName: 'adp-<<namePrefix>>-az-umi-x-001'
    vmSize: 'Standard_D2s_v3'
  }
}

// Trigger VHD creation
module triggerImageDeploymentScript '../../../../../modules/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-triggerImageDeploymentScript'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: 'adp-<<namePrefix>>-az-ds-vhd-triggerImageTemplate'
    arguments: '-ImageTemplateName \\"${imageTemplate.outputs.name}\\" -ImageTemplateResourceGroup \\"${imageTemplate.outputs.resourceGroupName}\\"'
    azPowerShellVersion: '6.4'
    cleanupPreference: 'OnSuccess'
    kind: 'AzurePowerShell'
    retentionInterval: 'P1D'
    runOnce: false
    scriptContent: loadTextContent('deploymentScripts/Start-ImageTemplate.ps1')
    timeout: 'PT30M'
    userAssignedIdentities: {
      '${userMsi.outputs.resourceId}': {}
    }
  }
  dependsOn: [ roleAssignment ]
}

// Copy VHD to destination storage account
module copyVhdDeploymentScript '../../../../../modules/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-copyVhdDeploymentScript'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: 'adp-<<namePrefix>>-az-ds-vhd-copyVhdToStorage'
    arguments: '-ImageTemplateName \\"${imageTemplate.outputs.name}\\" -ImageTemplateResourceGroup \\"${imageTemplate.outputs.resourceGroupName}\\" -DestinationStorageAccountName \\"${destinationStorageAccount.outputs.name}\\" -VhdName \\"${imageTemplate.outputs.namePrefix}\\" -WaitForComplete'
    azPowerShellVersion: '6.4'
    cleanupPreference: 'OnSuccess'
    kind: 'AzurePowerShell'
    retentionInterval: 'P1D'
    runOnce: false
    scriptContent: loadTextContent('deploymentScripts/Copy-VhdToStorageAccount.ps1')
    timeout: 'PT30M'
    userAssignedIdentities: {
      '${userMsi.outputs.resourceId}': {}
    }
  }
  dependsOn: [ triggerImageDeploymentScript ]
}

// Remove image template
module removeImageTemplate '../../../../../modules/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-removeImageTemplate'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: 'adp-<<namePrefix>>-az-ds-vhd-removeImageTemplate'
    arguments: '-ImageTemplateName \\"${imageTemplate.outputs.name}\\" -ImageTemplateResourceGroup \\"${imageTemplate.outputs.resourceGroupName}\\"'
    azPowerShellVersion: '6.4'
    cleanupPreference: 'OnSuccess'
    kind: 'AzurePowerShell'
    retentionInterval: 'P1D'
    runOnce: false
    scriptContent: loadTextContent('deploymentScripts/Remove-ImageTemplate.ps1')
    timeout: 'PT30M'
    userAssignedIdentities: {
      '${userMsi.outputs.resourceId}': {}
    }
  }
  dependsOn: [ copyVhdDeploymentScript ]
}
