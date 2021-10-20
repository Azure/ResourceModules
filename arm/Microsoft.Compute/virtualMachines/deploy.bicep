// Main resource
@description('Optional. The name of the virtual machine to be created. You should use a unique prefix to reduce name collisions in Active Directory. If no value is provided, a 10 character long unique string will be generated based on the Resource Group\'s name.')
param virtualMachineName string = take(toLower(uniqueString(resourceGroup().name)), 10)

@description('Optional. Specifies whether the computer names should be transformed. The transformation is performed on all computer names. Available transformations are \'none\' (Default), \'uppercase\' and \'lowercase\'.')
param vmComputerNamesTransformation string = 'none'

@description('Optional. Specifies the size for the VMs')
param vmSize string = 'Standard_D2s_v3'

@description('Optional. OS image reference. In case of marketplace images, it\'s the combination of the publisher, offer, sku, version attributes. In case of custom images it\'s the resource ID of the custom image.')
param imageReference object = {}

@description('Optional. Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.')
param plan object = {}

@description('Required. Specifies the OS disk.')
param osDisk object

@description('Optional. Specifies the data disks.')
param dataDisks array = []

@description('Optional. The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled.')
param ultraSSDEnabled bool = false

@description('Required. Administrator username')
@secure()
param adminUsername string

@description('Required. When specifying a Windows Virtual Machine, this value should be passed')
@secure()
param adminPassword string = ''

@description('Optional. Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format.')
param customData string = ''

@description('Optional. Specifies Windows operating system settings on the virtual machine.')
param windowsConfiguration object = {}

@description('Optional. Specifies the Linux operating system settings on the virtual machine.')
param linuxConfiguration object = {}

@description('Optional. Specifies set of certificates that should be installed onto the virtual machine.')
param certificatesToBeInstalled array = []

@description('Optional. Specifies the priority for the virtual machine.')
@allowed([
  'Regular'
  'Low'
  'Spot'
])
param vmPriority string = 'Regular'

@description('Optional. Specifies the eviction policy for the low priority virtual machine. Will result in \'Deallocate\' eviction policy.')
param enableEvictionPolicy bool = false

@description('Optional. Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars.')
param maxPriceForLowPriorityVm string = ''

@description('Optional. Specifies resource Id about the dedicated host that the virtual machine resides in.')
param dedicatedHostId string = ''

@description('Optional. Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system.')
@allowed([
  'Windows_Client'
  'Windows_Server'
  ''
])
param licenseType string = ''

@description('Optional. The type of identity used for the virtual machine. The type \'SystemAssigned, UserAssigned\' includes both an implicitly created identity and a set of user assigned identities. The type \'None\' (default) will remove any identities from the virtual machine.')
@allowed([
  'None'
  'SystemAssigned'
  'SystemAssigned, UserAssigned'
  'UserAssigned'
])
param managedServiceIdentity string = 'None'

@description('Optional. Mandatory if \'managedServiceIdentity\' contains UserAssigned. The list of user identities associated with the Virtual Machine.')
param userAssignedIdentities object = {}

@description('Optional. Storage account used to store boot diagnostic information. Boot diagnostics will be disabled if no value is provided.')
param bootDiagnosticStorageAccountName string = ''

@description('Optional. Storage account boot diagnostic base URI.')
param bootDiagnosticStorageAccountUri string = '.blob.core.windows.net/'

@description('Optional. Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine.')
param allowExtensionOperations bool = true

@description('Optional. Resource name of a proximity placement group.')
param proximityPlacementGroupName string = ''

@description('Optional. Resource name of an availability set. Cannot be used in combination with availability zone nor scale set.')
param availabilitySetName string = ''

@description('Optional. Creates an availability zone and adds the VMs to it. Cannot be used in combination with availability set nor scale set.')
param useAvailabilityZone bool = false

@description('Optional. If set to 1, 2 or 3, the availability zone for all VMs is hardcoded to that value. If zero, then the automatic algorithm will be used to give every VM in a different zone (up to three zones). Cannot be used in combination with availability set nor scale set.')
@allowed([
  0
  1
  2
  3
])
param availabilityZone int = 0

