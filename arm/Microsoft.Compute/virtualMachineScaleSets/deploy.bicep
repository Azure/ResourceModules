@description('Optional. Name of the VMSS.')
param vmssName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

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

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Fault Domain count for each placement group.')
param scaleSetFaultDomain int = 2

@description('Optional. Creates an proximity placement group and adds the VMs to it.')
param proximityPlacementGroupName string = ''

@description('Optional. Specifies the type of the proximity placement group.')
@allowed([
  'Standard'
  'Ultra'
])
param proximityPlacementGroupType string = 'Standard'

@description('Required. Configures NICs and PIPs.')
param nicConfigurations array = []

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

@description('Optional. Storage account boot diagnostic base URI.')
param bootDiagnosticStorageAccountUri string = '.blob.${environment().suffixes.storage}/'

@description('Optional. Storage account used to store boot diagnostic information. Boot diagnostics will be disabled if no value is provided.')
param bootDiagnosticStorageAccountName string = ''

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

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Specifies the mode of an upgrade to virtual machines in the scale set.\' Manual - You control the application of updates to virtual machines in the scale set. You do this by using the manualUpgrade action. ; Automatic - All virtual machines in the scale set are automatically updated at the same time. - Automatic, Manual, Rolling')
@allowed([
  'Manual'
  'Automatic'
  'Rolling'
])
param upgradePolicyMode string = 'Manual'

@description('Optional. The maximum percent of total virtual machine instances that will be upgraded simultaneously by the rolling upgrade in one batch. As this is a maximum, unhealthy instances in previous or future batches can cause the percentage of instances in a batch to decrease to ensure higher reliability.')
param maxBatchInstancePercent int = 20

@description('Optional. The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch')
param maxUnhealthyInstancePercent int = 20

@description('Optional. The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch.')
param maxUnhealthyUpgradedInstancePercent int = 20

@description('Optional. The wait time between completing the update for all virtual machines in one batch and starting the next batch. The time duration should be specified in ISO 8601 format')
param pauseTimeBetweenBatches string = 'PT0S'

@description('Optional. Indicates whether OS upgrades should automatically be applied to scale set instances in a rolling fashion when a newer version of the OS image becomes available. Default value is false. If this is set to true for Windows based scale sets, enableAutomaticUpdates is automatically set to false and cannot be set to true.')
param enableAutomaticOSUpgrade bool = false

@description('Optional. Whether OS image rollback feature should be disabled.')
param disableAutomaticRollback bool = false

@description('Optional. Specifies whether automatic repairs should be enabled on the virtual machine scale set.')
param automaticRepairsPolicyEnabled bool = false

@description('Optional. The amount of time for which automatic repairs are suspended due to a state change on VM. The grace time starts after the state change has completed. This helps avoid premature or accidental repairs. The time duration should be specified in ISO 8601 format. The minimum allowed grace period is 30 minutes (PT30M). The maximum allowed grace period is 90 minutes (PT90M).')
param gracePeriod string = 'PT30M'

@description('Optional. Specifies the computer name prefix for all of the virtual machines in the scale set.')
@minLength(1)
@maxLength(15)
param vmNamePrefix string = 'vmssvm'

@description('Optional. Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later.')
param provisionVMAgent bool = true

@description('Optional. Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning.')
param enableAutomaticUpdates bool = true

@description('Optional. Specifies the time zone of the virtual machine. e.g. \'Pacific Standard Time\'. Possible values can be TimeZoneInfo.Id value from time zones returned by TimeZoneInfo.GetSystemTimeZones.')
param timeZone string = ''

@description('Optional. Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. - AdditionalUnattendContent object')
param additionalUnattendContent array = []

@description('Optional. Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object.')
param winRMListeners object = {}

@description('Optional. Specifies whether password authentication should be disabled.')
param disablePasswordAuthentication bool = false

@description('Optional. The list of SSH public keys used to authenticate with linux based VMs')
param publicKeys array = []

