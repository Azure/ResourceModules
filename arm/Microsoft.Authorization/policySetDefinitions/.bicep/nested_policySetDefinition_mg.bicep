targetScope = 'managementGroup'

@sys.description('Required. Specifies the name of the policy Set Definition (Initiative). Space characters will be replaced by (-) and converted to lowercase')
@maxLength(64)
param name string

@sys.description('Optional. The display name of the Set Definition (Initiative)')
param displayName string = ''

@sys.description('Optional. The Description name of the Set Definition (Initiative)')
param description string = ''

@sys.description('Required. The group ID of the Management Group (Scope). Cannot be used with subscriptionId and does not support tenant level deployment (i.e. \'/\')')
param managementGroupId string

@sys.description('Optional. The Set Definition (Initiative) metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@sys.description('Required. The array of Policy definitions object to include for this policy set. Each object must include the Policy definition ID, and optionally other properties like parameters')
param policyDefinitions array

@sys.description('Optional. The metadata describing groups of policy definition references within the Policy Set Definition (Initiative).')
param policyDefinitionGroups array = []

@sys.description('Optional. The Set Definition (Initiative) parameters that can be used in policy definition references.')
param parameters object = {}

var name_var = replace(name, ' ', '-')

resource policySetDefinition 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: name_var
  properties: {
    policyType: 'Custom'
    displayName: empty(displayName) ? null : displayName
    description: empty(description) ? null : description
    metadata: empty(metadata) ? null : metadata
    parameters: empty(parameters) ? null : parameters
    policyDefinitions: policyDefinitions
    policyDefinitionGroups: empty(policyDefinitionGroups) ? [] : policyDefinitionGroups
  }
}

@sys.description('Policy Set Definition Name')
output policySetDefinitionName string = policySetDefinition.name

@sys.description('Policy Set Definition Resource ID')
output policySetDefinitionResourceId string = extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', managementGroupId), 'Microsoft.Authorization/policySetDefinitions', policySetDefinition.name)
