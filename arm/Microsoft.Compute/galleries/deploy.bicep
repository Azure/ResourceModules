@minLength(1)
@description('Required. Name of the Azure Shared Image Gallery')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Description of the Azure Shared Image Gallery')
param galleryDescription string = ''

@description('Optional. Images to create')
param images array = []

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags for all resources.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pidName '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource gallery 'Microsoft.Compute/galleries@2020-09-30' = {
  name: name
  location: location
  tags: tags
  properties: {
    description: galleryDescription
    identifier: {}
  }
}

resource gallery_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${gallery.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: gallery
}

module gallery_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Gallery-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: gallery.id
  }
}]

// Images
module galleries_images 'images/deploy.bicep' = [for (image, index) in images: {
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
    imageDefinitionDescription: contains(image, 'imageDefinitionDescription') ? image.imageDefinitionDescription : ''
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
  }
}]

@description('The resource ID of the deployed image gallery')
output galleryResourceId string = gallery.id

@description('The resource group of the deployed image gallery')
output galleryResourceGroup string = resourceGroup().name

@description('The name of the deployed image gallery')
output galleryName string = gallery.name
