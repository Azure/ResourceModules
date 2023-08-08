@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Azure Machine Learning Workspace to create.')
param amlWorkspaceName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Application Insights Instanec to create.')
param applicationInsightsName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
    name: keyVaultName
    location: location
    properties: {
        sku: {
            family: 'A'
            name: 'standard'
        }
        tenantId: tenant().tenantId
        enablePurgeProtection: true // Required by batch account
        softDeleteRetentionInDays: 7
        enabledForTemplateDeployment: true
        enabledForDiskEncryption: true
        enabledForDeployment: true
        enableRbacAuthorization: true
        accessPolicies: []
    }

    resource key 'keys@2022-07-01' = {
        name: 'keyEncryptionKey'
        properties: {
            kty: 'RSA'
        }
    }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
    name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key-Key-Vault-Crypto-User-RoleAssignment')
    scope: keyVault::key
    properties: {
        principalId: '5167ea7a-355a-466f-ae8b-8ea60f718b35' // AzureDatabricks Enterprise Application Object Id
        roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '12338af0-0e69-4776-bea7-57ae8d297424') // Key Vault Crypto User
        principalType: 'ServicePrincipal'
    }
}

resource amlPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
    name: guid('msi-${keyVault.id}-${location}-${managedIdentity.id}-Key-Vault-Contributor')
    scope: keyVault
    properties: {
        principalId: managedIdentity.properties.principalId
        roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor
        principalType: 'ServicePrincipal'
    }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
    name: storageAccountName
    location: location
    sku: {
        name: 'Standard_ZRS'
    }
    kind: 'StorageV2'
    properties: {}
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
    name: applicationInsightsName
    location: location
    kind: 'web'
    properties: {
        Application_Type: 'web'
    }
}

resource machineLearningWorkspace 'Microsoft.MachineLearningServices/workspaces@2023-04-01' = {
    name: amlWorkspaceName
    location: location
    identity: {
        type: 'UserAssigned'
        userAssignedIdentities: {
            '${managedIdentity.id}': {}
        }
    }
    properties: {
        storageAccount: storageAccount.id
        keyVault: keyVault.id
        applicationInsights: applicationInsights.id
        primaryUserAssignedIdentity: managedIdentity.id
    }
}

@description('The resource ID of the created Azure Machine Learning Workspace.')
output machineLearningWorkspaceResourceId string = machineLearningWorkspace.id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The name of the created Key Vault encryption key.')
output keyVaultKeyName string = keyVault::key.name

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
