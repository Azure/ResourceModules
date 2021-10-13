param registrationDefinitionId string
param registrationAssignmentId string

resource registrationAssignment 'Microsoft.ManagedServices/registrationAssignments@2019-09-01' = {
  name: registrationAssignmentId
  properties: {
    registrationDefinitionId: registrationDefinitionId
  }
}

output registrationAssignmentName string = registrationAssignment.name
output registrationAssignmentId string = registrationAssignment.id
