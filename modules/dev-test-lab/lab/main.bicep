@description('Required. The name of the lab.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalIds\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The properties of any lab announcement associated with this lab.')
param announcement object = {}

@allowed([
  'Contributor'
  'Reader'
])
@description('Optional. The access rights to be granted to the user when provisioning an environment.')
param environmentPermission string = 'Reader'

@description('Optional. Extended properties of the lab used for experimental features.')
param extendedProperties object = {}

@allowed([
  'Standard'
  'StandardSSD'
  'Premium'
])
@description('Optional. Type of storage used by the lab. It can be either Premium or Standard.')
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
@description('Optional. Enable browser connect on virtual machines if the lab\'s VNETs have configured Azure Bastion.')
param browserConnect string = 'Disabled'

@description('Optional. Disable auto upgrade custom script extension minor version.')
param disableAutoUpgradeCseMinorVersion bool = false

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Enable lab resources isolation from the public internet.')
param isolateLabResources string = 'Enabled'

@allowed([
  'EncryptionAtRestWithPlatformKey'
  'EncryptionAtRestWithCustomerKey'
])
@description('Optional. Specify how OS and data disks created as part of the lab are encrypted.')
param encryptionType string = 'EncryptionAtRestWithPlatformKey'

@description('Conditional. The Disk Encryption Set Resource ID used to encrypt OS and data disks created as part of the the lab. Required if encryptionType is set to "EncryptionAtRestWithCustomerKey".')
param encryptionDiskEncryptionSetId string = ''

@description('Optional. Virtual networks to create for the lab.')
param virtualnetworks array = []

@description('Optional. Policies to create for the lab.')
param policies array = []

@description('Optional. Schedules to create for the lab.')
param schedules array = []

@description('Conditional. Notification Channels to create for the lab. Required if the schedules property "notificationSettingsStatus" is set to "Enabled.')
param notificationchannels array = []

@description('Optional. Artifact sources to create for the lab.')
param artifactsources array = []

@description('Optional. Costs to create for the lab.')
param costs object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

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
  identity: {
    type: !empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned'
    userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : any(null)
  }
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

resource lab_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${lab.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: lab
}

