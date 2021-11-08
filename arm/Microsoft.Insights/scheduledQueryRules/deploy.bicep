@description('Required. The name of the Alert.')
param alertName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Description of the alert.')
param alertDescription string = ''

@description('Optional. Indicates whether this alert is enabled.')
@allowed([
  'true'
  'false'
])
param enabled string = 'true'

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

@description('Optional. How often the metric alert is evaluated (in minutes).')
@allowed([
  5
  10
  15
  30
  45
  60
  120
  180
  240
  300
  360
  1440
])
param evaluationFrequency int = 5

@description('Optional. The period of time (in minutes) that is used to monitor alert activity based on the threshold.')
@allowed([
  5
  10
  15
  30
  45
  60
  120
  180
  240
  300
  360
  1440
  2880
])
param windowSize int = 60

@description('Optional. The list of resource id\'s referenced in the query.')
param authorizedResources array = []

@description('Optional. The query to execute')
param query string = ''

@description('Optional. Operator of threshold breaches to trigger the alert.')
@allowed([
  'GreaterThan'
  'Equal'
  'LessThan'
])
param metricResultCountThresholdOperator string = 'GreaterThan'

@description('Optional. Operator for metric or number of result evaluation.')
@minValue(0)
@maxValue(10000)
param metricResultCountThreshold int = 0

@description('Optional. Variable (column) on which the query result will be grouped and then evaluated for trigger condition. Use comma to specify more than one. Leave empty to use "Number of results" type of alert logic')
param metricColumn string = ''

@description('Optional. If `metricColumn` is specified, operator for the breaches count evaluation to trigger the alert. Not used if using result count trigger.')
@allowed([
  'GreaterThan'
  'Equal'
  'LessThan'
])
param breachesThresholdOperator string = 'GreaterThan'

@description('Optional. Type of aggregation of threadshold violation')
@allowed([
  'Consecutive'
  'Total'
])
param breachesTriggerType string = 'Consecutive'

@description('Optional. Number of threadshold violation to trigger the alert')
@minValue(0)
@maxValue(10000)
param breachesThreshold int = 3

@description('Optional. The list of actions to take when alert triggers.')
param actions array = []

@description('Optional. The list of action alert creterias.')
param criterias array = []

@description('Optional. Type of the alert criteria.')
@allowed([
  'AlertingAction'
  'LogToMetricAction'
])
param odataType string = 'AlertingAction'

@description('Optional. Suppress Alert for (in minutes).')
param suppressForMinutes int = 0

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var metricTrigger = {
  metricColumn: metricColumn
  metricTriggerType: breachesTriggerType
  threshold: breachesThreshold
  thresholdOperator: breachesThresholdOperator
}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource queryAlert 'microsoft.insights/scheduledQueryRules@2018-04-16' = {
  name: alertName
  location: location
  tags: tags
  properties: {
    description: alertDescription
    enabled: enabled
    source: {
      query: query
      authorizedResources: authorizedResources
      dataSourceId: workspaceResourceId
      queryType: 'ResultCount'
    }
    schedule: {
      frequencyInMinutes: evaluationFrequency
      timeWindowInMinutes: windowSize
    }
    action: {
      severity: severity
      aznsAction: {
        actionGroup: actions
      }
      throttlingInMin: suppressForMinutes
      trigger: {
        thresholdOperator: metricResultCountThresholdOperator
        threshold: metricResultCountThreshold
        metricTrigger: (empty(metricColumn) ? json('null') : metricTrigger)
      }
      criteria: criterias
      'odata.type': 'Microsoft.WindowsAzure.Management.Monitoring.Alerts.Models.Microsoft.AppInsights.Nexus.DataContracts.Resources.ScheduledQueryRules.${odataType}'
    }
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
