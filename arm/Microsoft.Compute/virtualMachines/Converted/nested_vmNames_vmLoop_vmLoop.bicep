? /* TODO: User defined functions are not supported and have not been decompiled */
param location string
param tags object
param vmName string
param vmLoopIndex int
param vmComputerNames object
param vmComputerNamesTransformation string
param useAvailabilityZone bool
param availabilityZone string
param plan object
param nicConfigurations array
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
param avSetNames array
param maxNumberOfVmsPerAvSet int
param maxNumberOfVmsPerDeployment int
param bulkVMdeploymentLoopIndex int
param proximityPlacementGroupName string
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

var vmComputerName = (contains(vmComputerNames, vmName) ? vmComputerNames[vmName] : vmName)
var vmComputerNameTransformed = ((vmComputerNamesTransformation == 'uppercase') ? toUpper(vmComputerName) : ((vmComputerNamesTransformation == 'lowercase') ? toLower(vmComputerName) : vmComputerName))
var availabilitySetName = ((!empty(avSetNames)) ? avSetNames[((vmLoopIndex + (maxNumberOfVmsPerDeployment * bulkVMdeploymentLoopIndex)) / maxNumberOfVmsPerAvSet)] : '')
var nicName = ((length(nicConfigurations) == 1) ? concat(vmName, nicConfigurations[0].nicSuffix) : json('[]'))
var dnsServersValues = {
  dnsServers: ((length(nicConfigurations) == 1) ? (contains(nicConfigurations[0], 'dnsServers') ? nicConfigurations[0].dnsServers : json('[]')) : json('[]'))
}

module nicConfigurations_1_vmName_nicConfigurations_0_nicSuffix_nicConfigurations_0_ipConfigurations_vmNicPipConfigLoop_name_vmNicPipConfigLoop_dummyVmNicPipConfigLoop './nested_nicConfigurations_1_vmName_nicConfigurations_0_nicSuffix_nicConfigurations_0_ipConfigurations_vmNicPipConfigLoop_name_vmNicPipConfigLoop_dummyVmNicPipConfigLoop.bicep' = [for i in range(0, ((length(nicConfigurations) == 1) ? length(nicConfigurations[0].ipConfigurations) : 0)): {
  name: ((length(nicConfigurations) == 1) ? '${vmName}${nicConfigurations[0].nicSuffix}-${nicConfigurations[0].ipConfigurations[i].name}-vmNicPipConfigLoop' : 'dummyVmNicPipConfigLoop')
  params: {
    location: location
    tags: tags
    vmName: vmName
    ipConfiguration: nicConfigurations[0].ipConfigurations[i]
    lockForDeletion: lockForDeletion
    diagnosticSettingName: diagnosticSettingName
    diagnosticStorageAccountId: diagnosticStorageAccountId
    workspaceId: workspaceId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    diagnosticsMetrics: diagnosticsMetrics
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
  }
  dependsOn: []
}]