@description('Optional. Specifies set of certificates that should be installed onto the virtual machines in the scale set.')
param secrets array = []

@description('Optional. Specifies Scheduled Event related configurations')
param scheduledEventsProfile object = {}

@description('Optional. Specifies whether the Virtual Machine Scale Set should be overprovisioned.')
param overprovision bool = false

@description('Optional. When Overprovision is enabled, extensions are launched only on the requested number of VMs which are finally kept. This property will hence ensure that the extensions do not run on the extra overprovisioned VMs.')
param doNotRunExtensionsOnOverprovisionedVMs bool = false

@description('Optional. Whether to force strictly even Virtual Machine distribution cross x-zones in case there is zone outage.')
param zoneBalance bool = false

@description('Optional. When true this limits the scale set to a single placement group, of max size 100 virtual machines. NOTE: If singlePlacementGroup is true, it may be modified to false. However, if singlePlacementGroup is false, it may not be modified to true.')
param singlePlacementGroup bool = true

@description('Optional. Specifies the scale-in policy that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled-in')
param scaleInPolicy object = {
  rules: [
    'Default'
  ]
}

@description('Optional. The SKU size of the VMs.')
param instanceSize string = ''

@description('Optional. The initial instance count of scale set VMs.')
param instanceCount int = 1

@description('Optional. The virtual machine scale set zones. NOTE: Availability zones can only be set when you create the scale set.')
param availabilityZones array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. The chosen OS type')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@description('Generated. Do not provide a value! This date value is used to generate a registration token.')
param baseTime string = utcNow('u')

@description('Optional. SAS token validity length to use to download files from storage accounts. Usage: \'PT8H\' - valid for 8 hours; \'P5D\' - valid for 5 days; \'P1Y\' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours.')
param sasTokenValidityLength string = 'PT8H'

@description('Optional. The type of identity used for the virtual machine scale set. The type \'SystemAssigned, UserAssigned\' includes both an implicitly created identity and a set of user assigned identities. The type \'None\' will remove any identities from the virtual machine scale set. - SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, None')
@allowed([
  'SystemAssigned'
  'UserAssigned'
  'None'
  ''
])
param managedIdentityType string = ''

@description('Optional. The list of user identities associated with the virtual machine scale set. The user identity dictionary key references will be ARM resource ids in the form: \'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}\'.')
param managedIdentityIdentities object = {}

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param metricsToEnable array = [
  'AllMetrics'
]

var diagnosticsMetrics = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var publicKeysFormatted = [for publicKey in publicKeys: {
  path: publicKey.path
  keyData: publicKey.keyData
}]
var linuxConfiguration = {
  disablePasswordAuthentication: disablePasswordAuthentication
  ssh: {
    publicKeys: publicKeysFormatted
  }
  provisionVMAgent: provisionVMAgent
}

var windowsConfiguration = {
  provisionVMAgent: provisionVMAgent
  enableAutomaticUpdates: enableAutomaticUpdates
  timeZone: (empty(timeZone) ? json('null') : timeZone)
  additionalUnattendContent: (empty(additionalUnattendContent) ? json('null') : additionalUnattendContent)
  winRM: (empty(winRMListeners) ? json('null') : json('{"listeners": "${winRMListeners}"}'))
}

