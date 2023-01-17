@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Event Grid Topic to create.')
param eventTopicName string

@description('Required. The name of the Service Bus Namespace to create.')
param serviceBusName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

resource eventTopic 'Microsoft.EventGrid/topics@2022-06-15' = {
    name: eventTopicName
    location: location
    properties:{
        disableLocalAuth: false
        publicNetworkAccess: 'Enabled'
    }
    identity: {
        type: 'UserAssigned'
        userAssignedIdentities: {
            '${managedIdentity.id}': {}
        }
    }
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
    name: serviceBusName
    location: location
    properties: {
        sku: {
            name: 'Standard'
            tier: 'Standard'
            capacity: 1
        }
        zoneRedundant: false
    }

    resource topic 'topics@2021-11-01' = {
        name: 'topic1'
        properties:{
            maxSizeInMegabytes: 1024
            requiresDuplicateDetection: false
            defaultMessageTimeToLive: 'P10675199DT2H48M5.4775807S'
            duplicateDetectionHistoryTimeWindow: 'PT10M'
            enableBatchedOperations: true
            status: 'Active'
            autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
        }
    }
}


@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Event Grid Topic.')
output eventTopicResourceId string = eventTopic.id

@description('The resource ID of the created Service Bus Topic.')
output serviceBusTopicResourceId string = serviceBusNamespace::topic.id
