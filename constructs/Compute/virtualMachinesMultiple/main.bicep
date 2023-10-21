@description('Conditional. Name(s) of the virtual machine(s). If no explicit names are provided, VM name(s) will be generated based on the vmNamePrefix, vmNumberOfInstances and vmInitialNumber parameters.')
param vmNames array = []

@description('Conditional. If no explicit values were provided in the vmNames parameter, this prefix will be used in combination with the vmNumberOfInstances and the vmInitialNumber parameters to create unique VM names. You should use a unique prefix to reduce name collisions in Active Directory. If no value is provided, a 10 character long unique string will be generated based on the Resource Group\'s name.')
param vmNamePrefix string = take(toLower(uniqueString(resourceGroup().name)), 10)

@description('Conditional. If no explicit values were provided in the vmNames parameter, this parameter will be used to generate VM names, using the vmNamePrefix and the vmNumberOfInstances values.')
param vmInitialNumber int = 1

@description('Conditional. If no explicit values were provided in the vmNames parameter, this parameter will be used to generate VM names, using the vmNamePrefix and the vmInitialNumber values.')
@minValue(1)
@maxValue(800)
param vmNumberOfInstances int = 1

@description('Optional. Specifies whether the computer names should be transformed. The transformation is performed on all computer names. Available transformations are \'none\' (Default), \'uppercase\' and \'lowercase\'.')
@allowed([
  'none'
  'uppercase'
  'lowercase'
])
param vmComputerNamesTransformation string = 'none'

@description('Required. Specifies the size for the VMs.')
param vmSize string

@description('Optional. This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.')
param encryptionAtHost bool = true

@description('Optional. Specifies the SecurityType of the virtual machine. It is set as TrustedLaunch to enable UefiSettings.')
param securityType string = ''

@description('Optional. Specifies whether secure boot should be enabled on the virtual machine. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings.')
param secureBootEnabled bool = false

@description('Optional. Specifies whether vTPM should be enabled on the virtual machine. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings.')
param vTpmEnabled bool = false

@description('Required. OS image reference. In case of marketplace images, it\'s the combination of the publisher, offer, sku, version attributes. In case of custom images it\'s the resource ID of the custom image.')
param imageReference object

@description('Optional. Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.')
param plan object = {}

@description('Required. Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object.  Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.')
param osDisk object

@description('Optional. Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.')
param dataDisks array = []

@description('Optional. The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled.')
param ultraSSDEnabled bool = false

@description('Required. Administrator username.')
@secure()
param adminUsername string

@description('Optional. When specifying a Windows Virtual Machine, this value should be passed.')
@secure()
param adminPassword string = ''

@description('Optional. Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format.')
param customData string = ''

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

@description('Optional. Specifies resource ID about the dedicated host that the virtual machine resides in.')
param dedicatedHostId string = ''

@description('Optional. Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system.')
@allowed([
  'Windows_Client'
  'Windows_Server'
  ''
])
param licenseType string = ''

@description('Optional. The list of SSH public keys used to authenticate with linux based VMs.')
param publicKeys array = []

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Storage account used to store boot diagnostic information. Boot diagnostics will be disabled if no value is provided.')
param bootDiagnosticStorageAccountName string = ''

@description('Optional. Storage account boot diagnostic base URI.')
param bootDiagnosticStorageAccountUri string = '.blob.${environment().suffixes.storage}/'

@description('Optional. Resource ID of a proximity placement group.')
param proximityPlacementGroupResourceId string = ''

@description('Optional. Resource ID of an availability set. Cannot be used in combination with availability zone nor scale set.')
param availabilitySetResourceId string = ''

@description('Optional. If set to 1, 2 or 3, the availability zone for all VMs is hardcoded to that value. If zero, then availability zones is not used. Cannot be used in combination with availability set nor scale set.')
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

@description('Optional. The name of the PIP diagnostic setting, if deployed.')
param pipDiagnosticSettingsName string = ''

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'DDoSProtectionNotifications'
  'DDoSMitigationFlowLogs'
  'DDoSMitigationReports'
])
param pipdiagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param pipdiagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the NIC diagnostic setting, if deployed.')
param nicDiagnosticSettingsName string = ''

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param nicdiagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. Recovery service vault name to add VMs to backup.')
param backupVaultName string = ''

@description('Optional. Resource group of the backup recovery service vault. If not provided the current resource group name is considered by default.')
param backupVaultResourceGroup string = resourceGroup().name

@description('Optional. Backup policy the VMs should be using for backup. If not provided, it will use the DefaultPolicy from the backup recovery service vault.')
param backupPolicyName string = 'DefaultPolicy'

// Child resources
@description('Optional. Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine.')
param allowExtensionOperations bool = true

@description('Optional. Required if domainName is specified. Password of the user specified in domainJoinUser parameter.')
@secure()
param extensionDomainJoinPassword string = ''

@description('Optional. The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionDomainJoinConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [AAD Join] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionAadJoinConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionAntiMalwareConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionMonitoringAgentConfig object = {
  enabled: false
}

@description('Optional. Resource ID of the monitoring log analytics workspace. Must be set when extensionMonitoringAgentConfig is set to true.')
param monitoringWorkspaceId string = ''

@description('Optional. The configuration for the [Dependency Agent] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionDependencyAgentConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Network Watcher Agent] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionNetworkWatcherAgentConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Disk Encryption] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionAzureDiskEncryptionConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionDSCConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Custom Script] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionCustomScriptConfig object = {
  enabled: false
  fileData: []
}

@description('Optional. Any object that contains the extension specific protected settings.')
@secure()
param extensionCustomScriptProtectedSetting object = {}

