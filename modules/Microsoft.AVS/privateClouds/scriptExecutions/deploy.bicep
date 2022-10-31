// ============== //
//   Parameters   //
// ============== //

@description('Required. Name of the user-invoked script execution resource')
param name string

@description('Conditional. The name of the parent privateClouds. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Error message if the script was able to run, but if the script itself had errors or powershell threw an exception')
param failureReason string = ''

@description('Optional. Parameters that will be hidden/not visible to ARM, such as passwords and credentials')
param hiddenParameters array = []

@description('Optional. User-defined dictionary.')
param namedOutputs object = {}

@description('Optional. Standard output stream from the powershell execution')
param output array = []

@description('Optional. Parameters the script will accept')
param parameters array = []

@description('Optional. Time to live for the resource. If not provided, will be available for 60 days')
param retention string = ''

@description('Optional. A reference to the script cmdlet resource if user is running a AVS script')
param scriptCmdletId string = ''

@description('Optional. Time limit for execution')
param timeout string = ''

// =============== //
//   Deployments   //
// =============== //

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

resource privateCloud 'Microsoft.AVS/privateClouds@2022-05-01' existing = {
  name: privateCloudName
}

resource scriptExecution 'Microsoft.AVS/privateClouds/scriptExecutions@2022-05-01' = {
  parent: privateCloud
  name: name
  properties: {
    failureReason: failureReason
    hiddenParameters: hiddenParameters
    namedOutputs: namedOutputs
    output: output
    parameters: parameters
    retention: retention
    scriptCmdletId: scriptCmdletId
    timeout: timeout
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the scriptExecution.')
output name string = scriptExecution.name

@description('The resource ID of the scriptExecution.')
output resourceId string = scriptExecution.id

@description('The name of the resource group the scriptExecution was created in.')
output resourceGroupName string = resourceGroup().name