var accountSasProperties = {
  signedServices: 'b'
  signedPermission: 'r'
  signedExpiry: dateTimeAdd(baseTime, sasTokenValidityLength)
  signedResourceTypes: 'o'
  signedProtocol: 'https'
}
var pidName_var = 'pid-${cuaId}'
var builtInRoleNames = {
  'Avere Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/4f8fab4f-1852-4a58-a46a-8eaf358af14a'
  Contributor: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
  'DevTest Labs User': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/76283e04-6283-4c54-8f91-bcf1374a3c64'
  'Log Analytics Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  'Log Analytics Reader': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/73c42c96-874c-492b-b04d-ab87d138a893'
  'Managed Application Contributor Role': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/641177b8-a67a-45b9-a033-47bc880bb21e'
  'Managed Application Operator Role': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/c7393b34-138c-406f-901b-d8cf2b17e6ae'
  'Managed Applications Reader': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b9331d33-8a36-4f8c-b097-4f54124fdb44'
  'Monitoring Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  'Monitoring Metrics Publisher': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/3913510d-42f4-4e42-8a64-420c390055eb'
  'Monitoring Reader': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  Owner: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Reader: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7'
  'Resource Policy Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/36243c78-bf99-498c-9df9-86d9f8d28608'
  'User Access Administrator': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  'Virtual Machine Administrator Login': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/1c0163c0-47e6-4577-8991-ea5c82e286e4'
  'Virtual Machine Contributor': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
  'Virtual Machine User Login': '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/fb879df8-f326-4884-b1cf-06f3ad86be52'
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: pidName_var
  params: {}
}

