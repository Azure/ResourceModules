targetScope = 'managementGroup'

param policySetDefinitionName string = 'test-policySetExample'

param displayName string = '[Test] contoso global security Policies'

param policySetDescription string =  '[Test] Set of \'global\' security policies'

param metadata object = {
  category: 'Security'
  version: '2'
}

param policyDefinitionGroups array = [
  {
    name: 'Network'
  }
  {
    name: 'ARM'
  }
]

param policyDefinitions array = [
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

param parameters object = {}

param managementGroupId string = 'mg-contoso'

resource policySetDefinition 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: '${policySetDefinitionName}-mg'
  properties: {
    policyType: 'Custom'
    displayName: (empty(displayName) ? policySetDefinitionName : json('null'))
    description: (empty(policySetDescription) ? policySetDefinitionName : json('null'))
    metadata: (empty(metadata) ? json('null') : metadata)
    parameters: (empty(parameters) ? json('null') : parameters)
    policyDefinitions: policyDefinitions
    policyDefinitionGroups: (empty(policyDefinitionGroups) ? [] : policyDefinitionGroups)
  }
}

output policySetDefinitionId string = extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups',managementGroupId),'Microsoft.Authorization/policySetDefinitions',policySetDefinition.name)
