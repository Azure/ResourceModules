param variables_runbooks_copyIndex_runbookName ? /* TODO: fill in correct type */
param variables_runbooks_copyIndex_runbookType ? /* TODO: fill in correct type */
param variables_runbooks_copyIndex_runbookScriptUri ? /* TODO: fill in correct type */
param variables_runbooks_copyIndex ? /* TODO: fill in correct type */
param variables_runbooks_copyIndex_scriptStorageAccountId ? /* TODO: fill in correct type */
param variables_accountSasProperties ? /* TODO: fill in correct type */
param variables_runbooks_copyIndex_version ? /* TODO: fill in correct type */

@description('Required. Name of the Automation Account')
param automationAccountName string

resource automationAccountName_variables_runbooks_copyIndex_runbookName_runbookName 'Microsoft.Automation/automationAccounts/runbooks@2018-06-30' = {
  name: '${automationAccountName}/${variables_runbooks_copyIndex_runbookName[copyIndex()].runbookName}'
  location: resourceGroup().location
  properties: {
    runbookType: (empty(variables_runbooks_copyIndex_runbookType[copyIndex()].runbookType) ? json('null') : variables_runbooks_copyIndex_runbookType[copyIndex()].runbookType)
    publishContentLink: {
      uri: (empty(variables_runbooks_copyIndex_runbookScriptUri[copyIndex()].runbookScriptUri) ? json('null') : concat(variables_runbooks_copyIndex_runbookScriptUri[copyIndex()].runbookScriptUri, (contains(variables_runbooks_copyIndex[copyIndex()], 'scriptStorageAccountId') ? '?${listAccountSas(variables_runbooks_copyIndex_scriptStorageAccountId[copyIndex()].scriptStorageAccountId, '2019-04-01', variables_accountSasProperties).accountSasToken}' : '')))
      version: (empty(variables_runbooks_copyIndex_version[copyIndex()].version) ? json('null') : variables_runbooks_copyIndex_version[copyIndex()].version)
    }
  }
}