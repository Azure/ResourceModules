@description('Required. Name of the VMSS.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your virtual machine scale sets.')
param encryptionAtHost bool = true

@description('Optional. Specifies the SecurityType of the virtual machine scale set. It is set as TrustedLaunch to enable UefiSettings.')
param securityType string = ''

@description('Optional. Specifies whether secure boot should be enabled on the virtual machine scale set. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings.')
param secureBootEnabled bool = false

@description('Optional. Specifies whether vTPM should be enabled on the virtual machine scale set. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings.')
param vTpmEnabled bool = false

@description('Required. OS image reference. In case of marketplace images, it\'s the combination of the publisher, offer, sku, version attributes. In case of custom images it\'s the resource ID of the custom image.')
param imageReference object

@description('Optional. Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.')
param plan object = {}

@description('Required. Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.')
param osDisk object

@description('Optional. Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.')
param dataDisks array = []

@description('Optional. The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled.')
param ultraSSDEnabled bool = false

@description('Required. Administrator username')
@secure()
param adminUsername string

@description('Optional. When specifying a Windows Virtual Machine, this value should be passed')
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

@description('Optional. Specifies if Windows VM disks should be encrypted with Server-side encryption + Customer managed Key.')
param enableServerSideEncryption bool = false

@description('Optional. Required if domainName is specified. Password of the user specified in domainJoinUser parameter')
@secure()
param extensionDomainJoinPassword string = ''

@description('Optional. The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed')
param extensionDomainJoinConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed')
param extensionAntiMalwareConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed')
param extensionMonitoringAgentConfig object = {
  enabled: false
}

@description('Optional. Resource ID of the monitoring log analytics workspace.')
param monitoringWorkspaceId string = ''

@description('Optional. The configuration for the [Dependency Agent] extension. Must at least contain the ["enabled": true] property to be executed')
param extensionDependencyAgentConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Network Watcher Agent] extension. Must at least contain the ["enabled": true] property to be executed')
param extensionNetworkWatcherAgentConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Disk Encryption] extension. Must at least contain the ["enabled": true] property to be executed')
param extensionDiskEncryptionConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed')
param extensionDSCConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Custom Script] extension. Must at least contain the ["enabled": true] property to be executed')
param extensionCustomScriptConfig object = {
  enabled: false
  fileData: []
}

@description('Optional. Storage account boot diagnostic base URI.')
param bootDiagnosticStorageAccountUri string = '.blob.${environment().suffixes.storage}/'

@description('Optional. Storage account used to store boot diagnostic information. Boot diagnostics will be disabled if no value is provided.')
param bootDiagnosticStorageAccountName string = ''

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

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

@description('Optional. Specifies the time zone of the virtual machine. e.g. \'Pacific Standard Time\'. Possible values can be TimeZoneInfo.id value from time zones returned by TimeZoneInfo.GetSystemTimeZones.')
param timeZone string = ''

@description('Optional. Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. - AdditionalUnattendContent object')
param additionalUnattendContent array = []

@description('Optional. Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object.')
param winRM object = {}

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

@description('Required. The SKU size of the VMs.')
param skuName string

@description('Optional. The initial instance count of scale set VMs.')
param skuCapacity int = 1

@description('Optional. The virtual machine scale set zones. NOTE: Availability zones can only be set when you create the scale set.')
param availabilityZones array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Required. The chosen OS type')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@description('Generated. Do not provide a value! This date value is used to generate a registration token.')
param baseTime string = utcNow('u')

@description('Optional. SAS token validity length to use to download files from storage accounts. Usage: \'PT8H\' - valid for 8 hours; \'P5D\' - valid for 5 days; \'P1Y\' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours.')
param sasTokenValidityLength string = 'PT8H'

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

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
  timeZone: empty(timeZone) ? null : timeZone
  additionalUnattendContent: empty(additionalUnattendContent) ? null : additionalUnattendContent
  winRM: !empty(winRM) ? {
    listeners: winRM
  } : null
}

