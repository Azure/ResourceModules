@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Deployment Script to create for the Certificate generation.')
param certDeploymentScriptName string

@description('Required. The name of the certificate to generate.')
param certName string

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
        enablePurgeProtection: null
        enabledForTemplateDeployment: true
        enabledForDiskEncryption: true
        enabledForDeployment: true
        enableRbacAuthorization: false
        accessPolicies: [
            {
                objectId: managedIdentity.properties.principalId
                permissions: {
                    secrets: [
                        'get'
                        'list'
                    ]
                    certificates: [
                        'create'
                        'get'
                    ]
                }
                tenantId: tenant().tenantId
            }
        ]
    }
}

resource certDeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
    name: certDeploymentScriptName
    location: location
    kind: 'AzurePowerShell'
    identity: {
        type: 'UserAssigned'
        userAssignedIdentities: {
            '${managedIdentity.id}': {}
        }
    }
    properties: {
        azPowerShellVersion: '8.0'
        retentionInterval: 'P1D'
        arguments: '-KeyVaultName "${keyVault.name}" -CertName "${certName}"'
        scriptContent: loadTextContent('../../../../.shared/.scripts/Set-CertificateInKeyVault.ps1')
    }
}

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The URL of the created certificate.')
output certificateSecretUrl string = certDeploymentScript.properties.outputs.secretUrl
