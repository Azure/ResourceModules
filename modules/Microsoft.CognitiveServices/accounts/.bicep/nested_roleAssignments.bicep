@sys.description('Required. The IDs of the principals to assign the role to.')
param principalIds array

@sys.description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
param roleDefinitionIdOrName string

@sys.description('Required. The resource ID of the resource to apply the role assignment to.')
param resourceId string

@sys.description('Optional. The principal type of the assigned principal ID.')
@allowed([
  'ServicePrincipal'
  'Group'
  'User'
  'ForeignGroup'
  'Device'
  ''
])
param principalType string = ''

@sys.description('Optional. The description of the role assignment.')
param description string = ''

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Azure Service Deploy Release Management Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '21d96096-b162-414a-8302-d8354f9d91b2')
  'Cognitive Services Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '25fbc0a9-bd7c-42a3-aa1a-3b75d497ee68')
  'Cognitive Services Custom Vision Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c1ff6cc2-c111-46fe-8896-e0ef812ad9f3')
  'Cognitive Services Custom Vision Deployment': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5c4089e1-6d96-4d2f-b296-c1bc7137275f')
  'Cognitive Services Custom Vision Labeler': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '88424f51-ebe7-446f-bc41-7fa16989e96c')
  'Cognitive Services Custom Vision Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '93586559-c37d-4a6b-ba08-b9f0940c2d73')
  'Cognitive Services Custom Vision Trainer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0a5ae4ab-0d65-4eeb-be61-29fc9b54394b')
  'Cognitive Services Data Reader (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b59867f0-fa02-499b-be73-45a86b5b3e1c')
  'Cognitive Services Face Recognizer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9894cab4-e18a-44aa-828b-cb588cd6f2d7')
  'Cognitive Services Metrics Advisor Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'cb43c632-a144-4ec5-977c-e80c4affc34a')
  'Cognitive Services Metrics Advisor User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3b20f47b-3825-43cb-8114-4bd2201156a8')
  'Cognitive Services QnA Maker Editor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f4cc2bf9-21be-47a1-bdf1-5c5804381025')
  'Cognitive Services QnA Maker Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '466ccd10-b268-4a11-b098-b4849f024126')
  'Cognitive Services Speech Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0e75ca1e-0464-4b4d-8b93-68208a576181')
  'Cognitive Services Speech User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f2dc8367-1007-4938-bd23-fe263f013447')
  'Cognitive Services User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a97b65f3-24c7-4388-baec-2e87135dc908')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'masterreader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a48d7796-14b4-4889-afef-fbb65a93e5a2')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource account 'Microsoft.CognitiveServices/accounts@2017-04-18' existing = {
  name: last(split(resourceId, '/'))
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = [for principalId in principalIds: {
  name: guid(account.id, principalId, roleDefinitionIdOrName)
  properties: {
    description: description
    roleDefinitionId: contains(builtInRoleNames, roleDefinitionIdOrName) ? builtInRoleNames[roleDefinitionIdOrName] : roleDefinitionIdOrName
    principalId: principalId
    principalType: !empty(principalType) ? any(principalType) : null
  }
  scope: account
}]
