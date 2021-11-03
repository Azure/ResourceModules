@description('Required. Name of the image definition.')
param imageDefinitionName string

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Name of the Azure Shared Image Gallery')
@minLength(1)
param galleryName string

@description('Optional. OS type of the image to be created.')
@allowed([
  'Windows'
  'Linux'
])
param osType string = 'Windows'

@description('Optional. This property allows the user to specify whether the virtual machines created under this image are \'Generalized\' or \'Specialized\'.')
@allowed([
  'Generalized'
  'Specialized'
])
param osState string = 'Generalized'

@description('Optional. The name of the gallery Image Definition publisher.')
param publisher string = 'MicrosoftWindowsServer'

@description('Optional. The name of the gallery Image Definition offer.')
param offer string = 'WindowsServer'

@description('Optional. The name of the gallery Image Definition SKU.')
param sku string = '2019-Datacenter'

@description('Optional. The minimum number of the CPU cores recommended for this image.')
@minValue(1)
@maxValue(128)
param minRecommendedvCPUs int = 1

@description('Optional. The maximum number of the CPU cores recommended for this image.')
@minValue(1)
@maxValue(128)
param maxRecommendedvCPUs int = 4

@description('Optional. The minimum amount of RAM in GB recommended for this image.')
@minValue(1)
@maxValue(4000)
param minRecommendedMemory int = 4

@description('Optional. The maximum amount of RAM in GB recommended for this image.')
@minValue(1)
@maxValue(4000)
param maxRecommendedMemory int = 16

@description('Optional. The hypervisor generation of the Virtual Machine. Applicable to OS disks only. - V1 or V2')
@allowed([
  'V1'
  'V2'
])
param hyperVGeneration string = 'V1'

@description('Optional. The description of this gallery Image Definition resource. This property is updatable.')
param imageDefinitionDescription string = ''

@description('Optional. The Eula agreement for the gallery Image Definition. Has to be a valid URL.')
param eula string = ''

@description('Optional. The privacy statement uri. Has to be a valid URL.')
param privacyStatementUri string = ''

@description('Optional. The release note uri. Has to be a valid URL.')
param releaseNoteUri string = ''

@description('Optional. The product ID.')
param productName string = ''

@description('Optional. The plan ID.')
param planName string = ''

@description('Optional. The publisher ID.')
param planPublisherName string = ''

@description('Optional. The end of life date of the gallery Image Definition. This property can be used for decommissioning purposes. This property is updatable. Allowed format: 2020-01-10T23:00:00.000Z')
param endOfLife string = ''

@description('Optional. List of the excluded disk types. E.g. Standard_LRS')
param excludedDiskTypes array = []

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags for all resources.')
param tags object = {}

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Avere Cluster Create': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a7b1b19a-0e83-4fe5-935c-faaefbfd18c3')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Azure Service Deploy Release Management Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '21d96096-b162-414a-8302-d8354f9d91b2')
  'CAL-Custom-Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7b266cd7-0bba-4ae2-8423-90ede5e1e898')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'masterreader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a48d7796-14b4-4889-afef-fbb65a93e5a2')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'myCustomRoleAtSub': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '60cb79d9-783a-50a4-9f05-d4c579fb8ce3')
}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource galleryImage 'Microsoft.Compute/galleries/images@2020-09-30' = {
  name: '${galleryName}/${imageDefinitionName}'
  location: location
  tags: tags
  properties: {
    osType: osType
    osState: osState
    identifier: {
      publisher: publisher
      offer: offer
      sku: sku
    }
    recommended: {
      vCPUs: {
        min: minRecommendedvCPUs
        max: maxRecommendedvCPUs
      }
      memory: {
        min: minRecommendedMemory
        max: maxRecommendedMemory
      }
    }
    hyperVGeneration: hyperVGeneration
    description: imageDefinitionDescription
    eula: eula
    privacyStatementUri: privacyStatementUri
    releaseNoteUri: releaseNoteUri
    purchasePlan: {
      product: productName
      name: planName
      publisher: planPublisherName
    }
    endOfLifeDate: endOfLife
    disallowed: {
      diskTypes: excludedDiskTypes
    }
  }
}

module galleryImage_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: galleryImage.name
  }
}]

output galleryResourceId string = resourceId('Microsoft.Compute/galleries', galleryName)
output galleryResourceGroup string = resourceGroup().name
output galleryName string = galleryName
output galleryImageResourceId string = galleryImage.id
output galleryImageName string = galleryImage.name
