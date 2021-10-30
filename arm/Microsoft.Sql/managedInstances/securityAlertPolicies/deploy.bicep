@description('The name of the security alert policy')
param name string

@description('Name of the resource.')
param managedInstanceName string

@description('Optional. Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided.')
@allowed([
  'Enabled'
  'Disabled'
])
param state string = 'Disabled'

@description('Optional. Specifies that the schedule scan notification will be is sent to the subscription administrators.')
param emailAccountAdmins bool = false

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource securityAlertPolicy 'Microsoft.Sql/managedInstances/securityAlertPolicies@2017-03-01-preview' = {
  name: '${managedInstanceName}/${name}'
  properties: {
    state: state
    emailAccountAdmins: emailAccountAdmins
  }
}

@description('The name of the deployed security alert policy')
output securityAlertPolicyName string = securityAlertPolicy.name

@description('The resourceId of the deployed security alert policy')
output securityAlertPolicyResourceId string = securityAlertPolicy.id

@description('The resource group of the deployed security alert policy')
output securityAlertPolicyResourceGroupName string = resourceGroup().name
