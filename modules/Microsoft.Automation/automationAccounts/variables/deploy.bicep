@sys.description('Conditional. The name of the parent Automation Account. Required if the template is used in a standalone deployment.')
param automationAccountName string

@sys.description('Required. The name of the variable.')
param name string

@sys.description('Required. The value of the variable.')
param value string

@sys.description('Optional. The description of the variable.')
param description string = ''

@sys.description('Optional. If the variable should be encrypted. For security reasons encryption of variables should be enabled.')
param isEncrypted bool = true

@sys.description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
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

@sys.description('The name of the deployed variable.')
output name string = variable.name

@sys.description('The resource ID of the deployed variable.')
output resourceId string = variable.id

@sys.description('The resource group of the deployed variable.')
output resourceGroupName string = resourceGroup().name
