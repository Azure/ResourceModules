module parameters '../deploy.bicep' = {
  name: 'parameters'
  params: {
    name: 'sxx-az-apgw-weu-x-002'
    backendHttpConfigurations: [
      {
        backendHttpConfigurationName: 'appServiceBackendHttpsSetting'
        port: 443
        protocol: 'https'
        cookieBasedAffinity: 'Disabled'
        pickHostNameFromBackendAddress: true
        probeEnabled: false
      }
      {
        backendHttpConfigurationName: 'privateVmHttpSetting'
        port: 80
        protocol: 'http'
        cookieBasedAffinity: 'Disabled'
        pickHostNameFromBackendAddress: false
        probeEnabled: true
      }
    ]
    backendPools: [
      {
        backendPoolName: 'appServiceBackendPool'
        backendAddresses: [
          {
            fqdn: 'aghapp.azurewebsites.net'
          }
        ]
      }
      {
        backendPoolName: 'privateVmBackendPool'
        backendAddresses: [
          {
            ipAddress: '10.0.0.4'
          }
        ]
      }
    ]
    frontendPublicIpResourceId: '/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/dependencies-rg/providers/Microsoft.Network/publicIPAddresses/sxx-az-pip-weu-x-003'
    routingRules: [
      {
        frontendListenerName: 'public443'
        backendPoolName: 'appServiceBackendPool'
        backendHttpConfigurationName: 'appServiceBackendHttpsSetting'
      }
      {
        frontendListenerName: 'private4433'
        backendPoolName: 'privateVmBackendPool'
        backendHttpConfigurationName: 'privateVmHttpSetting'
      }
    ]
    subnetName: 'sxx-az-subnet-weu-x-003'
    vNetName: 'sxx-az-vnet-weu-x-003'
  }
}
