@description('Required. The ID of the resource to apply the lock to.')
param resourceId string

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

resource virtualGatewayPublicIP 'Microsoft.Network/publicIPAddresses@2021-05-01' existing = {
  name: last(split(resourceId, '/'))
}

resource privateLinkScope_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${last(split(resourceId, '/'))}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: virtualGatewayPublicIP
}
