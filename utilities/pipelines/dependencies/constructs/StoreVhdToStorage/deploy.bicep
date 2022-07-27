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

module deploymentScripts '../../../../../modules/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-deploymentScripts'
  params: {
    // Required parameters
    name: 'adp-<<namePrefix>>-az-ds-rke-001'
    // Non-required parameters
    azPowerShellVersion: '3.0'
    cleanupPreference: 'Always'
    kind: 'AzurePowerShell'
    lock: 'CanNotDelete'
    retentionInterval: 'P1D'
    runOnce: false
    scriptContent: imageTemplates.outputs.runThisCommandNew
    timeout: 'PT30M'
    // userAssignedIdentities: {
    //   '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    // }
  }
}
