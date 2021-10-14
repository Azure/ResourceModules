param vmNames array
param nicConfigurations array
param avSetNames array
param maxNumberOfVmsPerAvSet int
param maxNumberOfVmsPerDeployment int
param bulkVMdeploymentLoopIndex int
param proximityPlacementGroupName string
param location string
param tags object
param vmComputerNames object
param vmComputerNamesTransformation string
param useAvailabilityZone bool
param availabilityZones array
param plan object
param lockForDeletion bool
param diagnosticSettingName string
param diagnosticStorageAccountId string
param workspaceId string
param eventHubAuthorizationRuleId string
param eventHubName string
param diagnosticsMetrics array
param diagnosticLogsRetentionInDays int
param vmSize string
param imageReference object
param osDisk object
param dataDisks array
param enableServerSideEncryption bool
param ultraSSDEnabled bool

@secure()
param adminUsername string

@secure()
param adminPassword string
param customData string
param windowsConfiguration object
param linuxConfiguration object
param certificatesToBeInstalled array
param allowExtensionOperations bool
param bootDiagnosticStorageAccountName string
param bootDiagnosticStorageAccountUri string
param vmPriority string
param enableEvictionPolicy bool
param dedicatedHostId string
param licenseType string
param domainName string
param domainJoinUser string
param domainJoinOU string
param domainJoinRestart bool
param domainJoinOptions int

@secure()
param domainJoinPassword string
param enableMicrosoftAntiMalware bool
param microsoftAntiMalwareSettings object
param enableWindowsMMAAgent bool
param enableLinuxMMAAgent bool
param enableWindowsDiskEncryption bool
param forceUpdateTag string
param keyVaultUri string
param keyVaultId string
param keyEncryptionKeyURL string
param diskKeyEncryptionAlgorithm string
param diskEncryptionVolumeType string
param resizeOSDisk bool
param enableLinuxDiskEncryption bool
param enableWindowsDependencyAgent bool
param enableLinuxDependencyAgent bool
param enableNetworkWatcherWindows bool
param enableNetworkWatcherLinux bool
param identity object
param dscConfiguration object
param windowsScriptExtensionFileData array

@secure()
param windowsScriptExtensionCommandToExecute string
param cseStorageAccountName string
param cseStorageAccountKey string
param cseManagedIdentity object

@secure()
param maxPriceForLowPriorityVm string
param accountSasProperties object
param roleAssignments array
param builtInRoleNames object
param backupVaultName string
param backupVaultResourceGroup string
param backupPolicyName string

module vmNames_vmLoop_vmLoop './nested_vmNames_vmLoop_vmLoop.bicep' = [for (item, i) in vmNames: {
  name: '${item}-vmLoop'
  params: {
    location: location
    tags: tags
    vmLoopIndex: i
    vmName: item
    vmComputerNames: vmComputerNames
    vmComputerNamesTransformation: vmComputerNamesTransformation
    useAvailabilityZone: useAvailabilityZone
    availabilityZone: availabilityZones[i]
    plan: plan
    nicConfigurations: nicConfigurations
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
    avSetNames: avSetNames
    maxNumberOfVmsPerAvSet: maxNumberOfVmsPerAvSet
    maxNumberOfVmsPerDeployment: maxNumberOfVmsPerDeployment
    bulkVMdeploymentLoopIndex: bulkVMdeploymentLoopIndex
    proximityPlacementGroupName: proximityPlacementGroupName
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
  dependsOn: []
}]

output deploymentOutput array = vmNames