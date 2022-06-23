var location = 'westeurope'

module fullRedisCacheDeployment '../deploy.bicep' = {
  name: 'fullRedisCacheDeployment'
  params: {
    name: 'redis01'
    location: location
    capacity: 2
    diagnosticLogCategoriesToEnable: [
      'ApplicationGatewayAccessLog'
      'ApplicationGatewayFirewallLog'
    ]
    diagnosticMetricsToEnable: [
      'AllMetrics'
    ]
    enableNonSslPort: true
    family: 'P'
    lock: 'CanNotDelete'
    minimumTlsVersion: '1.2'
    diagnosticSettingsName: 'redisdiagnostics'
    publicNetworkAccess: 'Enabled'
    redisVersion: '6'
    skuName: 'Premium'
    systemAssignedIdentity: true
    shardCount: 1
    tags: {
      purpose: 'test'
    }
    enableDefaultTelemetry: false
  }
}