var accountSasProperties = {
  signedServices: 'b'
  signedPermission: 'r'
  signedExpiry: dateTimeAdd(baseTime, sasTokenValidityLength)
  signedResourceTypes: 'o'
  signedProtocol: 'https'
}

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource proximityPlacementGroup 'Microsoft.Compute/proximityPlacementGroups@2021-04-01' = if (!empty(proximityPlacementGroupName)) {
  name: !empty(proximityPlacementGroupName) ? proximityPlacementGroupName : 'dummyProximityGroup'
  location: location
  tags: tags
  properties: {
    proximityPlacementGroupType: proximityPlacementGroupType
  }
}

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2021-04-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  zones: availabilityZones
  properties: {
    proximityPlacementGroup: !empty(proximityPlacementGroupName) ? {
      id: az.resourceId('Microsoft.Compute/proximityPlacementGroups', proximityPlacementGroup.name)
    } : null
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
        adminPassword: !empty(adminPassword) ? adminPassword : null
        customData: !empty(customData) ? base64(customData) : null
        windowsConfiguration: osType == 'Windows' ? windowsConfiguration : null
        linuxConfiguration: osType == 'Linux' ? linuxConfiguration : null
        secrets: secrets
      }
      securityProfile: {
        encryptionAtHost: encryptionAtHost
        securityType: securityType
        uefiSettings: securityType == 'TrustedLaunch' ? {
          secureBootEnabled: secureBootEnabled
          vTpmEnabled: vTpmEnabled
        } : null
      
      }
      storageProfile: {
        imageReference: imageReference
        osDisk: {
          createOption: osDisk.createOption
          diskSizeGB: osDisk.diskSizeGB
          caching: contains(osDisk, 'caching') ? osDisk.caching : null
          writeAcceleratorEnabled: contains(osDisk, 'writeAcceleratorEnabled') ? osDisk.writeAcceleratorEnabled : null
          diffDiskSettings: contains(osDisk, 'diffDiskSettings') ? osDisk.diffDiskSettings : null
          osType: contains(osDisk, 'osType') ? osDisk.osType : null
          image: contains(osDisk, 'image') ? osDisk.image : null
          vhdContainers: contains(osDisk, 'vhdContainers') ? osDisk.vhdContainers : null
          managedDisk: {
            storageAccountType: osDisk.managedDisk.storageAccountType
            diskEncryptionSet: contains(osDisk.managedDisk, 'diskEncryptionSet') ? osDisk.managedDisk.diskEncryptionSet : null
          }
        }
        dataDisks: [for (item, j) in dataDisks: {
          lun: j
          diskSizeGB: item.diskSizeGB
          createOption: item.createOption
          caching: item.caching
          writeAcceleratorEnabled: contains(osDisk, 'writeAcceleratorEnabled') ? osDisk.writeAcceleratorEnabled : null
          managedDisk: {
            storageAccountType: item.managedDisk.storageAccountType
            diskEncryptionSet: {
              id: enableServerSideEncryption ? item.managedDisk.diskEncryptionSet.id : null
            }
          }
          diskIOPSReadWrite: contains(osDisk, 'diskIOPSReadWrite') ? item.diskIOPSReadWrite : null
          diskMBpsReadWrite: contains(osDisk, 'diskMBpsReadWrite') ? item.diskMBpsReadWrite : null
        }]
      }
      networkProfile: {
        networkInterfaceConfigurations: [for (nicConfiguration, index) in nicConfigurations: {
          name: '${name}${nicConfiguration.nicSuffix}configuration-${index}'
          properties: {
            primary: (index == 0) ? true : any(null)
            enableAcceleratedNetworking: contains(nicConfigurations, 'enableAcceleratedNetworking') ? nicConfiguration.enableAcceleratedNetworking : null
            networkSecurityGroup: contains(nicConfigurations, 'nsgId') ? {
              id: nicConfiguration.nsgId
            } : null
            ipConfigurations: nicConfiguration.ipConfigurations
          }
        }]
      }
      diagnosticsProfile: {
        bootDiagnostics: {
          enabled: !empty(bootDiagnosticStorageAccountName)
          storageUri: !empty(bootDiagnosticStorageAccountName) ? 'https://${bootDiagnosticStorageAccountName}${bootDiagnosticStorageAccountUri}' : null
        }
      }
      licenseType: empty(licenseType) ? null : licenseType
      priority: vmPriority
      evictionPolicy: enableEvictionPolicy ? 'Deallocate' : null
      billingProfile: !empty(vmPriority) && !empty(maxPriceForLowPriorityVm) ? json('{"maxPrice":"${maxPriceForLowPriorityVm}"}') : null
      scheduledEventsProfile: scheduledEventsProfile
    }
    overprovision: overprovision
    doNotRunExtensionsOnOverprovisionedVMs: doNotRunExtensionsOnOverprovisionedVMs
    zoneBalance: zoneBalance == 'true' ? zoneBalance : null
    platformFaultDomainCount: scaleSetFaultDomain
    singlePlacementGroup: singlePlacementGroup
    additionalCapabilities: {
      ultraSSDEnabled: ultraSSDEnabled
    }
    scaleInPolicy: scaleInPolicy
  }
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  plan: !empty(plan) ? plan : null
}

