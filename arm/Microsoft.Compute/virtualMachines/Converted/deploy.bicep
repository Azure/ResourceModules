@description('Optional. Name(s) of the virtual machine(s). If no explicit names are provided, VM name(s) will be generated based on the vmNamePrefix, vmNumberOfInstances and vmInitialNumber parameters.')
param vmNames array = []

@description('Optional. If no explicit values were provided in the vmNames parameter, this prefix will be used in combination with the vmNumberOfInstances and the vmInitialNumber parameters to create unique VM names. You should use a unique prefix to reduce name collisions in Active Directory. If no value is provided, a 10 character long unique string will be generated based on the Resource Group\'s name.')
param vmNamePrefix string = take(toLower(uniqueString(resourceGroup().name)), 10)

@description('Optional. Specifies the VM computer names for the VMs. If the VM name is not in the object as key the VM name is used as computer name. Be aware of the maximum size of 15 characters and limitations regarding special characters for the computer name. Once set it can\'t be changed via template.')
param vmComputerNames object = {}

@description('Optional. Specifies whether the computer names should be transformed. The transformation is performed on all computer names. Available transformations are \'none\' (Default), \'uppercase\' and \'lowercase\'.')
param vmComputerNamesTransformation string = 'none'

@description('Optional. If no explicit values were provided in the vmNames parameter, this parameter will be used to generate VM names, using the vmNamePrefix and the vmInitialNumber values.')
@minValue(1)
@maxValue(800)
param vmNumberOfInstances int = 1

@description('Optional. If no explicit values were provided in the vmNames parameter, this parameter will be used to generate VM names, using the vmNamePrefix and the vmNumberOfInstances values.')
param vmInitialNumber int = 1

@description('Optional. The maximum number of VMs allowed in a single deployment. The template will create additional deployments if the number of VMs to be deployed exceeds this quota.')
param maxNumberOfVmsPerDeployment int = 50

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

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

@description('Optional. Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine.')
param allowExtensionOperations bool = true

@description('Optional. Name(s) of the availability set(s). If no explicit names are provided, availability set name(s) will be generated based on the availabilitySetName, vmNumberOfInstances and maxNumberOfVmsPerAvSet parameters.')
param availabilitySetNames array = []

@description('Optional. Creates an availability set with the given name and adds the VMs to it. Cannot be used in combination with availability zone nor scale set.')
param availabilitySetName string = ''

@description('Optional. The number of fault domains to use.')
param availabilitySetFaultDomain int = 2

@description('Optional. The number of update domains to use.')
param availabilitySetUpdateDomain int = 5

@description('Optional. Sku of the availability set. Use \'Aligned\' for virtual machines with managed disks and \'Classic\' for virtual machines with unmanaged disks.')
param availabilitySetSku string = 'Aligned'

@description('Optional. The maximum number of VMs allowed in an availability set. The template will create additional availability sets if the number of VMs to be deployed exceeds this quota.')
@minValue(1)
@maxValue(200)
param maxNumberOfVmsPerAvSet int = 200

@description('Optional. Creates an proximity placement group and adds the VMs to it.')
param proximityPlacementGroupName string = ''

@description('Optional. Specifies the type of the proximity placement group.')
@allowed([
  'Standard'
  'Ultra'
])
param proximityPlacementGroupType string = 'Standard'

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

@description('Required. Configures NICs and PIPs.')
param nicConfigurations array

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

@description('Optional. Enables Microsoft Windows Defender AV.')
param enableMicrosoftAntiMalware bool = false

@description('Optional. Settings for Microsoft Windows Defender AV extension.')
param microsoftAntiMalwareSettings object = {}

@description('Optional. Specifies if MMA agent for Windows VM should be enabled.')
param enableWindowsMMAAgent bool = false

@description('Optional. Specifies if MMA agent for Linux VM should be enabled.')
param enableLinuxMMAAgent bool = false

