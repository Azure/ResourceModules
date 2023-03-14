@sys.description('Required. The resource ID of the resource to apply the policy exemption to.')
param resourceId string

@sys.description('Required. Specifies the name of the policy exemption. Maximum length is 64 characters.')
@maxLength(64)
param name string

@sys.description('Optional. The display name of the policy exemption. Maximum length is 128 characters.')
@maxLength(128)
param displayName string = ''

@sys.description('Optional. The description of the policy exemption.')
param description string = ''

@sys.description('Optional. The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@sys.description('Optional. The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated.')
@allowed([
  'Mitigated'
  'Waiver'
])
param exemptionCategory string = 'Mitigated'

@sys.description('Required. The resource ID of the policy assignment that is being exempted.')
param policyAssignmentId string

@sys.description('Optional. The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.')
param policyDefinitionReferenceIds array = []

@sys.description('Optional. The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z.')
param expiresOn string = ''

@sys.description('Optional. The option whether validate the exemption is at or under the assignment scope.')
@allowed([
  ''
  'Default'
  'DoNotValidate'
])
param assignmentScopeValidation string = ''

@sys.description('Optional. The resource selector list to filter policies by resource properties.')
param resourceSelectors array = []

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: last(split(resourceId, '/'))!
}

resource policyExemption 'Microsoft.Authorization/policyExemptions@2022-07-01-preview' = {
  name: name
  properties: {
    assignmentScopeValidation: !empty(assignmentScopeValidation) ? assignmentScopeValidation : null
    displayName: !empty(displayName) ? displayName : null
    description: !empty(description) ? description : null
    exemptionCategory: exemptionCategory
    expiresOn: !empty(expiresOn) ? expiresOn : null
    metadata: !empty(metadata) ? metadata : null
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceIds: !empty(policyDefinitionReferenceIds) ? policyDefinitionReferenceIds : null
    resourceSelectors: resourceSelectors
  }
  scope: storageAccount
}
