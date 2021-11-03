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

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Application Insights Component Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ae349356-3a1b-4a5e-921d-050484c6347e')
  'Automation Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f353d9bd-d4a6-484e-a77a-8050b599b867')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
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

module queryAlert_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: queryAlert.name
  }
}]

output queryAlertName string = queryAlert.name
output queryAlertResourceId string = queryAlert.id
output deploymentResourceGroup string = resourceGroup().name
