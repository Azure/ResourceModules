# API Management Services `[Microsoft.ApiManagement/service]`

This module deploys an API management service.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Considerations](#Considerations)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service) |
| `Microsoft.ApiManagement/service/apis` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apis) |
| `Microsoft.ApiManagement/service/apis/policies` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apis/policies) |
| `Microsoft.ApiManagement/service/apiVersionSets` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apiVersionSets) |
| `Microsoft.ApiManagement/service/authorizationServers` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/authorizationServers) |
| `Microsoft.ApiManagement/service/backends` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/backends) |
| `Microsoft.ApiManagement/service/caches` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/caches) |
| `Microsoft.ApiManagement/service/identityProviders` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/identityProviders) |
| `Microsoft.ApiManagement/service/namedValues` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/namedValues) |
| `Microsoft.ApiManagement/service/policies` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/policies) |
| `Microsoft.ApiManagement/service/portalsettings` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/service) |
| `Microsoft.ApiManagement/service/products` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/products) |
| `Microsoft.ApiManagement/service/products/apis` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/products/apis) |
| `Microsoft.ApiManagement/service/products/groups` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/products/groups) |
| `Microsoft.ApiManagement/service/subscriptions` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/subscriptions) |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

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
| `apis` | _[apis](apis/readme.md)_ array | `[]` |  | APIs. |
| `apiVersionSets` | _[apiVersionSets](apiVersionSets/readme.md)_ array | `[]` |  | API Version Sets. |
| `authorizationServers` | _[authorizationServers](authorizationServers/readme.md)_ array | `[]` |  | Authorization servers. |
| `backends` | _[backends](backends/readme.md)_ array | `[]` |  | Backends. |
| `caches` | _[caches](caches/readme.md)_ array | `[]` |  | Caches. |
| `certificates` | array | `[]` |  | List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10. |
| `customProperties` | object | `{object}` |  | Custom properties of the API Management service. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[GatewayLogs]` | `[GatewayLogs]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `disableGateway` | bool | `False` |  | Property only valid for an API Management service deployed in multiple locations. This can be used to disable the gateway in master region. |
| `enableClientCertificate` | bool | `False` |  | Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `hostnameConfigurations` | array | `[]` |  | Custom hostname configuration of the API Management service. |
| `identityProviders` | _[identityProviders](identityProviders/readme.md)_ array | `[]` |  | Identity providers. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `minApiVersion` | string | `''` |  | Limit control plane API calls to API Management service with version equal to or newer than this value. |
| `namedValues` | _[namedValues](namedValues/readme.md)_ array | `[]` |  | Named values. |
| `newGuidValue` | string | `[newGuid()]` |  | Necessary to create a new GUID. |
| `notificationSenderEmail` | string | `'apimgmt-noreply@mail.windowsazure.com'` |  | The notification sender email address for the service. |
| `policies` | _[policies](policies/readme.md)_ array | `[]` |  | Policies. |
| `portalSettings` | _[portalSettings](portalSettings/readme.md)_ array | `[]` |  | Portal settings. |
| `products` | _[products](products/readme.md)_ array | `[]` |  | Products. |
| `restore` | bool | `False` |  | Undelete API Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sku` | string | `'Developer'` | `[Consumption, Developer, Basic, Standard, Premium]` | The pricing tier of this API Management service. |
| `skuCount` | int | `1` | `[1, 2]` | The instance size of this API Management service. |
| `subnetResourceId` | string | `''` |  | The full resource ID of a subnet in a virtual network to deploy the API Management service in. |
| `subscriptions` | _[subscriptions](subscriptions/readme.md)_ array | `[]` |  | Subscriptions. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `virtualNetworkType` | string | `'None'` | `[None, External, Internal]` | The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only. |
| `zones` | array | `[]` |  | A list of availability zones denoting where the resource needs to come from. |


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
| `name` | string | The name of the API management service. |
| `resourceGroupName` | string | The resource group the API management service was deployed into. |
| `resourceId` | string | The resource ID of the API management service. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Considerations

- *None*

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
            "value": "<<namePrefix>>-az-apim-max-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "publisherEmail": {
            "value": "apimgmt-noreply@mail.windowsazure.com"
        },
        "publisherName": {
            "value": "<<namePrefix>>-az-amorg-x-001"
        },
        "apis": {
            "value": [
                {
                    "name": "echo-api",
                    "displayName": "Echo API",
                    "path": "echo",
                    "serviceUrl": "http://echoapi.cloudapp.net/api",
                    "apiVersionSet": {
                        "name": "echo-version-set",
                        "properties": {
                            "description": "echo-version-set",
                            "displayName": "echo-version-set",
                            "versioningScheme": "Segment"
                        }
                    }
                }
            ]
        },
        "authorizationServers": {
            "value": [
                {
                    "name": "AuthServer1",
                    "authorizationEndpoint": "https://login.microsoftonline.com/651b43ce-ccb8-4301-b551-b04dd872d401/oauth2/v2.0/authorize",
                    "grantTypes": [
                        "authorizationCode"
                    ],
                    "clientCredentialsKeyVaultId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001",
                    "clientIdSecretName": "apimclientid",
                    "clientSecretSecretName": "apimclientsecret",
                    "clientRegistrationEndpoint": "http://localhost",
                    "tokenEndpoint": "https://login.microsoftonline.com/651b43ce-ccb8-4301-b551-b04dd872d401/oauth2/v2.0/token"
                }
            ]
        },
        "backends": {
            "value": [
                {
                    "name": "backend",
                    "url": "http://echoapi.cloudapp.net/api",
                    "tls": {
                        "validateCertificateChain": false,
                        "validateCertificateName": false
                    }
                }
            ]
        },
        "caches": {
            "value": [
                {
                    "name": "westeurope",
                    "connectionString": "connectionstringtest",
                    "useFromLocation": "westeurope"
                }
            ]
        },
        "identityProviders": {
            "value": [
                {
                    "name": "aadProvider"
                }
            ]
        },
        "namedValues": {
            "value": [
                {
                    "name": "apimkey",
                    "displayName": "apimkey",
                    "secret": true
                }
            ]
        },
        "policies": {
            "value": [
                {
                    "value": "<policies> <inbound> <rate-limit-by-key calls='250' renewal-period='60' counter-key='@(context.Request.IpAddress)' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>",
                    "format": "xml"
                }
            ]
        },
        "portalSettings": {
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
                            "enabled": false,
                            "consentRequired": false
                        }
                    }
                }
            ]
        },
        "products": {
            "value": [
                {
                    "name": "Starter",
                    "subscriptionRequired": false,
                    "approvalRequired": false,
                    "apis": [
                        {
                            "name": "echo-api"
                        }
                    ],
                    "groups": [
                        {
                            "name": "developers"
                        }
                    ]
                }
            ]
        },
        "subscriptions": {
            "value": [
                {
                    "scope": "/apis",
                    "name": "testArmSubscriptionAllApis"
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
        "diagnosticLogsRetentionInDays": {
            "value": 7
        },
        "diagnosticStorageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "diagnosticWorkspaceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        },
        "diagnosticEventHubAuthorizationRuleId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
        },
        "diagnosticEventHubName": {
            "value": "adp-<<namePrefix>>-az-evh-x-001"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module service './Microsoft.ApiManagement/service/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-service'
  params: {
    name: '<<namePrefix>>-az-apim-max-001'
    lock: 'CanNotDelete'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: '<<namePrefix>>-az-amorg-x-001'
    apis: [
      {
        name: 'echo-api'
        displayName: 'Echo API'
        path: 'echo'
        serviceUrl: 'http://echoapi.cloudapp.net/api'
        apiVersionSet: {
          name: 'echo-version-set'
          properties: {
            description: 'echo-version-set'
            displayName: 'echo-version-set'
            versioningScheme: 'Segment'
          }
        }
      }
    ]
    authorizationServers: [
      {
        name: 'AuthServer1'
        authorizationEndpoint: 'https://login.microsoftonline.com/651b43ce-ccb8-4301-b551-b04dd872d401/oauth2/v2.0/authorize'
        grantTypes: [
          'authorizationCode'
        ]
        clientCredentialsKeyVaultId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001'
        clientIdSecretName: 'apimclientid'
        clientSecretSecretName: 'apimclientsecret'
        clientRegistrationEndpoint: 'http://localhost'
        tokenEndpoint: 'https://login.microsoftonline.com/651b43ce-ccb8-4301-b551-b04dd872d401/oauth2/v2.0/token'
      }
    ]
    backends: [
      {
        name: 'backend'
        url: 'http://echoapi.cloudapp.net/api'
        tls: {
          validateCertificateChain: false
          validateCertificateName: false
        }
      }
    ]
    caches: [
      {
        name: 'westeurope'
        connectionString: 'connectionstringtest'
        useFromLocation: 'westeurope'
      }
    ]
    identityProviders: [
      {
        name: 'aadProvider'
      }
    ]
    namedValues: [
      {
        name: 'apimkey'
        displayName: 'apimkey'
        secret: true
      }
    ]
    policies: [
      {
        value: '<policies> <inbound> <rate-limit-by-key calls='250' renewal-period='60' counter-key='@(context.Request.IpAddress)' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>'
        format: 'xml'
      }
    ]
    portalSettings: [
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
            enabled: false
            consentRequired: false
          }
        }
      }
    ]
    products: [
      {
        name: 'Starter'
        subscriptionRequired: false
        approvalRequired: false
        apis: [
          {
            name: 'echo-api'
          }
        ]
        groups: [
          {
            name: 'developers'
          }
        ]
      }
    ]
    subscriptions: [
      {
        scope: '/apis'
        name: 'testArmSubscriptionAllApis'
      }
    ]
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
  }
}
```

