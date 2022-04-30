# SQL Servers `[Microsoft.Sql/servers]`

This module deploys a SQL server.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Sql/servers` | 2021-05-01-preview |
| `Microsoft.Sql/servers/databases` | 2021-02-01-preview |
| `Microsoft.Sql/servers/firewallRules` | 2021-05-01-preview |
| `Microsoft.Sql/servers/securityAlertPolicies` | 2021-05-01-preview |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the server. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `administratorLogin` | string | `''` |  | Administrator username for the server. Required if no `administrators` object for AAD authentication is provided. |
| `administratorLoginPassword` | secureString | `''` |  | The administrator login password. Required if no `administrators` object for AAD authentication is provided. |
| `administrators` | object | `{object}` |  | The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided. |
| `databases` | _[databases](databases/readme.md)_ array | `[]` |  | The databases to create in the server |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `firewallRules` | _[firewallRules](firewallRules/readme.md)_ array | `[]` |  | The firewall rules to create in the server |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `securityAlertPolicies` | _[securityAlertPolicies](securityAlertPolicies/readme.md)_ array | `[]` |  | The security alert policies to create in the server |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
},
```

### Parameter Usage: `administrators`

Configure Azure Active Directory Authentication method for server administrator.
https://docs.microsoft.com/en-us/azure/templates/microsoft.sql/servers/administrators?tabs=bicep

```json
"administrators": {
    "value": {
        "azureADOnlyAuthentication": true
        "login": "John Doe" // if application can be anything
        "sid": "<<objectId>>" // if application, the object ID
        "principalType" : "User" // options: "User", "Group", "Application"
        "tenantId": "<<tenantId>>"
    }
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed SQL server |
| `resourceGroupName` | string | The resourceGroup of the deployed SQL server |
| `resourceId` | string | The resource ID of the deployed SQL server |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Servers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/servers)
- [Servers/Databases](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/servers/databases)
- [Servers/Firewallrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/servers/firewallRules)
- [Servers/Securityalertpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/servers/securityAlertPolicies)

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-sqlsrv-admin-001"
        },
        "administrators": {
            "value": {
                "azureADOnlyAuthentication": true,
                "login": "myspn",
                "sid": "<<deploymentSpId>>",
                "principalType": "Application",
                "tenantId": "<<tenantId>>"
            }
        }
    }
}

```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module servers './Microsoft.Sql/servers/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-servers'
  params: {
      administrators: {
        login: 'myspn'
        principalType: 'Application'
        sid: '<<deploymentSpId>>'
        azureADOnlyAuthentication: true
        tenantId: '<<tenantId>>'
      }
      name: '<<namePrefix>>-az-sqlsrv-admin-001'
  }
```

</details>

<h3>Example 2</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-sqlsrv-x-001"
        },
        "administratorLogin": {
            "reference": {
                "keyVault": {
                    "id": "/subscriptions/<<subscriptionId>>/resourceGroups/<<resourceGroupName>>/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
                },
                "secretName": "administratorLogin"
            }
        },
        "administratorLoginPassword": {
            "reference": {
                "keyVault": {
                    "id": "/subscriptions/<<subscriptionId>>/resourceGroups/<<resourceGroupName>>/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
                },
                "secretName": "administratorLoginPassword"
            }
        },
        "location": {
            "value": "westeurope"
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        },
        "databases": {
            "value": [
                {
                    "name": "<<namePrefix>>-az-sqldb-x-001",
                    "collation": "SQL_Latin1_General_CP1_CI_AS",
                    "skuTier": "BusinessCritical",
                    "skuName": "BC_Gen5",
                    "skuCapacity": 12,
                    "skuFamily": "Gen5",
                    "maxSizeBytes": 34359738368,
                    "licenseType": "LicenseIncluded",
                    "diagnosticLogsRetentionInDays": 7,
                    "diagnosticStorageAccountId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001",
                    "diagnosticWorkspaceId": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001",
                    "diagnosticEventHubAuthorizationRuleId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey",
                    "diagnosticEventHubName": "adp-<<namePrefix>>-az-evh-x-001"
                }
            ]
        },
        "firewallRules": {
            "value": [
                {
                    "name": "AllowAllWindowsAzureIps",
                    "endIpAddress": "0.0.0.0",
                    "startIpAddress": "0.0.0.0"
                }
            ]
        },
        "securityAlertPolicies": {
            "value": [
                {
                    "name": "Default",
                    "state": "Enabled",
                    "emailAccountAdmins": true
                }
            ]
        },
        "systemAssignedIdentity": {
            "value": true
        },
        "userAssignedIdentities": {
            "value": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            }
        }
    }
}

```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
resource kv1 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
    name: 'adp-<<namePrefix>>-az-kv-x-001'
    scope: resourceGroup('<<subscriptionId>>','<<resourceGroupName>>')
}

module servers './Microsoft.Sql/servers/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-servers'
  params: {
      systemAssignedIdentity: true
      securityAlertPolicies: [
        {
          emailAccountAdmins: true
          state: 'Enabled'
          name: 'Default'
        }
      ]
      location: 'westeurope'
      databases: [
        {
          licenseType: 'LicenseIncluded'
          collation: 'SQL_Latin1_General_CP1_CI_AS'
          diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
          diagnosticLogsRetentionInDays: 7
          skuTier: 'BusinessCritical'
          name: '<<namePrefix>>-az-sqldb-x-001'
          maxSizeBytes: 34359738368
          diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
          diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
          skuName: 'BC_Gen5'
          diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
          skuCapacity: 12
          skuFamily: 'Gen5'
        }
      ]
      name: '<<namePrefix>>-az-sqlsrv-x-001'
      roleAssignments: [
        {
          principalIds: [
            '<<deploymentSpId>>'
          ]
          roleDefinitionIdOrName: 'Reader'
        }
      ]
      userAssignedIdentities: {
        '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
      }
      administratorLogin: kv1.getSecret('administratorLogin')
      administratorLoginPassword: kv1.getSecret('administratorLoginPassword')
      firewallRules: [
        {
          name: 'AllowAllWindowsAzureIps'
          endIpAddress: '0.0.0.0'
          startIpAddress: '0.0.0.0'
        }
      ]
  }
```

</details>
