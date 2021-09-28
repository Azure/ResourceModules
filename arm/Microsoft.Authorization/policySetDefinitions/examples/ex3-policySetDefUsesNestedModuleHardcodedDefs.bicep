targetScope = 'managementGroup'

param policySetDefinitionName string = 'test-policySetExample'

param properties object = {
  displayName: '[Test] contoso global security Policies'
  description: '[Test] Set of \'global\' security policies'
  metadata: {
    category: 'Security'
    version: '2'
  }
  policyDefinitionGroups: [
    {
      name: 'Network'
    }
    {
      name: 'ARM'
    }
  ]
  policyDefinitions: [
    {
      groupNames: [
        'ARM'
      ]
      parameters: {
        listOfAllowedLocations: {
          value: [
            'australiaeast'
          ]
        }
      }
      policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
      policyDefinitionReferenceId: 'Allowed locations_1'
    }
    {
      groupNames: [
        'ARM'
      ]
      parameters: {
        listOfAllowedLocations: {
          value: [
            'australiaeast'
          ]
        }
      }
      policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988'
      policyDefinitionReferenceId: 'Allowed locations for resource groups_1'
    }
    {
      groupNames: [
        'Network'
      ]
      parameters: {
        effect: {
          value: 'Audit'
        }
      }
      policyDefinitionId: '/providers/Microsoft.Management/managementGroups/mg-contoso/providers/Microsoft.Authorization/policyDefinitions/test-deny-keyvault-public-access'
      policyDefinitionReferenceId: 'test-deny-keyvault-public-access'
    }
  ]
}

param managementGroupId string = 'mg-contoso'

module policySetDefinition '../.bicep/nested_policySetDefinition_mg.bicep' = {
  name: policySetDefinitionName
  scope: managementGroup(managementGroupId)
  params: {
    policySetDefinitionName: policySetDefinitionName
    properties: properties
    managementGroupId: managementGroupId
  }
}

output policySetDefinitionId string = policySetDefinition.outputs.policySetDefinitionId