</details>
<p>

<h3>Example 2</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-apim-min-001"
        },
        "publisherEmail": {
            "value": "apimgmt-noreply@mail.windowsazure.com"
        },
        "publisherName": {
            "value": "<<namePrefix>>-az-amorg-x-001"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module service './Microsoft.ApiManagement/service/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-service'
  params: {
    name: '<<namePrefix>>-az-apim-min-001'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: '<<namePrefix>>-az-amorg-x-001'
  }
}
```

</details>
<p>

<h3>Example 3</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-apim-x-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "publisherEmail": {
            "value": "apimgmt-noreply@mail.windowsazure.com"
        },
        "publisherName": {
            "value": "<<namePrefix>>-az-amorg-x-001"
        },
        "portalSettings": {
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
                            "enabled": false,
                            "consentRequired": false
                        }
                    }
                }
            ]
        },
        "policies": {
            "value": [
                {
                    "value": "<policies> <inbound> <rate-limit-by-key calls='250' renewal-period='60' counter-key='@(context.Request.IpAddress)' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>",
                    "format": "xml"
                }
            ]
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
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module service './Microsoft.ApiManagement/service/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-service'
  params: {
    name: '<<namePrefix>>-az-apim-x-001'
    lock: 'CanNotDelete'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: '<<namePrefix>>-az-amorg-x-001'
    portalSettings: [
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
            enabled: false
            consentRequired: false
          }
        }
      }
    ]
    policies: [
      {
        value: '<policies> <inbound> <rate-limit-by-key calls='250' renewal-period='60' counter-key='@(context.Request.IpAddress)' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>'
        format: 'xml'
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
  }
}
```

</details>
<p>
