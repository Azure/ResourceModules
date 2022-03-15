targetScope = 'resourceGroup'
@secure()
param username string = 'admsblair'

module virtualMachines '../arm/Microsoft.Compute/virtualMachines/deploy.bicep' = {
  name: 'scenario-vm'

  params: {
    name: 'web01'
    osType: 'Windows'
    osDisk: {
      name: 'web01-data'
      createOption: 'FromImage'
      osType: 'Windows'
      diskSizeGB: '128GB'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    adminUsername: username
    imageReference: {
      publisher: 'WindowsServer'
      sku: '2016-Datacenter'
      version: 'latest'
    }
    nicConfigurations: [
      {
        nicSuffix: '-nic-01'
        deleteOption: 'Delete'
      }
    ]
  }
}
