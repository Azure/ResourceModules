metadata name = 'Virtual Machine Image Templates'
metadata description = 'This module deploys a Virtual Machine Image Template that can be consumed by Azure Image Builder (AIB).'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name prefix of the Image Template to be built by the Azure Image Builder service.')
param name string

@description('Required. Name of the User Assigned Identity to be used to deploy Image Templates in Azure Image Builder.')
param userMsiName string

@description('Optional. Resource group of the user assigned identity.')
param userMsiResourceGroup string = resourceGroup().name

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Image build timeout in minutes. Allowed values: 0-960. 0 means the default 240 minutes.')
@minValue(0)
@maxValue(960)
param buildTimeoutInMinutes int = 0

@description('Optional. Specifies the size for the VM.')
param vmSize string = 'Standard_D2s_v3'

@description('Optional. Specifies the size of OS disk.')
param osDiskSizeGB int = 128

@description('Optional. Resource ID of an already existing subnet, e.g.: /subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>.</p>If no value is provided, a new temporary VNET and subnet will be created in the staging resource group and will be deleted along with the remaining temporary resources.')
param subnetId string = ''

@description('Optional. List of User-Assigned Identities associated to the Build VM for accessing Azure resources such as Key Vaults from your customizer scripts.</p>Be aware, the user assigned identity specified in the \'userMsiName\' parameter must have the \'Managed Identity Operator\' role assignment on all the user assigned identities specified in this parameter for Azure Image Builder to be able to associate them to the build VM.')
param userAssignedIdentities array = []

@description('Required. Image source definition in object format.')
param imageSource object

@description('Required. Customization steps to be run when building the VM image.')
param customizationSteps array

@description('Optional. Name of the managed image that will be created in the AIB resourcegroup.')
param managedImageName string = ''

@description('Optional. Name of the unmanaged image that will be created in the AIB resourcegroup.')
param unManagedImageName string = ''

@description('Optional. Resource ID of Shared Image Gallery to distribute image to, e.g.: /subscriptions/<subscriptionID>/resourceGroups/<SIG resourcegroup>/providers/Microsoft.Compute/galleries/<SIG name>/images/<image definition>.')
param sigImageDefinitionId string = ''

@description('Optional. Version of the Shared Image Gallery Image. Supports the following Version Syntax: Major.Minor.Build (i.e., \'1.1.1\' or \'10.1.2\').')
param sigImageVersion string = ''

@description('Optional. Exclude the created Azure Compute Gallery image version from the latest.')
param excludeFromLatest bool = false

@description('Optional. List of the regions the image produced by this solution should be stored in the Shared Image Gallery. When left empty, the deployment\'s location will be taken as a default value.')
param imageReplicationRegions array = []

@allowed([
  'Standard_LRS'
  'Standard_ZRS'
])
@description('Optional. Storage account type to be used to store the image in the Azure Compute Gallery.')
param storageAccountType string = 'Standard_LRS'

@description('Optional. Resource ID of the staging resource group in the same subscription and location as the image template that will be used to build the image.</p>If this field is empty, a resource group with a random name will be created.</p>If the resource group specified in this field doesn\'t exist, it will be created with the same name.</p>If the resource group specified exists, it must be empty and in the same region as the image template.</p>The resource group created will be deleted during template deletion if this field is empty or the resource group specified doesn\'t exist,</p>but if the resource group specified exists the resources created in the resource group will be deleted during template deletion and the resource group itself will remain.')
param stagingResourceGroup string = ''

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Tags of the resource.')
param tags object?

@description('Generated. Do not provide a value! This date value is used to generate a unique image template name.')
param baseTime string = utcNow('yyyy-MM-dd-HH-mm-ss')

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

var managedImageNameVar = '${managedImageName}-${baseTime}'
var managedImageId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Compute/images/${managedImageNameVar}'
var imageReplicationRegionsVar = empty(imageReplicationRegions) ? array(location) : imageReplicationRegions