// External resources
@description('Required. Configures NICs and PIPs.')
param nicConfigurations array

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'DDoSProtectionNotifications'
  'DDoSMitigationFlowLogs'
  'DDoSMitigationReports'
])
param pipLogsToEnable array = [
  'DDoSProtectionNotifications'
  'DDoSMitigationFlowLogs'
  'DDoSMitigationReports'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param pipMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param nicMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. Recovery service vault name to add VMs to backup.')
param backupVaultName string = ''

@description('Optional. Resource group of the backup recovery service vault. If not provided the current resource group name is considered by default.')
param backupVaultResourceGroup string = resourceGroup().name

@description('Optional. Backup policy the VMs should be using for backup.')
param backupPolicyName string = 'DefaultPolicy'

@description('Optional. Specifies if Windows VM disks should be encrypted with Server-side encryption + Customer managed Key.')
param enableServerSideEncryption bool = false

// Child resources

@description('Optional. Settings for vm extensions.')
param extensionConfigurations array = []

// Shared parameters
@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource identifier of the Diagnostic Storage Account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource identifier of Log Analytics.')
param workspaceId string = ''

@description('Optional. Resource identifier of Log Analytics.')
param workspaceName string = ''

@description('Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param eventHubName string = ''

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Generated. Do not provide a value! This date value is used to generate a registration token.')
param baseTime string = utcNow('u')

@description('Optional. SAS token validity length to use to download files from storage accounts. Usage: \'PT8H\' - valid for 8 hours; \'P5D\' - valid for 5 days; \'P1Y\' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours.')
param sasTokenValidityLength string = 'PT8H'

var identity = {
  type: managedServiceIdentity
  userAssignedIdentities: (empty(userAssignedIdentities) ? json('null') : userAssignedIdentities)
}

var accountSasProperties = {
  signedServices: 'b'
  signedPermission: 'r'
  signedExpiry: dateTimeAdd(baseTime, sasTokenValidityLength)
  signedResourceTypes: 'o'
  signedProtocol: 'https'
}

var vmComputerNameTransformed = ((vmComputerNamesTransformation == 'uppercase') ? toUpper(virtualMachineName) : ((vmComputerNamesTransformation == 'lowercase') ? toLower(virtualMachineName) : virtualMachineName))

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Avere Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c025889f-8102-4ebf-b32c-fc0c6f0c6bd9')
  'DevTest Labs User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '76283e04-6283-4c54-8f91-bcf1374a3c64')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Microsoft OneAsset Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fd1bb084-1503-4bd2-99c0-630220046786')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Reservation Purchaser': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f7b75c60-3036-4b75-91c3-6b41c27c1689')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Virtual Machine Administrator Login': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1c0163c0-47e6-4577-8991-ea5c82e286e4')
  'Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
  'Virtual Machine User Login': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fb879df8-f326-4884-b1cf-06f3ad86be52')
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = if (!empty(workspaceName)) {
  name: workspaceName
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

module virtualMachine_nic './.bicep/nested_networkInterface.bicep' = [for (nicConfiguration, index) in nicConfigurations: {
  name: '${deployment().name}-nic-${index}'
  params: {
    networkInterfaceName: '${virtualMachineName}${nicConfiguration.nicSuffix}'
    virtualMachineName: virtualMachineName
    location: location
    tags: tags
    enableIPForwarding: (contains(nicConfiguration, 'enableIPForwarding') ? (!(empty(nicConfiguration.enableIPForwarding)) ? nicConfiguration.enableIPForwarding : false) : false)
    enableAcceleratedNetworking: (contains(nicConfiguration, 'enableAcceleratedNetworking') ? (!(empty(nicConfiguration.enableAcceleratedNetworking)) ? nicConfiguration.enableAcceleratedNetworking : false) : false)
    dnsServers: (contains(nicConfiguration, 'dnsServers') ? (!(empty(nicConfiguration.dnsServers)) ? nicConfiguration.dnsServers : json('[]')) : json('[]'))
    networkSecurityGroupId: (contains(nicConfiguration, 'nsgId') ? (!(empty(nicConfiguration.nsgId)) ? nicConfiguration.nsgId : '') : '')
    ipConfigurationArray: nicConfiguration.ipConfigurations
    lock: lock
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
    workspaceId: workspace.id
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    metricsToEnable: nicMetricsToEnable
    pipMetricsToEnable: pipMetricsToEnable
    pipLogsToEnable: pipLogsToEnable
    builtInRoleNames: builtInRoleNames
    roleAssignments: (contains(nicConfiguration, 'roleAssignments') ? (!(empty(nicConfiguration.roleAssignments)) ? nicConfiguration.roleAssignments : json('[]')) : json('[]'))
  }
}]

resource virtualMachine 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: virtualMachineName
  location: location
  identity: identity
  tags: tags
  zones: (useAvailabilityZone ? array(availabilityZone) : json('null'))
  plan: (empty(plan) ? json('null') : plan)
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: imageReference
      osDisk: {
        name: '${virtualMachineName}-disk-os-01'
        createOption: osDisk.createOption
        diskSizeGB: osDisk.diskSizeGB
        managedDisk: {
          storageAccountType: osDisk.managedDisk.storageAccountType
        }
      }
      dataDisks: [for (dataDisk, index) in dataDisks: {
        lun: index
        name: '${virtualMachineName}-disk-data-${padLeft((index + 1), 2, '0')}'
        diskSizeGB: dataDisk.diskSizeGB
        createOption: dataDisk.createOption
        caching: dataDisk.caching
        managedDisk: {
          storageAccountType: dataDisk.managedDisk.storageAccountType
          diskEncryptionSet: {
            id: (enableServerSideEncryption ? dataDisk.managedDisk.diskEncryptionSet.id : json('null'))
          }
        }
      }]
    }
    additionalCapabilities: {
      ultraSSDEnabled: ultraSSDEnabled
    }
    osProfile: {
      computerName: vmComputerNameTransformed
      adminUsername: adminUsername
      adminPassword: adminPassword
      customData: (empty(customData) ? json('null') : base64(customData))
      windowsConfiguration: (empty(windowsConfiguration) ? json('null') : windowsConfiguration)
      linuxConfiguration: (empty(linuxConfiguration) ? json('null') : linuxConfiguration)
      secrets: certificatesToBeInstalled
      allowExtensionOperations: allowExtensionOperations
    }
    networkProfile: {
      networkInterfaces: [for (nicConfiguration, index) in nicConfigurations: {
        properties: {
          primary: ((index == 0) ? true : false)
        }
        id: resourceId('Microsoft.Network/networkInterfaces', '${virtualMachineName}${nicConfiguration.nicSuffix}')
      }]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: (!empty(bootDiagnosticStorageAccountName))
        storageUri: (empty(bootDiagnosticStorageAccountName) ? json('null') : 'https://${bootDiagnosticStorageAccountName}${bootDiagnosticStorageAccountUri}')
      }
    }
    availabilitySet: (empty(availabilitySetName) ? json('null') : json('{"id":"${resourceId('Microsoft.Compute/availabilitySets', availabilitySetName)}"}'))
    proximityPlacementGroup: (empty(proximityPlacementGroupName) ? json('null') : json('{"id":"${resourceId('Microsoft.Compute/proximityPlacementGroups', proximityPlacementGroupName)}"}'))
    priority: vmPriority
    evictionPolicy: (enableEvictionPolicy ? 'Deallocate' : json('null'))
    billingProfile: (((!empty(vmPriority)) && (!empty(maxPriceForLowPriorityVm))) ? json('{"maxPrice":"${maxPriceForLowPriorityVm}"}') : json('null'))
    host: ((!empty(dedicatedHostId)) ? json('{"id":"${dedicatedHostId}"}') : json('null'))
    licenseType: (empty(licenseType) ? json('null') : licenseType)
  }
  dependsOn: [
    virtualMachine_nic
  ]
}

