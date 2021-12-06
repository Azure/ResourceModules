param registrationDefinitionId string
param registrationAssignmentId string

resource registrationAssignment 'Microsoft.ManagedServices/registrationAssignments@2019-09-01' = {
  name: registrationAssignmentId
  properties: {
    registrationDefinitionId: registrationDefinitionId
  }
}

@description('The name of the registration assignment')
output registrationAssignmentName string = registrationAssignment.name
@description('The resource ID of the registration assignment')
output registrationAssignmentId string = registrationAssignment.id
