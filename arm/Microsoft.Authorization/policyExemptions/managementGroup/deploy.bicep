targetScope = 'managementGroup'

@sys.description('Required. Specifies the name of the policy exemption. Maximum length is 64 characters for management group scope.')
@maxLength(64)
param name string

@sys.description('Optional. The display name of the policy assignment. Maximum length is 128 characters.')
@maxLength(128)
param displayName string = ''

@sys.description('Optional. The description of the policy exemption.')
param description string = ''

@sys.description('Optional. The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@sys.description('Optional. The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated')
@allowed([
  'Mitigated'
  'Waiver'
])
param exemptionCategory string = 'Mitigated'

@sys.description('Required. The resource ID of the policy assignment that is being exempted.')
param policyAssignmentId string

@sys.description('Optional. The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.')
param policyDefinitionReferenceIds array = []

@sys.description('Optional. The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z ')
param expiresOn string = ''

@sys.description('Optional. The group ID of the management group to be exempted from the policy assignment. If not provided, will use the current scope for deployment.')
param managementGroupId string = managementGroup().name

resource policyExemption 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: name
  properties: {
    displayName: !empty(displayName) ? displayName : null
    description: !empty(description) ? description : null
    metadata: !empty(metadata) ? metadata : null
    exemptionCategory: exemptionCategory
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceIds: !empty(policyDefinitionReferenceIds) ? policyDefinitionReferenceIds : []
    expiresOn: !empty(expiresOn) ? expiresOn : null
  }
}

@sys.description('Policy Exemption Name')
output name string = policyExemption.name

@sys.description('Policy Exemption resource ID')
output resourceId string = extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', managementGroupId), 'Microsoft.Authorization/policyExemptions', policyExemption.name)

@sys.description('Policy Exemption Scope')
output scope string = tenantResourceId('Microsoft.Management/managementGroups', managementGroupId)
