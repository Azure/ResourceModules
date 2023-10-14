# API Management Services `[Microsoft.ApiManagement/service]`

This module deploys an API Management Service.

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
| `Microsoft.ApiManagement/service` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service) |
| `Microsoft.ApiManagement/service/apis` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apis) |
| `Microsoft.ApiManagement/service/apis/policies` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apis/policies) |
| `Microsoft.ApiManagement/service/apiVersionSets` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apiVersionSets) |
| `Microsoft.ApiManagement/service/authorizationServers` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/authorizationServers) |
| `Microsoft.ApiManagement/service/backends` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/backends) |
| `Microsoft.ApiManagement/service/caches` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/caches) |
| `Microsoft.ApiManagement/service/identityProviders` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/identityProviders) |
| `Microsoft.ApiManagement/service/namedValues` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/namedValues) |
| `Microsoft.ApiManagement/service/policies` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/policies) |
| `Microsoft.ApiManagement/service/portalsettings` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/service) |
| `Microsoft.ApiManagement/service/products` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/products) |
| `Microsoft.ApiManagement/service/products/apis` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/products/apis) |
| `Microsoft.ApiManagement/service/products/groups` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/products/groups) |
| `Microsoft.ApiManagement/service/subscriptions` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/subscriptions) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API Management service. |
| `publisherEmail` | string | The email address of the owner of the service. |
| `publisherName` | string | The name of the owner of the service. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `additionalLocations` | array | `[]` |  | Additional datacenter locations of the API Management service. |
| `apis` | array | `[]` |  | APIs. |
| `apiVersionSets` | array | `[]` |  | API Version Sets. |
| `authorizationServers` | secureObject | `{object}` |  | Authorization servers. |
| `backends` | array | `[]` |  | Backends. |
| `caches` | array | `[]` |  | Caches. |
| `certificates` | array | `[]` |  | List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10. |
| `customProperties` | object | `{object}` |  | Custom properties of the API Management service. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', allLogs, GatewayLogs]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `disableGateway` | bool | `False` |  | Property only valid for an API Management service deployed in multiple locations. This can be used to disable the gateway in master region. |
| `enableClientCertificate` | bool | `False` |  | Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `hostnameConfigurations` | array | `[]` |  | Custom hostname configuration of the API Management service. |
| `identityProviders` | array | `[]` |  | Identity providers. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `minApiVersion` | string | `''` |  | Limit control plane API calls to API Management service with version equal to or newer than this value. |
| `namedValues` | array | `[]` |  | Named values. |
| `newGuidValue` | string | `[newGuid()]` |  | Necessary to create a new GUID. |
| `notificationSenderEmail` | string | `'apimgmt-noreply@mail.windowsazure.com'` |  | The notification sender email address for the service. |
| `policies` | array | `[]` |  | Policies. |
| `portalsettings` | array | `[]` |  | Portal settings. |
| `products` | array | `[]` |  | Products. |
| `restore` | bool | `False` |  | Undelete API Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sku` | string | `'Developer'` | `[Basic, Consumption, Developer, Premium, Standard]` | The pricing tier of this API Management service. |
| `skuCount` | int | `1` | `[1, 2]` | The instance size of this API Management service. |
| `subnetResourceId` | string | `''` |  | The full resource ID of a subnet in a virtual network to deploy the API Management service in. |
| `subscriptions` | array | `[]` |  | Subscriptions. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `virtualNetworkType` | string | `'None'` | `[External, Internal, None]` | The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only. |
| `zones` | array | `[]` |  | A list of availability zones denoting where the resource needs to come from. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the API management service. |
| `resourceGroupName` | string | The resource group the API management service was deployed into. |
| `resourceId` | string | The resource ID of the API management service. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module service './api-management/service/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-apiscom'
  params: {
    // Required parameters
    name: 'apiscom001'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: 'az-amorg-x-001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    policies: [
      {
        format: 'xml'
        value: '<policies> <inbound> <rate-limit-by-key calls=\'250\' renewal-period=\'60\' counter-key=\'@(context.Request.IpAddress)\' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>'
      }
    ]
    portalsettings: [
      {
        name: 'signin'
        properties: {
          enabled: false
        }
      }
      {
        name: 'signup'
        properties: {
          enabled: false
          termsOfService: {
            consentRequired: false
            enabled: false
          }
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
      "value": "apiscom001"
    },
    "publisherEmail": {
      "value": "apimgmt-noreply@mail.windowsazure.com"
    },
    "publisherName": {
      "value": "az-amorg-x-001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "policies": {
      "value": [
        {
          "format": "xml",
          "value": "<policies> <inbound> <rate-limit-by-key calls=\"250\" renewal-period=\"60\" counter-key=\"@(context.Request.IpAddress)\" /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>"
        }
      ]
    },
    "portalsettings": {
      "value": [
        {
          "name": "signin",
          "properties": {
            "enabled": false
          }
        },
        {
          "name": "signup",
          "properties": {
            "enabled": false,
            "termsOfService": {
              "consentRequired": false,
              "enabled": false
            }
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

<h3>Example 2: Max</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module service './api-management/service/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-apismax'
  params: {
    // Required parameters
    name: 'apismax001'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: 'az-amorg-x-001'
    // Non-required parameters
    apis: [
      {
        apiVersionSet: {
          name: 'echo-version-set'
          properties: {
            description: 'echo-version-set'
            displayName: 'echo-version-set'
            versioningScheme: 'Segment'
          }
        }
        displayName: 'Echo API'
        name: 'echo-api'
        path: 'echo'
        serviceUrl: 'http://echoapi.cloudapp.net/api'
      }
    ]
    authorizationServers: {
      secureList: [
        {
          authorizationEndpoint: '<authorizationEndpoint>'
          clientId: 'apimclientid'
          clientRegistrationEndpoint: 'http://localhost'
          clientSecret: '<clientSecret>'
          grantTypes: [
            'authorizationCode'
          ]
          name: 'AuthServer1'
          tokenEndpoint: '<tokenEndpoint>'
        }
      ]
    }
    backends: [
      {
        name: 'backend'
        tls: {
          validateCertificateChain: false
          validateCertificateName: false
        }
        url: 'http://echoapi.cloudapp.net/api'
      }
    ]
    caches: [
      {
        connectionString: 'connectionstringtest'
        name: 'westeurope'
        useFromLocation: 'westeurope'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    identityProviders: [
      {
        name: 'aadProvider'
      }
    ]
    lock: 'CanNotDelete'
    namedValues: [
      {
        displayName: 'apimkey'
        name: 'apimkey'
        secret: true
      }
    ]
    policies: [
      {
        format: 'xml'
        value: '<policies> <inbound> <rate-limit-by-key calls=\'250\' renewal-period=\'60\' counter-key=\'@(context.Request.IpAddress)\' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>'
      }
    ]
    portalsettings: [
      {
        name: 'signin'
        properties: {
          enabled: false
        }
      }
      {
        name: 'signup'
        properties: {
          enabled: false
          termsOfService: {
            consentRequired: false
            enabled: false
          }
        }
      }
    ]
    products: [
      {
        apis: [
          {
            name: 'echo-api'
          }
        ]
        approvalRequired: false
        groups: [
          {
            name: 'developers'
          }
        ]
        name: 'Starter'
        subscriptionRequired: false
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
    subscriptions: [
      {
        name: 'testArmSubscriptionAllApis'
      }
    ]
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
      "value": "apismax001"
    },
    "publisherEmail": {
      "value": "apimgmt-noreply@mail.windowsazure.com"
    },
    "publisherName": {
      "value": "az-amorg-x-001"
    },
    // Non-required parameters
    "apis": {
      "value": [
        {
          "apiVersionSet": {
            "name": "echo-version-set",
            "properties": {
              "description": "echo-version-set",
              "displayName": "echo-version-set",
              "versioningScheme": "Segment"
            }
          },
          "displayName": "Echo API",
          "name": "echo-api",
          "path": "echo",
          "serviceUrl": "http://echoapi.cloudapp.net/api"
        }
      ]
    },
    "authorizationServers": {
      "value": {
        "secureList": [
          {
            "authorizationEndpoint": "<authorizationEndpoint>",
            "clientId": "apimclientid",
            "clientRegistrationEndpoint": "http://localhost",
            "clientSecret": "<clientSecret>",
            "grantTypes": [
              "authorizationCode"
            ],
            "name": "AuthServer1",
            "tokenEndpoint": "<tokenEndpoint>"
          }
        ]
      }
    },
    "backends": {
      "value": [
        {
          "name": "backend",
          "tls": {
            "validateCertificateChain": false,
            "validateCertificateName": false
          },
          "url": "http://echoapi.cloudapp.net/api"
        }
      ]
    },
    "caches": {
      "value": [
        {
          "connectionString": "connectionstringtest",
          "name": "westeurope",
          "useFromLocation": "westeurope"
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
    "identityProviders": {
      "value": [
        {
          "name": "aadProvider"
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "namedValues": {
      "value": [
        {
          "displayName": "apimkey",
          "name": "apimkey",
          "secret": true
        }
      ]
    },
    "policies": {
      "value": [
        {
          "format": "xml",
          "value": "<policies> <inbound> <rate-limit-by-key calls=\"250\" renewal-period=\"60\" counter-key=\"@(context.Request.IpAddress)\" /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>"
        }
      ]
    },
    "portalsettings": {
      "value": [
        {
          "name": "signin",
          "properties": {
            "enabled": false
          }
        },
        {
          "name": "signup",
          "properties": {
            "enabled": false,
            "termsOfService": {
              "consentRequired": false,
              "enabled": false
            }
          }
        }
      ]
    },
    "products": {
      "value": [
        {
          "apis": [
            {
              "name": "echo-api"
            }
          ],
          "approvalRequired": false,
          "groups": [
            {
              "name": "developers"
            }
          ],
          "name": "Starter",
          "subscriptionRequired": false
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
    "subscriptions": {
      "value": [
        {
          "name": "testArmSubscriptionAllApis"
        }
      ]
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

<h3>Example 3: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module service './api-management/service/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-apismin'
  params: {
    // Required parameters
    name: 'apismin001'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: 'az-amorg-x-001'
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
      "value": "apismin001"
    },
    "publisherEmail": {
      "value": "apimgmt-noreply@mail.windowsazure.com"
    },
    "publisherName": {
      "value": "az-amorg-x-001"
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

### Parameter Usage: `apiManagementServicePolicy`

<details>

<summary>Parameter JSON format</summary>

```json
"apiManagementServicePolicy": {
    "value": {
        "value":"<policies> <inbound> <rate-limit-by-key calls='250' renewal-period='60' counter-key='@(context.Request.IpAddress)' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>",
        "format":"xml"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
apiManagementServicePolicy: {
    value:'<policies> <inbound> <rate-limit-by-key calls=\'250\' renewal-period='60' counter-key=\'@(context.Request.IpAddress)\' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>'
    format:'xml'
}
```

</details>
<p>
