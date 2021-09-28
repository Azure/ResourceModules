targetScope = 'managementGroup'

@allowed([
    'Audit'
    'Deny'
    'Disabled'
  ])
param effect string = 'Deny'

param managementGroupId string = 'mg-contoso'

module policyDefinition '../deploy.bicep' = {
  name: 'test-deny-keyvault-public-access'
  params: {
    policyDefinitionName: 'test-deny-keyvault-public-access'
    displayName: '[Test] This policy denies creation of Key Vaults with IP Firewall exposed to all public endpoints'
    policyDescription: '[Test] Description - This policy denies creation of Key Vaults with IP Firewall exposed to all public endpoints'
    mode: 'All'
    metadata: {
      category : 'Security'
    }
    parameters: {
      effect: {
        type : 'string'
        allowedValues : [
          'Audit'
          'Deny'
          'Disabled'
        ]
        defaultValue : effect
        metadata : {
          description : 'Enable or disable the execution of the policy'
          displayName : 'Effect'
        }
      }
    }
    policyRule: {
      if : {
        allof : [
          {
            equals : 'Microsoft.KeyVault/vaults'
            field : 'type'
          }
          {
            field : 'Microsoft.KeyVault/vaults/networkAcls.defaultAction'
            notequals : 'Deny'
          }
        ]
      }
      then : {
        effect : '[parameters(\'effect\')]'
      }
    }
    managementGroupId: managementGroupId
  }
}

output policyDefinitionId string = policyDefinition.outputs.policyDefinitionId
