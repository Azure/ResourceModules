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

// Copy VHD to destination storage account
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

// TODO: cleanup - deployment scripts?

// // // EXAMPLE OUTPUT
// param name string = '\\"John Dole\\"'
// param utcValue string = utcNow()
// param location string = resourceGroup().location

// resource runPowerShellInlineWithOutput 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
//   name: 'runPowerShellInlineWithOutputAndEnvQuotes'
//   location: location
//   kind: 'AzurePowerShell'
//   properties: {
//     forceUpdateTag: utcValue
//     azPowerShellVersion: '6.4'
//     environmentVariables: [
//       {
//         name: 'imageTemplateName'
//         value: imageTemplates.outputs.name
//       }
//       {
//         name: 'resourceGroupName'
//         value: imageTemplates.outputs.resourceGroupName
//       }
//     ]
//     scriptContent: '''
//       param([string] $name)
//       $output = "Hello {0}. The imageTemplateName is {1}, the resourceGroupName is {2}." -f $name,\${Env:imageTemplateName},\${Env:resourceGroupName}
//       Write-Output $output
//       $DeploymentScriptOutputs = @{}
//       $DeploymentScriptOutputs["text"] = $output
//     '''
//     arguments: '-name ${name}'
//     timeout: 'PT1H'
//     cleanupPreference: 'OnSuccess'
//     retentionInterval: 'P1D'
//   }
// }

// output result string = runPowerShellInlineWithOutput.properties.outputs.text
