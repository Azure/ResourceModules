@description('Required. Name for the container group.')
param containergroupname string

@description('Required. Name for the container.')
param containername string

@description('Required. Name of the image.')
param image string

@description('Optional. Port to open on the container and the public IP address.')
param ports array = [
  {
    name: 'Tcp'
    value: '443'
  }
]

@description('Optional. The number of CPU cores to allocate to the container.')
param cpuCores int = 2

@description('Optional. The amount of memory to allocate to the container in gigabytes.')
param memoryInGB int = 2

@description('Optional. The operating system type required by the containers in the container group. - Windows or Linux.')
param osType string = 'Linux'

@description('Optional. Restart policy for all containers within the container group. - Always: Always restart. OnFailure: Restart on failure. Never: Never restart. - Always, OnFailure, Never')
param restartPolicy string = 'Always'

@description('Optional. Specifies if the IP is exposed to the public internet or private VNET. - Public or Private')
param ipAddressType string = 'Public'

@description('Optional. The image registry credentials by which the container group is created from.')
param imageRegistryCredentials array = []

@description('Optional. Envrionment variables of the container group.')
param environmentVariables array = []

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Switch to lock resource from deletion.')
param lockForDeletion bool = false

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource containergroup 'Microsoft.ContainerInstance/containerGroups@2021-03-01' = {
  name: containergroupname
  location: location
  tags: tags
  properties: {
    containers: [
      {
        name: containername
        properties: {
          command: []
          image: image
          ports: ports
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryInGB
            }
          }
          environmentVariables: environmentVariables
        }
      }
    ]
    imageRegistryCredentials: imageRegistryCredentials
    restartPolicy: restartPolicy
    osType: osType
    ipAddress: {
      type: ipAddressType
      ports: ports
    }
  }
}

resource containergroup_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${containergroup.name}-DoNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: containergroup
}

output containerGroupName string = containergroup.name
output containerGroupResourceId string = containergroup.id
output containerGroupResourceGroup string = resourceGroup().name
output containerGroupIPv4Address string = containergroup.properties.ipAddress.ip
