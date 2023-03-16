@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Event Grid Domain to create.')
param eventGridDomainname string

resource domain 'Microsoft.EventGrid/domains@2022-06-15' = {
  name: eventGridDomainname
  location: location
}

@description('The resource ID of the created Event Grid Domain.')
output eventGridDomainResourceId string = domain.id

@description('The name the created Event Grid Domain.')
output eventGridDomainName string = domain.name
