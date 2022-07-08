@description('Conditional. The custom domain name. Required if the template is used in a standalone deployment.')
param name string

@description('Conditional. The name of the parent Static Web App. Required if the template is used in a standalone deployment.')
param staticSiteName string

@description('Optional. Validation method for adding a custom domain.')
param validationMethod string = 'cname-delegation'

resource staticSite 'Microsoft.Web/staticSites@2022-03-01' existing = {
  name: staticSiteName
}

resource customDomain 'Microsoft.Web/staticSites/customDomains@2022-03-01' = {
  name: name
  parent: staticSite
  properties: {
    validationMethod: validationMethod
  }
}

@description('The name of the static site.')
output name string = customDomain.name

@description('The resource ID of the static site.')
output resourceId string = customDomain.id

@description('The resource group the static site was deployed into.')
output resourceGroupName string = resourceGroup().name
