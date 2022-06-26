@description('Required. The name of the disk that is being created.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@allowed([
  'Standard_LRS'
  'Premium_LRS'
  'StandardSSD_LRS'
  'UltraSSD_LRS'
  'Premium_ZRS'
  'Premium_ZRS'
])
@description('Required. The disks sku name. Can be .')
param sku string

@description('Optional. Set to true to enable bursting beyond the provisioned performance target of the disk.')
param burstingEnabled bool = false

@description('Optional. Percentage complete for the background copy when a resource is created via the CopyStart operation.')
param completionPercent int = 100

@allowed([
  'Attach'
  'Copy'
  'CopyStart'
  'Empty'
  'FromImage'
  'Import'
  'ImportSecure'
  'Restore'
  'Upload'
  'UploadPreparedSecure'
])
@description('Optional. Sources of a disk creation.')
param createOption string = 'Empty'

@description('Optional. A relative uri containing either a Platform Image Repository or user image reference.')
param imageReferenceId string = ''

@description('Optional. Logical sector size in bytes for Ultra disks. Supported values are 512 ad 4096.')
param logicalSectorSize int = 4096

@description('Optional. If create option is ImportSecure, this is the URI of a blob to be imported into VM guest state.')
param securityDataUri string = ''

@description('Optional. If create option is Copy, this is the ARM id of the source snapshot or disk.')
param sourceResourceId string = ''

@description('Optional. If create option is Import, this is the URI of a blob to be imported into a managed disk.')
param sourceUri string = ''

@description('Optional. Required if create option is Import. The Azure Resource Manager identifier of the storage account containing the blob to import as a disk.')
param storageAccountId string = ''

@description('Optional. If create option is Upload, this is the size of the contents of the upload including the VHD footer.')
param uploadSizeBytes int = 20972032

@description('Optional. If create option is empty, this field is mandatory and it indicates the size of the disk to create.')
param diskSizeGB int = 0

@description('Optional. The number of IOPS allowed for this disk; only settable for UltraSSD disks.')
param diskIOPSReadWrite int = 0

@description('Optional. The bandwidth allowed for this disk; only settable for UltraSSD disks.')
param diskMBpsReadWrite int = 0

@allowed([
  'V1'
  'V2'
])
@description('Optional. The hypervisor generation of the Virtual Machine. Applicable to OS disks only.')
param hyperVGeneration string = 'V2'

@description('Optional. The maximum number of VMs that can attach to the disk at the same time. Default value is 0.')
param maxShares int = 1

@allowed([
  'AllowAll'
  'AllowPrivate'
  'DenyAll'
])
@description('Optional. Policy for accessing the disk via network.')
param networkAccessPolicy string = 'DenyAll'

@allowed([
  'Windows'
  'Linux'
  ''
])
@description('Optional. Sources of a disk creation.')
param osType string = ''

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Policy for controlling export on the disk.')
param publicNetworkAccess string = 'Disabled'

@description('Optional. True if the image from which the OS disk is created supports accelerated networking.')
param acceleratedNetwork bool = false

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the availability set resource.')
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

resource disk 'Microsoft.Compute/disks@2021-08-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    burstingEnabled: burstingEnabled
    completionPercent: completionPercent
    creationData: {
      createOption: createOption
      imageReference: createOption != 'FromImage' ? null : {
        id: imageReferenceId
      }
      logicalSectorSize: contains(sku, 'Ultra') ? logicalSectorSize : null
      securityDataUri: createOption == 'ImportSecure' ? securityDataUri : null
      sourceResourceId: createOption == 'Copy' ? sourceResourceId : null
      sourceUri: createOption == 'Import' ? sourceUri : null
      storageAccountId: createOption == 'Import' ? storageAccountId : null
      uploadSizeBytes: createOption == 'Upload' ? uploadSizeBytes : null
    }
    diskIOPSReadWrite: contains(sku, 'Ultra') ? diskIOPSReadWrite : null
    diskMBpsReadWrite: contains(sku, 'Ultra') ? diskMBpsReadWrite : null
    diskSizeGB: createOption == 'Empty' ? diskSizeGB : null
    hyperVGeneration: empty(osType) ? null : hyperVGeneration
    maxShares: maxShares
    networkAccessPolicy: networkAccessPolicy
    osType: empty(osType) ? any(null) : osType
    publicNetworkAccess: publicNetworkAccess
    supportedCapabilities: empty(osType) ? {} : {
      acceleratedNetwork: acceleratedNetwork
    }
  }
}

resource disk_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${disk.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: disk
}

module disk_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AvSet-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: disk.id
  }
}]

@description('The resource group the  disk was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the disk.')
output resourceId string = disk.id

@description('The name of the disk.')
output name string = disk.name

@description('The location the resource was deployed into.')
output location string = disk.location