resource nicConfigurations_1_nicName_dummyVmNic 'Microsoft.Network/networkInterfaces@2020-08-01' = if ((length(nicConfigurations) == 1) && (!empty(nicConfigurations[0].ipConfigurations))) {
  location: location
  tags: tags
  name: ((length(nicConfigurations) == 1) ? nicName : 'dummyVmNic')
  properties: {
    enableIPForwarding: (contains(nicConfigurations[0], 'enableIPForwarding') ? nicConfigurations[0].enableIPForwarding : 'false')
    enableAcceleratedNetworking: (contains(nicConfigurations[0], 'enableAcceleratedNetworking') ? nicConfigurations[0].enableAcceleratedNetworking : 'false')
    dnsSettings: (contains(nicConfigurations[0], 'dnsServers') ? (empty(nicConfigurations[0].dnsServers) ? json('null') : dnsServersValues) : json('null'))
    ipConfigurations: [for j in range(0, (contains(nicConfigurations[0], 'ipConfigurations') ? length(nicConfigurations[0].ipConfigurations) : 0)): {
      name: (contains(nicConfigurations[0].ipConfigurations[j], 'name') ? nicConfigurations[0].ipConfigurations[j].name : 'ipconfig${(j + 1)}')
      properties: {
        primary: ((j == 0) ? 'true' : 'false')
        privateIPAllocationMethod: (contains(nicConfigurations[0].ipConfigurations[j], 'vmIPAddress') ? (empty(nicConfigurations[0].ipConfigurations[j].vmIPAddress) ? 'Dynamic' : 'Static') : 'Dynamic')
        publicIPAddress: (contains(nicConfigurations[0].ipConfigurations[j], 'enablePublicIP') ? (nicConfigurations[0].ipConfigurations[j].enablePublicIP ? json('{"id":"${resourceId('Microsoft.Network/publicIPAddresses', concat(vmName, nicConfigurations[0].ipConfigurations[j].publicIpNameSuffix))}"}') : json('null')) : json('null'))
        privateIPAddress: (contains(nicConfigurations[0].ipConfigurations[j], 'vmIPAddress') ? (empty(nicConfigurations[0].ipConfigurations[j].vmIPAddress) ? json('null') : iacs.nextIP(nicConfigurations[0].ipConfigurations[j].vmIPAddress, vmLoopIndex)) : json('null'))
        subnet: {
          id: nicConfigurations[0].ipConfigurations[j].subnetId
        }
        loadBalancerBackendAddressPools: (contains(nicConfigurations[0].ipConfigurations[j], 'loadBalancerBackendAddressPools') ? nicConfigurations[0].ipConfigurations[j].loadBalancerBackendAddressPools : '')
        applicationSecurityGroups: (contains(nicConfigurations[0].ipConfigurations[j], 'applicationSecurityGroups') ? nicConfigurations[0].ipConfigurations[j].applicationSecurityGroups : '')
      }
    }]
  }
  dependsOn: [
    nicConfigurations_1_vmName_nicConfigurations_0_nicSuffix_nicConfigurations_0_ipConfigurations_vmNicPipConfigLoop_name_vmNicPipConfigLoop_dummyVmNicPipConfigLoop
  ]
}

resource nicConfigurations_1_nicName_dummyVmNic_Microsoft_Authorization_networkInterfaceDoNotDelete 'Microsoft.Network/networkInterfaces/providers/locks@2016-09-01' = if ((length(nicConfigurations) == 1) && (!empty(nicConfigurations[0].ipConfigurations))) {
  name: '${((length(nicConfigurations) == 1) ? nicName : 'dummyVmNic')}/Microsoft.Authorization/networkInterfaceDoNotDelete'
  properties: {
    level: 'CannotDelete'
  }
  dependsOn: [
    nicConfigurations_1_nicName_dummyVmNic
  ]
}

resource nicConfigurations_1_nicName_dummyVmNic_Microsoft_Insights_diagnosticSettingName 'Microsoft.Network/networkInterfaces/providers/diagnosticSettings@2017-05-01-preview' = if ((length(nicConfigurations) == 1) && (!empty(nicConfigurations[0].ipConfigurations))) {
  location: location
  tags: tags
  name: '${((length(nicConfigurations) == 1) ? nicName : 'dummyVmNic')}/Microsoft.Insights/${diagnosticSettingName}'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
  }
  dependsOn: [
    nicConfigurations_1_nicName_dummyVmNic
  ]
}

module nicConfigurations_1_vmName_nicConfigurations_vmNicDeployInnerLoop_nicSuffix_vmNicDeployInnerLoop_dummyVmNicDeployInnerLoop './nested_nicConfigurations_1_vmName_nicConfigurations_vmNicDeployInnerLoop_nicSuffix_vmNicDeployInnerLoop_dummyVmNicDeployInnerLoop.bicep' = [for item in nicConfigurations: {
  name: ((length(nicConfigurations) > 1) ? '${vmName}${item.nicSuffix}-vmNicDeployInnerLoop' : 'dummyVmNicDeployInnerLoop')
  params: {
    location: location
    tags: tags
    vmName: vmName
    vmLoopIndex: vmLoopIndex
    nicConfiguration: item
    lockForDeletion: lockForDeletion
    diagnosticSettingName: diagnosticSettingName
    diagnosticStorageAccountId: diagnosticStorageAccountId
    workspaceId: workspaceId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
    diagnosticsMetrics: diagnosticsMetrics
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
  }
  dependsOn: []
}]

