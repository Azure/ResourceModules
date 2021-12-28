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

resource lock 'Microsoft.Authorization/locks@2016-09-01' = if (level != 'NotSpecified') {
  name: lockName
  properties: {
    level: level
    notes: lockNotes[level]
  }
}

@description('The resource ID of the lock')
output lockResourceId string = lock.id
@description('The name of the lock')
output lockName string = lock.name
