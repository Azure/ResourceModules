# Web/Function Apps `[Microsoft.Web/sites]`

This module deploys a Web or Function App.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)
- [Notes](#Notes)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/locks` | [2017-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Web/sites` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites) |
| `Microsoft.Web/sites/basicPublishingCredentialsPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |
| `Microsoft.Web/sites/config` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |
| `Microsoft.Web/sites/hybridConnectionNamespaces/relays` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/hybridConnectionNamespaces/relays) |
| `Microsoft.Web/sites/slots` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/slots) |
| `Microsoft.Web/sites/slots/config` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/slots/hybridConnectionNamespaces/relays) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `kind` | string | `[app, functionapp, functionapp,linux, functionapp,workflowapp, functionapp,workflowapp,linux]` | Type of site to deploy. |
| `name` | string |  | Name of the site. |
| `serverFarmResourceId` | string |  | The resource ID of the app service plan to use for the site. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appInsightResourceId` | string | `''` |  | Resource ID of the app insight to leverage for this resource. |
| `appServiceEnvironmentResourceId` | string | `''` |  | The resource ID of the app service environment to use for this resource. |
| `appSettingsKeyValuePairs` | object | `{object}` |  | The app settings-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING. |
| `authSettingV2Configuration` | object | `{object}` |  | The auth settings V2 configuration. |
| `basicPublishingCredentialsPolicies` | array | `[]` |  | The site publishing credential policy names which are associated with the sites. |
| `clientAffinityEnabled` | bool | `True` |  | If client affinity is enabled. |
| `clientCertEnabled` | bool | `False` |  | To enable client certificate authentication (TLS mutual authentication). |
| `clientCertExclusionPaths` | string | `''` |  | Client certificate authentication comma-separated exclusion paths. |
| `clientCertMode` | string | `'Optional'` | `[Optional, OptionalInteractiveUser, Required]` | This composes with ClientCertEnabled setting.</p>- ClientCertEnabled: false means ClientCert is ignored.</p>- ClientCertEnabled: true and ClientCertMode: Required means ClientCert is required.</p>- ClientCertEnabled: true and ClientCertMode: Optional means ClientCert is optional or accepted. |
| `cloningInfo` | object | `{object}` |  | If specified during app creation, the app is cloned from a source app. |
| `containerSize` | int | `-1` |  | Size of the function container. |
| `customDomainVerificationId` | string | `''` |  | Unique identifier that verifies the custom domains assigned to the app. Customer will add this ID to a txt record for verification. |
| `dailyMemoryTimeQuota` | int | `-1` |  | Maximum allowed daily memory-time quota (applicable on dynamic apps only). |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[if(equals(parameters('kind'), 'functionapp'), createArray('FunctionAppLogs'), createArray('AppServiceHTTPLogs', 'AppServiceConsoleLogs', 'AppServiceAppLogs', 'AppServiceAuditLogs', 'AppServiceIPSecAuditLogs', 'AppServicePlatformLogs'))]` | `['', allLogs, AppServiceAppLogs, AppServiceAuditLogs, AppServiceConsoleLogs, AppServiceHTTPLogs, AppServiceIPSecAuditLogs, AppServicePlatformLogs, FunctionAppLogs]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of log analytics workspace. |
| `enabled` | bool | `True` |  | Setting this value to false disables the app (takes the app offline). |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `hostNameSslStates` | array | `[]` |  | Hostname SSL states are used to manage the SSL bindings for app's hostnames. |
| `httpsOnly` | bool | `True` |  | Configures a site to accept only HTTPS requests. Issues redirect for HTTP requests. |
| `hybridConnectionRelays` | array | `[]` |  | Names of hybrid connection relays to connect app with. |
| `hyperV` | bool | `False` |  | Hyper-V sandbox. |
| `keyVaultAccessIdentityResourceId` | string | `''` |  | The resource ID of the assigned identity to be used to access a key vault with. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `publicNetworkAccess` | string | `''` | `['', Disabled, Enabled]` | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| `redundancyMode` | string | `'None'` | `[ActiveActive, Failover, GeoRedundant, Manual, None]` | Site redundancy mode. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `scmSiteAlsoStopped` | bool | `False` |  | Stop SCM (KUDU) site when the app is stopped. |
| `setAzureWebJobsDashboard` | bool | `[if(contains(parameters('kind'), 'functionapp'), true(), false())]` |  | For function apps. If true the app settings "AzureWebJobsDashboard" will be set. If false not. In case you use Application Insights it can make sense to not set it for performance reasons. |
| `siteConfig` | object | `{object}` |  | The site config object. |
| `slots` | array | `[]` |  | Configuration for deployment slots for an app. |
| `storageAccountRequired` | bool | `False` |  | Checks if Customer provided storage account is required. |
| `storageAccountResourceId` | string | `''` |  | Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `virtualNetworkSubnetId` | string | `''` |  | Azure Resource Manager ID of the Virtual network and subnet to be joined by Regional VNET Integration. This must be of the form /subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}. |
| `vnetContentShareEnabled` | bool | `False` |  | To enable accessing content over virtual network. |
| `vnetImagePullEnabled` | bool | `False` |  | To enable pulling image over Virtual Network. |
| `vnetRouteAllEnabled` | bool | `False` |  | Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `defaultHostname` | string | Default hostname of the app. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the site. |
| `resourceGroupName` | string | The resource group the site was deployed into. |
| `resourceId` | string | The resource ID of the site. |
| `slotResourceIds` | array | The list of the slot resource ids. |
| `slots` | array | The list of the slots. |
| `slotSystemAssignedPrincipalIds` | array | The principal ID of the system assigned identity of slots. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `network/private-endpoint` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Functionappcommon</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module site './web/site/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-wsfacom'
  params: {
    // Required parameters
    kind: 'functionapp'
    name: 'wsfacom001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    appInsightResourceId: '<appInsightResourceId>'
    appSettingsKeyValuePairs: {
      AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
      EASYAUTH_SECRET: '<EASYAUTH_SECRET>'
      FUNCTIONS_EXTENSION_VERSION: '~4'
      FUNCTIONS_WORKER_RUNTIME: 'dotnet'
    }
    authSettingV2Configuration: {
      globalValidation: {
        requireAuthentication: true
        unauthenticatedClientAction: 'Return401'
      }
      httpSettings: {
        forwardProxy: {
          convention: 'NoProxy'
        }
        requireHttps: true
        routes: {
          apiPrefix: '/.auth'
        }
      }
      identityProviders: {
        azureActiveDirectory: {
          enabled: true
          login: {
            disableWWWAuthenticate: false
          }
          registration: {
            clientId: 'd874dd2f-2032-4db1-a053-f0ec243685aa'
            clientSecretSettingName: 'EASYAUTH_SECRET'
            openIdIssuer: '<openIdIssuer>'
          }
          validation: {
            allowedAudiences: [
              'api://d874dd2f-2032-4db1-a053-f0ec243685aa'
            ]
            defaultAuthorizationPolicy: {
              allowedPrincipals: {}
            }
            jwtClaimChecks: {}
          }
        }
      }
      login: {
        allowedExternalRedirectUrls: [
          'string'
        ]
        cookieExpiration: {
          convention: 'FixedTime'
          timeToExpiration: '08:00:00'
        }
        nonce: {
          nonceExpirationInterval: '00:05:00'
          validateNonce: true
        }
        preserveUrlFragmentsForLogins: false
        routes: {}
        tokenStore: {
          azureBlobStorage: {}
          enabled: true
          fileSystem: {}
          tokenRefreshExtensionHours: 72
        }
      }
      platform: {
        enabled: true
        runtimeVersion: '~1'
      }
    }
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    hybridConnectionRelays: [
      {
        resourceId: '<resourceId>'
        sendKeyName: 'defaultSender'
      }
    ]
    keyVaultAccessIdentityResourceId: '<keyVaultAccessIdentityResourceId>'
    lock: 'CanNotDelete'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'sites'
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
    setAzureWebJobsDashboard: true
    siteConfig: {
      alwaysOn: true
      use32BitWorkerProcess: false
    }
    storageAccountResourceId: '<storageAccountResourceId>'
    systemAssignedIdentity: true
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
    "kind": {
      "value": "functionapp"
    },
    "name": {
      "value": "wsfacom001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "appInsightResourceId": {
      "value": "<appInsightResourceId>"
    },
    "appSettingsKeyValuePairs": {
      "value": {
        "AzureFunctionsJobHost__logging__logLevel__default": "Trace",
        "EASYAUTH_SECRET": "<EASYAUTH_SECRET>",
        "FUNCTIONS_EXTENSION_VERSION": "~4",
        "FUNCTIONS_WORKER_RUNTIME": "dotnet"
      }
    },
    "authSettingV2Configuration": {
      "value": {
        "globalValidation": {
          "requireAuthentication": true,
          "unauthenticatedClientAction": "Return401"
        },
        "httpSettings": {
          "forwardProxy": {
            "convention": "NoProxy"
          },
          "requireHttps": true,
          "routes": {
            "apiPrefix": "/.auth"
          }
        },
        "identityProviders": {
          "azureActiveDirectory": {
            "enabled": true,
            "login": {
              "disableWWWAuthenticate": false
            },
            "registration": {
              "clientId": "d874dd2f-2032-4db1-a053-f0ec243685aa",
              "clientSecretSettingName": "EASYAUTH_SECRET",
              "openIdIssuer": "<openIdIssuer>"
            },
            "validation": {
              "allowedAudiences": [
                "api://d874dd2f-2032-4db1-a053-f0ec243685aa"
              ],
              "defaultAuthorizationPolicy": {
                "allowedPrincipals": {}
              },
              "jwtClaimChecks": {}
            }
          }
        },
        "login": {
          "allowedExternalRedirectUrls": [
            "string"
          ],
          "cookieExpiration": {
            "convention": "FixedTime",
            "timeToExpiration": "08:00:00"
          },
          "nonce": {
            "nonceExpirationInterval": "00:05:00",
            "validateNonce": true
          },
          "preserveUrlFragmentsForLogins": false,
          "routes": {},
          "tokenStore": {
            "azureBlobStorage": {},
            "enabled": true,
            "fileSystem": {},
            "tokenRefreshExtensionHours": 72
          }
        },
        "platform": {
          "enabled": true,
          "runtimeVersion": "~1"
        }
      }
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "hybridConnectionRelays": {
      "value": [
        {
          "resourceId": "<resourceId>",
          "sendKeyName": "defaultSender"
        }
      ]
    },
    "keyVaultAccessIdentityResourceId": {
      "value": "<keyVaultAccessIdentityResourceId>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "sites",
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
    "setAzureWebJobsDashboard": {
      "value": true
    },
    "siteConfig": {
      "value": {
        "alwaysOn": true,
        "use32BitWorkerProcess": false
      }
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
    },
    "systemAssignedIdentity": {
      "value": true
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

<h3>Example 2: Functionappmin</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module site './web/site/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-wsfamin'
  params: {
    // Required parameters
    kind: 'functionapp'
    name: 'wsfamin001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    siteConfig: {
      alwaysOn: true
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
    "kind": {
      "value": "functionapp"
    },
    "name": {
      "value": "wsfamin001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "siteConfig": {
      "value": {
        "alwaysOn": true
      }
    }
  }
}
```

</details>
<p>

<h3>Example 3: Webappcommon</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module site './web/site/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-wswa'
  params: {
    // Required parameters
    kind: 'app'
    name: 'wswa001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    basicPublishingCredentialsPolicies: [
      {
        name: 'ftp'
      }
      {
        name: 'scm'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    httpsOnly: true
    hybridConnectionRelays: [
      {
        resourceId: '<resourceId>'
        sendKeyName: 'defaultSender'
      }
    ]
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'sites'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    publicNetworkAccess: 'Disabled'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    scmSiteAlsoStopped: true
    siteConfig: {
      alwaysOn: true
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnetcore'
        }
      ]
    }
    slots: [
      {
        diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
        diagnosticEventHubName: '<diagnosticEventHubName>'
        diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
        diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
        hybridConnectionRelays: [
          {
            resourceId: '<resourceId>'
            sendKeyName: 'defaultSender'
          }
        ]
        name: 'slot1'
        privateEndpoints: [
          {
            privateDnsZoneGroup: {
              privateDNSResourceIds: [
                '<privateDNSZoneResourceId>'
              ]
            }
            service: 'sites'
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
        siteConfig: {
          alwaysOn: true
          metadata: [
            {
              name: 'CURRENT_STACK'
              value: 'dotnetcore'
            }
          ]
        }
      }
      {
        name: 'slot2'
      }
    ]
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
    vnetContentShareEnabled: true
    vnetImagePullEnabled: true
    vnetRouteAllEnabled: true
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
    "kind": {
      "value": "app"
    },
    "name": {
      "value": "wswa001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "basicPublishingCredentialsPolicies": {
      "value": [
        {
          "name": "ftp"
        },
        {
          "name": "scm"
        }
      ]
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "httpsOnly": {
      "value": true
    },
    "hybridConnectionRelays": {
      "value": [
        {
          "resourceId": "<resourceId>",
          "sendKeyName": "defaultSender"
        }
      ]
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "sites",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "publicNetworkAccess": {
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
    "scmSiteAlsoStopped": {
      "value": true
    },
    "siteConfig": {
      "value": {
        "alwaysOn": true,
        "metadata": [
          {
            "name": "CURRENT_STACK",
            "value": "dotnetcore"
          }
        ]
      }
    },
    "slots": {
      "value": [
        {
          "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
          "diagnosticEventHubName": "<diagnosticEventHubName>",
          "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
          "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
          "hybridConnectionRelays": [
            {
              "resourceId": "<resourceId>",
              "sendKeyName": "defaultSender"
            }
          ],
          "name": "slot1",
          "privateEndpoints": [
            {
              "privateDnsZoneGroup": {
                "privateDNSResourceIds": [
                  "<privateDNSZoneResourceId>"
                ]
              },
              "service": "sites",
              "subnetResourceId": "<subnetResourceId>",
              "tags": {
                "Environment": "Non-Prod",
                "hidden-title": "This is visible in the resource name",
                "Role": "DeploymentValidation"
              }
            }
          ],
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "siteConfig": {
            "alwaysOn": true,
            "metadata": [
              {
                "name": "CURRENT_STACK",
                "value": "dotnetcore"
              }
            ]
          }
        },
        {
          "name": "slot2"
        }
      ]
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    },
    "vnetContentShareEnabled": {
      "value": true
    },
    "vnetImagePullEnabled": {
      "value": true
    },
    "vnetRouteAllEnabled": {
      "value": true
    }
  }
}
```

</details>
<p>

<h3>Example 4: Webappmin</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module site './web/site/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-wswamin'
  params: {
    // Required parameters
    kind: 'app'
    name: 'wswamin001'
    serverFarmResourceId: '<serverFarmResourceId>'
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
    "kind": {
      "value": "app"
    },
    "name": {
      "value": "wswamin001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
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


## Notes

### Parameter Usage: `appSettingsKeyValuePairs`

AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING are set separately (check parameters storageAccountId, setAzureWebJobsDashboard, appInsightId).
For all other app settings key-value pairs use this object.

<details>

<summary>Parameter JSON format</summary>

```json
"appSettingsKeyValuePairs": {
    "value": {
      "AzureFunctionsJobHost__logging__logLevel__default": "Trace",
      "EASYAUTH_SECRET": "https://adp-[[namePrefix]]-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password",
      "FUNCTIONS_EXTENSION_VERSION": "~4",
      "FUNCTIONS_WORKER_RUNTIME": "dotnet"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
appSettingsKeyValuePairs: {
  AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
  EASYAUTH_SECRET: 'https://adp-[[namePrefix]]-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password'
  FUNCTIONS_EXTENSION_VERSION: '~4'
  FUNCTIONS_WORKER_RUNTIME: 'dotnet'
}
```

</details>
<p>
