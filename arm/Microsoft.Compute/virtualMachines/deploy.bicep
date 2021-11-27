// Main resource
@description('Optional. The name of the virtual machine to be created. You should use a unique prefix to reduce name collisions in Active Directory. If no value is provided, a 10 character long unique string will be generated based on the Resource Group\'s name.')
param name string = take(toLower(uniqueString(resourceGroup().name)), 10)

@description('Optional. Specifies whether the computer names should be transformed. The transformation is performed on all computer names. Available transformations are \'none\' (Default), \'uppercase\' and \'lowercase\'.')
param vmComputerNamesTransformation string = 'none'

@description('Optional. Specifies the size for the VMs')
param vmSize string = 'Standard_D2s_v3'

@description('Required. OS image reference. In case of marketplace images, it\'s the combination of the publisher, offer, sku, version attributes. In case of custom images it\'s the resource ID of the custom image.')
param imageReference object

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
param adminPassword string

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
param bootDiagnosticStorageAccountUri string = '.blob.${environment().suffixes.storage}/'

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

@description('Optional. Backup policy the VMs should be using for backup. If not provided, it will use the DefaultPolicy from the backup recovery service vault.')
param backupPolicyName string = 'DefaultPolicy'

@description('Optional. Specifies if Windows VM disks should be encrypted with Server-side encryption + Customer managed Key.')
param enableServerSideEncryption bool = false

// Child resources
@description('Optional. Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine.')
param allowExtensionOperations bool = true

@description('Optional. Specifies if the Domain Join Extension should be enabled.')
param enableDomainJoinExtension bool = false

@description('Optional. The Domain Join configuration object')
@metadata({
  domainName: 'Optional. Mandatory if enableDomainJoinExtension is set to true. Specifies the FQDN the of the domain the VM will be joined to. Currently implemented for Windows VMs only. Example: "contoso.com"'
  domainJoinUser: 'Optional. Mandatory if enableDomainJoinExtension is set to true. User used for the join to the domain. Example: "username@contoso.com"'
  domainJoinOU: 'Optional. Specifies an organizational unit (OU) for the domain account. Enter the full distinguished name of the OU in quotation marks. Example: "OU=testOU; DC=domain; DC=com"'
  domainJoinRestart: 'Optional. Controls the restart of vm after executing domain join'
  domainJoinOptions: 'Optional. Set of bit flags that define the join options. Example: 3 is a combination of NETSETUP_JOIN_DOMAIN (0x00000001) & NETSETUP_ACCT_CREATE (0x00000002) i.e. will join the domain and create the account on the domain. For more information see https://msdn.microsoft.com/en-us/library/aa392154(v=vs.85).aspx'
})
param domainJoinSettings object = {}
@description('Optional. Required if domainName is specified. Password of the user specified in domainJoinUser parameter')
@secure()
param domainJoinPassword string = ''

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

@description('Optional. Specifies if Linux VM disks should be encrypted. If enabled, boot diagnostics must be enabled as well.')
param enableLinuxDiskEncryption bool = false

@description('Optional. Settings for Azure Disk Encription extension.')
@metadata({
  EncryptionOperation: 'Set to "EnableEncryption" to enable disk encryption'
  KeyVaultURL: 'Optional. URL of the Key Vault instance where the Key Encryption Key (KEK) resides'
  KeyVaultResourceId: 'Optional. Resource identifier of the Key Vault instance where the Key Encryption Key (KEK) resides'
  KeyEncryptionKeyURL: 'Optional. URL of the KeyEncryptionKey used to encrypt the volume encryption key'
  KekVaultResourceId: 'Optional. Resource identifier of the Key Vault instance where the Key Encryption Key (KEK) resides'
  KeyEncryptionAlgorithm: 'Optional. Specifies disk key encryption algorithm. Possible values: "RSA-OAEP","RSA-OAEP-256","RSA1_5"'
  VolumeType: 'Optional. Type of the volume OS or Data to perform encryption operation. Possible values: "OS","Data","All"'
  ResizeOSDisk: 'Optional. Should the OS partition be resized to occupy full OS VHD before splitting system volume'
})
param diskEncryptionSettings object = {}

