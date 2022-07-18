# Automation Accounts `[Microsoft.Automation/automationAccounts]`

This module deploys an Azure Automation Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Automation/automationAccounts` | [2020-01-13-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts) |
| `Microsoft.Automation/automationAccounts/jobSchedules` | [2020-01-13-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/jobSchedules) |
| `Microsoft.Automation/automationAccounts/modules` | [2020-01-13-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/modules) |
| `Microsoft.Automation/automationAccounts/runbooks` | [2019-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2019-06-01/automationAccounts/runbooks) |
| `Microsoft.Automation/automationAccounts/schedules` | [2020-01-13-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/schedules) |
| `Microsoft.Automation/automationAccounts/softwareUpdateConfigurations` | [2019-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2019-06-01/automationAccounts/softwareUpdateConfigurations) |
| `Microsoft.Automation/automationAccounts/variables` | [2020-01-13-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Automation/2020-01-13-preview/automationAccounts/variables) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2020-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Automation Account. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cMKKeyName` | string | `''` |  | The name of the customer managed key to use for encryption. |
| `cMKKeyVaultResourceId` | string | `''` |  | The resource ID of a key vault to reference a customer managed key for encryption from. |
| `cMKKeyVersion` | string | `''` |  | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| `cMKUserAssignedIdentityResourceId` | string | `''` |  | User assigned identity to use when fetching the customer managed key. If not provided, a system-assigned identity can be used - but must be given access to the referenced key vault first. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[DscNodeStatus, JobLogs, JobStreams]` | `[DscNodeStatus, JobLogs, JobStreams]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `gallerySolutions` | array | `[]` |  | List of gallerySolutions to be created in the linked log analytics workspace. |
| `jobSchedules` | _[jobSchedules](jobSchedules/readme.md)_ array | `[]` |  | List of jobSchedules to be created in the automation account. |
| `linkedWorkspaceResourceId` | string | `''` |  | ID of the log analytics workspace to be linked to the deployed automation account. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `modules` | _[modules](modules/readme.md)_ array | `[]` |  | List of modules to be created in the automation account. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `runbooks` | _[runbooks](runbooks/readme.md)_ array | `[]` |  | List of runbooks to be created in the automation account. |
| `schedules` | _[schedules](schedules/readme.md)_ array | `[]` |  | List of schedules to be created in the automation account. |
| `skuName` | string | `'Basic'` | `[Basic, Free]` | SKU name of the account. |
| `softwareUpdateConfigurations` | _[softwareUpdateConfigurations](softwareUpdateConfigurations/readme.md)_ array | `[]` |  | List of softwareUpdateConfigurations to be created in the automation account. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the Automation Account resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `variables` | _[variables](variables/readme.md)_ array | `[]` |  | List of variables to be created in the automation account. |


### Parameter Usage: `encryption`
Prerequisites:
- User Assigned Identity for Encryption needs `Get`, `List`, `Wrap` and `Unwrap` permissions on the key.
- User Assigned Identity have to be one of the defined identities in userAssignedIdentities parameter block.
- To use Azure Automation with customer managed keys, both `Soft Delete` and `Do Not Purge` features must be turned on to allow for recovery of keys in case of accidental deletion.

<details>

<summary>Parameter JSON format</summary>

```json
"encryptionKeySource" : {
    "value" : "Microsoft.KeyVault"
},
"encryptionUserAssignedIdentity": {
    "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001" // this identity needs to be one of the identities defined in userAssignedIdentities section
},
"keyName" : {
        "value" : "keyEncryptionKey"
},
"keyvaultUri" : {
            "value" : "https://<<keyValutName>>.vault.azure.net/"
},
"keyVersion" : {
            "value" : "aa11b22c1234567890c3608c657cd5a2"
},
"userAssignedIdentities": {
    "value": {
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}, // same value as 'encryptionUserAssignedIdentity' parameter
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
encryptionKeySource: 'Microsoft.KeyVault'
encryptionUserAssignedIdentity: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001' // this identity needs to be one of the identities defined in userAssignedIdentities section
keyName : 'keyEncryptionKey'
keyvaultUri: 'https://<<keyValutName>>.vault.azure.net/'
keyVersion: 'aa11b22c1234567890c3608c657cd5a2'
userAssignedIdentities: {
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {} // same value as 'encryptionUserAssignedIdentity' parameter
}
```

</details>
<p>

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

<details>

