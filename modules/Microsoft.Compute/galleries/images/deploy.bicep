@sys.description('Required. Name of the image definition.')
param name string

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Conditional. The name of the parent Azure Shared Image Gallery. Required if the template is used in a standalone deployment.')
@minLength(1)
param galleryName string

@sys.description('Optional. OS type of the image to be created.')
@allowed([
  'Windows'
  'Linux'
])
param osType string = 'Windows'

@sys.description('Optional. This property allows the user to specify whether the virtual machines created under this image are \'Generalized\' or \'Specialized\'.')
@allowed([
  'Generalized'
  'Specialized'
])
param osState string = 'Generalized'

@sys.description('Optional. The name of the gallery Image Definition publisher.')
param publisher string = 'MicrosoftWindowsServer'

@sys.description('Optional. The name of the gallery Image Definition offer.')
param offer string = 'WindowsServer'

@sys.description('Optional. The name of the gallery Image Definition SKU.')
param sku string = '2019-Datacenter'

@sys.description('Optional. The minimum number of the CPU cores recommended for this image.')
@minValue(1)
@maxValue(128)
param minRecommendedvCPUs int = 1

@sys.description('Optional. The maximum number of the CPU cores recommended for this image.')
@minValue(1)
@maxValue(128)
param maxRecommendedvCPUs int = 4

@sys.description('Optional. The minimum amount of RAM in GB recommended for this image.')
@minValue(1)
@maxValue(4000)
param minRecommendedMemory int = 4

@sys.description('Optional. The maximum amount of RAM in GB recommended for this image.')
@minValue(1)
@maxValue(4000)
param maxRecommendedMemory int = 16

@sys.description('''Optional. The hypervisor generation of the Virtual Machine.
* If this value is not specified, then it is determined by the securityType parameter.
* If the securityType parameter is specified, then the value of hyperVGeneration will be V2, else V1.
''')
@allowed([
  ''
  'V1'
  'V2'
])
param hyperVGeneration string = ''

@sys.description('Optional. The security type of the image. Requires a hyperVGeneration V2.')
@allowed([
  'Standard'
  'TrustedLaunch'
  'ConfidentialVM'
  'ConfidentialVMSupported'
])
param securityType string = 'Standard'

@sys.description('Optional. The image will support hibernation.')
@allowed([
  'true'
  'false'
])
param isHibernateSupported string = 'false'

@sys.description('''Optional. The image supports accelerated networking.
Accelerated networking enables single root I/O virtualization (SR-IOV) to a VM, greatly improving its networking performance.
This high-performance path bypasses the host from the data path, which reduces latency, jitter, and CPU utilization for the
most demanding network workloads on supported VM types.
''')
@allowed([
  'true'
  'false'
])
param isAcceleratedNetworkSupported string = 'false'

@sys.description('Optional. The description of this gallery Image Definition resource. This property is updatable.')
param description string = ''

@sys.description('Optional. The Eula agreement for the gallery Image Definition. Has to be a valid URL.')
param eula string = ''

@sys.description('Optional. The privacy statement uri. Has to be a valid URL.')
param privacyStatementUri string = ''

@sys.description('Optional. The release note uri. Has to be a valid URL.')
param releaseNoteUri string = ''

@sys.description('Optional. The product ID.')
param productName string = ''

@sys.description('Optional. The plan ID.')
param planName string = ''

@sys.description('Optional. The publisher ID.')
param planPublisherName string = ''

@sys.description('Optional. The end of life date of the gallery Image Definition. This property can be used for decommissioning purposes. This property is updatable. Allowed format: 2020-01-10T23:00:00.000Z.')
param endOfLife string = ''

@sys.description('Optional. List of the excluded disk types. E.g. Standard_LRS.')
param excludedDiskTypes array = []

@sys.description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@sys.description('Optional. Tags for all resources.')
param tags object = {}

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

resource gallery 'Microsoft.Compute/galleries@2022-03-03' existing = {
  name: galleryName
}

resource image 'Microsoft.Compute/galleries/images@2022-03-03' = {
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
    hyperVGeneration: !empty(hyperVGeneration) ? hyperVGeneration : (!empty(securityType) ? 'V2' : 'V1')
    features: !empty(securityType) && securityType != 'Standard' ? [
      {
        name: 'SecurityType'
        value: securityType
      }
      {
        name: 'IsAcceleratedNetworkSupported'
        value: isAcceleratedNetworkSupported
      }
      {
        name: 'IsHibernateSupported'
        value: isHibernateSupported
      }
    ] : [
      {
        name: 'IsAcceleratedNetworkSupported'
        value: isAcceleratedNetworkSupported
      }
      {
        name: 'IsHibernateSupported'
        value: isHibernateSupported
      }
    ]
    description: description
    eula: eula
    privacyStatementUri: privacyStatementUri
    releaseNoteUri: releaseNoteUri
    purchasePlan: {
      product: !empty(productName) ? productName : null
      name: !empty(planName) ? planName : null
      publisher: !empty(planPublisherName) ? planPublisherName : null
    }
    endOfLifeDate: endOfLife
    disallowed: {
      diskTypes: excludedDiskTypes
    }
  }
}

module galleryImage_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: image.id
  }
}]

@sys.description('The resource group the image was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The resource ID of the image.')
output resourceId string = image.id

@sys.description('The name of the image.')
output name string = image.name

@sys.description('The location the resource was deployed into.')
output location string = image.location
