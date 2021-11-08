@description('Required. The name of the action group.')
param actionGroupName string

@description('Required. The short name of the action group.')
param groupShortName string

@description('Optional. Indicates whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications.')
param enabled bool = true

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. The list of email receivers that are part of this action group.')
param emailReceivers array = []

@description('Optional. The list of SMS receivers that are part of this action group.')
param smsReceivers array = []

@description('Optional. The list of webhook receivers that are part of this action group.')
param webhookReceivers array = []

@description('Optional. The list of ITSM receivers that are part of this action group.')
param itsmReceivers array = []

@description('Optional. The list of AzureAppPush receivers that are part of this action group.')
param azureAppPushReceivers array = []

@description('Optional. The list of AutomationRunbook receivers that are part of this action group.')
param automationRunbookReceivers array = []

@description('Optional. The list of voice receivers that are part of this action group.')
param voiceReceivers array = []

@description('Optional. The list of logic app receivers that are part of this action group.')
param logicAppReceivers array = []

@description('Optional. The list of function receivers that are part of this action group.')
param azureFunctionReceivers array = []

@description('Optional. The list of ARM role receivers that are part of this action group. Roles are Azure RBAC roles and only built-in roles are supported.')
param armRoleReceivers array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Location for all resources.')
param location string = 'global'

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource actionGroup 'microsoft.insights/actionGroups@2019-06-01' = {
  name: actionGroupName
  location: location
  tags: tags
  properties: {
    groupShortName: groupShortName
    enabled: enabled
    emailReceivers: (empty(emailReceivers) ? json('null') : emailReceivers)
    smsReceivers: (empty(smsReceivers) ? json('null') : smsReceivers)
    webhookReceivers: (empty(webhookReceivers) ? json('null') : webhookReceivers)
    itsmReceivers: (empty(itsmReceivers) ? json('null') : itsmReceivers)
    azureAppPushReceivers: (empty(azureAppPushReceivers) ? json('null') : azureAppPushReceivers)
    automationRunbookReceivers: (empty(automationRunbookReceivers) ? json('null') : automationRunbookReceivers)
    voiceReceivers: (empty(voiceReceivers) ? json('null') : voiceReceivers)
    logicAppReceivers: (empty(logicAppReceivers) ? json('null') : logicAppReceivers)
    azureFunctionReceivers: (empty(azureFunctionReceivers) ? json('null') : azureFunctionReceivers)
    armRoleReceivers: (empty(armRoleReceivers) ? json('null') : armRoleReceivers)
  }
}

module actionGroup_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: actionGroup.name
  }
}]

output deploymentResourceGroup string = resourceGroup().name
output actionGroupName string = actionGroup.name
output actionGroupResourceId string = actionGroup.id