@description('Optional. Specifies if Azure Dependency Agent for Windows VM should be enabled. Requires WindowsMMAAgent to be enabled.')
param enableWindowsDependencyAgent bool = false

@description('Optional. Specifies if Azure Dependency Agent for Linux VM should be enabled. Requires LinuxMMAAgent to be enabled.')
param enableLinuxDependencyAgent bool = false

@description('Optional. Specifies if Azure Network Watcher Agent for Windows VM should be enabled.')
param enableNetworkWatcherWindows bool = false

@description('Optional. Specifies if Azure Network Watcher Agent for Linux VM should be enabled.')
param enableNetworkWatcherLinux bool = false

@description('Optional. Specifies if Windows VM disks should be encrypted. If enabled, boot diagnostics must be enabled as well.')
param enableWindowsDiskEncryption bool = false

@description('Optional. Specifies if Windows VM disks should be encrypted with Server-side encryption + Customer managed Key.')
param enableServerSideEncryption bool = false

@description('Optional. Specifies if Linux VM disks should be encrypted. If enabled, boot diagnostics must be enabled as well.')
param enableLinuxDiskEncryption bool = false

@description('Optional. The type of identity used for the virtual machine. The type \'SystemAssigned, UserAssigned\' includes both an implicitly created identity and a set of user assigned identities. The type \'None\' (default) will remove any identities from the virtual machine.')
@allowed([
  'None'
  'SystemAssigned'
  'UserAssigned'
  'SystemAssigned, UserAssigned'
  'UserAssigned, SystemAssigned'
])
param managedServiceIdentity string = 'None'

@description('Optional. Mandatory if \'managedServiceIdentity\' contains UserAssigned. The list of user identities associated with the Virtual Machine.')
param userAssignedIdentities object = {}

@description('Optional. Specifies disk key encryption algorithm.')
@allowed([
  'RSA-OAEP'
  'RSA-OAEP-256'
  'RSA1_5'
])
param diskKeyEncryptionAlgorithm string = 'RSA-OAEP'

@description('Optional. URL of the KeyEncryptionKey used to encrypt the volume encryption key')
param keyEncryptionKeyURL string = ''

@description('Optional. URL of the Key Vault instance where the Key Encryption Key (KEK) resides')
param keyVaultUri string = ''

@description('Optional. Resource identifier of the Key Vault instance where the Key Encryption Key (KEK) resides')
param keyVaultId string = ''

@description('Optional. Type of the volume OS or Data to perform encryption operation')
@allowed([
  'OS'
  'Data'
  'All'
])
param diskEncryptionVolumeType string = 'All'

@description('Optional. Pass in an unique value like a GUID everytime the operation needs to be force run')
param forceUpdateTag string = '1.0'

@description('Optional. Should the OS partition be resized to occupy full OS VHD before splitting system volume')
param resizeOSDisk bool = false

@description('Optional. Array of objects that specifies URIs and the storageAccountId of the scripts that need to be downloaded and run by the Custom Script Extension on a Windows VM.')
param windowsScriptExtensionFileData array = []

@description('Optional. Specifies the command that should be run on a Windows VM.')
@secure()
param windowsScriptExtensionCommandToExecute string = ''

@description('Optional. The name of the storage account to access for the CSE script(s).')
param cseStorageAccountName string = ''

@description('Optional. The storage key of the storage account to access for the CSE script(s).')
param cseStorageAccountKey string = ''

@description('Optional. A managed identity to use for the CSE.')
param cseManagedIdentity object = {}

@description('Optional. Recovery service vault name to add VMs to backup.')
param backupVaultName string = ''

@description('Optional. Resource group of the backup recovery service vault.')
param backupVaultResourceGroup string = ''

@description('Optional. Backup policy the VMs should be using for backup.')
param backupPolicyName string = 'DefaultPolicy'

@description('Optional. Specifies the FQDN the of the domain the VM will be joined to. Currently implemented for Windows VMs only')
param domainName string = ''

@description('Optional. Mandatory if domainName is specified. User used for the join to the domain. Format: username@domainFQDN')
param domainJoinUser string = ''