// Shared parameters
@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Generated. Do not provide a value! This date value is used to generate a registration token.')
param baseTime string = utcNow('u')

@description('Optional. SAS token validity length to use to download files from storage accounts. Usage: \'PT8H\' - valid for 8 hours; \'P5D\' - valid for 5 days; \'P1Y\' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours.')
param sasTokenValidityLength string = 'PT8H'

@description('Required. The chosen OS type.')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@description('Optional. Specifies whether password authentication should be disabled.')
param disablePasswordAuthentication bool = false

@description('Optional. Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later.')
param provisionVMAgent bool = true

@description('Optional. Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning.')
param enableAutomaticUpdates bool = true

@description('Optional. Specifies the time zone of the virtual machine. e.g. \'Pacific Standard Time\'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`.')
param timeZone string = ''

@description('Optional. Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. - AdditionalUnattendContent object.')
param additionalUnattendContent array = []

@description('Optional. Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object.')
param winRM object = {}

@description('Optional. Any VM configuration profile assignments.')
param configurationProfileAssignments string = ''

var vmGeneratedNames = [for instance in range(0, vmNumberOfInstances): '${vmNamePrefix}${padLeft((instance + vmInitialNumber), 3, '0')}']

var vmNamesToApply = !empty(vmNames) ? vmNames : vmGeneratedNames

var enableReferencedModulesTelemetry = false

module virtualMachine '../../../modules/compute/virtual-machine/main.bicep' = [for (vmName, index) in vmNamesToApply: {
  name: '${deployment().name}-vm-${index}'
  params: {
    name: vmName
    nicConfigurations: nicConfigurations
    adminUsername: adminUsername
    adminPassword: adminPassword
    osDisk: osDisk
    imageReference: imageReference
    osType: osType
    vmSize: vmSize
    additionalUnattendContent: additionalUnattendContent
    allowExtensionOperations: allowExtensionOperations
    availabilitySetResourceId: availabilitySetResourceId
    backupPolicyName: backupPolicyName
    backupVaultName: backupVaultName
    backupVaultResourceGroup: backupVaultResourceGroup
    baseTime: baseTime
    bootDiagnosticStorageAccountName: bootDiagnosticStorageAccountName
    bootDiagnosticStorageAccountUri: bootDiagnosticStorageAccountUri
    certificatesToBeInstalled: certificatesToBeInstalled
    configurationProfile: configurationProfileAssignments
    customData: customData
    dataDisks: dataDisks
    dedicatedHostId: dedicatedHostId
    diagnosticEventHubAuthorizationRuleId: diagnosticEventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticEventHubName
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticWorkspaceId: diagnosticWorkspaceId
    disablePasswordAuthentication: disablePasswordAuthentication
    enableAutomaticUpdates: enableAutomaticUpdates
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    enableEvictionPolicy: enableEvictionPolicy
    encryptionAtHost: encryptionAtHost
    extensionAntiMalwareConfig: extensionAntiMalwareConfig
    extensionCustomScriptConfig: extensionCustomScriptConfig
    extensionCustomScriptProtectedSetting: extensionCustomScriptProtectedSetting
    extensionDependencyAgentConfig: extensionDependencyAgentConfig
    extensionAzureDiskEncryptionConfig: extensionAzureDiskEncryptionConfig
    extensionAadJoinConfig: extensionAadJoinConfig
    extensionDomainJoinConfig: extensionDomainJoinConfig
    extensionDomainJoinPassword: extensionDomainJoinPassword
    extensionDSCConfig: extensionDSCConfig
    extensionMonitoringAgentConfig: extensionMonitoringAgentConfig
    extensionNetworkWatcherAgentConfig: extensionNetworkWatcherAgentConfig
    licenseType: licenseType
    location: location
    lock: lock
    maxPriceForLowPriorityVm: maxPriceForLowPriorityVm
    monitoringWorkspaceId: monitoringWorkspaceId
    nicdiagnosticMetricsToEnable: nicdiagnosticMetricsToEnable
    nicDiagnosticSettingsName: !empty(nicDiagnosticSettingsName) ? nicDiagnosticSettingsName : '${vmName}-diagnosticSettings'
    pipdiagnosticLogCategoriesToEnable: pipdiagnosticLogCategoriesToEnable
    pipdiagnosticMetricsToEnable: pipdiagnosticMetricsToEnable
    pipDiagnosticSettingsName: !empty(pipDiagnosticSettingsName) ? pipDiagnosticSettingsName : '${vmName}-diagnosticSettings'
    plan: plan
    provisionVMAgent: provisionVMAgent
    proximityPlacementGroupResourceId: proximityPlacementGroupResourceId
    publicKeys: publicKeys
    roleAssignments: roleAssignments
    sasTokenValidityLength: sasTokenValidityLength
    secureBootEnabled: secureBootEnabled
    securityType: securityType
    systemAssignedIdentity: systemAssignedIdentity
    tags: tags
    timeZone: timeZone
    ultraSSDEnabled: ultraSSDEnabled
    userAssignedIdentities: userAssignedIdentities
    priority: vmPriority
    vTpmEnabled: vTpmEnabled
    winRM: winRM
    availabilityZone: availabilityZone
  }
}]

@description('The resource ID(s) of the VM(s).')
output virtualMachinesResourceId array = [for vmIndex in range(0, length(vmNamesToApply)): virtualMachine[vmIndex].outputs.resourceId]

@description('The name of the resource group the VM(s) was/were created in.')
output virtualMachinesResourceGroup string = resourceGroup().name

@description('The names of the VMs.')
output virtualMachinesName array = [for vmIndex in range(0, length(vmNamesToApply)): virtualMachine[vmIndex].outputs.name]
