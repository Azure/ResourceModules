# SQL Servers `[Microsoft.Sql/servers]`

This module deploys a SQL server.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Sql/servers` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers) |
| `Microsoft.Sql/servers/databases` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-11-01/servers/databases) |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/databases/backupShortTermRetentionPolicies) |
| `Microsoft.Sql/servers/elasticPools` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers/elasticPools) |
| `Microsoft.Sql/servers/encryptionProtector` | [2022-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/encryptionProtector) |
| `Microsoft.Sql/servers/firewallRules` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers/firewallRules) |
| `Microsoft.Sql/servers/keys` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/keys) |
| `Microsoft.Sql/servers/securityAlertPolicies` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers/securityAlertPolicies) |
| `Microsoft.Sql/servers/virtualNetworkRules` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers/virtualNetworkRules) |
| `Microsoft.Sql/servers/vulnerabilityAssessments` | [2022-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers/vulnerabilityAssessments) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the server. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `administratorLogin` | string | `''` | The administrator username for the server. Required if no `administrators` object for AAD authentication is provided. |
| `administratorLoginPassword` | securestring | `''` | The administrator login password. Required if no `administrators` object for AAD authentication is provided. |
| `administrators` | object | `{object}` | The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided. |
| `primaryUserAssignedIdentityId` | string | `''` | The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `databases` | _[databases](databases/README.md)_ array | `[]` |  | The databases to create in the server. |
| `elasticPools` | _[elasticPools](elastic-pools/README.md)_ array | `[]` |  | The Elastic Pools to create in the server. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `encryptionProtectorObj` | _[encryptionProtector](encryption-protector/README.md)_ object | `{object}` |  | The encryption protection configuration. |
| `firewallRules` | _[firewallRules](firewall-rules/README.md)_ array | `[]` |  | The firewall rules to create in the server. |
| `keys` | _[keys](keys/README.md)_ array | `[]` |  | The keys to configure. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `minimalTlsVersion` | string | `'1.2'` | `[1.0, 1.1, 1.2]` | Minimal TLS version allowed. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `publicNetworkAccess` | string | `''` | `['', Disabled, Enabled]` | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and neither firewall rules nor virtual network rules are set. |
| `restrictOutboundNetworkAccess` | string | `''` | `['', Disabled, Enabled]` | Whether or not to restrict outbound network access for this server. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `securityAlertPolicies` | _[securityAlertPolicies](security-alert-policies/README.md)_ array | `[]` |  | The security alert policies to create in the server. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `virtualNetworkRules` | _[virtualNetworkRules](virtual-network-rules/README.md)_ array | `[]` |  | The virtual network rules to create in the server. |
| `vulnerabilityAssessmentsObj` | _[vulnerabilityAssessments](vulnerability-assessments/README.md)_ object | `{object}` |  | The vulnerability assessment configuration. |


### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

### Parameter Usage: `administrators`

Configure Azure Active Directory Authentication method for server administrator.
<https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers/administrators?tabs=bicep>

<details>

<summary>Parameter JSON format</summary>

```json
"administrators": {
    "value": {
        "azureADOnlyAuthentication": true
        "login": "John Doe", // if application can be anything
        "sid": "<<objectId>>", // if application, the object ID
        "principalType" : "User", // options: "User", "Group", "Application"
        "tenantId": "<<tenantId>>"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
administrators: {
    azureADOnlyAuthentication: true
    login: 'John Doe' // if application can be anything
    sid: '<<objectId>>' // if application the object ID
    'principalType' : 'User' // options: 'User' 'Group' 'Application'
    tenantId: '<<tenantId>>'
}
```

</details>
<p>

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`. Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

<details>

<summary>Parameter JSON format</summary>

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<serviceName>", // e.g. vault, registry, blob
            "privateDnsZoneGroup": {
                "privateDNSResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                    "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>" // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
                ]
            },
            "ipConfigurations":[
                {
                    "name": "myIPconfigTest02",
                    "properties": {
                        "groupId": "blob",
                        "memberName": "blob",
                        "privateIPAddress": "10.0.0.30"
                    }
                }
            ],
            "customDnsConfigs": [
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
            ]
        },
        // Example showing only mandatory fields
        {
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<serviceName>" // e.g. vault, registry, blob
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
privateEndpoints:  [
    // Example showing all available fields
    {
        name: 'sxx-az-pe' // Optional: Name will be automatically generated if one is not provided here
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<serviceName>' // e.g. vault, registry, blob
        privateDnsZoneGroup: {
            privateDNSResourceIds: [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>' // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
            ]
        }
        customDnsConfigs: [
            {
                fqdn: 'customname.test.local'
                ipAddresses: [
                    '10.10.10.10'
                ]
            }
        ]
        ipConfigurations:[
          {
            name: 'myIPconfigTest02'
            properties: {
              groupId: 'blob'
              memberName: 'blob'
              privateIPAddress: '10.0.0.30'
            }
          }
        ]
    }
    // Example showing only mandatory fields
    {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<serviceName>' // e.g. vault, registry, blob
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed SQL server. |
| `resourceGroupName` | string | The resource group of the deployed SQL server. |
| `resourceId` | string | The resource ID of the deployed SQL server. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `network/private-endpoints` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Admin</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module servers './sql/servers/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-sqlsadmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>-sqlsadmin'
    // Non-required parameters
    administrators: {
      azureADOnlyAuthentication: true
      login: 'myspn'
      principalType: 'Application'
      sid: '<sid>'
      tenantId: '<tenantId>'
    }
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<<namePrefix>>-sqlsadmin"
    },
    // Non-required parameters
    "administrators": {
      "value": {
        "azureADOnlyAuthentication": true,
        "login": "myspn",
        "principalType": "Application",
        "sid": "<sid>",
        "tenantId": "<tenantId>"
      }
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

<h3>Example 2: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module servers './sql/servers/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-sqlscom'
  params: {
    name: '<<namePrefix>>-sqlscom'
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    databases: [
      {
        backupLongTermRetentionPolicy: {
          monthlyRetention: 'P6M'
        }
        backupShortTermRetentionPolicy: {
          retentionDays: 14
        }
        capacity: 0
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
        diagnosticEventHubName: '<diagnosticEventHubName>'
        diagnosticLogsRetentionInDays: 7
        diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
        diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
        elasticPoolId: '<elasticPoolId>'
        encryptionProtectorObj: {
          serverKeyName: '<serverKeyName>'
          serverKeyType: 'AzureKeyVault'
        }
        licenseType: 'LicenseIncluded'
        maxSizeBytes: 34359738368
        name: '<<namePrefix>>-sqlscomdb-001'
        skuName: 'ElasticPool'
        skuTier: 'GeneralPurpose'
      }
    ]
    elasticPools: [
      {
        maintenanceConfigurationId: '<maintenanceConfigurationId>'
        name: '<<namePrefix>>-sqlscom-ep-001'
        skuCapacity: 10
        skuName: 'GP_Gen5'
        skuTier: 'GeneralPurpose'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    firewallRules: [
      {
        endIpAddress: '0.0.0.0'
        name: 'AllowAllWindowsAzureIps'
        startIpAddress: '0.0.0.0'
      }
    ]
    keys: [
      {
        name: '<name>'
        serverKeyType: 'AzureKeyVault'
        uri: '<uri>'
      }
    ]
    location: '<location>'
    lock: 'CanNotDelete'
    primaryUserAssignedIdentityId: '<primaryUserAssignedIdentityId>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSResourceId>'
          ]
        }
        service: 'sqlServer'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    restrictOutboundNetworkAccess: 'Disabled'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    securityAlertPolicies: [
      {
        emailAccountAdmins: true
        name: 'Default'
        state: 'Enabled'
      }
    ]
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
    virtualNetworkRules: [
      {
        ignoreMissingVnetServiceEndpoint: true
        name: 'newVnetRule1'
        virtualNetworkSubnetId: '<virtualNetworkSubnetId>'
      }
    ]
    vulnerabilityAssessmentsObj: {
      emailSubscriptionAdmins: true
      name: 'default'
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      recurringScansIsEnabled: true
      storageAccountResourceId: '<storageAccountResourceId>'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "<<namePrefix>>-sqlscom"
    },
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "databases": {
      "value": [
        {
          "backupLongTermRetentionPolicy": {
            "monthlyRetention": "P6M"
          },
          "backupShortTermRetentionPolicy": {
            "retentionDays": 14
          },
          "capacity": 0,
          "collation": "SQL_Latin1_General_CP1_CI_AS",
          "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
          "diagnosticEventHubName": "<diagnosticEventHubName>",
          "diagnosticLogsRetentionInDays": 7,
          "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
          "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
          "elasticPoolId": "<elasticPoolId>",
          "encryptionProtectorObj": {
            "serverKeyName": "<serverKeyName>",
            "serverKeyType": "AzureKeyVault"
          },
          "licenseType": "LicenseIncluded",
          "maxSizeBytes": 34359738368,
          "name": "<<namePrefix>>-sqlscomdb-001",
          "skuName": "ElasticPool",
          "skuTier": "GeneralPurpose"
        }
      ]
    },
    "elasticPools": {
      "value": [
        {
          "maintenanceConfigurationId": "<maintenanceConfigurationId>",
          "name": "<<namePrefix>>-sqlscom-ep-001",
          "skuCapacity": 10,
          "skuName": "GP_Gen5",
          "skuTier": "GeneralPurpose"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "firewallRules": {
      "value": [
        {
          "endIpAddress": "0.0.0.0",
          "name": "AllowAllWindowsAzureIps",
          "startIpAddress": "0.0.0.0"
        }
      ]
    },
    "keys": {
      "value": [
        {
          "name": "<name>",
          "serverKeyType": "AzureKeyVault",
          "uri": "<uri>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "primaryUserAssignedIdentityId": {
      "value": "<primaryUserAssignedIdentityId>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSResourceId>"
            ]
          },
          "service": "sqlServer",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "restrictOutboundNetworkAccess": {
      "value": "Disabled"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "securityAlertPolicies": {
      "value": [
        {
          "emailAccountAdmins": true,
          "name": "Default",
          "state": "Enabled"
        }
      ]
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    },
    "virtualNetworkRules": {
      "value": [
        {
          "ignoreMissingVnetServiceEndpoint": true,
          "name": "newVnetRule1",
          "virtualNetworkSubnetId": "<virtualNetworkSubnetId>"
        }
      ]
    },
    "vulnerabilityAssessmentsObj": {
      "value": {
        "emailSubscriptionAdmins": true,
        "name": "default",
        "recurringScansEmails": [
          "test1@contoso.com",
          "test2@contoso.com"
        ],
        "recurringScansIsEnabled": true,
        "storageAccountResourceId": "<storageAccountResourceId>"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 3: Pe</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module servers './sql/servers/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-sqlspe'
  params: {
    // Required parameters
    name: '<<namePrefix>>-sqlspe'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSResourceId>'
          ]
        }
        service: 'sqlServer'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<<namePrefix>>-sqlspe"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSResourceId>"
            ]
          },
          "service": "sqlServer",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 4: Secondary</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module servers './sql/servers/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-sqlsec'
  params: {
    // Required parameters
    name: '<<namePrefix>>-sqlsec-sec'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    databases: [
      {
        createMode: 'Secondary'
        maxSizeBytes: 2147483648
        name: '<name>'
        skuName: 'Basic'
        skuTier: 'Basic'
        sourceDatabaseResourceId: '<sourceDatabaseResourceId>'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<<namePrefix>>-sqlsec-sec"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "databases": {
      "value": [
        {
          "createMode": "Secondary",
          "maxSizeBytes": 2147483648,
          "name": "<name>",
          "skuName": "Basic",
          "skuTier": "Basic",
          "sourceDatabaseResourceId": "<sourceDatabaseResourceId>"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>