resource vmName_resource 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: vmName
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
        name: '${vmName}-disk-os-01'
        createOption: osDisk.createOption
        diskSizeGB: osDisk.diskSizeGB
        managedDisk: {
          storageAccountType: osDisk.managedDisk.storageAccountType
        }
      }
      dataDisks: [for (item, j) in dataDisks: {
        lun: j
        name: '${vmName}-disk-data-${padLeft((j + 1), 2, '0')}'
        diskSizeGB: item.diskSizeGB
        createOption: item.createOption
        caching: item.caching
        managedDisk: {
          storageAccountType: item.managedDisk.storageAccountType
          diskEncryptionSet: {
            id: (enableServerSideEncryption ? item.managedDisk.diskEncryptionSet.id : json('null'))
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
      networkInterfaces: [for (item, j) in nicConfigurations: {
        properties: {
          primary: ((j == 0) ? 'true' : 'false')
        }
        id: resourceId('Microsoft.Network/networkInterfaces', concat(vmName, item.nicSuffix))
      }]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: (!empty(bootDiagnosticStorageAccountName))
        storageUri: (empty(bootDiagnosticStorageAccountName) ? json('null') : 'https://${bootDiagnosticStorageAccountName}${bootDiagnosticStorageAccountUri}')
      }
    }
    availabilitySet: ((!empty(availabilitySetName)) ? json('{"id":"${resourceId('Microsoft.Compute/availabilitySets', availabilitySetName)}"}') : json('null'))
    proximityPlacementGroup: (empty(proximityPlacementGroupName) ? json('null') : json('{"id":"${resourceId('Microsoft.Compute/proximityPlacementGroups', proximityPlacementGroupName)}"}'))
    priority: vmPriority
    evictionPolicy: (enableEvictionPolicy ? 'Deallocate' : json('null'))
    billingProfile: (((!empty(vmPriority)) && (!empty(maxPriceForLowPriorityVm))) ? json('{"maxPrice":"${maxPriceForLowPriorityVm}"}') : json('null'))
    host: ((!empty(dedicatedHostId)) ? json('{"id":"${dedicatedHostId}"}') : json('null'))
    licenseType: (empty(licenseType) ? json('null') : licenseType)
  }
  dependsOn: [
    ((length(nicConfigurations) > 1) ? 'vmNicDeployInnerLoop' : nicName)
  ]
}

resource vmName_Microsoft_Authorization_vmDoNotDelete 'Microsoft.Compute/virtualMachines/providers/locks@2016-09-01' = if (lockForDeletion) {
  name: '${vmName}/Microsoft.Authorization/vmDoNotDelete'
  properties: {
    level: 'CannotDelete'
  }
  dependsOn: [
    vmName_resource
  ]
}

resource vmName_DomainJoin 'Microsoft.Compute/virtualMachines/extensions@2019-07-01' = if (!empty(domainName)) {
  parent: vmName_resource
  name: 'DomainJoin'
  location: location
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

resource vmName_MicrosoftAntiMalware 'Microsoft.Compute/virtualMachines/extensions@2019-07-01' = if (enableMicrosoftAntiMalware) {
  parent: vmName_resource
  name: 'MicrosoftAntiMalware'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Security'
    type: 'IaaSAntimalware'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: microsoftAntiMalwareSettings
  }
  dependsOn: [
    vmName_DomainJoin
  ]
}

resource vmName_WindowsMMAAgent 'Microsoft.Compute/virtualMachines/extensions@2019-07-01' = if (enableWindowsMMAAgent) {
  parent: vmName_resource
  name: 'WindowsMMAAgent'
  location: location
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
    vmName_MicrosoftAntiMalware
  ]
}

resource vmName_LinuxMMAAgent 'Microsoft.Compute/virtualMachines/extensions@2019-07-01' = if (enableLinuxMMAAgent) {
  parent: vmName_resource
  name: 'LinuxMMAAgent'
  location: location
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
    vmName_WindowsMMAAgent
  ]
}

resource vmName_WindowsDiskEncryption 'Microsoft.Compute/virtualMachines/extensions@2019-07-01' = if (enableWindowsDiskEncryption) {
  parent: vmName_resource
  name: 'WindowsDiskEncryption'
  location: location
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
    vmName_LinuxMMAAgent
  ]
}

resource vmName_LinuxDiskEncryption 'Microsoft.Compute/virtualMachines/extensions@2019-07-01' = if (enableLinuxDiskEncryption) {
  parent: vmName_resource
  name: 'LinuxDiskEncryption'
  location: location
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
    vmName_WindowsDiskEncryption
  ]
}

