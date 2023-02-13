targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.containerservice.managedclusters-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csmmf2'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    name: '${serviceShort}001'
    enableDefaultTelemetry: enableDefaultTelemetry
    systemAssignedIdentity: true
    primaryAgentPoolProfile: [
      {
        name: 'systempool'
        count: 1
        vmSize: 'Standard_DS2_v2'
        mode: 'System'
      }
    ]
    fluxExtension: {
      configurationSettings: {
        'helm-controller.enabled': 'true'
        'source-controller.enabled': 'true'
        'kustomize-controller.enabled': 'true'
        'notification-controller.enabled': 'true'
        'image-automation-controller.enabled': 'false'
        'image-reflector-controller.enabled': 'false'
      }
      configurations: [
        {
          namespace: 'flux-system'
          scope: 'cluster'
          gitRepository: {
            repositoryRef: {
              branch: 'main'
            }
            sshKnownHosts: ''
            syncIntervalInSeconds: 300
            timeoutInSeconds: 180
            url: 'https://github.com/mspnp/aks-baseline'
          }
        }
        {
          namespace: 'flux-system-helm'
          scope: 'cluster'
          gitRepository: {
            repositoryRef: {
              branch: 'main'
            }
            sshKnownHosts: ''
            syncIntervalInSeconds: 300
            timeoutInSeconds: 180
            url: 'https://github.com/Azure/gitops-flux2-kustomize-helm-mt'
          }
          kustomizations: {
            infra: {
              path: './infrastructure'
              dependsOn: []
              timeoutInSeconds: 600
              syncIntervalInSeconds: 600
              validation: 'none'
              prune: true
            }
            apps: {
              path: './apps/staging'
              dependsOn: [
                'infra'
              ]
              timeoutInSeconds: 600
              syncIntervalInSeconds: 600
              retryIntervalInSeconds: 120
              prune: true
            }
          }
        }
      ]
    }
  }
}
