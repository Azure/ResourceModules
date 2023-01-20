@description('Required. Name of the application definition.')
param name string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Conditional. The name of the parent Azure Compute Gallery. Required if the template is used in a standalone deployment.')
@minLength(1)
param galleryName string

@description('Optional. The description of this gallery Application Definition resource. This property is updatable.')
param applicationDefinitionDescription string = ''

@description('Optional. The Eula agreement for the gallery Application Definition. Has to be a valid URL.')
param eula string = ''

@description('Optional. The privacy statement uri. Has to be a valid URL.')
param privacyStatementUri string = ''

@description('Optional. The release note uri. Has to be a valid URL.')
param releaseNoteUri string = ''

@description('Optional. This property allows you to specify the supported type of the OS that application is built for.')
@allowed([
  'Windows'
  'Linux'
])
param supportedOSType string = 'Windows'

@description('Optional. The end of life date of the gallery Image Definition. This property can be used for decommissioning purposes. This property is updatable. Allowed format: 2020-01-10T23:00:00.000Z.')
param endOfLifeDate string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags for all resources.')
param tags object = {}

@description('Optional. A list of custom actions that can be performed with all of the Gallery Application Versions within this Gallery Application.')
param customActions array = []

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

resource gallery 'Microsoft.Compute/galleries@2022-03-03' existing = {
  name: galleryName
}

resource application 'Microsoft.Compute/galleries/applications@2022-03-03' = {
  name: name
  parent: gallery
  location: location
  tags: tags
  properties: {
    customActions: !empty(customActions) ? customActions : null
    description: applicationDefinitionDescription
    endOfLifeDate: endOfLifeDate
    eula: eula
    privacyStatementUri: privacyStatementUri
    releaseNoteUri: releaseNoteUri
    supportedOSType: supportedOSType
  }
}

module galleryApplication_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: application.id
  }
}]

@description('The resource group the image was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the image.')
output resourceId string = application.id

@description('The name of the image.')
output name string = application.name

@description('The location the resource was deployed into.')
output location string = application.location
