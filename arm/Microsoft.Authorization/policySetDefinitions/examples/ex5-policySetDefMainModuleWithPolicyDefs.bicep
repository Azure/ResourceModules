targetScope = 'managementGroup'

param policySetDefinitionName string = 'test-policySetExample'
param managementGroupId string = 'mg-contoso'

module testDenyKeyvaultPublicAccess '../../policyDefinitions/examples/ex2-policyDefUsesMainModule.bicep' = {
  name: 'testDenyKeyvaultPublicAccess'
  scope: managementGroup(managementGroupId)
  params: {
    managementGroupId: managementGroupId
  }
}

resource allowedLocationsBuiltinPolicy 'Microsoft.Authorization/policyDefinitions@2020-09-01' existing = {
  name: 'e56962a6-4747-49cd-b67b-bf8b01975c4c'
}

resource allowedLocationsResourceGroupsBuiltinPolicy 'Microsoft.Authorization/policyDefinitions@2020-09-01' existing = {
  name: 'e765b5de-1225-4ba3-bd56-1ac6695af988'
}

module policySetDefinition '../deploy.bicep' = {
  name: policySetDefinitionName
  scope: managementGroup(managementGroupId)
  params: {
    managementGroupId: managementGroupId
    policySetDefinitionName: policySetDefinitionName
    displayName: '[Test] contoso global security Policies'
    policySetDescription: '[Test] Set of \'global\' security policies'
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
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions',allowedLocationsBuiltinPolicy.name)
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
        policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions',allowedLocationsResourceGroupsBuiltinPolicy.name)
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
        policyDefinitionId: testDenyKeyvaultPublicAccess.outputs.policyDefinitionId
        policyDefinitionReferenceId: 'test-deny-keyvault-public-access'
      }
    ]
  }
}

output policySetDefinitionId string = policySetDefinition.outputs.policySetDefinitionId

