targetScope = 'subscription'

@allowed([
  'EnableCassandra'
  'EnableTable'
  'EnableGremlin'
  'EnableMongo'
  'DisableRateLimitingResponses'
  'EnableServerless'
])
@description('Optional. List of Cosmos DB capabilities for the account.')
param capabilitiesToAdd array = []

//////////////////////////
//   Input Parameters   //
//////////////////////////
@description('Optional. A parameter to control which Front facing deployments should be executed')
@allowed([
  'Enable Web Static App'
])
param deploymentsToPerformFrontFacingLayer string

@description('Optional. A parameter to control which Database deployments should be executed')
@allowed([ // Do storage account later
  'All'
  'Enable Cosmos DB'
  'Enable Serverless SQL'
  'Enable PostresSQL'
])
param deploymentsToPerformDatabaseLayer string

@description('Optional. A parameter to control which Application layer deployments should be executed')
@allowed([ //Do Function App later
  'All'
  'Enable Container Group'
  'Enable Container Registry'
])
param deploymentsToPerformApplicationLayer string

///////////////////////////////
//   User-defined Deployment Properties //
///////////////////////////////

//Parameters for Resource Group

@description('Required. Name of the Resource Group.')
param resourceGroupName string = 'validation-rg'

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object = {}

@description('Resource Group location')
param location string = 'westeurope'

//Parameters for Static site ALL DEFAULT IN JSON (optional) all REQUIRED IN HERE.

@description('Required. Name of the Static Site.')
param staticSiteName string = 'az-ss-app-002'

@description('Required. Allow Config File Updates of the Static Site.')
param allowConfigFileUpdates bool = true

@description('Required. Emterprise Grade Cdn Status of the Static Site.')
param enterpriseGradeCdnStatus string = 'Disabled'

@description('Optional. Lock of the Static Site.')
param lock string = 'CanNotDelete'

@description('Required. Private DNS Resource Ids of the Static Site.')
param privateDNSResourceIds string = '/subscriptions/75b1e0ee-d030-43d8-a4bc-35a810096e46/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurestaticapps.net'

@description('Required. Service of the Static Site.')
param service string = 'staticSites'

@description('Required. Subnet Resource Id of the Static Site.')
param subnetResourceId string = '/subscriptions/75b1e0ee-d030-43d8-a4bc-35a810096e46/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints'

// @description('Required. Principal Ids of the Static Site.')
// param principalIds string = '<<deploymentSpId>>'

// @description('Optional. Role Definition or Name of the Static Site.')
// param roleDefinitionIdOrName string = 'Reader'

@description('Optional. Role Assignments of the Static Site.')
param roleAssignments array = []

@description('Optional. Private Endpoints of the Static Site.')
param privateEndpoints array = []

@description('Optional. SKU of the Static Site.')
param sku string = 'Standard'

@description('Optional. Stagimg Environment Policy of the Static Site.')
param stagingEnvironmentPolicy string = 'Enabled'

@description('Optional. System assigned identity of the Static Site.')
param systemAssignedIdentity bool = true

// Resource Group Deployment

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// User managed identity Deployment

@description('Optional. Name of the User Assigned Identity.') //DO THE PARAMS FOR
param userAssignedMIname string = newGuid()

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param userAssignedMIroleAssignments array = []

module userAssignedManagedIdentity '../../../modules/Microsoft.ManagedIdentity/userAssignedIdentities/deploy.bicep' = {
  name: 'userAssignedMI_deployment'
  scope: resourceGroup
  params: {
    name: userAssignedMIname
    location: location
    roleAssignments: userAssignedMIroleAssignments
    lock: lock
    tags: tags
  }
}

// Static Site Deployment

module staticSites '../../../modules/Microsoft.Web/staticSites/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-StaticSites'
  scope: resourceGroup
  params: {
    // Required parameters
    name: staticSiteName
    // Non-required parameters
    allowConfigFileUpdates: allowConfigFileUpdates
    enterpriseGradeCdnStatus: enterpriseGradeCdnStatus
    lock: lock
    privateEndpoints: privateEndpoints
    roleAssignments: roleAssignments
    sku: sku
    stagingEnvironmentPolicy: stagingEnvironmentPolicy
    systemAssignedIdentity: systemAssignedIdentity
    userAssignedIdentities: {
      '${userAssignedManagedIdentity.outputs.resourceId}': {}
    }
  }
}

// module containerGroups '../../../modules/Microsoft.ContainerInstance/containerGroups/deploy.bicep' = {
//   name: '${uniqueString(deployment().name)}-ContainerGroups'
//   scope: resourceGroup
//   params: {
//     // Required parameters
//     containername: '<<namePrefix>>-az-aci-x-001'
//     image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
//     name: '<<namePrefix>>-az-acg-x-001'
//     // Non-required parameters
//     lock: 'CanNotDelete'
//     ports: [
//       {
//         port: '80'
//         protocol: 'Tcp'
//       }
//       {
//         port: '443'
//         protocol: 'Tcp'
//       }
//     ]
//     systemAssignedIdentity: true
//     userAssignedIdentities: {
//       '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
//     }
//   }
// }