@description('Optional. Pass in an unique value like a GUID everytime the operation needs to be force run')
param forceUpdateTag string = '1.0'

@description('Optional. Specifies if Desired State Configuration Extension should be enabled.')
param enableDesiredStateConfiguration bool = false

@description('Optional. The DSC configuration Settings Object')
param desiredStateConfigurationSettings object = {}

@description('Optional. The DSC configuration Protected Settings Object')
@secure()
param desiredStateConfigurationProtectedSettings object = {}

@description('Optional. Specifies if Custom Script Extension should be enabled.')
param enableCustomScriptExtension bool = false

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

var vmComputerNameTransformed = vmComputerNamesTransformation == 'uppercase' ? toUpper(name) : (vmComputerNamesTransformation == 'lowercase' ? toLower(name) : name)

var accountSasProperties = {
  signedServices: 'b'
  signedPermission: 'r'
  signedExpiry: dateTimeAdd(baseTime, sasTokenValidityLength)
  signedResourceTypes: 'o'
  signedProtocol: 'https'
}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

module virtualMachine_nic '.bicep/nested_networkInterface.bicep' = [for (nicConfiguration, index) in nicConfigurations: {
  name: '${uniqueString(deployment().name, location)}-vm-nic-${index}'
  params: {
    networkInterfaceName: '${name}${nicConfiguration.nicSuffix}'
    virtualMachineName: name
    location: location
    tags: tags
    enableIPForwarding: contains(nicConfiguration, 'enableIPForwarding') ? (!empty(nicConfiguration.enableIPForwarding) ? nicConfiguration.enableIPForwarding : false) : false
    enableAcceleratedNetworking: contains(nicConfiguration, 'enableAcceleratedNetworking') ? (!empty(nicConfiguration.enableAcceleratedNetworking) ? nicConfiguration.enableAcceleratedNetworking : false) : false
    dnsServers: contains(nicConfiguration, 'dnsServers') ? (!empty(nicConfiguration.dnsServers) ? nicConfiguration.dnsServers : []) : []
    networkSecurityGroupId: contains(nicConfiguration, 'nsgId') ? (!empty(nicConfiguration.nsgId) ? nicConfiguration.nsgId : '') : ''
    ipConfigurationArray: nicConfiguration.ipConfigurations
    lock: lock
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
    workspaceId: workspaceId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    metricsToEnable: nicMetricsToEnable
    pipMetricsToEnable: pipMetricsToEnable
    pipLogsToEnable: pipLogsToEnable
    roleAssignments: contains(nicConfiguration, 'roleAssignments') ? (!empty(nicConfiguration.roleAssignments) ? nicConfiguration.roleAssignments : []) : []
  }
}]

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: name
  location: location
  identity: {
    type: managedServiceIdentity
    userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
  }
  tags: tags
  zones: useAvailabilityZone ? array(availabilityZone) : null
  plan: !empty(plan) ? plan : null
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: imageReference
      osDisk: {
        name: '${name}-disk-os-01'
        createOption: osDisk.createOption
        diskSizeGB: osDisk.diskSizeGB
        managedDisk: {
          storageAccountType: osDisk.managedDisk.storageAccountType
        }
      }
      dataDisks: [for (dataDisk, index) in dataDisks: {
        lun: index
        name: '${name}-disk-data-${padLeft((index + 1), 2, '0')}'
        diskSizeGB: dataDisk.diskSizeGB
        createOption: dataDisk.createOption
        caching: dataDisk.caching
        managedDisk: {
          storageAccountType: dataDisk.managedDisk.storageAccountType
          diskEncryptionSet: {
            id: enableServerSideEncryption ? dataDisk.managedDisk.diskEncryptionSet.id : null
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
      customData: !empty(customData) ? base64(customData) : null
      windowsConfiguration: !empty(windowsConfiguration) ? windowsConfiguration : null
      linuxConfiguration: !empty(linuxConfiguration) ? linuxConfiguration : null
      secrets: certificatesToBeInstalled
      allowExtensionOperations: allowExtensionOperations
    }
    networkProfile: {
      networkInterfaces: [for (nicConfiguration, index) in nicConfigurations: {
        properties: {
          primary: index == 0 ? true : false
        }
        id: resourceId('Microsoft.Network/networkInterfaces', '${name}${nicConfiguration.nicSuffix}')
      }]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: !empty(bootDiagnosticStorageAccountName)
        storageUri: !empty(bootDiagnosticStorageAccountName) ? 'https://${bootDiagnosticStorageAccountName}${bootDiagnosticStorageAccountUri}' : null
      }
    }
    availabilitySet: !empty(availabilitySetName) ? json('{"id":"${resourceId('Microsoft.Compute/availabilitySets', availabilitySetName)}"}') : null
    proximityPlacementGroup: !empty(proximityPlacementGroupName) ? json('{"id":"${resourceId('Microsoft.Compute/proximityPlacementGroups', proximityPlacementGroupName)}"}') : null
    priority: vmPriority
    evictionPolicy: enableEvictionPolicy ? 'Deallocate' : null
    billingProfile: !empty(vmPriority) && !empty(maxPriceForLowPriorityVm) ? json('{"maxPrice":"${maxPriceForLowPriorityVm}"}') : null
    host: !empty(dedicatedHostId) ? json('{"id":"${dedicatedHostId}"}') : null
    licenseType: !empty(licenseType) ? licenseType : null
  }
  dependsOn: [
    virtualMachine_nic
  ]
}