resource proximityPlacementGroup 'Microsoft.Compute/proximityPlacementGroups@2021-04-01' = if (!empty(proximityPlacementGroupName)) {
  name: ((!empty(proximityPlacementGroupName)) ? proximityPlacementGroupName : 'dummyProximityGroup')
  location: location
  tags: tags
  properties: {
    proximityPlacementGroupType: proximityPlacementGroupType
  }
}

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2021-04-01' = if (!empty(vmssName)) {
  name: vmssName
  location: location
  tags: tags
  identity: (empty(managedIdentityType) ? json('null') : json('{"type":"${managedIdentityType}${((!empty(managedIdentityIdentities)) ? ',"userAssignedIdentities":"${managedIdentityIdentities}' : '')}"}'))
  zones: availabilityZones
  properties: {
    proximityPlacementGroup: (empty(proximityPlacementGroupName) ? json('null') : json('{"id":"${resourceId('Microsoft.Compute/proximityPlacementGroups', proximityPlacementGroupName)}"}'))
    upgradePolicy: {
      mode: upgradePolicyMode
      rollingUpgradePolicy: {
        maxBatchInstancePercent: maxBatchInstancePercent
        maxUnhealthyInstancePercent: maxUnhealthyInstancePercent
        maxUnhealthyUpgradedInstancePercent: maxUnhealthyUpgradedInstancePercent
        pauseTimeBetweenBatches: pauseTimeBetweenBatches
      }
      automaticOSUpgradePolicy: {
        enableAutomaticOSUpgrade: enableAutomaticOSUpgrade
        disableAutomaticRollback: disableAutomaticRollback
      }
    }
    automaticRepairsPolicy: {
      enabled: automaticRepairsPolicyEnabled
      gracePeriod: gracePeriod
    }
    virtualMachineProfile: {
      osProfile: {
        computerNamePrefix: vmNamePrefix
        adminUsername: adminUsername
        adminPassword: (empty(adminPassword) ? json('null') : adminPassword)
        customData: (empty(customData) ? json('null') : base64(customData))
        windowsConfiguration: ((osType == 'Windows') ? windowsConfiguration : json('null'))
        linuxConfiguration: ((osType == 'Linux') ? linuxConfiguration : json('null'))
        secrets: secrets
      }
      storageProfile: {
        imageReference: imageReference
        osDisk: {
          createOption: osDisk.createOption
          diskSizeGB: osDisk.diskSizeGB
          caching: (contains(osDisk, 'caching') ? osDisk.caching : json('null'))
          writeAcceleratorEnabled: (contains(osDisk, 'writeAcceleratorEnabled') ? osDisk.writeAcceleratorEnabled : json('null'))
          diffDiskSettings: (contains(osDisk, 'diffDiskSettings') ? osDisk.diffDiskSettings : json('null'))
          osType: (contains(osDisk, 'osType') ? osDisk.osType : json('null'))
          image: (contains(osDisk, 'image') ? osDisk.image : json('null'))
          vhdContainers: (contains(osDisk, 'vhdContainers') ? osDisk.vhdContainers : json('null'))
          managedDisk: {
            storageAccountType: osDisk.managedDisk.storageAccountType
            diskEncryptionSet: (contains(osDisk, 'diskEncryptionSet') ? osDisk.diskEncryptionSet : json('null'))
          }
        }
        dataDisks: [for (item, j) in dataDisks: {
          lun: j
          diskSizeGB: item.diskSizeGB
          createOption: item.createOption
          caching: item.caching
          writeAcceleratorEnabled: (contains(osDisk, 'writeAcceleratorEnabled') ? osDisk.writeAcceleratorEnabled : json('null'))
          managedDisk: {
            storageAccountType: item.managedDisk.storageAccountType
            diskEncryptionSet: {
              id: (enableServerSideEncryption ? item.managedDisk.diskEncryptionSet.id : json('null'))
            }
          }
          diskIOPSReadWrite: (contains(osDisk, 'diskIOPSReadWrite') ? item.diskIOPSReadWrite : json('null'))
          diskMBpsReadWrite: (contains(osDisk, 'diskMBpsReadWrite') ? item.diskMBpsReadWrite : json('null'))
        }]
      }
      networkProfile: {
        networkInterfaceConfigurations: [for (item, j) in nicConfigurations: {
          name: '${vmssName}${item.nicSuffix}configuration-${j}'
          properties: {
            primary: ((j == 0) ? true : any(null))
            enableAcceleratedNetworking: (contains(nicConfigurations, 'enableAcceleratedNetworking') ? item.enableAcceleratedNetworking : json('null'))
            networkSecurityGroup: (contains(nicConfigurations, 'nsgId') ? json('{"id": "${item.nsgId}"}') : json('null'))
            ipConfigurations: item.ipConfigurations
          }
        }]
      }
      diagnosticsProfile: {
        bootDiagnostics: {
          enabled: (!empty(bootDiagnosticStorageAccountName))
          storageUri: (empty(bootDiagnosticStorageAccountName) ? json('null') : 'https://${bootDiagnosticStorageAccountName}${bootDiagnosticStorageAccountUri}')
        }
      }
      licenseType: (empty(licenseType) ? json('null') : licenseType)
      priority: vmPriority
      evictionPolicy: (enableEvictionPolicy ? 'Deallocate' : json('null'))
      billingProfile: (((!empty(vmPriority)) && (!empty(maxPriceForLowPriorityVm))) ? json('{"maxPrice":"${maxPriceForLowPriorityVm}"}') : json('null'))
      scheduledEventsProfile: scheduledEventsProfile
    }
    overprovision: overprovision
    doNotRunExtensionsOnOverprovisionedVMs: doNotRunExtensionsOnOverprovisionedVMs
    zoneBalance: ((zoneBalance == 'true') ? zoneBalance : json('null'))
    platformFaultDomainCount: scaleSetFaultDomain
    singlePlacementGroup: singlePlacementGroup
    additionalCapabilities: {
      ultraSSDEnabled: ultraSSDEnabled
    }
    scaleInPolicy: scaleInPolicy
  }
  sku: {
    name: instanceSize
    capacity: instanceCount
  }
  plan: (empty(plan) ? json('null') : plan)
  dependsOn: [
    proximityPlacementGroup
  ]
}

resource vmss_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${vmss.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: vmss
}

resource vmss_DomainJoin 'Microsoft.Compute/virtualMachineScaleSets/extensions@2021-07-01' = if (!empty(domainName)) {
  parent: vmss
  name: 'DomainJoin'
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      Name: domainName
      User: domainJoinUser
      OUPath: domainJoinOU
      Restart: domainJoinRestart
      Options: domainJoinOptions
    }
    protectedSettings: {
      Password: domainJoinPassword
    }
  }
}

