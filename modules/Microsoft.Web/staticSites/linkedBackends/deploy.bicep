@description('Requried. The resource id of the backend linked to the static site.')
param backendResourceId string

@description('Optional. The region of the backend linked to the static site.')
param region string = resourceGroup().location

@description('Conditional. The name of the parent Static Web App. Required if the template is used in a standalone deployment.')
param staticSiteName string

@description('Optional. Name of the backend to link to the static site.')
param linkedBackendName string = uniqueString(backendResourceId)

resource staticSite 'Microsoft.Web/staticSites@2022-03-01' existing = {
  name: staticSiteName
}

resource linkedBackend 'Microsoft.Web/staticSites/linkedBackends@2022-03-01' = {
  name: linkedBackendName
  parent: staticSite
  properties: {
    backendResourceId: backendResourceId
    region: region
  }
}

@description('The name of the static site.')
output name string = linkedBackend.name

@description('The resource ID of the static site.')
output resourceId string = linkedBackend.id

@description('The resource group the static site was deployed into.')
output resourceGroupName string = resourceGroup().name
