@sys.description('Required. Name of the parent Automation Account')
param automationAccountName string

@sys.description('Required. The name of the variable.')
param name string

@sys.description('Required. The value of the variable.')
param value string

@sys.description('Optional. The description of the variable.')
param description string = ''

@sys.description('Optional. If the variable should be encrypted.')
param isEncrypted bool = false

@sys.description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2021-06-22' existing = {
  name: automationAccountName
}

resource variable 'Microsoft.Automation/automationAccounts/variables@2020-01-13-preview' = {
  name: name
  parent: automationAccount
  properties: {
    description: description
    isEncrypted: isEncrypted
    value: value
  }
}

@sys.description('The name of the deployed variable')
output variableName string = variable.name

@sys.description('The resource ID of the deployed variable')
output variableResourceId string = variable.id

@sys.description('The resource group of the deployed variable')
output variableResourceGroup string = resourceGroup().name
