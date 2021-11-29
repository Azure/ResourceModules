targetScope = 'subscription'

@sys.description('Required. Specifies the name of the policy definition. Space characters will be replaced by (-) and converted to lowercase')
@maxLength(64)
param name string

@sys.description('Optional. The display name of the policy definition.')
param displayName string = ''

@sys.description('Optional. The policy definition description.')
param description string = ''

@sys.description('Optional. The policy definition mode. Default is All, Some examples are All, Indexed, Microsoft.KeyVault.Data.')
@allowed([
  'All'
  'Indexed'
  'Microsoft.KeyVault.Data'
  'Microsoft.ContainerService.Data'
  'Microsoft.Kubernetes.Data'
])
param mode string = 'All'

@sys.description('Optional. The policy Definition metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@sys.description('Optional. The policy definition parameters that can be used in policy definition references.')
param parameters object = {}

@sys.description('Required. The Policy Rule details for the Policy Definition')
param policyRule object

@sys.description('Optional. The subscription ID of the subscription')
param subscriptionId string = subscription().subscriptionId

var name_var = toLower(replace(name, ' ', '-'))

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: name_var
  properties: {
    policyType: 'Custom'
    mode: mode
    displayName: empty(displayName) ? null : displayName
    description: empty(description) ? null : description
    metadata: empty(metadata) ? null : metadata
    parameters: empty(parameters) ? null : parameters
    policyRule: policyRule
  }
}

@sys.description('Policy Definition Name')
output PolicyDefinitionName string = policyDefinition.name

@sys.description('Policy Definition Resource ID')
output policyDefinitionResourceId string = subscriptionResourceId(subscriptionId, 'Microsoft.Authorization/policyDefinitions', policyDefinition.name)

@sys.description('Policy Definition Role Definition IDs')
output roleDefinitionIds array = (contains(policyDefinition.properties.policyRule.then, 'details') ? ((contains(policyDefinition.properties.policyRule.then.details, 'roleDefinitionIds') ? policyDefinition.properties.policyRule.then.details.roleDefinitionIds : [])) : [])
