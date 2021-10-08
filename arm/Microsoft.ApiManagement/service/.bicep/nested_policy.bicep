@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string

@description('Optional. Policy content for the Api Management Service. Format: Format of the policyContent. - xml, xml-link, rawxml, rawxml-link. Value: Contents of the Policy as defined by the format.')
param apiManagementServicePolicy object

resource apiManagementServiceName_policy 'Microsoft.ApiManagement/service/policies@2020-06-01-preview' = {
  name: '${apiManagementServiceName}/policy'
  properties: apiManagementServicePolicy
}