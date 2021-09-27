resource resourceGroupDoNotDelete 'Microsoft.Authorization/locks@2016-09-01' = {
  name: 'resourceGroupDoNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
}