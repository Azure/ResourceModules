@description('Required. The name of the lab.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The properties of any lab announcement associated with this lab.')
param announcement object = {}

@allowed([
  'Contributor'
  'Reader'
])
@description('Optional. The access rights to be granted to the user when provisioning an environment. Default is "Reader".')
param environmentPermission string = 'Reader'

@description('Optional. Extended properties of the lab used for experimental features.')
param extendedProperties object = {}

@allowed([
  'Standard'
  'StandardSSD'
  'Premium'
])
@description('Optional. Type of storage used by the lab. It can be either Premium or Standard. Default is Premium.')
param labStorageType string = 'Premium'

@description('Optional. The resource ID of the storage account used to store artifacts and images by the lab. Also used for defaultStorageAccount, defaultPremiumStorageAccount and premiumDataDiskStorageAccount properties. If left empty, a default storage account will be created by the lab and used.')
param artifactsStorageAccount string = ''

@description('Optional. The ordered list of artifact resource IDs that should be applied on all Linux VM creations by default, prior to the artifacts specified by the user.')
param mandatoryArtifactsResourceIdsLinux array = []

@description('Optional. The ordered list of artifact resource IDs that should be applied on all Windows VM creations by default, prior to the artifacts specified by the user.')
param mandatoryArtifactsResourceIdsWindows array = []

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. The setting to enable usage of premium data disks. When its value is "Enabled", creation of standard or premium data disks is allowed. When its value is "Disabled", only creation of standard data disks is allowed. Default is "Disabled".')
param premiumDataDisks string = 'Disabled'

@description('Optional. The properties of any lab support message associated with this lab.')
param support object = {}

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. The ID(s) to assign to the virtual machines associated with this lab.')
param managementIdentities object = {}

@description('Optional. Resource Group allocation for virtual machines. If left empty, virtual machines will be deployed in their own Resource Groups. Default is the same Resource Group for DevTest Lab.')
param vmCreationResourceGroupId string = resourceGroup().id

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Enable browser connect on virtual machines if the lab\'s VNETs have configured Azure Bastion. Default is "Disabled".')
param browserConnect string = 'Disabled'

@description('Optional. Disable auto upgrade custom script extension minor version. Default is false.')
param disableAutoUpgradeCseMinorVersion bool = false

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Enable lab resources isolation from the public internet. Default is "Enabled".')
param isolateLabResources string = 'Enabled'

@allowed([
  'EncryptionAtRestWithPlatformKey'
  'EncryptionAtRestWithCustomerKey'
])
@description('Optional. Specify how OS and data disks created as part of the lab are encrypted. Default is "EncryptionAtRestWithPlatformKey".')
param encryptionType string = 'EncryptionAtRestWithPlatformKey'

@description('Conditional. The Disk Encryption Set Resource ID used to encrypt OS and data disks created as part of the the lab. Required if encryptionType is set to "EncryptionAtRestWithCustomerKey".')
param encryptionDiskEncryptionSetId string = ''

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Virtual networks to create for the lab.')
param virtualNetworks array = []

@description('Optional. Policies to create for the lab.')
param policies array = []

@description('Optional. Schedules to create for the lab.')
param schedules array = []

var enableReferencedModulesTelemetry = false

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource lab 'Microsoft.DevTestLab/labs@2018-10-15-preview' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    artifactsStorageAccount: artifactsStorageAccount
    announcement: announcement
    environmentPermission: environmentPermission
    extendedProperties: extendedProperties
    labStorageType: labStorageType
    mandatoryArtifactsResourceIdsLinux: mandatoryArtifactsResourceIdsLinux
    mandatoryArtifactsResourceIdsWindows: mandatoryArtifactsResourceIdsWindows
    premiumDataDisks: premiumDataDisks
    support: support
    managementIdentities: managementIdentities
    vmCreationResourceGroupId: vmCreationResourceGroupId
    browserConnect: browserConnect
    disableAutoUpgradeCseMinorVersion: disableAutoUpgradeCseMinorVersion
    isolateLabResources: isolateLabResources
    encryption: {
      type: encryptionType
      diskEncryptionSetId: !empty(encryptionDiskEncryptionSetId) ? encryptionDiskEncryptionSetId : null
    }
  }
}

module lab_virtualNetworks 'virtualNetworks/deploy.bicep' = [for (virtualNetwork, index) in virtualNetworks: {
  name: '${uniqueString(deployment().name, location)}-Lab-VirtualNetwork-${index}'
  params: {
    labName: lab.name
    name: virtualNetwork.name
    externalProviderResourceId: virtualNetwork.externalProviderResourceId
    location: location
    tags: tags
    description: contains(virtualNetwork, 'description') ? virtualNetwork.description : ''
    allowedSubnets: contains(virtualNetwork, 'allowedSubnets') ? virtualNetwork.allowedSubnets : []
    subnetOverrides: contains(virtualNetwork, 'subnetOverrides') ? virtualNetwork.subnetOverrides : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module lab_policies 'policySets/policies/deploy.bicep' = [for (policy, index) in policies: {
  name: '${uniqueString(deployment().name, location)}-Lab-PolicySets-Policy-${index}'
  params: {
    labName: lab.name
    name: policy.name
    location: location
    tags: tags
    description: contains(policy, 'description') ? policy.description : ''
    evaluatorType: policy.evaluatorType
    factData: contains(policy, 'factData') ? policy.factData : ''
    factName: policy.factName
    status: contains(policy, 'status') ? policy.status : 'Enabled'
    threshold: policy.threshold
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module lab_schedules 'schedules/deploy.bicep' = [for (schedule, index) in schedules: {
  name: '${uniqueString(deployment().name, location)}-Lab-Schedules-${index}'
  params: {
    labName: lab.name
    name: schedule.name
    location: location
    tags: tags
    taskType: schedule.taskType
    dailyRecurrence: contains(schedule, 'dailyRecurrence') ? schedule.dailyRecurrence : {}
    hourlyRecurrence: contains(schedule, 'hourlyRecurrence') ? schedule.hourlyRecurrence : {}
    weeklyRecurrence: contains(schedule, 'weeklyRecurrence') ? schedule.weeklyRecurrence : {}
    status: contains(schedule, 'status') ? schedule.status : 'Enabled'
    targetResourceId: contains(schedule, 'targetResourceId') ? schedule.targetResourceId : ''
    timeZoneId: contains(schedule, 'timeZoneId') ? schedule.timeZoneId : 'Pacific Standard time'
    notificationSettingsStatus: contains(schedule, 'notificationSettingsStatus') ? schedule.notificationSettingsStatus : 'Disabled'
    notificationSettingsEmailRecipient: contains(schedule, 'notificationSettingsEmailRecipient') ? schedule.notificationSettingsEmailRecipient : ''
    notificationSettingsWebhookUrl: contains(schedule, 'notificationSettingsWebhookUrl') ? schedule.notificationSettingsWebhookUrl : ''
    notificationSettingsNotificationLocale: contains(schedule, 'notificationSettingsNotificationLocale') ? schedule.notificationSettingsNotificationLocale : 'en'
    notificationSettingsTimeInMinutes: contains(schedule, 'notificationSettingsTimeInMinutes') ? schedule.notificationSettingsTimeInMinutes : 30
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@description('The resource group the lab was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the lab.')
output resourceId string = lab.id

@description('The name of the lab.')
output name string = lab.name

@description('The location the resource was deployed into.')
output location string = lab.location