module vmss_domainJoinExtension 'extensions/deploy.bicep' = if (extensionDomainJoinConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-DomainJoin'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'DomainJoin'
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: contains(extensionDomainJoinConfig, 'typeHandlerVersion') ? extensionDomainJoinConfig.typeHandlerVersion : '1.3'
    autoUpgradeMinorVersion: contains(extensionDomainJoinConfig, 'autoUpgradeMinorVersion') ? extensionDomainJoinConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionDomainJoinConfig, 'enableAutomaticUpgrade') ? extensionDomainJoinConfig.enableAutomaticUpgrade : false
    settings: extensionDomainJoinConfig.settings
    protectedSettings: {
      Password: extensionDomainJoinPassword
    }
  }
}

module vmss_microsoftAntiMalwareExtension 'extensions/deploy.bicep' = if (extensionAntiMalwareConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-MicrosoftAntiMalware'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'MicrosoftAntiMalware'
    publisher: 'Microsoft.Azure.Security'
    type: 'IaaSAntimalware'
    typeHandlerVersion: contains(extensionAntiMalwareConfig, 'typeHandlerVersion') ? extensionAntiMalwareConfig.typeHandlerVersion : '1.3'
    autoUpgradeMinorVersion: contains(extensionAntiMalwareConfig, 'autoUpgradeMinorVersion') ? extensionAntiMalwareConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionAntiMalwareConfig, 'enableAutomaticUpgrade') ? extensionAntiMalwareConfig.enableAutomaticUpgrade : false
    settings: extensionAntiMalwareConfig.settings
  }
}

resource vmss_logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = if (!empty(monitoringWorkspaceId)) {
  name: last(split(monitoringWorkspaceId, '/'))
  scope: resourceGroup(split(monitoringWorkspaceId, '/')[2], split(monitoringWorkspaceId, '/')[4])
}

module vmss_microsoftMonitoringAgentExtension 'extensions/deploy.bicep' = if (extensionMonitoringAgentConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-MicrosoftMonitoringAgent'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'MicrosoftMonitoringAgent'
    publisher: 'Microsoft.EnterpriseCloud.Monitoring'
    type: osType == 'Windows' ? 'MicrosoftMonitoringAgent' : 'OmsAgentForLinux'
    typeHandlerVersion: contains(extensionMonitoringAgentConfig, 'typeHandlerVersion') ? extensionMonitoringAgentConfig.typeHandlerVersion : (osType == 'Windows' ? '1.0' : '1.7')
    autoUpgradeMinorVersion: contains(extensionMonitoringAgentConfig, 'autoUpgradeMinorVersion') ? extensionMonitoringAgentConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionMonitoringAgentConfig, 'enableAutomaticUpgrade') ? extensionMonitoringAgentConfig.enableAutomaticUpgrade : false
    settings: {
      workspaceId: !empty(monitoringWorkspaceId) ? reference(vmss_logAnalyticsWorkspace.id, vmss_logAnalyticsWorkspace.apiVersion).customerId : ''
    }
    protectedSettings: {
      workspaceKey: !empty(monitoringWorkspaceId) ? vmss_logAnalyticsWorkspace.listKeys().primarySharedKey : ''
    }
  }
}

module vmss_dependencyAgentExtension 'extensions/deploy.bicep' = if (extensionDependencyAgentConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-DependencyAgent'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'DependencyAgent'
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: osType == 'Windows' ? 'DependencyAgentWindows' : 'DependencyAgentLinux'
    typeHandlerVersion: contains(extensionDependencyAgentConfig, 'typeHandlerVersion') ? extensionDependencyAgentConfig.typeHandlerVersion : '9.5'
    autoUpgradeMinorVersion: contains(extensionDependencyAgentConfig, 'autoUpgradeMinorVersion') ? extensionDependencyAgentConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionDependencyAgentConfig, 'enableAutomaticUpgrade') ? extensionDependencyAgentConfig.enableAutomaticUpgrade : true
  }
}

