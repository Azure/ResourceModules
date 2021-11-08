param virtualMachineName string
param extensionName string
param location string
param publisher string
param type string
param typeHandlerVersion string
param autoUpgradeMinorVersion bool
param forceUpdateTag string = ''
param settings object = {}
param protectedSettings object = {}

resource extension 'Microsoft.Compute/virtualMachines/extensions@2021-04-01' = {
  name: '${virtualMachineName}/${extensionName}'
  location: location
  properties: {
    publisher: publisher
    type: type
    typeHandlerVersion: typeHandlerVersion
    autoUpgradeMinorVersion: autoUpgradeMinorVersion
    forceUpdateTag: !empty(forceUpdateTag) ? forceUpdateTag : null
    settings: !empty(settings) ? settings : null
    protectedSettings: !empty(protectedSettings) ? protectedSettings : null
  }
}