@description('Optional. Specifies an organizational unit (OU) for the domain account. Enter the full distinguished name of the OU in quotation marks. Example: "OU=testOU; DC=domain; DC=Domain; DC=com"')
param domainJoinOU string = ''

@description('Optional. Required if domainName is specified. Password of the user specified in domainJoinUser parameter')
@secure()
param domainJoinPassword string = ''

@description('Optional. Controls the restart of vm after executing domain join')
param domainJoinRestart bool = false

@description('Optional. Set of bit flags that define the join options. Default value of 3 is a combination of NETSETUP_JOIN_DOMAIN (0x00000001) & NETSETUP_ACCT_CREATE (0x00000002) i.e. will join the domain and create the account on the domain. For more information see https://msdn.microsoft.com/en-us/library/aa392154(v=vs.85).aspx')
param domainJoinOptions int = 3

@description('Optional. The DSC configuration object')
param dscConfiguration object = {}

@description('Optional. Storage account used to store boot diagnostic information. Boot diagnostics will be disabled if no value is provided.')
param bootDiagnosticStorageAccountName string = ''

@description('Optional. Storage account boot diagnostic base URI.')
param bootDiagnosticStorageAccountUri string = '.blob.core.windows.net/'

@description('Optional. The name of the Diagnostic setting.')
param diagnosticSettingName string = 'service'

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource identifier of the Diagnostic Storage Account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource identifier of Log Analytics.')
param workspaceId string = ''