module vmss_networkWatcherAgentExtension 'extensions/deploy.bicep' = if (extensionNetworkWatcherAgentConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-NetworkWatcherAgent'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'NetworkWatcherAgent'
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: osType == 'Windows' ? 'NetworkWatcherAgentWindows' : 'NetworkWatcherAgentLinux'
    typeHandlerVersion: contains(extensionNetworkWatcherAgentConfig, 'typeHandlerVersion') ? extensionNetworkWatcherAgentConfig.typeHandlerVersion : '1.4'
    autoUpgradeMinorVersion: contains(extensionNetworkWatcherAgentConfig, 'autoUpgradeMinorVersion') ? extensionNetworkWatcherAgentConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionNetworkWatcherAgentConfig, 'enableAutomaticUpgrade') ? extensionNetworkWatcherAgentConfig.enableAutomaticUpgrade : false
  }
}

module vmss_desiredStateConfigurationExtension 'extensions/deploy.bicep' = if (extensionDSCConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-DesiredStateConfiguration'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'DesiredStateConfiguration'
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: contains(extensionDSCConfig, 'typeHandlerVersion') ? extensionDSCConfig.typeHandlerVersion : '2.77'
    autoUpgradeMinorVersion: contains(extensionDSCConfig, 'autoUpgradeMinorVersion') ? extensionDSCConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionDSCConfig, 'enableAutomaticUpgrade') ? extensionDSCConfig.enableAutomaticUpgrade : false
    settings: contains(extensionDSCConfig, 'settings') ? extensionDSCConfig.settings : {}
    protectedSettings: contains(extensionDSCConfig, 'protectedSettings') ? extensionDSCConfig.protectedSettings : {}
  }
}

module vmss_customScriptExtension 'extensions/deploy.bicep' = if (extensionCustomScriptConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-CustomScriptExtension'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'CustomScriptExtension'
    publisher: osType == 'Windows' ? 'Microsoft.Compute' : 'Microsoft.Azure.Extensions'
    type: osType == 'Windows' ? 'CustomScriptExtension' : 'CustomScript'
    typeHandlerVersion: contains(extensionCustomScriptConfig, 'typeHandlerVersion') ? extensionCustomScriptConfig.typeHandlerVersion : (osType == 'Windows' ? '1.10' : '2.1')
    autoUpgradeMinorVersion: contains(extensionCustomScriptConfig, 'autoUpgradeMinorVersion') ? extensionCustomScriptConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionCustomScriptConfig, 'enableAutomaticUpgrade') ? extensionCustomScriptConfig.enableAutomaticUpgrade : false
    settings: {
      fileUris: [for fileData in extensionCustomScriptConfig.fileData: contains(fileData, 'storageAccountId') ? '${fileData.uri}?${listAccountSas(fileData.storageAccountId, '2019-04-01', accountSasProperties).accountSasToken}' : fileData.uri]
    }
    protectedSettings: contains(extensionCustomScriptConfig, 'protectedSettings') ? extensionCustomScriptConfig.protectedSettings : {}
  }
  dependsOn: [
    vmss_desiredStateConfigurationExtension
  ]
}

module vmss_diskEncryptionExtension 'extensions/deploy.bicep' = if (extensionDiskEncryptionConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-DiskEncryption'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'DiskEncryption'
    publisher: 'Microsoft.Azure.Security'
    type: osType == 'Windows' ? 'AzureDiskEncryption' : 'AzureDiskEncryptionForLinux'
    typeHandlerVersion: contains(extensionDiskEncryptionConfig, 'typeHandlerVersion') ? extensionDiskEncryptionConfig.typeHandlerVersion : (osType == 'Windows' ? '2.2' : '1.1')
    autoUpgradeMinorVersion: contains(extensionDiskEncryptionConfig, 'autoUpgradeMinorVersion') ? extensionDiskEncryptionConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionDiskEncryptionConfig, 'enableAutomaticUpgrade') ? extensionDiskEncryptionConfig.enableAutomaticUpgrade : false
    forceUpdateTag: contains(extensionDiskEncryptionConfig, 'forceUpdateTag') ? extensionDiskEncryptionConfig.forceUpdateTag : '1.0'
    settings: extensionDiskEncryptionConfig.settings
  }
  dependsOn: [
    vmss_customScriptExtension
    vmss_microsoftMonitoringAgentExtension
  ]
}

resource vmss_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${vmss.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: vmss
}

resource vmss_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: '${vmss.name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
  }
  scope: vmss
}

module vmss_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-VMSS-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: vmss.id
  }
}]

@description('The resource ID of the virtual machine scale set')
output resourceId string = vmss.id

@description('The resource group of the virtual machine scale set')
output resourceGroupName string = resourceGroup().name

@description('The name of the virtual machine scale set')
output name string = vmss.name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(vmss.identity, 'principalId') ? vmss.identity.principalId : ''