module virtualMachine_domainJoinExtension './extensions/deploy.bicep' = if (enableDomainJoinExtension) {
  name: '${uniqueString(deployment().name, location)}-vm-DomainJoin'
  params: {
    virtualMachineName: virtualMachine.name
    name: 'DomainJoin'
    location: location
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: false
    settings: domainJoinSettings
    protectedSettings: {
      Password: domainJoinPassword
    }
  }
}

module virtualMachine_microsoftAntiMalwareExtension './extensions/deploy.bicep' = if (enableMicrosoftAntiMalware) {
  name: '${uniqueString(deployment().name, location)}-vm-MicrosoftAntiMalware'
  params: {
    virtualMachineName: virtualMachine.name
    name: 'MicrosoftAntiMalware'
    location: location
    publisher: 'Microsoft.Azure.Security'
    type: 'IaaSAntimalware'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: false
    settings: microsoftAntiMalwareSettings
  }
}

resource virtualMachine_logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = if (!empty(workspaceId)) {
  name: last(split(workspaceId, '/'))
  scope: resourceGroup(split(workspaceId, '/')[2], split(workspaceId, '/')[4])
}

module virtualMachine_microsoftMonitoringAgentExtension './extensions/deploy.bicep' = if (enableWindowsMMAAgent || enableLinuxMMAAgent) {
  name: '${uniqueString(deployment().name, location)}-vm-MicrosoftMonitoringAgent'
  params: {
    virtualMachineName: virtualMachine.name
    name: 'MicrosoftMonitoringAgent'
    location: location
    publisher: 'Microsoft.EnterpriseCloud.Monitoring'
    type: enableWindowsMMAAgent ? 'MicrosoftMonitoringAgent' : 'OmsAgentForLinux'
    typeHandlerVersion: enableWindowsMMAAgent ? '1.0' : '1.7'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: false
    settings: {
      workspaceId: !empty(workspaceId) ? reference(virtualMachine_logAnalyticsWorkspace.id, virtualMachine_logAnalyticsWorkspace.apiVersion).customerId : ''
    }
    protectedSettings: {
      workspaceKey: !empty(workspaceId) ? virtualMachine_logAnalyticsWorkspace.listKeys().primarySharedKey : ''
    }
  }
}

module virtualMachine_dependencyAgentExtension './extensions/deploy.bicep' = if (enableWindowsDependencyAgent || enableLinuxDependencyAgent) {
  name: '${uniqueString(deployment().name, location)}-vm-DependencyAgent'
  params: {
    virtualMachineName: virtualMachine.name
    name: 'DependencyAgent'
    location: location
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: enableWindowsDependencyAgent ? 'DependencyAgentWindows' : 'DependencyAgentLinux'
    typeHandlerVersion: '9.5'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
  }
}