module virtualMachine_extension './.bicep/nested_extension.bicep' = [for (extension, index) in extensionConfigurations: {
  name: '${deployment().name}-vmextension-${index}'
  params: {
    virtualMachineName: virtualMachine.name
    extensionName: extension.extensionName
    location: location
    publisher: extension.publisher
    type: extension.type
    typeHandlerVersion: extension.typeHandlerVersion
    autoUpgradeMinorVersion: extension.autoUpgradeMinorVersion
    forceUpdateTag: contains(extension, 'forceUpdateTag') ? (!(empty(extension.forceUpdateTag)) ? extension.forceUpdateTag : '') : ''
    settings: contains(extension, 'settings') ? (!(empty(extension.settings)) ? extension.settings : json('{}')) : json('{}')
    protectedSettings: contains(extension, 'protectedSettings') ? (!(empty(extension.protectedSettings)) ? extension.protectedSettings : json('{}')) : json('{}')
    // settings: (contains(extension, 'settings') ? (!(empty(extension.settings)) ? (extension.type == 'MicrosoftMonitoringAgent' ? json('{"workspaceId": "${reference(workspace.id, workspace.apiVersion).customerId}"}') : extension.settings) : json('{}')) : json('{}'))
    // protectedSettings: (contains(extension, 'protectedSettings') ? (!(empty(extension.protectedSettings)) ? (extension.type == 'MicrosoftMonitoringAgent' ? json('{"workspaceKey": "${listKeys(workspace.id, workspace.apiVersion).primarySharedKey}"}') : extension.protectedSettings) : json('{}')) : json('{}'))
  }
}]

