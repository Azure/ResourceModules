// ================ //
// Parameters       //
// ================ //
@description('Required. Name of the Machine Learning Workspace.')
param machineLearningWorkspaceName string

@description('Required. Name of the compute.')
@minLength(2)
@maxLength(16)
param name string

@description('Optional. Specifies the location of the resource.')
param location string = resourceGroup().location

@description('Required. Specifies the sku, also referred as "edition".')
@allowed([
  'Basic'
  'Enterprise'
])
param sku string

@description('Optional. Identity for the resource.')
param identity object = {}

@description('Optional. Contains resource tags defined as key/value pairs.')
param tags object = {}

@description('Required. Flag to specify whether to deploy the compute. Necessary as the compute resource is not idempontent, i.e. a second deployment will fail. Therefore, this flag needs to be set to "false" as long as the compute resource exists.')
param deployCompute bool

@description('Optional. Location for the underlying compute.')
param computeLocation string = resourceGroup().location

@description('Optional. The description of the Machine Learning compute.')
param computeDescription string = ''

@description('Optional. Opt-out of local authentication and ensure customers can use only MSI and AAD exclusively for authentication.')
param computeDisableLocalAuth bool = false

@description('Optional. ARM resource id of the underlying compute.')
param computeResourceId string = ''

@description('Required. Set the object type.')
@allowed([
  'AKS'
  'AmlCompute'
  'ComputeInstance'
  'Databricks'
  'DataFactory'
  'DataLakeAnalytics'
  'HDInsight'
  'Kubernetes'
  'SynapseSpark'
  'VirtualMachine'
])
param computeType string

@description('Optional. The properties of the compute. Will be ignored in case "computeResourceId" is set.')
param computeProperties object = {}

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

// =========== //
// Existing resources //
// =========== //
resource machineLearningWorkspace 'Microsoft.MachineLearningServices/workspaces@2021-04-01' existing = {
  name: machineLearningWorkspaceName
}

// =========== //
// Deployments //
// =========== //
resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource machineLearningWorkspaceCompute 'Microsoft.MachineLearningServices/workspaces/computes@2022-01-01-preview' = if (deployCompute == true) {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
    tier: sku
  }
  parent: machineLearningWorkspace
  identity: identity
  properties: union({
    computeLocation: computeLocation
    description: computeDescription
    disableLocalAuth: computeDisableLocalAuth
    computeType: computeType
  }, (!empty(computeResourceId) ? {
    resourceId: computeResourceId
  } : {
    properties: computeProperties
  }))
}

// =========== //
// Outputs     //
// =========== //
@description('The name of the compute.')
output name string = machineLearningWorkspaceCompute.name

@description('The resource ID of the compute.')
output resourceId string = machineLearningWorkspaceCompute.id

@description('The resource group the compute was deployed into.')
output resourceGroupName string = resourceGroup().name
