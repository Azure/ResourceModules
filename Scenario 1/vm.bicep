targetScope = 'resourceGroup'
@secure()
param username string = 'admsblair'

module virtualMachines '../arm/Microsoft.Compute/virtualMachines/deploy.bicep' = {
  name: 'scenario-vm'

  params: {
    name: 'web01'
    osType: 'Windows'
    vmSize: 'standard_d4ads_v5'
    osDisk: {
      name: 'web01-data'
      createOption: 'FromImage'
      osType: 'Windows'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    adminUsername: username
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2016-Datacenter'
      version: 'latest'
    }
    nicConfigurations: [
      {
        nicSuffix: '-nic-01'
        deleteOption: 'Delete'
        ipConfigurations: [
          {
            name: 'scenario1-nic-config'
            subnetId: '/subscriptions/f90e413f-4282-4ace-8fe7-abbae028363e/resourceGroups/scenario1-rg/providers/Microsoft.Network/virtualNetworks/scenario1-vnet/subnets/vm-subnet'
          }
        ]
      }
    ]
  }
}
