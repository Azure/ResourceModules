@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Event Grid Topic to create.')
param eventTopicName string

@description('Required. The name of the Service Bus Namespace to create.')
param serviceBusName string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
    name: virtualNetworkName
    location: location
    properties: {
        addressSpace: {
            addressPrefixes: [
                '10.0.0.0/24'
            ]
        }
        subnets: [
            {
                name: 'defaultSubnet'
                properties: {
                    addressPrefix: '10.0.0.0/24'
                }
            }
        ]
    }
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
    name: 'privatelink.eventgrid.azure.net'
    location: 'global'

    resource virtualNetworkLinks 'virtualNetworkLinks@2020-06-01' = {
        name: '${virtualNetwork.name}-vnetlink'
        location: 'global'
        properties: {
            virtualNetwork: {
                id: virtualNetwork.id
            }
            registrationEnabled: false
        }
    }
}

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

resource serviceBus 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
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
}

resource serviceBus_Queue 'Microsoft.ServiceBus/namespaces/queues@2021-11-01' = {
    name: '${serviceBus.name}/queue1'
    properties:{
        lockDuration: 'PT1M'
        maxSizeInMegabytes: 1024
        requiresDuplicateDetection: false
        requiresSession: false
        defaultMessageTimeToLive: 'P10675199DT2H48M5.4775807S'
        deadLetteringOnMessageExpiration: false
        duplicateDetectionHistoryTimeWindow: 'PT10M'
        maxDeliveryCount: 10
        enableBatchedOperations: true
        status: 'Active'
        autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    }
}

resource serviceBus_Topic 'Microsoft.ServiceBus/namespaces/topics@2021-11-01' = {
    name: '${serviceBus.name}/topic1'
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

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Private DNS Zone.')
output privateDNSZoneResourceId string = privateDNSZone.id

@description('The resource ID of the created Event Grid Topic.')
output eventTopicId string = eventTopic.id

@description('The resource ID of the created Service Bus Namespace.')
output serviceBusId string = serviceBus.id

@description('The resource ID of the created Service Bus Queue.')
output serviceBusQueueId string = serviceBus_Queue.id

@description('The resource ID of the created Service Bus Topic.')
output serviceBusTopicId string = serviceBus_Topic.id
