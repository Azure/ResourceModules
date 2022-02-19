@description('Optional. The name of the Lock')
param name string = ''

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Set lock level.')
param level string = 'NotSpecified'

var lockNotes = {
  CanNotDelete: 'Cannot delete resource or child resources.'
  ReadOnly: 'Cannot modify the resource or child resources.'
}

var lockName = empty(name) ? '${level}-lock' : name

resource lock 'Microsoft.Authorization/locks@2017-04-01' = if (level != 'NotSpecified') {
  name: lockName
  properties: {
    level: level
    notes: lockNotes[level]
  }
}

@description('The resource ID of the lock')
output resourceId string = lock.id

@description('The name of the lock')
output name string = lock.name