module lab_virtualNetworks 'virtualnetworks/main.bicep' = [for (virtualNetwork, index) in virtualnetworks: {
  name: '${uniqueString(deployment().name, location)}-Lab-VirtualNetwork-${index}'
  params: {
    labName: lab.name
    name: virtualNetwork.name
    tags: tags
    externalProviderResourceId: virtualNetwork.externalProviderResourceId
    description: contains(virtualNetwork, 'description') ? virtualNetwork.description : ''
    allowedSubnets: contains(virtualNetwork, 'allowedSubnets') ? virtualNetwork.allowedSubnets : []
    subnetOverrides: contains(virtualNetwork, 'subnetOverrides') ? virtualNetwork.subnetOverrides : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module lab_policies 'policysets/policies/main.bicep' = [for (policy, index) in policies: {
  name: '${uniqueString(deployment().name, location)}-Lab-PolicySets-Policy-${index}'
  params: {
    labName: lab.name
    name: policy.name
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

module lab_schedules 'schedules/main.bicep' = [for (schedule, index) in schedules: {
  name: '${uniqueString(deployment().name, location)}-Lab-Schedules-${index}'
  params: {
    labName: lab.name
    name: schedule.name
    tags: tags
    taskType: schedule.taskType
    dailyRecurrence: contains(schedule, 'dailyRecurrence') ? schedule.dailyRecurrence : {}
    hourlyRecurrence: contains(schedule, 'hourlyRecurrence') ? schedule.hourlyRecurrence : {}
    weeklyRecurrence: contains(schedule, 'weeklyRecurrence') ? schedule.weeklyRecurrence : {}
    status: contains(schedule, 'status') ? schedule.status : 'Enabled'
    targetResourceId: contains(schedule, 'targetResourceId') ? schedule.targetResourceId : ''
    timeZoneId: contains(schedule, 'timeZoneId') ? schedule.timeZoneId : 'Pacific Standard time'
    notificationSettingsStatus: contains(schedule, 'notificationSettingsStatus') ? schedule.notificationSettingsStatus : 'Disabled'
    notificationSettingsTimeInMinutes: contains(schedule, 'notificationSettingsTimeInMinutes') ? schedule.notificationSettingsTimeInMinutes : 30
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module lab_notificationChannels 'notificationchannels/main.bicep' = [for (notificationChannel, index) in notificationchannels: {
  name: '${uniqueString(deployment().name, location)}-Lab-NotificationChannels-${index}'
  params: {
    labName: lab.name
    name: notificationChannel.name
    tags: tags
    description: contains(notificationChannel, 'description') ? notificationChannel.description : ''
    events: notificationChannel.events
    emailRecipient: contains(notificationChannel, 'emailRecipient') ? notificationChannel.emailRecipient : ''
    webHookUrl: contains(notificationChannel, 'webhookUrl') ? notificationChannel.webhookUrl : ''
    notificationLocale: contains(notificationChannel, 'notificationLocale') ? notificationChannel.notificationLocale : 'en'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module lab_artifactSources 'artifactsources/main.bicep' = [for (artifactSource, index) in artifactsources: {
  name: '${uniqueString(deployment().name, location)}-Lab-ArtifactSources-${index}'
  params: {
    labName: lab.name
    name: artifactSource.name
    tags: tags
    displayName: contains(artifactSource, 'displayName') ? artifactSource.displayName : artifactSource.name
    branchRef: contains(artifactSource, 'branchRef') ? artifactSource.branchRef : ''
    folderPath: contains(artifactSource, 'folderPath') ? artifactSource.folderPath : ''
    armTemplateFolderPath: contains(artifactSource, 'armTemplateFolderPath') ? artifactSource.armTemplateFolderPath : ''
    sourceType: contains(artifactSource, 'sourceType') ? artifactSource.sourceType : ''
    status: contains(artifactSource, 'status') ? artifactSource.status : 'Enabled'
    uri: artifactSource.uri
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module lab_costs 'costs/main.bicep' = if (!empty(costs)) {
  name: '${uniqueString(deployment().name, location)}-Lab-Costs'
  params: {
    labName: lab.name
    tags: tags
    currencyCode: contains(costs, 'currencyCode') ? costs.currencyCode : 'USD'
    cycleType: costs.cycleType
    cycleStartDateTime: contains(costs, 'cycleStartDateTime') ? costs.cycleStartDateTime : ''
    cycleEndDateTime: contains(costs, 'cycleEndDateTime') ? costs.cycleEndDateTime : ''
    status: contains(costs, 'status') ? costs.status : 'Enabled'
    target: contains(costs, 'target') ? costs.target : 0
    thresholdValue25DisplayOnChart: contains(costs, 'thresholdValue25DisplayOnChart') ? costs.thresholdValue25DisplayOnChart : 'Disabled'
    thresholdValue25SendNotificationWhenExceeded: contains(costs, 'thresholdValue25SendNotificationWhenExceeded') ? costs.thresholdValue25SendNotificationWhenExceeded : 'Disabled'
    thresholdValue50DisplayOnChart: contains(costs, 'thresholdValue50DisplayOnChart') ? costs.thresholdValue50DisplayOnChart : 'Disabled'
    thresholdValue50SendNotificationWhenExceeded: contains(costs, 'thresholdValue50SendNotificationWhenExceeded') ? costs.thresholdValue50SendNotificationWhenExceeded : 'Disabled'
    thresholdValue75DisplayOnChart: contains(costs, 'thresholdValue75DisplayOnChart') ? costs.thresholdValue75DisplayOnChart : 'Disabled'
    thresholdValue75SendNotificationWhenExceeded: contains(costs, 'thresholdValue75SendNotificationWhenExceeded') ? costs.thresholdValue75SendNotificationWhenExceeded : 'Disabled'
    thresholdValue100DisplayOnChart: contains(costs, 'thresholdValue100DisplayOnChart') ? costs.thresholdValue100DisplayOnChart : 'Disabled'
    thresholdValue100SendNotificationWhenExceeded: contains(costs, 'thresholdValue100SendNotificationWhenExceeded') ? costs.thresholdValue100SendNotificationWhenExceeded : 'Disabled'
    thresholdValue125DisplayOnChart: contains(costs, 'thresholdValue125DisplayOnChart') ? costs.thresholdValue125DisplayOnChart : 'Disabled'
    thresholdValue125SendNotificationWhenExceeded: contains(costs, 'thresholdValue125SendNotificationWhenExceeded') ? costs.thresholdValue125SendNotificationWhenExceeded : 'Disabled'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module lab_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: lab.id
  }
}]

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = lab.identity.principalId

@description('The unique identifier for the lab. Used to track tags that the lab applies to each resource that it creates.')
output uniqueIdentifier string = lab.properties.uniqueIdentifier

@description('The resource group the lab was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the lab.')
output resourceId string = lab.id

@description('The name of the lab.')
output name string = lab.name

@description('The location the resource was deployed into.')
output location string = lab.location
