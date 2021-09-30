param runbookName string
param runbookType string
param runbookScriptUri string
param scriptStorageAccountId string
param accountSasProperties object
param version string
param automationAccountName string

resource runbook 'Microsoft.Automation/automationAccounts/runbooks@2018-06-30' = {
  name: '${automationAccountName}/${runbookName}'
  location: resourceGroup().location
  properties: {
    runbookType: (empty(runbookType) ? json('null') : runbookType)
    publishContentLink: {
      uri: (empty(runbookScriptUri) ? json('null') : (empty(scriptStorageAccountId) ? '${runbookScriptUri}' : '${runbookScriptUri}${listAccountSas(scriptStorageAccountId, '2019-04-01', accountSasProperties).accountSasToken}'))
      version: (empty(version) ? json('null') : version)
    }
  }
}

