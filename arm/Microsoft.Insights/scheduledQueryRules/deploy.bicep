@description('Required. The name of the Alert.')
param alertName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Description of the alert.')
param alertDescription string = ''

@description('Optional. Indicates whether this alert is enabled.')
param enabled bool = true

@description('Optional. Indicates the type of scheduled query rule.')
@allowed([
  'LogAlert'
  'LogToMetric'
])
param kind string = 'LogAlert'

@description('Optional. The flag that indicates whether the alert should be automatically resolved or not. Relevant only for rules of the kind LogAlert.')
param autoMitigate bool = true

@description('Optional. If specified then overrides the query time range. Relevant only for rules of the kind LogAlert.')
param queryTimeRange string = 'WindowSize*NumberOfEvaluationPeriods'

@description('Optional. The flag which indicates whether the provided query should be validated or not. Relevant only for rules of the kind LogAlert.')
param skipQueryValidation bool = false

param targetResourceTypes array = []

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Required. Resource ID of the Log Analytics workspace where the query needs to be executed')
param workspaceResourceId string

@description('Optional. The severity of the alert.')
@allowed([
  0
  1
  2
  3
  4
])
param severity int = 3

@description('Optional. How often the scheduled query rule is evaluated represented in ISO 8601 duration format. Relevant and required only for rules of the kind LogAlert.')
param evaluationFrequency string = ''

@description('Optional. The period of time (in ISO 8601 duration format) on which the Alert query will be executed (bin size). Relevant and required only for rules of the kind LogAlert.')
param windowSize string = ''

@description('Optional. The list of actions to take when alert triggers.')
param actions array = []

@description('Optional. The rule criteria that defines the conditions of the scheduled query rule.')
param criterias object = {}

@description('Optional. Mute actions for the chosen period of time (in ISO 8601 duration format) after the alert is fired. Relevant only for rules of the kind LogAlert.')
param suppressForMinutes string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource queryAlert 'Microsoft.Insights/scheduledQueryRules@2021-02-01-preview' = {
  name: alertName
  location: location
  tags: tags
  kind: kind
  properties: {
    actions: {
      actionGroups: actions
      customProperties: {}
    }
    autoMitigate: contains(kind, 'LogAlert') ? autoMitigate : null
    criteria: criterias

    description: alertDescription
    displayName: alertName
    enabled: enabled
    evaluationFrequency: contains(kind, 'LogAlert') ? evaluationFrequency : ''
    muteActionsDuration: contains(kind, 'LogAlert') ? suppressForMinutes : ''
    overrideQueryTimeRange: contains(kind, 'LogAlert') ? queryTimeRange: ''
    scopes: [
      workspaceResourceId
    ]
    severity: contains(kind, 'LogAlert') ? severity : null
    skipQueryValidation: contains(kind, 'LogAlert') ? skipQueryValidation : null
    targetResourceTypes: contains(kind, 'LogAlert') ? targetResourceTypes : null
    windowSize: contains(kind, 'LogAlert') ? windowSize : ''
  }
}


module queryAlert_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: queryAlert.name
  }
}]

output queryAlertName string = queryAlert.name
output queryAlertResourceId string = queryAlert.id
output deploymentResourceGroup string = resourceGroup().name
