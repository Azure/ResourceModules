targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

// Resource Group
@description('Required. The name prefix to inject into all resource names')
param namePrefix string

@description('Optional. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string = '${serviceShort}-ms.network-vpnSites-rg'

@description('Optional. The location to deploy resources to')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'vsipar'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'nestedTemplates/default.parameters.nested.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    managedIdentityName: 'dep-${namePrefix}-az-msi-${serviceShort}-01'
    virtualWANName: 'dep-${namePrefix}-az-vw-${serviceShort}-001'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-vpnSites-${serviceShort}'
  params: {
    name: '${namePrefix}-az-${serviceShort}-001'
    virtualWanId: resourceGroupResources.outputs.virtualWWANResourceId
    lock: 'CanNotDelete'
    tags: {
      tagA: 'valueA'
      tagB: 'valueB'
    }
    deviceProperties: {
      linkSpeedInMbps: 0
    }
    vpnSiteLinks: [
      {
        name: '${namePrefix}-az-vSite-${serviceShort}-001'
        properties: {
          bgpProperties: {
            asn: 65010
            bgpPeeringAddress: '1.1.1.1'
          }
          ipAddress: '1.2.3.4'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
      }
      {
        name: 'Link1'
        properties: {
          bgpProperties: {
            asn: 65020
            bgpPeeringAddress: '192.168.1.0'
          }
          ipAddress: '2.2.2.2'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
      }
    ]
    o365Policy: {
      breakOutCategories: {
        optimize: true
        allow: true
        default: true
      }
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
      }
    ]
  }
}