// resource vmName_WindowsCustomScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2019-07-01' = if ((!empty(windowsScriptExtensionFileData)) && (!empty(windowsScriptExtensionCommandToExecute))) {
//   parent: vmName_resource
//   name: 'WindowsCustomScriptExtension'
//   location: location
//   properties: {
//     publisher: 'Microsoft.Compute'
//     type: 'CustomScriptExtension'
//     typeHandlerVersion: '1.9'
//     autoUpgradeMinorVersion: true
//     settings: {
//       fileUris: [for item in windowsScriptExtensionFileData: concat(item.uri, (contains(item, 'storageAccountId') ? '?${listAccountSas(item.storageAccountId, '2019-04-01', accountSasProperties).accountSasToken}' : ''))]
//     }
//     protectedSettings: {
//       commandToExecute: windowsScriptExtensionCommandToExecute
//       storageAccountName: ((!empty(cseStorageAccountName)) ? cseStorageAccountName : json('null'))
//       storageAccountKey: ((!empty(cseStorageAccountKey)) ? cseStorageAccountKey : json('null'))
//       managedIdentity: ((!empty(cseManagedIdentity)) ? cseManagedIdentity : json('null'))
//     }
//   }
//   dependsOn: [
//     vmName_windowsDsc
//   ]
// }

module virtualMachine_backup './.bicep/nested_backup.bicep' = if (!empty(backupVaultName)) {
  name: 'add-${virtualMachine.name}-ToBackup'
  params: {
    backupResourceName: '${backupVaultName}/Azure/iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${virtualMachine.name}/vm;iaasvmcontainerv2;${resourceGroup().name};${virtualMachine.name}'
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    backupPolicyId: resourceId('Microsoft.RecoveryServices/vaults/backupPolicies', backupVaultName, backupPolicyName)
    sourceResourceId: virtualMachine.id
  }
  scope: resourceGroup(backupVaultResourceGroup)
  dependsOn: [
    virtualMachine_extension
  ]
}

resource virtualMachine_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${virtualMachine.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: virtualMachine
}

module virtualMachine_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: virtualMachine.name
  }
}]

output virtualMachineName string = virtualMachine.name
output virtualMachineResourceId string = virtualMachine.id
output virtualMachineResourceGroup string = resourceGroup().name