resource vmss_MicrosoftAntiMalware 'Microsoft.Compute/virtualMachineScaleSets/extensions@2021-07-01' = if (enableMicrosoftAntiMalware) {
  parent: vmss
  name: 'MicrosoftAntiMalware'
  properties: {
    publisher: 'Microsoft.Azure.Security'
    type: 'IaaSAntimalware'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: microsoftAntiMalwareSettings
  }
  dependsOn: [
    vmss_DomainJoin
  ]
}

resource vmss_WindowsMMAAgent 'Microsoft.Compute/virtualMachineScaleSets/extensions@2021-07-01' = if (enableWindowsMMAAgent) {
  parent: vmss
  name: 'WindowsMMAAgent'
  properties: {
    publisher: 'Microsoft.EnterpriseCloud.Monitoring'
    type: 'MicrosoftMonitoringAgent'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
    settings: {
      workspaceId: (empty(workspaceId) ? 'dummy' : reference(workspaceId, '2015-11-01-preview').customerId)
    }
    protectedSettings: {
      workspaceKey: (empty(workspaceId) ? 'dummy' : listKeys(workspaceId, '2015-11-01-preview').primarySharedKey)
    }
  }
  dependsOn: [
    vmss_MicrosoftAntiMalware
  ]
}

resource vmss_LinuxMMAAgent 'Microsoft.Compute/virtualMachineScaleSets/extensions@2021-07-01' = if (enableLinuxMMAAgent) {
  parent: vmss
  name: 'LinuxMMAAgent'
  properties: {
    publisher: 'Microsoft.EnterpriseCloud.Monitoring'
    type: 'OmsAgentForLinux'
    typeHandlerVersion: '1.7'
    autoUpgradeMinorVersion: true
    settings: {
      workspaceId: (empty(workspaceId) ? 'dummy' : reference(workspaceId, '2015-11-01-preview').customerId)
    }
    protectedSettings: {
      workspaceKey: (empty(workspaceId) ? 'dummy' : listKeys(workspaceId, '2015-11-01-preview').primarySharedKey)
    }
  }
  dependsOn: [
    vmss_WindowsMMAAgent
  ]
}

resource vmss_WindowsDiskEncryption 'Microsoft.Compute/virtualMachineScaleSets/extensions@2021-07-01' = if (enableWindowsDiskEncryption) {
  parent: vmss
  name: 'WindowsDiskEncryption'
  properties: {
    publisher: 'Microsoft.Azure.Security'
    type: 'AzureDiskEncryption'
    typeHandlerVersion: '2.2'
    autoUpgradeMinorVersion: true
    forceUpdateTag: forceUpdateTag
    settings: {
      EncryptionOperation: 'EnableEncryption'
      KeyVaultURL: keyVaultUri
      KeyVaultResourceId: keyVaultId
      KeyEncryptionKeyURL: keyEncryptionKeyURL
      KekVaultResourceId: keyVaultId
      KeyEncryptionAlgorithm: diskKeyEncryptionAlgorithm
      VolumeType: diskEncryptionVolumeType
      ResizeOSDisk: resizeOSDisk
    }
  }
  dependsOn: [
    vmss_LinuxMMAAgent
  ]
}

resource vmss_LinuxDiskEncryption 'Microsoft.Compute/virtualMachineScaleSets/extensions@2021-07-01' = if (enableLinuxDiskEncryption) {
  parent: vmss
  name: 'LinuxDiskEncryption'
  properties: {
    publisher: 'Microsoft.Azure.Security'
    type: 'AzureDiskEncryptionForLinux'
    typeHandlerVersion: '1.1'
    autoUpgradeMinorVersion: true
    forceUpdateTag: forceUpdateTag
    settings: {
      EncryptionOperation: 'EnableEncryption'
      KeyVaultURL: keyVaultUri
      KeyVaultResourceId: keyVaultId
      KeyEncryptionKeyURL: keyEncryptionKeyURL
      KekVaultResourceId: keyVaultId
      KeyEncryptionAlgorithm: diskKeyEncryptionAlgorithm
      VolumeType: diskEncryptionVolumeType
    }
  }
  dependsOn: [
    vmss_WindowsDiskEncryption
  ]
}

