@description('Required. Name of the image definition.')
param name string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
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

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource gallery 'Microsoft.Compute/galleries@2020-09-30' existing = {
  name: galleryName
}

resource image 'Microsoft.Compute/galleries/images@2020-09-30' = {
  name: name
  parent: gallery
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
  name: '${deployment().name}-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: image.id
  }
}]

@description('The resource group the image was deployed into')
output imageResourceGroup string = resourceGroup().name

@description('The resource ID of the image')
output imageResourceId string = image.id

@description('The name of the image')
output imageName string = image.name
