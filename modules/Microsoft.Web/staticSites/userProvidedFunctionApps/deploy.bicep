@description('Conditional. The name of the parent Static Web App. Required if the template is used in a standalone deployment.')
param staticSiteName string

@description('Required. The resource id of the function app registered with the static site.')
param functionAppResourceId string

@description('Optional. The region of the function app registered with the static site.')
param functionAppRegion string = resourceGroup().location

resource staticSite 'Microsoft.Web/staticSites@2022-03-01' existing = {
  name: staticSiteName
}

resource userProvidedFunctionApp 'Microsoft.Web/staticSites/userProvidedFunctionApps@2022-03-01' = {
  name: '${staticSite.name}-userProvidedFunctionApp'
  parent: staticSite
  properties: empty(staticSite.properties.userProvidedFunctionApps) ? {
    functionAppRegion: functionAppRegion
    functionAppResourceId: functionAppResourceId
  } : {}
}

@description('The name of the userProvidedFunctionApp setting.')
output name string = userProvidedFunctionApp.name

@description('The resource ID of the userProvidedFunctionApp setting.')
output resourceId string = userProvidedFunctionApp.id

@description('The name of the resource group the userProvidedFunctionApp setting was created in.')
output resourceGroupName string = resourceGroup().name

@description('The functionAppResourceId setting.')
output functionAppResourceId string = userProvidedFunctionApp.properties.functionAppResourceId