@description('Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param eventHubName string = ''

@description('Optional. Switch to lock VM from deletion.')
param lockForDeletion bool = false

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

var diagnosticsMetrics = [
  {
    category: 'AllMetrics'
    timeGrain: null
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]
var identity = {
  type: managedServiceIdentity
  userAssignedIdentities: (empty(userAssignedIdentities) ? json('null') : userAssignedIdentities)
}
var pidName_var = 'pid-${cuaId}'
var vmNames_var = (empty(vmNames) ? vmGeneratedNames : vmNames)
var avSetNames = ((empty(availabilitySetNames) && empty(availabilitySetName)) ? json('[]') : (empty(availabilitySetNames) ? avSetGeneratedNames : availabilitySetNames))
var accountSasProperties = {
  signedServices: 'b'
  signedPermission: 'r'
  signedExpiry: dateTimeAdd(baseTime, sasTokenValidityLength)
  signedResourceTypes: 'o'
  signedProtocol: 'https'
}
var builtInRoleNames = {
  'Avere Cluster Create': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/a7b1b19a-0e83-4fe5-935c-faaefbfd18c3'
  'Avere Cluster Runtime Operator': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/e078ab98-ef3a-4c9a-aba7-12f5172b45d0'
  'Avere Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/4f8fab4f-1852-4a58-a46a-8eaf358af14a'
  'Avere Operator': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/c025889f-8102-4ebf-b32c-fc0c6f0c6bd9'
  'Azure Service Deploy Release Management Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/21d96096-b162-414a-8302-d8354f9d91b2'
  Contributor: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
  'CAL-Custom-Role': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/7b266cd7-0bba-4ae2-8423-90ede5e1e898'
  'DevTest Labs User': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/76283e04-6283-4c54-8f91-bcf1374a3c64'
  'Log Analytics Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  'Log Analytics Reader': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/73c42c96-874c-492b-b04d-ab87d138a893'
  masterreader: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/a48d7796-14b4-4889-afef-fbb65a93e5a2'
  'Managed Application Contributor Role': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/641177b8-a67a-45b9-a033-47bc880bb21e'
  'Managed Application Operator Role': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/c7393b34-138c-406f-901b-d8cf2b17e6ae'
  'Managed Applications Reader': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b9331d33-8a36-4f8c-b097-4f54124fdb44'
  'Microsoft OneAsset Reader': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/fd1bb084-1503-4bd2-99c0-630220046786'
  'Monitoring Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  'Monitoring Metrics Publisher': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/3913510d-42f4-4e42-8a64-420c390055eb'
  'Monitoring Reader': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  Owner: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Reader: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7'
  'Reservation Purchaser': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/f7b75c60-3036-4b75-91c3-6b41c27c1689'
  'Resource Policy Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/36243c78-bf99-498c-9df9-86d9f8d28608'
  'User Access Administrator': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  'Virtual Machine Administrator Login': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/1c0163c0-47e6-4577-8991-ea5c82e286e4'
  'Virtual Machine Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
  'Virtual Machine User Login': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/fb879df8-f326-4884-b1cf-06f3ad86be52'
}
var vmGeneratedNames = [for i in range(0, vmNumberOfInstances): concat(vmNamePrefix, padLeft((i + vmInitialNumber), 3, '0'))]
var avSetGeneratedNames = [for i in range(0, (((vmNumberOfInstances % maxNumberOfVmsPerAvSet) == 0) ? (vmNumberOfInstances / maxNumberOfVmsPerAvSet) : ((vmNumberOfInstances / maxNumberOfVmsPerAvSet) + 1))): '${availabilitySetName}-${padLeft((i + 1), 3, '0')}']
var availabilityZones = [for i in range(0, length(vmNames_var)): ((availabilityZone == 0) ? string(((i % 3) + 1)) : string(availabilityZone))]

module pidName './nested_pidName.bicep' = if (!empty(cuaId)) {
  name: pidName_var
  params: {}
}

resource proximityPlacementGroupName_proximityPlacementGroupName_dummyProximityGroup 'Microsoft.Compute/proximityPlacementGroups@2021-04-01' = if (!empty(proximityPlacementGroupName)) {
  location: location
  tags: tags
  name: ((!empty(proximityPlacementGroupName)) ? proximityPlacementGroupName : 'dummyProximityGroup')
  properties: {
    proximityPlacementGroupType: proximityPlacementGroupType
  }
}

resource avSetNames_avSetNames_avSetLoop_dummyAvailabilitySet 'Microsoft.Compute/availabilitySets@2021-04-01' = [for item in avSetNames: if (!empty(avSetNames)) {
  location: location
  tags: tags
  name: ((!empty(avSetNames)) ? item : 'dummyAvailabilitySet')
  properties: {
    platformFaultDomainCount: availabilitySetFaultDomain
    platformUpdateDomainCount: availabilitySetUpdateDomain
    proximityPlacementGroup: (empty(proximityPlacementGroupName) ? json('null') : json('{"id":"${resourceId('Microsoft.Compute/proximityPlacementGroups', proximityPlacementGroupName)}"}'))
  }
  sku: {
    name: availabilitySetSku
  }
  dependsOn: [
    proximityPlacementGroupName_proximityPlacementGroupName_dummyProximityGroup
  ]
}]

module bulkVMdeployment_vmDepBulkVMdeployment './nested_bulkVMdeployment_vmDepBulkVMdeployment.bicep' = [for i in range(0, (((length(vmNames_var) % maxNumberOfVmsPerDeployment) == 0) ? (length(vmNames_var) / maxNumberOfVmsPerDeployment) : ((length(vmNames_var) / maxNumberOfVmsPerDeployment) + 1))): {
  name: 'bulkVMdeployment-${i}'
  params: {
    vmNames: take(skip(vmNames_var, (i * maxNumberOfVmsPerDeployment)), maxNumberOfVmsPerDeployment)
    nicConfigurations: nicConfigurations
    avSetNames: avSetNames
    maxNumberOfVmsPerAvSet: maxNumberOfVmsPerAvSet
    maxNumberOfVmsPerDeployment: maxNumberOfVmsPerDeployment
    bulkVMdeploymentLoopIndex: i
    proximityPlacementGroupName: proximityPlacementGroupName
    location: location
    tags: tags
    vmComputerNames: vmComputerNames
    vmComputerNamesTransformation: vmComputerNamesTransformation
    useAvailabilityZone: useAvailabilityZone
    availabilityZones: availabilityZones
    plan: plan
    lockForDeletion: lockForDeletion
    diagnosticSettingName: diagnosticSettingName
    diagnosticStorageAccountId: diagnosticStorageAccountId
    workspaceId: workspaceId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    diagnosticsMetrics: diagnosticsMetrics
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
    vmSize: vmSize
    imageReference: imageReference
    osDisk: osDisk
    dataDisks: dataDisks
    enableServerSideEncryption: enableServerSideEncryption
    ultraSSDEnabled: ultraSSDEnabled
    adminUsername: adminUsername
    adminPassword: adminPassword
    customData: customData
    windowsConfiguration: windowsConfiguration
    linuxConfiguration: linuxConfiguration
    certificatesToBeInstalled: certificatesToBeInstalled
    allowExtensionOperations: allowExtensionOperations
    bootDiagnosticStorageAccountName: bootDiagnosticStorageAccountName
    bootDiagnosticStorageAccountUri: bootDiagnosticStorageAccountUri
    vmPriority: vmPriority
    enableEvictionPolicy: enableEvictionPolicy
    dedicatedHostId: dedicatedHostId
    licenseType: licenseType
    domainName: domainName
    domainJoinUser: domainJoinUser
    domainJoinOU: domainJoinOU
    domainJoinRestart: domainJoinRestart
    domainJoinOptions: domainJoinOptions
    domainJoinPassword: domainJoinPassword
    enableMicrosoftAntiMalware: enableMicrosoftAntiMalware
    microsoftAntiMalwareSettings: microsoftAntiMalwareSettings
    enableWindowsMMAAgent: enableWindowsMMAAgent
    enableLinuxMMAAgent: enableLinuxMMAAgent
    enableWindowsDiskEncryption: enableWindowsDiskEncryption
    forceUpdateTag: forceUpdateTag
    keyVaultUri: keyVaultUri
    keyVaultId: keyVaultId
    keyEncryptionKeyURL: keyEncryptionKeyURL
    diskKeyEncryptionAlgorithm: diskKeyEncryptionAlgorithm
    diskEncryptionVolumeType: diskEncryptionVolumeType
    resizeOSDisk: resizeOSDisk
    enableLinuxDiskEncryption: enableLinuxDiskEncryption
    enableWindowsDependencyAgent: enableWindowsDependencyAgent
    enableLinuxDependencyAgent: enableLinuxDependencyAgent
    enableNetworkWatcherWindows: enableNetworkWatcherWindows
    enableNetworkWatcherLinux: enableNetworkWatcherLinux
    identity: identity
    dscConfiguration: dscConfiguration
    windowsScriptExtensionFileData: windowsScriptExtensionFileData
    windowsScriptExtensionCommandToExecute: windowsScriptExtensionCommandToExecute
    cseStorageAccountName: cseStorageAccountName
    cseStorageAccountKey: cseStorageAccountKey
    cseManagedIdentity: cseManagedIdentity
    maxPriceForLowPriorityVm: maxPriceForLowPriorityVm
    accountSasProperties: accountSasProperties
    roleAssignments: roleAssignments
    builtInRoleNames: builtInRoleNames
    backupVaultName: backupVaultName
    backupVaultResourceGroup: backupVaultResourceGroup
    backupPolicyName: backupPolicyName
  }
  dependsOn: [
    avSetNames_avSetNames_avSetLoop_dummyAvailabilitySet
  ]
}]

output virtualMachinesResourceId array = [for item in vmNames_var: resourceId('Microsoft.Compute/virtualMachines', item)]
output virtualMachinesResourceGroup string = resourceGroup().name
output virtualMachinesName array = vmNames_var
output deploymentCount int = (((length(vmNames_var) % maxNumberOfVmsPerDeployment) == 0) ? (length(vmNames_var) / maxNumberOfVmsPerDeployment) : ((length(vmNames_var) / maxNumberOfVmsPerDeployment) + 1))