<summary>Parameter JSON format</summary>

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<<serviceName>>", // e.g. vault, registry, file, blob, queue, table etc.
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
            ],
            "customDnsConfigs": [ // Optional
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
            "service": "<<serviceName>>" // e.g. vault, registry, file, blob, queue, table etc.
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
        service: '<<serviceName>>' // e.g. vault registry file blob queue table etc.
        privateDnsZoneResourceIds: [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
            '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net'
        ]
        // Optional
        customDnsConfigs: [
            {
                fqdn: 'customname.test.local'
                ipAddresses: [
                    '10.10.10.10'
                ]
            }
        ]
    }
    // Example showing only mandatory fields
    {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<<serviceName>>' // e.g. vault registry file blob queue table etc.
    }
]
```

</details>
<p>

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
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed automation account. |
| `resourceGroupName` | string | The resource group of the deployed automation account. |
| `resourceId` | string | The resource ID of the deployed automation account. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.
   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Encr</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module automationAccounts './Microsoft.Automation/automationAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-automationAccounts'
  params: {
    // Required parameters
    name: '<<namePrefix>>-az-aut-encr-001'
    // Non-required parameters
    cMKKeyName: 'keyEncryptionKey'
    cMKKeyVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-nopr-002'
    cMKUserAssignedIdentityResourceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001'
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
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
      "value": "<<namePrefix>>-az-aut-encr-001"
    },
    // Non-required parameters
    "cMKKeyName": {
      "value": "keyEncryptionKey"
    },
    "cMKKeyVaultResourceId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-nopr-002"
    },
    "cMKUserAssignedIdentityResourceId": {
      "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001"
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
<p>

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module automationAccounts './Microsoft.Automation/automationAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-automationAccounts'
  params: {
    name: '<<namePrefix>>-az-aut-min-001'
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
      "value": "<<namePrefix>>-az-aut-min-001"
    }
  }
}
```

</details>
<p>

