@minLength(1)
@sys.description('Required. Name of the Azure Compute Gallery.')
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. Description of the Azure Shared Image Gallery.')
param description string = ''

@sys.description('Optional. Applications to create.')
param applications array = []

@sys.description('Optional. Images to create.')
param images array = []

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@sys.description('Optional. Specify the type of lock.')
param lock string = ''

@sys.description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@sys.description('Optional. Tags for all resources.')
param tags object = {}

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
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

resource gallery 'Microsoft.Compute/galleries@2022-03-03' = {
  name: name
  location: location
  tags: tags
  properties: {
    description: description
    identifier: {}
  }
}

resource gallery_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${gallery.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: gallery
}

module gallery_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Gallery-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: gallery.id
  }
}]

// Applications
module galleries_applications 'applications/main.bicep' = [for (application, index) in applications: {
  name: '${uniqueString(deployment().name, location)}-Gallery-Application-${index}'
  params: {
    name: application.name
    galleryName: gallery.name
    supportedOSType: contains(application, 'supportOSType') ? application.supportedOSType : 'Windows'
    description: contains(application, 'description') ? application.description : ''
    eula: contains(application, 'eula') ? application.eula : ''
    privacyStatementUri: contains(application, 'privacyStatementUri') ? application.privacyStatementUri : ''
    releaseNoteUri: contains(application, 'releaseNoteUri') ? application.releaseNoteUri : ''
    endOfLifeDate: contains(application, 'endOfLifeDate') ? application.endOfLifeDate : ''
    roleAssignments: contains(application, 'roleAssignments') ? application.roleAssignments : []
    customActions: contains(application, 'customActions') ? application.customActions : []
    tags: contains(application, 'tags') ? application.tags : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

// Images
module galleries_images 'images/main.bicep' = [for (image, index) in images: {
  name: '${uniqueString(deployment().name, location)}-Gallery-Image-${index}'
  params: {
    name: image.name
    galleryName: gallery.name
    osType: contains(image, 'osType') ? image.osType : 'Windows'
    osState: contains(image, 'osState') ? image.osState : 'Generalized'
    publisher: contains(image, 'publisher') ? image.publisher : 'MicrosoftWindowsServer'
    offer: contains(image, 'offer') ? image.offer : 'WindowsServer'
    sku: contains(image, 'sku') ? image.sku : '2019-Datacenter'
    minRecommendedvCPUs: contains(image, 'minRecommendedvCPUs') ? image.minRecommendedvCPUs : 1
    maxRecommendedvCPUs: contains(image, 'maxRecommendedvCPUs') ? image.maxRecommendedvCPUs : 4
    minRecommendedMemory: contains(image, 'minRecommendedMemory') ? image.minRecommendedMemory : 4
    maxRecommendedMemory: contains(image, 'maxRecommendedMemory') ? image.maxRecommendedMemory : 16
    hyperVGeneration: contains(image, 'hyperVGeneration') ? image.hyperVGeneration : 'V1'
    securityType: contains(image, 'securityType') ? image.securityType : 'Standard'
    description: contains(image, 'description') ? image.description : ''
    eula: contains(image, 'eula') ? image.eula : ''
    privacyStatementUri: contains(image, 'privacyStatementUri') ? image.privacyStatementUri : ''
    releaseNoteUri: contains(image, 'releaseNoteUri') ? image.releaseNoteUri : ''
    productName: contains(image, 'productName') ? image.productName : ''
    planName: contains(image, 'planName') ? image.planName : ''
    planPublisherName: contains(image, 'planPublisherName') ? image.planPublisherName : ''
    endOfLife: contains(image, 'endOfLife') ? image.endOfLife : ''
    excludedDiskTypes: contains(image, 'excludedDiskTypes') ? image.excludedDiskTypes : []
    roleAssignments: contains(image, 'roleAssignments') ? image.roleAssignments : []
    tags: contains(image, 'tags') ? image.tags : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@sys.description('The resource ID of the deployed image gallery.')
output resourceId string = gallery.id

@sys.description('The resource group of the deployed image gallery.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the deployed image gallery.')
output name string = gallery.name

@sys.description('The location the resource was deployed into.')
output location string = gallery.location
