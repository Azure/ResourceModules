targetScope = 'managementGroup'

param policyDefinitionName string = 'test-deny-keyvault-public-access'

@allowed([
  'Audit'
  'Deny'
  'Disabled'
])
param effect string = 'Deny'

param properties object = {
  displayName: '[Test] This policy denies creation of Key Vaults with IP Firewall exposed to all public endpoints'
  description: '[Test] Description - This policy denies creation of Key Vaults with IP Firewall exposed to all public endpoints'
  mode: 'All'
  metadata: {
    category: 'Security'
  }
  parameters: {
    effect: {
      type: 'string'
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

param managementGroupId string = 'mg-contoso'

module policyDefinition_mg '../.bicep/nested_policyDefinitions_mg.bicep' = {
  name: policyDefinitionName
  params: {
    policyDefinitionName: policyDefinitionName
    properties: properties
    managementGroupId: managementGroupId
  }
}

output policyDefinitionId string = policyDefinition_mg.outputs.policyDefinitionId