var managedImage = {
  type: 'ManagedImage'
  imageId: managedImageId
  location: location
  runOutputName: '${managedImageNameVar}-ManagedImage'
  artifactTags: {
    sourceType: imageSource.type
    sourcePublisher: contains(imageSource, 'publisher') ? imageSource.publisher : null
    sourceOffer: contains(imageSource, 'offer') ? imageSource.offer : null
    sourceSku: contains(imageSource, 'sku') ? imageSource.sku : null
    sourceVersion: contains(imageSource, 'version') ? imageSource.version : null
    sourceImageId: contains(imageSource, 'imageId') ? imageSource.imageId : null
    sourceImageVersionID: contains(imageSource, 'imageVersionID') ? imageSource.imageVersionID : null
    creationTime: baseTime
  }
}
var conditionalManagedImage = empty(managedImageName) ? [] : array(managedImage)
var sharedImage = {
  type: 'SharedImage'
  galleryImageId: empty(sigImageVersion) ? sigImageDefinitionId : '${sigImageDefinitionId}/versions/${sigImageVersion}'
  excludeFromLatest: excludeFromLatest
  replicationRegions: imageReplicationRegionsVar
  storageAccountType: storageAccountType
  runOutputName: !empty(sigImageDefinitionId) ? '${last(split(sigImageDefinitionId, '/'))}-SharedImage' : 'SharedImage'
  artifactTags: {
    sourceType: imageSource.type
    sourcePublisher: contains(imageSource, 'publisher') ? imageSource.publisher : null
    sourceOffer: contains(imageSource, 'offer') ? imageSource.offer : null
    sourceSku: contains(imageSource, 'sku') ? imageSource.sku : null
    sourceVersion: contains(imageSource, 'version') ? imageSource.version : null
    sourceImageId: contains(imageSource, 'imageId') ? imageSource.imageId : null
    sourceImageVersionID: contains(imageSource, 'imageVersionID') ? imageSource.imageVersionID : null
    creationTime: baseTime
  }
}
var conditionalSharedImage = empty(sigImageDefinitionId) ? [] : array(sharedImage)
var unManagedImage = {
  type: 'VHD'
  runOutputName: '${unManagedImageName}-VHD'
  artifactTags: {
    sourceType: imageSource.type
    sourcePublisher: contains(imageSource, 'publisher') ? imageSource.publisher : null
    sourceOffer: contains(imageSource, 'offer') ? imageSource.offer : null
    sourceSku: contains(imageSource, 'sku') ? imageSource.sku : null
    sourceVersion: contains(imageSource, 'version') ? imageSource.version : null
    sourceImageId: contains(imageSource, 'imageId') ? imageSource.imageId : null
    sourceImageVersionID: contains(imageSource, 'imageVersionID') ? imageSource.imageVersionID : null
    creationTime: baseTime
  }
}
var conditionalUnManagedImage = empty(unManagedImageName) ? [] : array(unManagedImage)
var distribute = concat(conditionalManagedImage, conditionalSharedImage, conditionalUnManagedImage)
var vnetConfig = {
  subnetId: subnetId
}

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

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

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2022-02-14' = {
  name: '${name}-${baseTime}'
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${az.resourceId(userMsiResourceGroup, 'Microsoft.ManagedIdentity/userAssignedIdentities', userMsiName)}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: buildTimeoutInMinutes
    vmProfile: {
      vmSize: vmSize
      osDiskSizeGB: osDiskSizeGB
      userAssignedIdentities: userAssignedIdentities
      vnetConfig: !empty(subnetId) ? vnetConfig : null
    }
    source: imageSource
    customize: customizationSteps
    distribute: distribute
    stagingResourceGroup: stagingResourceGroup
  }
}

resource imageTemplate_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: imageTemplate
}

resource imageTemplate_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(imageTemplate.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: imageTemplate
}]

@description('The resource ID of the image template.')
output resourceId string = imageTemplate.id

@description('The resource group the image template was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The full name of the deployed image template.')
output name string = imageTemplate.name

@description('The prefix of the image template name provided as input.')
output namePrefix string = name

@description('The command to run in order to trigger the image build.')
output runThisCommand string = 'Invoke-AzResourceAction -ResourceName ${imageTemplate.name} -ResourceGroupName ${resourceGroup().name} -ResourceType Microsoft.VirtualMachineImages/imageTemplates -Action Run -Force'

@description('The location the resource was deployed into.')
output location string = imageTemplate.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
