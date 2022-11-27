targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(80)
param resourceGroupName string = 'ms.containerservice.managedclusters-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csmkube'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/dependencyConstructs/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep<<namePrefix>>diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-<<namePrefix>>-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-<<namePrefix>>-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-<<namePrefix>>-evhns-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '<<namePrefix>>${serviceShort}001'
    primaryAgentPoolProfile: [
      {
        availabilityZones: [
          '1'
        ]
        count: 1
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        mode: 'System'
        name: 'systempool'
        osDiskSizeGB: 0
        osType: 'Linux'
        serviceCidr: ''
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    agentPools: [
      {
        availabilityZones: [
          '1'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool1'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
      {
        availabilityZones: [
          '1'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool2'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    aksClusterNetworkPlugin: 'kubenet'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    userAssignedIdentities: {
      '${resourceGroupResources.outputs.managedIdentityResourceId}': {}
    }
  }
}
