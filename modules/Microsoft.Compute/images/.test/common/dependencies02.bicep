@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The resource ID of the Managed Identity.')
param managedIdentityResourceId string

@description('Required. The name of the image template.')
param imageTemplateNamePrefix string

@description('Generated. Do not provide a value! This date value is used to generate a unique image template name.')
param baseTime string = utcNow('yyyy-MM-dd-HH-mm-ss')

@description('Required. The name of the Deployment Script to create for triggering the image creation.')
param triggerImageDeploymentScriptName string

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2022-02-14' = {
  name: '${imageTemplateNamePrefix}-${baseTime}'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityResourceId}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: 0
    vmProfile: {
      vmSize: 'Standard_D2s_v3'
      osDiskSizeGB: 127
    }
    source: {
      type: 'PlatformImage'
      publisher: 'MicrosoftWindowsDesktop'
      offer: 'Windows-10'
      sku: '19h2-evd'
      version: 'latest'
    }
    distribute: [
      {
        type: 'VHD'
        runOutputName: '${imageTemplateNamePrefix}-VHD'
        artifactTags: {}
      }
    ]
    customize: [
      {
        restartTimeout: '30m'
        type: 'WindowsRestart'
      }
    ]
  }
}

resource triggerImageDeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: triggerImageDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityResourceId}': {}
    }
  }
  properties: {
    azPowerShellVersion: '6.2.1'
    retentionInterval: 'P1D'
    arguments: '-ImageTemplateName \\"${imageTemplate.name}\\" -ImageTemplateResourceGroup \\"${resourceGroup().name}\\"'
    scriptContent: loadTextContent('../.scripts/Start-ImageTemplate.ps1')
  }
}

// // Trigger VHD creation
// module triggerImageDeploymentScript '../../../../../modules/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
//   name: '${uniqueString(deployment().name)}-triggerImageDeploymentScript'
//   scope: resourceGroup(resourceGroupName)
//   params: {
//     name: 'adp-<<namePrefix>>-az-ds-vhd-triggerImageTemplate'
//     arguments: '-ImageTemplateName \\"${imageTemplate.outputs.name}\\" -ImageTemplateResourceGroup \\"${imageTemplate.outputs.resourceGroupName}\\"'
//     azPowerShellVersion: '6.4'
//     cleanupPreference: 'OnSuccess'
//     kind: 'AzurePowerShell'
//     retentionInterval: 'P1D'
//     runOnce: false
//     scriptContent: loadTextContent('deploymentScripts/Start-ImageTemplate.ps1')
//     timeout: 'PT30M'
//     userAssignedIdentities: {
//       '${userMsi.outputs.resourceId}': {}
//     }
//   }
//   dependsOn: [ roleAssignment ]
// }
//
// // Copy VHD to destination storage account
// module copyVhdDeploymentScript '../../../../../modules/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
//   name: '${uniqueString(deployment().name)}-copyVhdDeploymentScript'
//   scope: resourceGroup(resourceGroupName)
//   params: {
//     name: 'adp-<<namePrefix>>-az-ds-vhd-copyVhdToStorage'
//     arguments: '-ImageTemplateName \\"${imageTemplate.outputs.name}\\" -ImageTemplateResourceGroup \\"${imageTemplate.outputs.resourceGroupName}\\" -DestinationStorageAccountName \\"${destinationStorageAccount.outputs.name}\\" -VhdName \\"${imageTemplate.outputs.namePrefix}\\" -WaitForComplete'
//     azPowerShellVersion: '6.4'
//     cleanupPreference: 'OnSuccess'
//     kind: 'AzurePowerShell'
//     retentionInterval: 'P1D'
//     runOnce: false
//     scriptContent: loadTextContent('deploymentScripts/Copy-VhdToStorageAccount.ps1')
//     timeout: 'PT30M'
//     userAssignedIdentities: {
//       '${userMsi.outputs.resourceId}': {}
//     }
//   }
//   dependsOn: [ triggerImageDeploymentScript ]
// }
