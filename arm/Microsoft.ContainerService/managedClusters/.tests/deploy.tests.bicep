// Module tests

// Test with only required parameters
module test_required_params '../deploy.bicep' = {
  name: 'test_required_params'
  params: {
    name: 'akstest001'
    aksClusterKubernetesVersion: '1.21.2'
    primaryAgentPoolProfile: [
      {
        name: 'systempool'
        osDiskSizeGB: 0
        count: 3
        enableAutoScaling: true
        minCount: 3
        maxCount: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        vnetSubnetID: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-sxx-az-vnet-x-aks/subnets/Primary'
        serviceCidr: ''
        maxPods: 50
        availabilityZones: [
          '1'
        ]
      }
    ]
  }
}
