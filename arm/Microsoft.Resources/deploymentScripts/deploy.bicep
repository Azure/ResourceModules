@description('Required. Display name of the script to be run.')
param scriptName string

@description('Required. Name of the User Assigned Identity to be used to deploy Image Templates in Azure Image Builder.')
param userMsiName string

@description('Optional. Resource group of the user assigned identity.')
param userMsiResourceGroup string = resourceGroup().name

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Type of the script. AzurePowerShell, AzureCLI.')
@allowed([
  'AzurePowerShell'
  'AzureCLI'
])
param kind string = 'AzurePowerShell'

@description('Optional. Azure PowerShell module version to be used.')
param azPowerShellVersion string = '3.0'

@description('Optional. Azure CLI module version to be used.')
param azCliVersion string = ''

@description('Optional. Script body. Max length: 32000 characters. To run an external script, use primaryScriptURI instead.')
param scriptContent string = ''

@description('Optional. Uri for the external script. This is the entry point for the external script. To run an internal script, use the scriptContent instead.')
param primaryScriptUri string = ''

@description('Optional. The environment variables to pass over to the script. Must have a \'name\' and a \'value\' or a \'secretValue\' property.')
param environmentVariables array = []

@description('Optional. List of supporting files for the external script (defined in primaryScriptUri). Does not work with internal scripts (code defined in scriptContent).')
param supportingScriptUris array = []

@description('Optional. Command line arguments to pass to the script. Arguments are separated by spaces.')
param arguments string = ''

@description('Optional. Interval for which the service retains the script resource after it reaches a terminal state. Resource will be deleted when this duration expires. Duration is based on ISO 8601 pattern (for example P7D means one week).')
param retentionInterval string = 'P1D'

@description('Optional. When set to false, script will run every time the template is deployed. When set to true, the script will only run once.')
param runOnce bool = false

@description('Optional. The clean up preference when the script execution gets in a terminal state. Specify the preference on when to delete the deployment script resources. The default value is Always, which means the deployment script resources are deleted despite the terminal state (Succeeded, Failed, canceled).')
@allowed([
  'Always'
  'OnSuccess'
  'OnExpiration'
])
param cleanupPreference string = 'Always'

@description('Optional. Container group name, if not specified then the name will get auto-generated. Not specifying a \'containerGroupName\' indicates the system to generate a unique name which might end up flagging an Azure Policy as non-compliant. Use \'containerGroupName\' when you have an Azure Policy that expects a specific naming convention or when you want to fully control the name. \'containerGroupName\' property must be between 1 and 63 characters long, must contain only lowercase letters, numbers, and dashes and it cannot start or end with a dash and consecutive dashes are not allowed.')
param containerGroupName string = ''

@description('Optional. Maximum allowed script execution time specified in ISO 8601 format. Default value is PT1H - 1 hour; \'PT30M\' - 30 minutes; \'P5D\' - 5 days; \'P1Y\' 1 year.')
param timeout string = 'PT1H'

@description('Generated. Do not provide a value! This date value is used to make sure the script run every time the template is deployed.')
param baseTime string = utcNow('yyyy-MM-dd-HH-mm-ss')

@description('Optional. Switch to lock Resource from deletion.')
param lockForDeletion bool = false

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var containerSettings = {
  containerGroupName: containerGroupName
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource dpeloymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: scriptName
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId(userMsiResourceGroup, 'Microsoft.ManagedIdentity/userAssignedIdentities', userMsiName)}': {}
    }
  }
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: ((kind == 'AzurePowerShell') ? azPowerShellVersion : json('null'))
    azCliVersion: ((kind == 'AzureCLI') ? azCliVersion : json('null'))
    containerSettings: (empty(containerGroupName) ? json('null') : containerSettings)
    arguments: arguments
    environmentVariables: (empty(environmentVariables) ? json('null') : environmentVariables)
    scriptContent: (empty(scriptContent) ? json('null') : scriptContent)
    primaryScriptUri: (empty(primaryScriptUri) ? json('null') : primaryScriptUri)
    supportingScriptUris: (empty(supportingScriptUris) ? json('null') : supportingScriptUris)
    cleanupPreference: cleanupPreference
    forceUpdateTag: (runOnce ? resourceGroup().name : baseTime)
    retentionInterval: retentionInterval
    timeout: timeout
  }
}

resource dpeloymentScript_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${dpeloymentScript.name}-doNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: dpeloymentScript
}

output deploymentScriptResourceId string = dpeloymentScript.id
output deploymentScriptResourceGroup string = resourceGroup().name
output deploymentScriptName string = dpeloymentScript.name
