param privateLinkScopeName string
param scopedResource object

var scopedResourceName = last(split(scopedResource.linkedResourceId, '/'))

resource scopedResource_name 'microsoft.insights/privatelinkscopes/scopedresources@2019-10-17-preview' = {
  name: '${privateLinkScopeName}/scoped-${scopedResourceName}-${guid(uniqueString(privateLinkScopeName, scopedResource.linkedResourceId))}'
  properties: {
    linkedResourceId: scopedResource.linkedResourceId
  }
}
