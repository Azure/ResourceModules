targetScope = 'managementGroup'

@allowed([
  'Audit'
  'Deny'
  'Disabled'
])
param effect string = 'Deny'
param managementGroupId string = 'mg-contoso'

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'test-deny-keyvault-public-access'
  properties: {
    displayName: '[Test] This policy denies creation of Key Vaults with IP Firewall exposed to all public endpoints'
    description: '[Test] Description - This policy denies creation of Key Vaults with IP Firewall exposed to all public endpoints'
    mode: 'All'
    metadata: {
      category: 'Security'
    }
    parameters: {
      effect: {
        type: 'String'
        allowedValues: [
          'Audit'
          'Deny'
          'Disabled'
        ]
        defaultValue: effect
        metadata: {
          description: 'Enable or disable the execution of the policy'
          displayName: 'Effect'
        }
      }
    }
    policyRule: {
      if: {
        allof: [
          {
            equals: 'Microsoft.KeyVault/vaults'
            field: 'type'
          }
          {
            field: 'Microsoft.KeyVault/vaults/networkAcls.defaultAction'
            notequals: 'Deny'
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}

output policyDefinitionId string = extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups',managementGroupId),'Microsoft.Authorization/policyDefinitions',policyDefinition.name)
