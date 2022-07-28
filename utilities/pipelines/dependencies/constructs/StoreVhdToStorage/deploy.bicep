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

// param location string = resourceGroup().location

// resource runPowerShellInline 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
//   name: 'runPowerShellInlineOutputQuotesImg'
//   location: location
//   kind: 'AzurePowerShell'
//   identity: {
//     type: 'UserAssigned'
//     userAssignedIdentities: {
//       '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
//     }
//   }
//   properties: {
//     forceUpdateTag: '1'
//     azPowerShellVersion: '6.4'
//     arguments: '-name \\"John Dole\\"'
//     environmentVariables: [
//       {
//         name: 'UserName'
//         value: imageTemplates.outputs.name
//       }
//       {
//         name: 'Password'
//         secureValue: imageTemplates.outputs.resourceGroupName
//       }
//     ]
//     scriptContent: '''
//       param([string] $name)
//       $UserName=${Env:UserName}
//       $Password=${Env:Password}
//       Install-Module -Name Az.ImageBuilder -Force
//       Start-AzImageBuilderTemplate -ImageTemplateName $UserName -ResourceGroupName $Password
//       $output = "Hello {0}. The username is {1}, the password is {2}." -f $name, $UserName, $Password
//       Write-Output $output
//       $DeploymentScriptOutputs = @{}
//       $DeploymentScriptOutputs["text"] = $output
//     ''' // or primaryScriptUri: 'https://raw.githubusercontent.com/Azure/azure-docs-bicep-samples/main/samples/deployment-script/inlineScript.ps1'
//     supportingScriptUris: []
//     timeout: 'PT30M'
//     cleanupPreference: 'OnSuccess'
//     retentionInterval: 'P1D'
//   }
// }

// resource runPowerShellScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
//   name: 'runPowerShellScriptLoadTextContent'
//   location: location
//   kind: 'AzurePowerShell'
//   identity: {
//     type: 'UserAssigned'
//     userAssignedIdentities: {
//       '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
//     }
//   }
//   properties: {
//     forceUpdateTag: '1'
//     azPowerShellVersion: '6.4'
//     arguments: '-imageTemplateName \\"${imageTemplates.outputs.name}\\" -imageTemplateResourceGroup \\"${imageTemplates.outputs.resourceGroupName}\\" -destinationStorageAccountName \\"testStorage\\"'
//     scriptContent: loadTextContent('deploymentScripts/Copy-VhdToStorageAccount.ps1')
//     supportingScriptUris: []
//     timeout: 'PT30M'
//     cleanupPreference: 'OnSuccess'
//     retentionInterval: 'P1D'
//   }
// }

module deploymentScripts01 '../../../../../modules/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-deploymentScripts01'
  params: {
    // Required parameters
    name: 'adp-<<namePrefix>>-ds-triggerImage'
    // Non-required parameters
    arguments: '-imageTemplateName \\"${imageTemplates.outputs.name}\\" -imageTemplateResourceGroup \\"${imageTemplates.outputs.resourceGroupName}\\"'
    azPowerShellVersion: '6.4'
    cleanupPreference: 'OnSuccess'
    kind: 'AzurePowerShell'
    retentionInterval: 'P1D'
    runOnce: false
    scriptContent: '''
      param(
        [string] $imageTemplateName,
        [string] $imageTemplateResourceGroup
      )
      Install-Module -Name Az.ImageBuilder -Force
      Start-AzImageBuilderTemplate -ImageTemplateName $imageTemplateName -ResourceGroupName $imageTemplateResourceGroup
    '''
    timeout: 'PT30M'
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
  }
}

module deploymentScripts02 '../../../../../modules/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-deploymentScripts02'
  params: {
    // Required parameters
    name: 'adp-<<namePrefix>>-ds-copyVhdToStorage'
    // Non-required parameters
    arguments: '-imageTemplateName \\"${imageTemplates.outputs.name}\\" -imageTemplateResourceGroup \\"${imageTemplates.outputs.resourceGroupName}\\" -destinationStorageAccountName \\"testStorage\\"'
    azPowerShellVersion: '6.4'
    cleanupPreference: 'OnSuccess'
    kind: 'AzurePowerShell'
    retentionInterval: 'P1D'
    runOnce: false
    scriptContent: loadTextContent('deploymentScripts/Copy-VhdToStorageAccount.ps1')
    timeout: 'PT30M'
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
  }
  dependsOn: [ deploymentScripts01 ]
}

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
