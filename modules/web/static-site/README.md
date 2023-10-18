# Static Web Apps `[Microsoft.Web/staticSites]`

This module deploys a Static Web App.

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
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Web/staticSites` | [2021-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-03-01/staticSites) |
| `Microsoft.Web/staticSites/config` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/staticSites/config) |
| `Microsoft.Web/staticSites/customDomains` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/staticSites/customDomains) |
| `Microsoft.Web/staticSites/linkedBackends` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/staticSites/linkedBackends) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/web.static-site:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module staticSite 'br:bicep/modules/web.static-site:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-wsscom'
  params: {
    // Required parameters
    name: 'wsscom001'
    // Non-required parameters
    allowConfigFileUpdates: true
    appSettings: {
      foo: 'bar'
      setting: 1
    }
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enterpriseGradeCdnStatus: 'Disabled'
    functionAppSettings: {
      foo: 'bar'
      setting: 1
    }
    linkedBackend: {
      resourceId: '<resourceId>'
    }
    lock: 'CanNotDelete'
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        service: 'staticSites'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    sku: 'Standard'
    stagingEnvironmentPolicy: 'Enabled'
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
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
      "value": "wsscom001"
    },
    // Non-required parameters
    "allowConfigFileUpdates": {
      "value": true
    },
    "appSettings": {
      "value": {
        "foo": "bar",
        "setting": 1
      }
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enterpriseGradeCdnStatus": {
      "value": "Disabled"
    },
    "functionAppSettings": {
      "value": {
        "foo": "bar",
        "setting": 1
      }
    },
    "linkedBackend": {
      "value": {
        "resourceId": "<resourceId>"
      }
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "service": "staticSites",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
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
    "sku": {
      "value": "Standard"
    },
    "stagingEnvironmentPolicy": {
      "value": "Enabled"
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module staticSite 'br:bicep/modules/web.static-site:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-wssmin'
  params: {
    // Required parameters
    name: 'wssmin001'
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
      "value": "wssmin001"
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
| [`name`](#parameter-name) | string | Name of the static site. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowConfigFileUpdates`](#parameter-allowconfigfileupdates) | bool | False if config file is locked for this static web app; otherwise, true. |
| [`appSettings`](#parameter-appsettings) | object | Static site app settings. |
| [`branch`](#parameter-branch) | string | The branch name of the GitHub repository. |
| [`buildProperties`](#parameter-buildproperties) | object | Build properties for the static site. |
| [`customDomains`](#parameter-customdomains) | array | The custom domains associated with this static site. The deployment will fail as long as the validation records are not present. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enterpriseGradeCdnStatus`](#parameter-enterprisegradecdnstatus) | string | State indicating the status of the enterprise grade CDN serving traffic to the static web app. |
| [`functionAppSettings`](#parameter-functionappsettings) | object | Function app settings. |
| [`linkedBackend`](#parameter-linkedbackend) | object | Object with "resourceId" and "location" of the a user defined function app. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Note, requires the 'sku' to be 'Standard'. |
| [`provider`](#parameter-provider) | string | The provider that submitted the last deployment to the primary environment of the static site. |
| [`repositoryToken`](#parameter-repositorytoken) | securestring | The Personal Access Token for accessing the GitHub repository. |
| [`repositoryUrl`](#parameter-repositoryurl) | string | The name of the GitHub repository. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`sku`](#parameter-sku) | string | Type of static site to deploy. |
| [`stagingEnvironmentPolicy`](#parameter-stagingenvironmentpolicy) | string | State indicating whether staging environments are allowed or not allowed for a static web app. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`templateProperties`](#parameter-templateproperties) | object | Template Options for the static site. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |

### Parameter: `allowConfigFileUpdates`

False if config file is locked for this static web app; otherwise, true.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `appSettings`

Static site app settings.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `branch`

The branch name of the GitHub repository.
- Required: No
- Type: string
- Default: `''`

### Parameter: `buildProperties`

Build properties for the static site.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `customDomains`

The custom domains associated with this static site. The deployment will fail as long as the validation records are not present.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enterpriseGradeCdnStatus`

State indicating the status of the enterprise grade CDN serving traffic to the static web app.
- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed: `[Disabled, Disabling, Enabled, Enabling]`

### Parameter: `functionAppSettings`

Function app settings.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `linkedBackend`

Object with "resourceId" and "location" of the a user defined function app.
- Required: No
- Type: object
- Default: `{object}`

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

Name of the static site.
- Required: Yes
- Type: string

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Note, requires the 'sku' to be 'Standard'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `provider`

The provider that submitted the last deployment to the primary environment of the static site.
- Required: No
- Type: string
- Default: `'None'`

### Parameter: `repositoryToken`

The Personal Access Token for accessing the GitHub repository.
- Required: No
- Type: securestring
- Default: `''`

### Parameter: `repositoryUrl`

The name of the GitHub repository.
- Required: No
- Type: string
- Default: `''`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `sku`

Type of static site to deploy.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed: `[Free, Standard]`

### Parameter: `stagingEnvironmentPolicy`

State indicating whether staging environments are allowed or not allowed for a static web app.
- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed: `[Disabled, Enabled]`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `templateProperties`

Template Options for the static site.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `defaultHostname` | string | The default autogenerated hostname for the static site. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the static site. |
| `resourceGroupName` | string | The resource group the static site was deployed into. |
| `resourceId` | string | The resource ID of the static site. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |
