module linux '../deploy.bicep' = {
  name: 'linux'
  params: {
    name: 'linux-scaleset'
    vmNamePrefix: 'vmsslinvm'
    skuName: 'Standard_B2s'
    skuCapacity: 1
    upgradePolicyMode: 'Manual'
    vmPriority: 'Regular'
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    availabilityZones: [
      '2'
    ]
    scaleSetFaultDomain: 1
    systemAssignedIdentity: true
    extensionMonitoringAgentConfig: {
      enabled: true
    }
    bootDiagnosticStorageAccountName: 'adpsxxazsaweux001'
    osType: 'Linux'
    imageReference: {
      publisher: 'Canonical'
      offer: 'UbuntuServer'
      sku: '18.04-LTS'
      version: 'latest'
    }
    adminUsername: 'scaleSetAdmin'
    disablePasswordAuthentication: true
    publicKeys: [
      {
        path: '/home/scaleSetAdmin/.ssh/authorized_keys'
        keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdOir5eO28EBwxU0Dyra7g9h0HUXDyMNFp2z8PhaTUQgHjrimkMxjYRwEOG/lxnYL7+TqZk+HcPTfbZOunHBw0Wx2CITzILt6531vmIYZGfq5YyYXbxZa5MON7L/PVivoRlPj5Z/t4RhqMhyfR7EPcZ516LJ8lXPTo8dE/bkOCS+kFBEYHvPEEKAyLs19sRcK37SeHjpX04zdg62nqtuRr00Tp7oeiTXA1xn5K5mxeAswotmd8CU0lWUcJuPBWQedo649b+L2cm52kTncOBI6YChAeyEc1PDF0Tn9FmpdOWKtI9efh+S3f8qkcVEtSTXoTeroBd31nzjAunMrZeM8Ut6dre+XeQQIjT7I8oEm+ZkIuIyq0x2fls8JXP2YJDWDqu8v1+yLGTQ3Z9XVt2lMti/7bIgYxS0JvwOr5n5L4IzKvhb4fm13LLDGFa3o7Nsfe3fPb882APE0bLFCmfyIeiPh7go70WqZHakpgIr6LCWTyePez9CsI/rfWDb6eAM8= generated-by-azure'
      }
    ]
    dataDisks: [
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: 256
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    nicConfigurations: [
      {
        nicSuffix: '-nic01'
        ipConfigurations: [
          {
            name: 'ipconfig01'
            properties: {
              subnet: {
                id: '/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/dependencies-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-002/subnets/sxx-az-subnet-weu-x-002'
              }
            }
          }
        ]
      }
    ]
    roleAssignments: []
  }
}
