@description('Required. Name of the Image Template to be built by the Azure Image Builder service.')
param imageTemplateName string

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

@description('Optional. Resource Id of an already existing subnet, e.g. \'/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>\'. If no value is provided, a new VNET will be created in the target Resource Group.')
param subnetId string = ''

@description('Required. Image source definition in object format.')
param imageSource object

@description('Required. Customization steps to be run when building the VM image.')
param customizationSteps array

@description('Optional. Name of the managed image that will be created in the AIB resourcegroup.')
param managedImageName string = ''

@description('Optional. Name of the unmanaged image that will be created in the AIB resourcegroup.')
param unManagedImageName string = ''

@description('Optional. Resource Id of Shared Image Gallery to distribute image to, e.g.: /subscriptions/<subscriptionID>/resourceGroups/<SIG resourcegroup>/providers/Microsoft.Compute/galleries/<SIG name>/images/<image definition>')
param sigImageDefinitionId string = ''

@description('Optional. List of the regions the image produced by this solution should be stored in the Shared Image Gallery. When left empty, the deployment\'s location will be taken as a default value.')
param imageReplicationRegions array = []

@description('Optional. Switch to lock Resource from deletion.')
param lockForDeletion bool = false

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Generated. Do not provide a value! This date value is used to generate a unique image template name.')
param baseTime string = utcNow('yyyy-MM-dd-HH-mm-ss')

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

var managedImageName_var = '${managedImageName}-${baseTime}'
var managedImageId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Compute/images/${managedImageName_var}'
var imageReplicationRegions_var = (empty(imageReplicationRegions) ? array(location) : imageReplicationRegions)
var emptyArray = []
var managedImage = {
  type: 'ManagedImage'
  imageId: managedImageId
  location: location
  runOutputName: '${managedImageName_var}-ManagedImage'
  artifactTags: {
    sourceType: imageSource.type
    sourcePublisher: (contains(imageSource, 'publisher') ? imageSource.publisher : json('null'))
    sourceOffer: (contains(imageSource, 'offer') ? imageSource.offer : json('null'))
    sourceSku: (contains(imageSource, 'sku') ? imageSource.sku : json('null'))
    sourceVersion: (contains(imageSource, 'version') ? imageSource.version : json('null'))
    sourceImageId: (contains(imageSource, 'imageId') ? imageSource.imageId : json('null'))
    sourceImageVersionID: (contains(imageSource, 'imageVersionID') ? imageSource.imageVersionID : json('null'))
    creationTime: baseTime
  }
}
var conditionalManagedImage = (empty(managedImageName) ? emptyArray : array(managedImage))
var sharedImage = {
  type: 'SharedImage'
  galleryImageId: sigImageDefinitionId
  runOutputName: ((!empty(sigImageDefinitionId)) ? '${split(sigImageDefinitionId, '/')[10]}-SharedImage' : 'SharedImage')
  artifactTags: {
    sourceType: imageSource.type
    sourcePublisher: (contains(imageSource, 'publisher') ? imageSource.publisher : json('null'))
    sourceOffer: (contains(imageSource, 'offer') ? imageSource.offer : json('null'))
    sourceSku: (contains(imageSource, 'sku') ? imageSource.sku : json('null'))
    sourceVersion: (contains(imageSource, 'version') ? imageSource.version : json('null'))
    sourceImageId: (contains(imageSource, 'imageId') ? imageSource.imageId : json('null'))
    sourceImageVersionID: (contains(imageSource, 'imageVersionID') ? imageSource.imageVersionID : json('null'))
    creationTime: baseTime
  }
  replicationRegions: imageReplicationRegions_var
}
var conditionalSharedImage = (empty(sigImageDefinitionId) ? emptyArray : array(sharedImage))
var unManagedImage = {
  type: 'VHD'
  runOutputName: '${unManagedImageName}-VHD'
  artifactTags: {
    sourceType: imageSource.type
    sourcePublisher: (contains(imageSource, 'publisher') ? imageSource.publisher : json('null'))
    sourceOffer: (contains(imageSource, 'offer') ? imageSource.offer : json('null'))
    sourceSku: (contains(imageSource, 'sku') ? imageSource.sku : json('null'))
    sourceVersion: (contains(imageSource, 'version') ? imageSource.version : json('null'))
    sourceImageId: (contains(imageSource, 'imageId') ? imageSource.imageId : json('null'))
    sourceImageVersionID: (contains(imageSource, 'imageVersionID') ? imageSource.imageVersionID : json('null'))
    creationTime: baseTime
  }
}
var conditionalUnManagedImage = (empty(unManagedImageName) ? emptyArray : array(unManagedImage))
var distribute = concat(conditionalManagedImage, conditionalSharedImage, conditionalUnManagedImage)
var vnetConfig = {
  subnetId: subnetId
}
var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2020-02-14' = {
  name: '${imageTemplateName}-${baseTime}'
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId(userMsiResourceGroup, 'Microsoft.ManagedIdentity/userAssignedIdentities', userMsiName)}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: buildTimeoutInMinutes
    vmProfile: {
      vmSize: vmSize
      osDiskSizeGB: osDiskSizeGB
      vnetConfig: (empty(subnetId) ? json('null') : vnetConfig)
    }
    source: imageSource
    customize: customizationSteps
    distribute: distribute
  }
  dependsOn: []
}

resource imageTemplate_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${imageTemplate.name}-imageTemplateDoNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: imageTemplate
}


module imageTemplate_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AppService-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: imageTemplate.name
  }
}]

output imageTemplateResourceId string = imageTemplate.id
output imageTemplateResourceGroup string = resourceGroup().name
output imageTemplateName string = imageTemplate.name
output runThisCommand string = 'Invoke-AzResourceAction -ResourceName ${imageTemplate.name} -ResourceGroupName ${resourceGroup().name} -ResourceType Microsoft.VirtualMachineImages/imageTemplates -Action Run -Force'
