param resourceId_Microsoft_ManagedServices_registrationDefinitions_variables_registrationDefinitionId string
param variables_assignmentId ? /* TODO: fill in correct type */

resource variables_assignmentId_resource 'Microsoft.ManagedServices/registrationAssignments@2019-06-01' = {
  name: variables_assignmentId
  properties: {
    registrationDefinitionId: resourceId_Microsoft_ManagedServices_registrationDefinitions_variables_registrationDefinitionId
  }
}