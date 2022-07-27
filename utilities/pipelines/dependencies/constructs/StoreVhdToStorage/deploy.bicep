// Image template
module imageTemplate '../../../../../modules/Microsoft.VirtualMachineImages/imageTemplates/deploy.bicep' = {
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
