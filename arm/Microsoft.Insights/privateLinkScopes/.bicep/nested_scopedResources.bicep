param privateLinkScopeName string
param scopedResource object

resource nested_scopedResource 'microsoft.insights/privatelinkscopes/scopedresources@2019-10-17-preview' = {
  name: '${privateLinkScopeName}/scoped-${last(split(scopedResource.linkedResourceId, '/'))}-${guid(uniqueString(privateLinkScopeName, scopedResource.linkedResourceId))}'
  properties: {
    linkedResourceId: scopedResource.linkedResourceId
  }
}