module virtualMachine_networkWatcherAgentExtension './extensions/deploy.bicep' = if (enableNetworkWatcherWindows || enableNetworkWatcherLinux) {
  name: '${uniqueString(deployment().name, location)}-vm-NetworkWatcherAgent'
  params: {
    virtualMachineName: virtualMachine.name
    name: 'NetworkWatcherAgent'
    location: location
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: enableNetworkWatcherWindows ? 'NetworkWatcherAgentWindows' : 'NetworkWatcherAgentLinux'
    typeHandlerVersion: '1.4'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: false
  }
}

module virtualMachine_diskEncryptionExtension './extensions/deploy.bicep' = if (enableWindowsDiskEncryption || enableLinuxDiskEncryption) {
  name: '${uniqueString(deployment().name, location)}-vm-DiskEncryption'
  params: {
    virtualMachineName: virtualMachine.name
    name: 'DiskEncryption'
    location: location
    publisher: 'Microsoft.Azure.Security'
    type: enableWindowsDiskEncryption ? 'AzureDiskEncryption' : 'AzureDiskEncryptionForLinux'
    typeHandlerVersion: enableWindowsDiskEncryption ? '2.2' : '1.1'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: false
    forceUpdateTag: forceUpdateTag
    settings: diskEncryptionSettings
  }
}

module virtualMachine_desiredStateConfigurationExtension './extensions/deploy.bicep' = if (enableDesiredStateConfiguration) {
  name: '${uniqueString(deployment().name, location)}-vm-DesiredStateConfiguration'
  params: {
    virtualMachineName: virtualMachine.name
    name: 'DesiredStateConfiguration'
    location: location
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.77'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: false
    settings: desiredStateConfigurationSettings
    protectedSettings: desiredStateConfigurationProtectedSettings
  }
}

module virtualMachine_customScriptExtension './extensions/deploy.bicep' = if (enableCustomScriptExtension) {
  name: '${uniqueString(deployment().name, location)}-vm-CustomScriptExtension'
  params: {
    virtualMachineName: virtualMachine.name
    name: 'CustomScriptExtension'
    location: location
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.9'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
    settings: {
      fileUris: [for fileData in windowsScriptExtensionFileData: contains(fileData, 'storageAccountId') ? '${fileData.uri}?${listAccountSas(fileData.storageAccountId, '2019-04-01', accountSasProperties).accountSasToken}' : fileData.uri]
    }
    protectedSettings: {
      commandToExecute: windowsScriptExtensionCommandToExecute
      storageAccountName: !empty(cseStorageAccountName) ? cseStorageAccountName : null
      storageAccountKey: !empty(cseStorageAccountKey) ? cseStorageAccountKey : null
      managedIdentity: !empty(cseManagedIdentity) ? cseManagedIdentity : null
    }
  }
}

module virtualMachine_backup '.bicep/nested_backup.bicep' = if (!empty(backupVaultName)) {
  name: '${uniqueString(deployment().name, location)}-vm-backup'
  params: {
    backupResourceName: '${backupVaultName}/Azure/iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${virtualMachine.name}/vm;iaasvmcontainerv2;${resourceGroup().name};${virtualMachine.name}'
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    backupPolicyId: resourceId('Microsoft.RecoveryServices/vaults/backupPolicies', backupVaultName, backupPolicyName)
    sourceResourceId: virtualMachine.id
  }
  scope: resourceGroup(backupVaultResourceGroup)
  dependsOn: [
    virtualMachine_domainJoinExtension
    virtualMachine_microsoftMonitoringAgentExtension
    virtualMachine_microsoftAntiMalwareExtension
    virtualMachine_networkWatcherAgentExtension
    virtualMachine_dependencyAgentExtension
    virtualMachine_dependencyAgentExtension
    virtualMachine_desiredStateConfigurationExtension
    virtualMachine_customScriptExtension
  ]
}

resource virtualMachine_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${virtualMachine.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: virtualMachine
}

module virtualMachine_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-vm-rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: virtualMachine.id
  }
}]

@description('The name of the VM.')
output virtualMachineName string = virtualMachine.name

@description('The Resource Id of the VM.')
output virtualMachineResourceId string = virtualMachine.id

@description('The name of the Resource Group the VM was created in.')
output virtualMachineResourceGroup string = resourceGroup().name
