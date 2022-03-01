targetScope = 'resourceGroup'

@sys.description('Required. Name of the custom RBAC role to be created.')
param roleName string

@sys.description('Optional. Description of the custom RBAC role to be created.')
param description string = ''

@sys.description('Optional. List of allowed actions.')
param actions array = []

@sys.description('Optional. List of denied actions.')
param notActions array = []

@sys.description('Optional. List of allowed data actions. This is not supported if the assignableScopes contains Management Group Scopes')
param dataActions array = []

@sys.description('Optional. List of denied data actions. This is not supported if the assignableScopes contains Management Group Scopes')
param notDataActions array = []

@sys.description('Optional. The subscription ID where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment.')
param subscriptionId string = subscription().subscriptionId

@sys.description('Optional. The name of the Resource Group where the Role Definition and Target Scope will be applied to. If not provided, will use the current scope for deployment.')
param resourceGroupName string = resourceGroup().name

@sys.description('Optional. Role definition assignable scopes. If not provided, will use the current scope provided.')
param assignableScopes array = []

@sys.description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered.')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: guid(roleName, subscriptionId, resourceGroupName)
  properties: {
    roleName: roleName
    description: description
    type: 'customRole'
    permissions: [
      {
        actions: actions
        notActions: notActions
        dataActions: dataActions
        notDataActions: notDataActions
      }
    ]
    assignableScopes: assignableScopes == [] ? array(resourceGroup().id) : assignableScopes
  }
}

@sys.description('The GUID of the Role Definition')
output name string = roleDefinition.name

@sys.description('The scope this Role Definition applies to')
output scope string = resourceGroup().id

@sys.description('The resource ID of the Role Definition')
output resourceId string = roleDefinition.id

@sys.description('The name of the resource group the role definition was created at')
output resourceGroupName string = resourceGroup().name
