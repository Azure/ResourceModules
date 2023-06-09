@description('Required. The name of the Health Data Services Workspace service.')
@maxLength(50)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Control permission for data plane traffic coming from public networks while private endpoint is enabled.')
param publicNetworkAccess string = 'Disabled'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Deploy DICOM services.')
param dicomservices array = []

@description('Optional. Deploy FHIR services.')
param fhirservices array = []

@description('Optional. Deploy IOT connectors.')
param iotconnectors array = []

var enableReferencedModulesTelemetry = false

// =========== //
// Deployments //
// =========== //
resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource workspace 'Microsoft.HealthcareApis/workspaces@2022-06-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    publicNetworkAccess: publicNetworkAccess
  }
}

resource workspace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${workspace.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: workspace
}

module workspace_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: workspace.id
  }
}]

module workspace_fhirservices 'fhirservices/main.bicep' = [for (fhir, index) in fhirservices: {
  name: '${uniqueString(deployment().name, location)}-Health-FHIR-${index}'
  params: {
    name: fhir.name
    location: location
    workspaceName: workspace.name
    kind: fhir.kind
    tags: contains(fhir, 'tags') ? fhir.tags : {}
    publicNetworkAccess: contains(fhir, 'publicNetworkAccess') ? fhir.publicNetworkAccess : 'Disabled'
    systemAssignedIdentity: contains(fhir, 'systemAssignedIdentity') ? fhir.systemAssignedIdentity : false
    roleAssignments: contains(fhir, 'roleAssignments') ? fhir.roleAssignments : []
    accessPolicyObjectIds: contains(fhir, 'accessPolicyObjectIds') ? fhir.accessPolicyObjectIds : []
    acrLoginServers: contains(fhir, 'acrLoginServers') ? fhir.acrLoginServers : []
    acrOciArtifacts: contains(fhir, 'acrOciArtifacts') ? fhir.acrOciArtifacts : []
    authenticationAuthority: contains(fhir, 'authenticationAuthority') ? fhir.authenticationAuthority : uri(environment().authentication.loginEndpoint, subscription().tenantId)
    authenticationAudience: contains(fhir, 'authenticationAudience') ? fhir.authenticationAudience : 'https://${workspace.name}-${fhir.name}.fhir.azurehealthcareapis.com'
    corsOrigins: contains(fhir, 'corsOrigins') ? fhir.corsOrigins : []
    corsHeaders: contains(fhir, 'corsHeaders') ? fhir.corsHeaders : []
    corsMethods: contains(fhir, 'corsMethods') ? fhir.corsMethods : []
    corsMaxAge: contains(fhir, 'corsMaxAge') ? fhir.corsMaxAge : -1
    corsAllowCredentials: contains(fhir, 'corsAllowCredentials') ? fhir.corsAllowCredentials : false
    diagnosticLogsRetentionInDays: contains(fhir, 'diagnosticLogsRetentionInDays') ? fhir.diagnosticLogsRetentionInDays : 365
    diagnosticStorageAccountId: contains(fhir, 'diagnosticStorageAccountId') ? fhir.diagnosticStorageAccountId : ''
    diagnosticWorkspaceId: contains(fhir, 'diagnosticWorkspaceId') ? fhir.diagnosticWorkspaceId : ''
    diagnosticEventHubAuthorizationRuleId: contains(fhir, 'diagnosticEventHubAuthorizationRuleId') ? fhir.diagnosticEventHubAuthorizationRuleId : ''
    diagnosticEventHubName: contains(fhir, 'diagnosticEventHubName') ? fhir.diagnosticEventHubName : ''
    exportStorageAccountName: contains(fhir, 'exportStorageAccountName') ? fhir.exportStorageAccountName : ''
    importStorageAccountName: contains(fhir, 'importStorageAccountName') ? fhir.importStorageAccountName : ''
    importEnabled: contains(fhir, 'importEnabled') ? fhir.importEnabled : false
    initialImportMode: contains(fhir, 'initialImportMode') ? fhir.initialImportMode : false
    lock: contains(fhir, 'lock') ? fhir.lock : ''
    resourceVersionPolicy: contains(fhir, 'resourceVersionPolicy') ? fhir.resourceVersionPolicy : 'versioned'
    resourceVersionOverrides: contains(fhir, 'resourceVersionOverrides') ? fhir.resourceVersionOverrides : {}
    smartProxyEnabled: contains(fhir, 'smartProxyEnabled') ? fhir.smartProxyEnabled : false
    userAssignedIdentities: contains(fhir, 'userAssignedIdentities') ? fhir.userAssignedIdentities : {}
    diagnosticLogCategoriesToEnable: contains(fhir, 'diagnosticLogCategoriesToEnable') ? fhir.diagnosticLogCategoriesToEnable : [ 'AuditLogs' ]
    diagnosticMetricsToEnable: contains(fhir, 'diagnosticMetricsToEnable') ? fhir.diagnosticMetricsToEnable : [ 'AllMetrics' ]
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module workspace_dicomservices 'dicomservices/main.bicep' = [for (dicom, index) in dicomservices: {
  name: '${uniqueString(deployment().name, location)}-Health-DICOM-${index}'
  params: {
    name: dicom.name
    location: location
    workspaceName: workspace.name
    tags: contains(dicom, 'tags') ? dicom.tags : {}
    publicNetworkAccess: contains(dicom, 'publicNetworkAccess') ? dicom.publicNetworkAccess : 'Disabled'
    systemAssignedIdentity: contains(dicom, 'systemAssignedIdentity') ? dicom.systemAssignedIdentity : false
    corsOrigins: contains(dicom, 'corsOrigins') ? dicom.corsOrigins : []
    corsHeaders: contains(dicom, 'corsHeaders') ? dicom.corsHeaders : []
    corsMethods: contains(dicom, 'corsMethods') ? dicom.corsMethods : []
    corsMaxAge: contains(dicom, 'corsMaxAge') ? dicom.corsMaxAge : -1
    corsAllowCredentials: contains(dicom, 'corsAllowCredentials') ? dicom.corsAllowCredentials : false
    diagnosticLogsRetentionInDays: contains(dicom, 'diagnosticLogsRetentionInDays') ? dicom.diagnosticLogsRetentionInDays : 365
    diagnosticStorageAccountId: contains(dicom, 'diagnosticStorageAccountId') ? dicom.diagnosticStorageAccountId : ''
    diagnosticWorkspaceId: contains(dicom, 'diagnosticWorkspaceId') ? dicom.diagnosticWorkspaceId : ''
    diagnosticEventHubAuthorizationRuleId: contains(dicom, 'diagnosticEventHubAuthorizationRuleId') ? dicom.diagnosticEventHubAuthorizationRuleId : ''
    diagnosticEventHubName: contains(dicom, 'diagnosticEventHubName') ? dicom.diagnosticEventHubName : ''
    lock: contains(dicom, 'lock') ? dicom.lock : ''
    userAssignedIdentities: contains(dicom, 'userAssignedIdentities') ? dicom.userAssignedIdentities : {}
    diagnosticLogCategoriesToEnable: contains(dicom, 'diagnosticLogCategoriesToEnable') ? dicom.diagnosticLogCategoriesToEnable : [ 'AuditLogs' ]
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module workspace_iotconnector 'iotconnectors/main.bicep' = [for (iotConnector, index) in iotconnectors: {
  name: '${uniqueString(deployment().name, location)}-Health-IOMT-${index}'
  params: {
    name: iotConnector.name
    location: location
    workspaceName: workspace.name
    tags: contains(iotConnector, 'tags') ? iotConnector.tags : {}
    eventHubName: iotConnector.eventHubName
    eventHubNamespaceName: iotConnector.eventHubNamespaceName
    deviceMapping: contains(iotConnector, 'deviceMapping') ? iotConnector.deviceMapping : {
      templateType: 'CollectionContent'
      template: []
    }
    fhirdestination: contains(iotConnector, 'fhirdestination') ? iotConnector.fhirdestination : {}
    consumerGroup: contains(iotConnector, 'consumerGroup') ? iotConnector.consumerGroup : iotConnector.name
    systemAssignedIdentity: contains(iotConnector, 'systemAssignedIdentity') ? iotConnector.systemAssignedIdentity : false
    diagnosticLogsRetentionInDays: contains(iotConnector, 'diagnosticLogsRetentionInDays') ? iotConnector.diagnosticLogsRetentionInDays : 365
    diagnosticStorageAccountId: contains(iotConnector, 'diagnosticStorageAccountId') ? iotConnector.diagnosticStorageAccountId : ''
    diagnosticWorkspaceId: contains(iotConnector, 'diagnosticWorkspaceId') ? iotConnector.diagnosticWorkspaceId : ''
    diagnosticEventHubAuthorizationRuleId: contains(iotConnector, 'diagnosticEventHubAuthorizationRuleId') ? iotConnector.diagnosticEventHubAuthorizationRuleId : ''
    diagnosticEventHubName: contains(iotConnector, 'diagnosticEventHubName') ? iotConnector.diagnosticEventHubName : ''
    lock: contains(iotConnector, 'lock') ? iotConnector.lock : ''
    userAssignedIdentities: contains(iotConnector, 'userAssignedIdentities') ? iotConnector.userAssignedIdentities : {}
    diagnosticLogCategoriesToEnable: contains(iotConnector, 'diagnosticLogCategoriesToEnable') ? iotConnector.diagnosticLogCategoriesToEnable : [ 'DiagnosticLogs' ]
    diagnosticMetricsToEnable: contains(iotConnector, 'diagnosticMetricsToEnable') ? iotConnector.diagnosticMetricsToEnable : [ 'AllMetrics' ]
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@description('The name of the health data services workspace.')
output name string = workspace.name

@description('The resource ID of the health data services workspace.')
output resourceId string = workspace.id

@description('The resource group where the workspace is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = workspace.location
