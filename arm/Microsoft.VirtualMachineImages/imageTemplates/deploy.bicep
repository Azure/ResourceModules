@description('Required. Name of the Image Template to be built by the Azure Image Builder service.')
param name string

@description('Required. Name of the User Assigned Identity to be used to deploy Image Templates in Azure Image Builder.')
param userMsiName string

@description('Optional. Resource group of the user assigned identity.')
param userMsiResourceGroup string = resourceGroup().name

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Image build timeout in minutes. Allowed values: 0-960. 0 means the default 240 minutes')
@minValue(0)
@maxValue(960)
param buildTimeoutInMinutes int = 0

@description('Optional. Specifies the size for the VM.')
param vmSize string = 'Standard_D2s_v3'

@description('Optional. Specifies the size of OS disk.')
param osDiskSizeGB int = 128

@description('Optional. Resource ID of an already existing subnet, e.g. \'/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>\'. If no value is provided, a new VNET will be created in the target Resource Group.')
param subnetId string = ''

@description('Required. Image source definition in object format.')
param imageSource object

@description('Required. Customization steps to be run when building the VM image.')
param customizationSteps array

@description('Optional. Name of the managed image that will be created in the AIB resourcegroup.')
param managedImageName string = ''

@description('Optional. Name of the unmanaged image that will be created in the AIB resourcegroup.')
param unManagedImageName string = ''

@description('Optional. Resource ID of Shared Image Gallery to distribute image to, e.g.: /subscriptions/<subscriptionID>/resourceGroups/<SIG resourcegroup>/providers/Microsoft.Compute/galleries/<SIG name>/images/<image definition>')
param sigImageDefinitionId string = ''

@description('Optional. List of the regions the image produced by this solution should be stored in the Shared Image Gallery. When left empty, the deployment\'s location will be taken as a default value.')
param imageReplicationRegions array = []

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Generated. Do not provide a value! This date value is used to generate a unique image template name.')
param baseTime string = utcNow('yyyy-MM-dd-HH-mm-ss')

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

var managedImageName_var = '${managedImageName}-${baseTime}'
var managedImageId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Compute/images/${managedImageName_var}'
var imageReplicationRegions_var = empty(imageReplicationRegions) ? array(location) : imageReplicationRegions

var managedImage = {
  type: 'ManagedImage'
  imageId: managedImageId
  location: location
  runOutputName: '${managedImageName_var}-ManagedImage'
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
  galleryImageId: sigImageDefinitionId
  runOutputName: !empty(sigImageDefinitionId) ? '${split(sigImageDefinitionId, '/')[10]}-SharedImage' : 'SharedImage'
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
  replicationRegions: imageReplicationRegions_var
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

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2020-02-14' = {
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
      vnetConfig: !empty(subnetId) ? vnetConfig : null
    }
    source: imageSource
    customize: customizationSteps
    distribute: distribute
  }
}

resource imageTemplate_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${imageTemplate.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: imageTemplate
}

module imageTemplate_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-ImageTemplate-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: imageTemplate.id
  }
}]

@description('The resource ID of the image template')
output resourceId string = imageTemplate.id

@description('The resource group the image template was deployed into')
output resourceGroupName string = resourceGroup().name

@description('The name of the image template')
output name string = imageTemplate.name

@description('The command to run in order to trigger the image build')
output runThisCommand string = 'Invoke-AzResourceAction -ResourceName ${imageTemplate.name} -ResourceGroupName ${resourceGroup().name} -ResourceType Microsoft.VirtualMachineImages/imageTemplates -Action Run -Force'
