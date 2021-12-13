var managedIdentityParameters = {
  name: 'adp-sxx-msi-${serviceShort}-01'
}
// Modules //
module managedIdentity '../../../../../arm/Microsoft.ManagedIdentity/userAssignedIdentities/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-mi'
  params: {
    name: managedIdentityParameters.name
  }
  dependsOn: [
    resourceGroup
  ]
}
// Output //
output managedIdentityResourceId string = managedIdentity.outputs.msiResourceId