resource vmName_DependencyAgentWindows 'Microsoft.Compute/virtualMachines/extensions@2019-07-01' = if (enableWindowsDependencyAgent) {
  parent: vmName_resource
  name: 'DependencyAgentWindows'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: 'DependencyAgentWindows'
    typeHandlerVersion: '9.5'
    autoUpgradeMinorVersion: true
  }
  dependsOn: [
    vmName_LinuxDiskEncryption
  ]
}

resource vmName_DependencyAgentLinux 'Microsoft.Compute/virtualMachines/extensions@2019-07-01' = if (enableLinuxDependencyAgent) {
  parent: vmName_resource
  name: 'DependencyAgentLinux'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: 'DependencyAgentLinux'
    typeHandlerVersion: '9.5'
    autoUpgradeMinorVersion: true
  }
  dependsOn: [
    vmName_DependencyAgentWindows
  ]
}

resource vmName_NetworkWatcherAgentWindows 'Microsoft.Compute/virtualMachines/extensions@2019-07-01' = if (enableNetworkWatcherWindows) {
  parent: vmName_resource
  name: 'NetworkWatcherAgentWindows'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentWindows'
    typeHandlerVersion: '1.4'
    autoUpgradeMinorVersion: true
    settings: {}
  }
  dependsOn: [
    vmName_DependencyAgentLinux
  ]
}

resource vmName_NetworkWatcherAgentLinux 'Microsoft.Compute/virtualMachines/extensions@2019-07-01' = if (enableNetworkWatcherLinux) {
  parent: vmName_resource
  name: 'NetworkWatcherAgentLinux'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentLinux'
    typeHandlerVersion: '1.4'
    autoUpgradeMinorVersion: true
    settings: {}
  }
  dependsOn: [
    vmName_NetworkWatcherAgentWindows
  ]
}

resource vmName_windowsDsc 'Microsoft.Compute/virtualMachines/extensions@2018-10-01' = if (!empty(dscConfiguration)) {
  parent: vmName_resource
  name: 'windowsDsc'
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.77'
    autoUpgradeMinorVersion: true
    settings: dscConfiguration.settings
    protectedSettings: (contains(dscConfiguration, 'protectedSettings') ? dscConfiguration.protectedSettings : json('null'))
  }
  dependsOn: [
    vmName_NetworkWatcherAgentLinux
  ]
}

resource vmName_WindowsCustomScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2019-07-01' = if ((!empty(windowsScriptExtensionFileData)) && (!empty(windowsScriptExtensionCommandToExecute))) {
  parent: vmName_resource
  name: 'WindowsCustomScriptExtension'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.9'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [for item in windowsScriptExtensionFileData: concat(item.uri, (contains(item, 'storageAccountId') ? '?${listAccountSas(item.storageAccountId, '2019-04-01', accountSasProperties).accountSasToken}' : ''))]
    }
    protectedSettings: {
      commandToExecute: windowsScriptExtensionCommandToExecute
      storageAccountName: ((!empty(cseStorageAccountName)) ? cseStorageAccountName : json('null'))
      storageAccountKey: ((!empty(cseStorageAccountKey)) ? cseStorageAccountKey : json('null'))
      managedIdentity: ((!empty(cseManagedIdentity)) ? cseManagedIdentity : json('null'))
    }
  }
  dependsOn: [
    vmName_windowsDsc
  ]
}

module add_vmName_ToBackup './nested_add_vmName_ToBackup.bicep' = if (!empty(backupVaultName)) {
  name: 'add-${vmName}-ToBackup'
  scope: resourceGroup(backupVaultResourceGroup)
  params: {
    resourceId_Microsoft_RecoveryServices_vaults_backupPolicies_parameters_backupVaultName_parameters_backupPolicyName: resourceId('Microsoft.RecoveryServices/vaults/backupPolicies', backupVaultName, backupPolicyName)
    resourceId_Microsoft_Compute_virtualMachines_parameters_vmName: vmName_resource.id
    backupVaultName: backupVaultName
    vmName: vmName
  }
  dependsOn: [
    vmName_WindowsCustomScriptExtension
    vmName_NetworkWatcherAgentLinux
  ]
}

module rbac_vmName_rbacDeplCopy './nested_rbac_vmName_rbacDeplCopy.bicep' = [for (item, i) in roleAssignments: {
  name: 'rbac-${vmName}-${i}'
  params: {
    roleAssignment: item
    builtInRoleNames: builtInRoleNames
    vmName: vmName
  }
  dependsOn: [
    vmName_resource
  ]
}]