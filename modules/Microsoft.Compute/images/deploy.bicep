@description('Required. The name of the image.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The Virtual Hard Disk.')
param osDiskBlobUri string

@description('Required. This property allows you to specify the type of the OS that is included in the disk if creating a VM from a custom image. - Windows or Linux.')
param osType string

@description('Optional. Specifies the caching requirements. Default: None for Standard storage. ReadOnly for Premium storage. - None, ReadOnly, ReadWrite.')
param osDiskCaching string

@description('Optional. Specifies the storage account type for the managed disk. NOTE: UltraSSD_LRS can only be used with data disks, it cannot be used with OS Disk. - Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS.')
param osAccountType string

@description('Optional. Default is false. Specifies whether an image is zone resilient or not. Zone resilient images can be created only in regions that provide Zone Redundant Storage (ZRS).')
param zoneResilient bool = false

@description('Optional. Gets the HyperVGenerationType of the VirtualMachine created from the image. - V1 or V2.')
param hyperVGeneration string = 'V1'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

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

resource image 'Microsoft.Compute/images@2021-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    storageProfile: {
      osDisk: {
        osType: osType
        blobUri: osDiskBlobUri
        caching: osDiskCaching
        storageAccountType: osAccountType
      }
      dataDisks: []
      zoneResilient: zoneResilient
    }
    hyperVGeneration: hyperVGeneration
  }
}

module image_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Image-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: image.id
  }
}]

@description('The resource ID of the image.')
output resourceId string = image.id

@description('The resource group the image was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the image.')
output name string = image.name

@description('The location the resource was deployed into.')
output location string = image.location