resource vmss_DependencyAgentWindows 'Microsoft.Compute/virtualMachineScaleSets/extensions@2021-07-01' = if (enableWindowsDependencyAgent) {
  parent: vmss
  name: 'DependencyAgentWindows'
  properties: {
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: 'DependencyAgentWindows'
    typeHandlerVersion: '9.5'
    autoUpgradeMinorVersion: true
  }
  dependsOn: [
    vmss_LinuxDiskEncryption
  ]
}

resource vmss_DependencyAgentLinux 'Microsoft.Compute/virtualMachineScaleSets/extensions@2021-07-01' = if (enableLinuxDependencyAgent) {
  parent: vmss
  name: 'DependencyAgentLinux'
  properties: {
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: 'DependencyAgentLinux'
    typeHandlerVersion: '9.5'
    autoUpgradeMinorVersion: true
  }
  dependsOn: [
    vmss_DependencyAgentWindows
  ]
}

resource vmss_NetworkWatcherAgentWindows 'Microsoft.Compute/virtualMachineScaleSets/extensions@2021-07-01' = if (enableNetworkWatcherWindows) {
  parent: vmss
  name: 'NetworkWatcherAgentWindows'
  properties: {
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentWindows'
    typeHandlerVersion: '1.4'
    autoUpgradeMinorVersion: true
    settings: {}
  }
  dependsOn: [
    vmss_DependencyAgentLinux
  ]
}

resource vmss_NetworkWatcherAgentLinux 'Microsoft.Compute/virtualMachineScaleSets/extensions@2021-07-01' = if (enableNetworkWatcherLinux) {
  parent: vmss
  name: 'NetworkWatcherAgentLinux'
  properties: {
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentLinux'
    typeHandlerVersion: '1.4'
    autoUpgradeMinorVersion: true
    settings: {}
  }
  dependsOn: [
    vmss_NetworkWatcherAgentWindows
  ]
}

resource vmss_windowsDsc 'Microsoft.Compute/virtualMachineScaleSets/extensions@2021-07-01' = if (!empty(dscConfiguration)) {
  parent: vmss
  name: 'windowsDsc'
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.77'
    autoUpgradeMinorVersion: true
    settings: dscConfiguration.settings
    protectedSettings: (contains(dscConfiguration, 'protectedSettings') ? dscConfiguration.protectedSettings : json('null'))
  }
  dependsOn: [
    vmss_NetworkWatcherAgentLinux
  ]
}

resource vmss_WindowsCustomScriptExtension 'Microsoft.Compute/virtualMachineScaleSets/extensions@2021-07-01' = if ((!empty(windowsScriptExtensionFileData)) && (!empty(windowsScriptExtensionCommandToExecute))) {
  parent: vmss
  name: 'WindowsCustomScriptExtension'
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.9'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [for item in windowsScriptExtensionFileData: '${item.uri}${(contains(item, 'storageAccountId') ? '?${listAccountSas(item.storageAccountId, '2019-04-01', accountSasProperties).accountSasToken}' : '')}']
    }
    protectedSettings: {
      commandToExecute: windowsScriptExtensionCommandToExecute
      storageAccountName: ((!empty(cseStorageAccountName)) ? cseStorageAccountName : json('null'))
      storageAccountKey: ((!empty(cseStorageAccountKey)) ? cseStorageAccountKey : json('null'))
      managedIdentity: ((!empty(cseManagedIdentity)) ? cseManagedIdentity : json('null'))
    }
  }
  dependsOn: [
    vmss_windowsDsc
  ]
}

resource vmss_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${vmssName}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
  }
  scope: vmss
}

module vmss_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: vmss.name
  }
}]

output vmssResourceIds string = vmss.id
output vmssResourceGroup string = resourceGroup().name
output vmssName string = vmssName
