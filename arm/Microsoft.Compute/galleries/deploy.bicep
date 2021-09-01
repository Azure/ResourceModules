@minLength(1)
@description('Required. Name of the Azure Shared Image Gallery')
param galleryName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Description of the Azure Shared Image Gallery')
param galleryDescription string = ''

@description('Optional. Switch to lock resources from deletion.')
param lockForDeletion bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags for all resources.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var pidName_var = 'pid-${cuaId}'

module pidName './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: pidName_var
  params: {}
}

resource galleryName_resource 'Microsoft.Compute/galleries@2019-12-01' = {
  name: galleryName
  location: location
  tags: tags
  properties: {
    description: galleryDescription
    identifier: {}
  }
}

resource galleryName_Microsoft_Authorization_sharedImageGallerDoNotDelete 'Microsoft.Compute/galleries/providers/locks@2016-09-01' = if (lockForDeletion) {
  name: '${galleryName}/Microsoft.Authorization/sharedImageGallerDoNotDelete'
  properties: {
    level: 'CannotDelete'
  }
  dependsOn: [
    galleryName_resource
  ]
}

module rbac_name './.bicep/nested_rbac.bicep' = [for (item, i) in roleAssignments: {
  name: 'rbac-${deployment().name}${i}'
  params: {
    roleAssignment: item
    galleryName: galleryName
  }
  dependsOn: [
    galleryName_resource
  ]
}]

output galleryResourceId string = galleryName_resource.id
output galleryResourceGroup string = resourceGroup().name
output galleryName string = galleryName