<h3>Example 3: Parameters</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module automationAccounts './Microsoft.Automation/automationAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-automationAccounts'
  params: {
    // Required parameters
    name: '<<namePrefix>>-az-aut-x-001'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    gallerySolutions: [
      {
        name: 'Updates'
        product: 'OMSGallery'
        publisher: 'Microsoft'
      }
    ]
    jobSchedules: [
      {
        runbookName: 'TestRunbook'
        scheduleName: 'TestSchedule'
      }
    ]
    linkedWorkspaceResourceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-aut-001'
    lock: 'CanNotDelete'
    modules: [
      {
        name: 'PSWindowsUpdate'
        uri: 'https://www.powershellgallery.com/api/v2/package'
        version: 'latest'
      }
    ]
    privateEndpoints: [
      {
        service: 'Webhook'
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints'
      }
      {
        service: 'DSCAndHybridWorker'
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints'
      }
    ]
    roleAssignments: [
      {
        principalIds: [
          '<<deploymentSpId>>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    runbooks: [
      {
        description: 'Test runbook'
        name: 'TestRunbook'
        runbookType: 'PowerShell'
        uri: 'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.automation/101-automation/scripts/AzureAutomationTutorial.ps1'
        version: '1.0.0.0'
      }
    ]
    schedules: [
      {
        advancedSchedule: {}
        expiryTime: '9999-12-31T13:00'
        frequency: 'Minute'
        interval: 15
        name: 'TestSchedule'
        startTime: ''
        timeZone: 'Europe/Berlin'
      }
    ]
    softwareUpdateConfigurations: [
      {
        excludeUpdates: [
          '123456'
        ]
        frequency: 'Month'
        includeUpdates: [
          '654321'
        ]
        interval: 1
        maintenanceWindow: 'PT4H'
        monthlyOccurrences: [
          {
            day: 'Friday'
            occurrence: 3
          }
        ]
        name: 'Windows_ZeroDay'
        operatingSystem: 'Windows'
        rebootSetting: 'IfRequired'
        scopeByTags: {
          Update: [
            'Automatic-Wave1'
          ]
        }
        startTime: '22:00'
        updateClassifications: [
          'Critical'
          'Definition'
          'FeaturePack'
          'Security'
          'ServicePack'
          'Tools'
          'UpdateRollup'
          'Updates'
        ]
      }
      {
        excludeUpdates: [
          'icacls'
        ]
        frequency: 'OneTime'
        includeUpdates: [
          'kernel'
        ]
        maintenanceWindow: 'PT4H'
        name: 'Linux_ZeroDay'
        operatingSystem: 'Linux'
        rebootSetting: 'IfRequired'
        startTime: '22:00'
        updateClassifications: [
          'Critical'
          'Other'
          'Security'
        ]
      }
    ]
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
    variables: [
      {
        description: 'TestStringDescription'
        name: 'TestString'
        value: '\'TestString\''
      }
      {
        description: 'TestIntegerDescription'
        name: 'TestInteger'
        value: '500'
      }
      {
        description: 'TestBooleanDescription'
        name: 'TestBoolean'
        value: 'false'
      }
      {
        description: 'TestDateTimeDescription'
        isEncrypted: false
        name: 'TestDateTime'
        value: '\'\\/Date(1637934042656)\\/\''
      }
      {
        description: 'TestEncryptedDescription'
        name: 'TestEncryptedVariable'
        value: '\'TestEncryptedValue\''
      }
    ]
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
      "value": "<<namePrefix>>-az-aut-x-001"
    },
    // Non-required parameters
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
    },
    "diagnosticEventHubName": {
      "value": "adp-<<namePrefix>>-az-evh-x-001"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
    },
    "diagnosticStorageAccountId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
    },
    "diagnosticWorkspaceId": {
      "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
    },
    "gallerySolutions": {
      "value": [
        {
          "name": "Updates",
          "product": "OMSGallery",
          "publisher": "Microsoft"
        }
      ]
    },
    "jobSchedules": {
      "value": [
        {
          "runbookName": "TestRunbook",
          "scheduleName": "TestSchedule"
        }
      ]
    },
    "linkedWorkspaceResourceId": {
      "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-aut-001"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "modules": {
      "value": [
        {
          "name": "PSWindowsUpdate",
          "uri": "https://www.powershellgallery.com/api/v2/package",
          "version": "latest"
        }
      ]
    },
    "privateEndpoints": {
      "value": [
        {
          "service": "Webhook",
          "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints"
        },
        {
          "service": "DSCAndHybridWorker",
          "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<<deploymentSpId>>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "runbooks": {
      "value": [
        {
          "description": "Test runbook",
          "name": "TestRunbook",
          "runbookType": "PowerShell",
          "uri": "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.automation/101-automation/scripts/AzureAutomationTutorial.ps1",
          "version": "1.0.0.0"
        }
      ]
    },
    "schedules": {
      "value": [
        {
          "advancedSchedule": {},
          "expiryTime": "9999-12-31T13:00",
          "frequency": "Minute",
          "interval": 15,
          "name": "TestSchedule",
          "startTime": "",
          "timeZone": "Europe/Berlin"
        }
      ]
    },
    "softwareUpdateConfigurations": {
      "value": [
        {
          "excludeUpdates": [
            "123456"
          ],
          "frequency": "Month",
          "includeUpdates": [
            "654321"
          ],
          "interval": 1,
          "maintenanceWindow": "PT4H",
          "monthlyOccurrences": [
            {
              "day": "Friday",
              "occurrence": 3
            }
          ],
          "name": "Windows_ZeroDay",
          "operatingSystem": "Windows",
          "rebootSetting": "IfRequired",
          "scopeByTags": {
            "Update": [
              "Automatic-Wave1"
            ]
          },
          "startTime": "22:00",
          "updateClassifications": [
            "Critical",
            "Definition",
            "FeaturePack",
            "Security",
            "ServicePack",
            "Tools",
            "UpdateRollup",
            "Updates"
          ]
        },
        {
          "excludeUpdates": [
            "icacls"
          ],
          "frequency": "OneTime",
          "includeUpdates": [
            "kernel"
          ],
          "maintenanceWindow": "PT4H",
          "name": "Linux_ZeroDay",
          "operatingSystem": "Linux",
          "rebootSetting": "IfRequired",
          "startTime": "22:00",
          "updateClassifications": [
            "Critical",
            "Other",
            "Security"
          ]
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
    },
    "variables": {
      "value": [
        {
          "description": "TestStringDescription",
          "name": "TestString",
          "value": "\"TestString\""
        },
        {
          "description": "TestIntegerDescription",
          "name": "TestInteger",
          "value": "500"
        },
        {
          "description": "TestBooleanDescription",
          "name": "TestBoolean",
          "value": "false"
        },
        {
          "description": "TestDateTimeDescription",
          "isEncrypted": false,
          "name": "TestDateTime",
          "value": "\"\\/Date(1637934042656)\\/\""
        },
        {
          "description": "TestEncryptedDescription",
          "name": "TestEncryptedVariable",
          "value": "\"TestEncryptedValue\""
        }
      ]
    }
  }
}
```

</details>
<p>
