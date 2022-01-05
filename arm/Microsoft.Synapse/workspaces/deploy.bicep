// Parameters
@description('Required. The name of the Synapse Workspace.')
param name string

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable or Disable AzureADOnlyAuthentication on All Workspace subresource')
param azureADOnlyAuthentication bool = false

@description('Optional. AAD object ID of initial workspace admin.')
param initialWorkspaceAdminObjectId string = ''

@description('Required. The default ADLS Gen2 storage account name.')
param defaultDataLakeStorageAccountName string

@description('Required. The default ADLS Gen2 file system.')
param defaultDataLakeStorageFilesystem string

@description('Optional. Create managed private endpoint to the default storage account or not. If Yes is selected, a managed private endpoint connection request is sent to the workspace\'s primary Data Lake Storage Gen2 account for Spark pools to access data. This must be approved by an owner of the storage account.')
param defaultDataLakeStorageCreateManagedPrivateEndpoint bool

@description('Optional. Double encryption using a customer-managed key.')
param encrytpion bool = false

@description('Optional. Key identifier should be in the format of: https://{keyvaultname}.vault.azure.net/keys/{keyname}.')
param encryptionKeyIdentifier string = ''

@description('Optional. The workspace encryption key name.')
param encryptionKeyName string = ''

@description('Optional. Use System Assigned Managed identity that will be used to access your customer-managed key stored in key vault.')
param encryptionUseSystemAssignedIdentity bool = false

@description('Optional. The ID of User Assigned Managed identity that will be used to access your customer-managed key stored in key vault.')
param encryptionUserAssignedIdentity string = ''

@maxLength(90)
@description('Optional. Workspace managed resource group. The resource group name uniquely identifies the resource group within the user subscriptionId. The resource group name must be no longer than 90 characters long, and must be alphanumeric characters (Char.IsLetterOrDigit()) and \'-\', \'_\', \'(\', \')\' and\'.\'. Note that the name cannot end with \'.\'')
param managedResourceGroupName string = ''

@description('Optional. Enable this to ensure that connection from your workspace to your data sources use Azure Private Links. You can create managed private endpoints to your data sources.')
param managedVirtualNetwork bool = false

@description('Optional. Allowed Aad Tenant Ids For Linking.')
param allowedAadTenantIdsForLinking array = []

@description('Optional. Linked Access Check On Target Resource.')
param linkedAccessCheckOnTargetResource bool = false

@description('Optional. Prevent Data Exfiltration.')
param preventDataExfiltration bool = false

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Enable or Disable public network access to workspace.')
param publicNetworkAccess string = 'Enabled'

@description('Optional. Purview Resource ID.')
param purviewResourceId string = ''

@description('Required. Login for administrator access to the workspace\'s SQL pools.')
param sqlAdministratorLogin string

@description('Optional. Password for administrator access to the workspace\'s SQL pools. If you don\'t provide a password, one will be automatically generated. You can change the password later.')
param sqlAdministratorLoginPassword string = ''

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

// Variables
var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: name
  location: location
  identity: identity
  tags: tags
  properties: {
    azureADOnlyAuthentication: (azureADOnlyAuthentication) ? azureADOnlyAuthentication : null
    cspWorkspaceAdminProperties: (!empty(initialWorkspaceAdminObjectId)) ? {
      initialWorkspaceAdminObjectId: initialWorkspaceAdminObjectId
    } : null
    defaultDataLakeStorage: {
      accountUrl: '${defaultDataLakeStorageAccountName}.dfs.core.windows.net'
      filesystem: defaultDataLakeStorageFilesystem
      createManagedPrivateEndpoint: (managedVirtualNetwork) ? defaultDataLakeStorageCreateManagedPrivateEndpoint : null
    }
    encryption: (encrytpion) ? {
      cmk: {
        kekIdentity: {
          userAssignedIdentity: (!empty(encryptionUserAssignedIdentity)) ? encryptionUserAssignedIdentity : null
          useSystemAssignedIdentity: (encryptionUseSystemAssignedIdentity) ? true : false
        }
        key: {
          keyVaultUrl: encryptionKeyIdentifier
          name: encryptionKeyName
        }
      }
    } : null
    managedResourceGroupName: (!empty(managedResourceGroupName)) ? managedResourceGroupName : null
    managedVirtualNetwork: (managedVirtualNetwork) ? 'default' : null
    managedVirtualNetworkSettings: (managedVirtualNetwork) ? {
      allowedAadTenantIdsForLinking: allowedAadTenantIdsForLinking
      linkedAccessCheckOnTargetResource: linkedAccessCheckOnTargetResource
      preventDataExfiltration: preventDataExfiltration
    } : null
    publicNetworkAccess: (managedVirtualNetwork) ? publicNetworkAccess : null
    purviewConfiguration: (!empty(purviewResourceId)) ? {
      purviewResourceId: purviewResourceId
    } : null
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: (!empty(sqlAdministratorLoginPassword)) ? sqlAdministratorLoginPassword : null
  }
}

//  Grant the workspace identity data access to the specified Data Lake Storage Gen2 account, using the Storage Blob Data Contributor role
// TODO

// Resource Lock
resource workspace_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${workspace.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: workspace
}

// RBAC
module workspace_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: workspace.id
  }
}]

// Private Endpoints
module workspace_privateEndpoints '.bicep/nested_privateEndpoint.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-PrivateEndpoint-${index}'
  params: {
    privateEndpointResourceId: workspace.id
    privateEndpointVnetLocation: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    privateEndpointObj: privateEndpoint
    tags: tags
  }
}]

@description('The resource ID of the deployed Synapse Workspace.')
output workspaceResourceId string = workspace.id

@description('The name of the deployed Synapse Workspace.')
output workspaceName string = workspace.name

@description('The resource group of the deployed Synapse Workspace.')
output workspaceResourceGroup string = resourceGroup().name

@description('Connectivity endpoints.')
output workspaceConnectivityEndpoints object = workspace.properties.connectivityEndpoints
