@description('Required. The name of the alert.')
param name string

@description('Optional. Description of the alert.')
param alertDescription string = ''

@description('Optional. Location for all resources.')
param location string = 'global'

@description('Optional. Indicates whether this alert is enabled.')
param enabled bool = true

@description('Required. the list of resource IDs that this metric alert is scoped to.')
param scopes array = [
  subscription().id
]

@description('Optional. The list of actions to take when alert triggers.')
param actions array = []

@description('Required. The condition that will cause this alert to activate. Array of objects')
param conditions array

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

var actionGroups = [for action in actions: {
  actionGroupId: contains(action, 'actionGroupId') ? action.actionGroupId : action
  webhookProperties: contains(action, 'webhookProperties') ? action.webhookProperties : null
}]

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource activityLogAlert 'Microsoft.Insights/activityLogAlerts@2020-10-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    scopes: scopes
    condition: {
      allOf: conditions
    }
    actions: {
      actionGroups: actionGroups
    }
    enabled: enabled
    description: alertDescription
  }
}

module activityLogAlert_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-ActivityLogAlert-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: activityLogAlert.id
  }
}]

@description('The name of the activity log alert')
output activityLogAlertName string = activityLogAlert.name

@description('The resource ID of the activity log alert')
output activityLogAlertResourceId string = activityLogAlert.id

@description('The resource group the activity log alert was deployed into')
output activityLogAlertResourceGroup string = resourceGroup().name
