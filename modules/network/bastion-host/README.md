# Bastion Hosts `[Microsoft.Network/bastionHosts]`

This module deploys a Bastion Host.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/bastionHosts` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/bastionHosts) |
| `Microsoft.Network/publicIPAddresses` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/publicIPAddresses) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.bastion-host:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Custompip](#example-2-custompip)
- [Using Maximum Parameters](#example-3-using-maximum-parameters)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module bastionHost 'br:bicep/modules/network.bastion-host:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nbhcom'
  params: {
    // Required parameters
    name: 'nbhcom001'
    vNetId: '<vNetId>'
    // Non-required parameters
    bastionSubnetPublicIpResourceId: '<bastionSubnetPublicIpResourceId>'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    disableCopyPaste: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableFileCopy: false
    enableIpConnect: false
    enableShareableLink: false
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    scaleUnits: 4
    skuName: 'Standard'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
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
      "value": "nbhcom001"
    },
    "vNetId": {
      "value": "<vNetId>"
    },
    // Non-required parameters
    "bastionSubnetPublicIpResourceId": {
      "value": "<bastionSubnetPublicIpResourceId>"
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "disableCopyPaste": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enableFileCopy": {
      "value": false
    },
    "enableIpConnect": {
      "value": false
    },
    "enableShareableLink": {
      "value": false
    },
    "lock": {
      "value": "CanNotDelete"
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
    "scaleUnits": {
      "value": 4
    },
    "skuName": {
      "value": "Standard"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Custompip_

<details>

<summary>via Bicep module</summary>

```bicep
module bastionHost 'br:bicep/modules/network.bastion-host:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nbhctmpip'
  params: {
    // Required parameters
    name: 'nbhctmpip001'
    vNetId: '<vNetId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    publicIPAddressObject: {
      allocationMethod: 'Static'
      diagnosticLogCategoriesToEnable: [
        'DDoSMitigationFlowLogs'
        'DDoSMitigationReports'
        'DDoSProtectionNotifications'
      ]
      diagnosticMetricsToEnable: [
        'AllMetrics'
      ]
      name: 'nbhctmpip001-pip'
      publicIPPrefixResourceId: ''
      roleAssignments: [
        {
          principalIds: [
            '<managedIdentityPrincipalId>'
          ]
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Reader'
        }
      ]
      skuName: 'Standard'
      skuTier: 'Regional'
      zones: [
        '1'
        '2'
        '3'
      ]
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
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
      "value": "nbhctmpip001"
    },
    "vNetId": {
      "value": "<vNetId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "publicIPAddressObject": {
      "value": {
        "allocationMethod": "Static",
        "diagnosticLogCategoriesToEnable": [
          "DDoSMitigationFlowLogs",
          "DDoSMitigationReports",
          "DDoSProtectionNotifications"
        ],
        "diagnosticMetricsToEnable": [
          "AllMetrics"
        ],
        "name": "nbhctmpip001-pip",
        "publicIPPrefixResourceId": "",
        "roleAssignments": [
          {
            "principalIds": [
              "<managedIdentityPrincipalId>"
            ],
            "principalType": "ServicePrincipal",
            "roleDefinitionIdOrName": "Reader"
          }
        ],
        "skuName": "Standard",
        "skuTier": "Regional",
        "zones": [
          "1",
          "2",
          "3"
        ]
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

### Example 3: _Using Maximum Parameters_

This instance deploys the module with the large set of possible parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module bastionHost 'br:bicep/modules/network.bastion-host:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nbhmin'
  params: {
    // Required parameters
    name: 'nbhmin001'
    vNetId: '<vNetId>'
    // Non-required parameters
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
      "value": "nbhmin001"
    },
    "vNetId": {
      "value": "<vNetId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Azure Bastion resource. |
| [`vNetId`](#parameter-vnetid) | string | Shared services Virtual Network resource identifier. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bastionSubnetPublicIpResourceId`](#parameter-bastionsubnetpublicipresourceid) | string | The Public IP resource ID to associate to the azureBastionSubnet. If empty, then the Public IP that is created as part of this module will be applied to the azureBastionSubnet. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`disableCopyPaste`](#parameter-disablecopypaste) | bool | Choose to disable or enable Copy Paste. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enableFileCopy`](#parameter-enablefilecopy) | bool | Choose to disable or enable File Copy. |
| [`enableIpConnect`](#parameter-enableipconnect) | bool | Choose to disable or enable IP Connect. |
| [`enableKerberos`](#parameter-enablekerberos) | bool | Choose to disable or enable Kerberos authentication. |
| [`enableShareableLink`](#parameter-enableshareablelink) | bool | Choose to disable or enable Shareable Link. |
| [`isCreateDefaultPublicIP`](#parameter-iscreatedefaultpublicip) | bool | Specifies if a Public IP should be created by default if one is not provided. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`publicIPAddressObject`](#parameter-publicipaddressobject) | object | Specifies the properties of the Public IP to create and be used by Azure Bastion. If it's not provided and publicIPAddressResourceId is empty, a '-pip' suffix will be appended to the Bastion's name. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`scaleUnits`](#parameter-scaleunits) | int | The scale units for the Bastion Host resource. |
| [`skuName`](#parameter-skuname) | string | The SKU of this Bastion Host. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `bastionSubnetPublicIpResourceId`

The Public IP resource ID to associate to the azureBastionSubnet. If empty, then the Public IP that is created as part of this module will be applied to the azureBastionSubnet.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticLogCategoriesToEnable`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array
- Default: `[allLogs]`
- Allowed: `['', allLogs, BastionAuditLogs]`

### Parameter: `diagnosticSettingsName`

The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource ID of the diagnostic log analytics workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `disableCopyPaste`

Choose to disable or enable Copy Paste.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableFileCopy`

Choose to disable or enable File Copy.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableIpConnect`

Choose to disable or enable IP Connect.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableKerberos`

Choose to disable or enable Kerberos authentication.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableShareableLink`

Choose to disable or enable Shareable Link.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `isCreateDefaultPublicIP`

Specifies if a Public IP should be created by default if one is not provided.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

Name of the Azure Bastion resource.
- Required: Yes
- Type: string

### Parameter: `publicIPAddressObject`

Specifies the properties of the Public IP to create and be used by Azure Bastion. If it's not provided and publicIPAddressResourceId is empty, a '-pip' suffix will be appended to the Bastion's name.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `scaleUnits`

The scale units for the Bastion Host resource.
- Required: No
- Type: int
- Default: `2`

### Parameter: `skuName`

The SKU of this Bastion Host.
- Required: No
- Type: string
- Default: `'Basic'`
- Allowed: `[Basic, Standard]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `vNetId`

Shared services Virtual Network resource identifier.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `ipConfAzureBastionSubnet` | object | The Public IPconfiguration object for the AzureBastionSubnet. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name the Azure Bastion. |
| `resourceGroupName` | string | The resource group the Azure Bastion was deployed into. |
| `resourceId` | string | The resource ID the Azure Bastion. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/public-ip-address` | Local reference |
