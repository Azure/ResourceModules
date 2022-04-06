# Network Application Gateways `[Microsoft.Network/applicationGateways]`

This module deploys Network ApplicationGateways.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/applicationGateways` | 2021-05-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Application Gateway. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `authenticationCertificates` | array | `[]` |  | Authentication certificates of the application gateway resource. |
| `autoscaleMaxCapacity` | int | `-1` |  | Upper bound on number of Application Gateway capacity. |
| `autoscaleMinCapacity` | int | `-1` |  | Lower bound on number of Application Gateway capacity. |
| `backendAddressPools` | array | `[]` |  | Backend address pool of the application gateway resource. |
| `backendHttpSettingsCollection` | array | `[]` |  | Backend http settings of the application gateway resource. |
| `capacity` | int | `2` |  | The number of Application instances to be configured. |
| `customErrorConfigurations` | array | `[]` |  | Custom error configurations of the application gateway resource. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.  |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub |
| `diagnosticLogCategoriesToEnable` | array | `[ApplicationGatewayAccessLog, ApplicationGatewayPerformanceLog, ApplicationGatewayFirewallLog]` | `[ApplicationGatewayAccessLog, ApplicationGatewayPerformanceLog, ApplicationGatewayFirewallLog]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `enableFips` | bool | `False` |  | Whether FIPS is enabled on the application gateway resource. |
| `enableHttp2` | bool | `False` |  | Whether HTTP2 is enabled on the application gateway resource. |
| `enableRequestBuffering` | bool | `False` |  | Enable request buffering. |
| `enableResponseBuffering` | bool | `False` |  | Enable response buffering. |
| `firewallPolicyId` | string | `''` |  | The resource ID of an associated firewall policy. |
| `frontendIPConfigurations` | array | `[]` |  | Frontend IP addresses of the application gateway resource. |
| `frontendPorts` | array | `[]` |  | Frontend ports of the application gateway resource. |
| `gatewayIPConfigurations` | array | `[]` |  | Subnets of the application gateway resource. |
| `httpListeners` | array | `[]` |  | Http listeners of the application gateway resource. |
| `loadDistributionPolicies` | array | `[]` |  | Load distribution policies of the application gateway resource. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `privateLinkConfigurations` | array | `[]` |  | PrivateLink configurations on application gateway. |
| `probes` | array | `[]` |  | Probes of the application gateway resource. |
| `redirectConfigurations` | array | `[]` |  | Redirect configurations of the application gateway resource. |
| `requestRoutingRules` | array | `[]` |  | Request routing rules of the application gateway resource. |
| `rewriteRuleSets` | array | `[]` |  | Rewrite rules for the application gateway resource.	 |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sku` | string | `'WAF_Medium'` | `[Standard_Small, Standard_Medium, Standard_Large, WAF_Medium, WAF_Large, Standard_v2, WAF_v2]` | The name of the SKU for the Application Gateway. |
| `sslCertificates` | array | `[]` |  | SSL certificates of the application gateway resource. |
| `sslPolicyCipherSuites` | array | `[TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256]` | `[TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA, TLS_DHE_DSS_WITH_AES_128_CBC_SHA, TLS_DHE_DSS_WITH_AES_128_CBC_SHA256, TLS_DHE_DSS_WITH_AES_256_CBC_SHA, TLS_DHE_DSS_WITH_AES_256_CBC_SHA256, TLS_DHE_RSA_WITH_AES_128_CBC_SHA, TLS_DHE_RSA_WITH_AES_128_GCM_SHA256, TLS_DHE_RSA_WITH_AES_256_CBC_SHA, TLS_DHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_RSA_WITH_3DES_EDE_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA256, TLS_RSA_WITH_AES_128_GCM_SHA256, TLS_RSA_WITH_AES_256_CBC_SHA, TLS_RSA_WITH_AES_256_CBC_SHA256, TLS_RSA_WITH_AES_256_GCM_SHA384]` | Ssl cipher suites to be enabled in the specified order to application gateway. |
| `sslPolicyMinProtocolVersion` | string | `'TLSv1_2'` | `[TLSv1_0, TLSv1_1, TLSv1_2]` | Ssl protocol enums. |
| `sslPolicyName` | string | `''` | `[AppGwSslPolicy20150501, AppGwSslPolicy20170401, AppGwSslPolicy20170401S, ]` | Ssl predefined policy name enums. |
| `sslPolicyType` | string | `'Custom'` | `[Custom, Predefined]` | Type of Ssl Policy. |
| `sslProfiles` | array | `[]` |  | SSL profiles of the application gateway resource. |
| `tags` | object | `{object}` |  | Resource tags. |
| `trustedClientCertificates` | array | `[]` |  | Trusted client certificates of the application gateway resource. |
| `trustedRootCertificates` | array | `[]` |  | Trusted Root certificates of the application gateway resource. |
| `urlPathMaps` | array | `[]` |  | URL path map of the application gateway resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `webApplicationFirewallConfiguration` | object | `{object}` |  | Application gateway web application firewall configuration. |
| `zones` | array | `[]` |  | A list of availability zones denoting where the resource needs to come from. |


### Parameter Usage: `authenticationCertificates`

```json
"authenticationCertificates": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "data": "string"
        }
      }
    ]
}
```

### Parameter Usage: `backendAddressPools`

```json
"backendAddressPools": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "backendAddresses": [
            {
              "fqdn": "string",
              "ipAddress": "string"
            }
          ]
        }
      }
    ]
}
```

### Parameter Usage: `backendHttpSettingsCollection`

```json
"backendHttpSettingsCollection": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "affinityCookieName": "string",
          "authenticationCertificates": [
            {
              "id": "string"
            }
          ],
          "connectionDraining": {
            "drainTimeoutInSec": "int",
            "enabled": "bool"
          },
          "cookieBasedAffinity": "string",
          "hostName": "string",
          "path": "string",
          "pickHostNameFromBackendAddress": "bool",
          "port": "int",
          "probe": {
            "id": "string"
          },
          "probeEnabled": "bool",
          "protocol": "string",
          "requestTimeout": "int",
          "trustedRootCertificates": [
            {
              "id": "string"
            }
          ]
        }
      }
    ]
}
```

### Parameter Usage: `customErrorConfigurations`

```json
"customErrorConfigurations": {
    "value": [
        {
        "customErrorPageUrl": "string",
        "statusCode": "string"
      }
    ]
}
```

### Parameter Usage: `frontendIPConfigurations`

```json
"frontendIPConfigurations": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "privateIPAddress": "string",
          "privateIPAllocationMethod": "string",
          "privateLinkConfiguration": {
            "id": "string"
          },
          "publicIPAddress": {
            "id": "string"
          },
          "subnet": {
            "id": "string"
          }
        }
      }
    ]
}
```

### Parameter Usage: `frontendPorts`

```json
"frontendPorts": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "port": "int"
        }
      }
    ]
}
```

### Parameter Usage: `gatewayIPConfigurations`

```json
"gatewayIPConfigurations": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "subnet": {
            "id": "string"
          }
        }
      }
    ]
}
```

### Parameter Usage: `httpListeners`

```json
"httpListeners": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "customErrorConfigurations": [
            {
              "customErrorPageUrl": "string",
              "statusCode": "string"
            }
          ],
          "firewallPolicy": {
            "id": "string"
          },
          "frontendIPConfiguration": {
            "id": "string"
          },
          "frontendPort": {
            "id": "string"
          },
          "hostName": "string",
          "hostNames": [ "string" ],
          "protocol": "string",
          "requireServerNameIndication": "bool",
          "sslCertificate": {
            "id": "string"
          },
          "sslProfile": {
            "id": "string"
          }
        }
      }
    ]
}
```

### Parameter Usage: `loadDistributionPolicies`

```json
"loadDistributionPolicies": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "loadDistributionAlgorithm": "string",
          "loadDistributionTargets": [
            {
              "id": "string",
              "name": "string",
              "properties": {
                "backendAddressPool": {
                  "id": "string"
                },
                "weightPerServer": "int"
              }
            }
          ]
        }
      }
    ]
}
```

### Parameter Usage: `privateLinkConfigurations`

```json
"privateLinkConfigurations": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "ipConfigurations": [
            {
              "id": "string",
              "name": "string",
              "properties": {
                "primary": "bool",
                "privateIPAddress": "string",
                "privateIPAllocationMethod": "string",
                "subnet": {
                  "id": "string"
                }
              }
            }
          ]
        }
      }
    ]
}
```

### Parameter Usage: `probes`

```json
"probes": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "host": "string",
          "interval": "int",
          "match": {
            "body": "string",
            "statusCodes": [ "string" ]
          },
          "minServers": "int",
          "path": "string",
          "pickHostNameFromBackendHttpSettings": "bool",
          "port": "int",
          "protocol": "string",
          "timeout": "int",
          "unhealthyThreshold": "int"
        }
      }
    ]
}
```

### Parameter Usage: `redirectConfigurations`

```json
"redirectConfigurations": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "includePath": "bool",
          "includeQueryString": "bool",
          "pathRules": [
            {
              "id": "string"
            }
          ],
          "redirectType": "string",
          "requestRoutingRules": [
            {
              "id": "string"
            }
          ],
          "targetListener": {
            "id": "string"
          },
          "targetUrl": "string",
          "urlPathMaps": [
            {
              "id": "string"
            }
          ]
        }
      }
    ]
}
```

### Parameter Usage: `requestRoutingRules`

```json
"requestRoutingRules": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "backendAddressPool": {
            "id": "string"
          },
          "backendHttpSettings": {
            "id": "string"
          },
          "httpListener": {
            "id": "string"
          },
          "loadDistributionPolicy": {
            "id": "string"
          },
          "priority": "int",
          "redirectConfiguration": {
            "id": "string"
          },
          "rewriteRuleSet": {
            "id": "string"
          },
          "ruleType": "string",
          "urlPathMap": {
            "id": "string"
          }
        }
      }
    ]
}
```

### Parameter Usage: `rewriteRuleSets`

```json
"rewriteRuleSets": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "rewriteRules": [
            {
              "actionSet": {
                "requestHeaderConfigurations": [
                  {
                    "headerName": "string",
                    "headerValue": "string"
                  }
                ],
                "responseHeaderConfigurations": [
                  {
                    "headerName": "string",
                    "headerValue": "string"
                  }
                ],
                "urlConfiguration": {
                  "modifiedPath": "string",
                  "modifiedQueryString": "string",
                  "reroute": "bool"
                }
              },
              "conditions": [
                {
                  "ignoreCase": "bool",
                  "negate": "bool",
                  "pattern": "string",
                  "variable": "string"
                }
              ],
              "name": "string",
              "ruleSequence": "int"
            }
          ]
        }
      }
    ]
}
```

### Parameter Usage: `sslCertificates`

```json
"sslCertificates": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "data": "string",
          "keyVaultSecretId": "string",
          "password": "string"
        }
      }
    ]
}
```

### Parameter Usage: `sslProfiles`

```json
"sslProfiles": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "clientAuthConfiguration": {
            "verifyClientCertIssuerDN": "bool"
          },
          "sslPolicy": {
            "cipherSuites": [ "string" ],
            "disabledSslProtocols": [ "string" ],
            "minProtocolVersion": "string",
            "policyName": "string",
            "policyType": "string"
          },
          "trustedClientCertificates": [
            {
              "id": "string"
            }
          ]
        }
      }
    ]
}
```

### Parameter Usage: `trustedClientCertificates`

```json
"trustedClientCertificates": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "data": "string"
        }
      }
    ]
}
```

### Parameter Usage: `trustedRootCertificates`

```json
"trustedRootCertificates": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "data": "string",
          "keyVaultSecretId": "string"
        }
      }
    ]
}
```

### Parameter Usage: `urlPathMaps`

```json
"urlPathMaps": {
    "value": [
        {
        "id": "string",
        "name": "string",
        "properties": {
          "defaultBackendAddressPool": {
            "id": "string"
          },
          "defaultBackendHttpSettings": {
            "id": "string"
          },
          "defaultLoadDistributionPolicy": {
            "id": "string"
          },
          "defaultRedirectConfiguration": {
            "id": "string"
          },
          "defaultRewriteRuleSet": {
            "id": "string"
          },
          "pathRules": [
            {
              "id": "string",
              "name": "string",
              "properties": {
                "backendAddressPool": {
                  "id": "string"
                },
                "backendHttpSettings": {
                  "id": "string"
                },
                "firewallPolicy": {
                  "id": "string"
                },
                "loadDistributionPolicy": {
                  "id": "string"
                },
                "paths": [ "string" ],
                "redirectConfiguration": {
                  "id": "string"
                },
                "rewriteRuleSet": {
                  "id": "string"
                }
              }
            }
          ]
        }
      }
    ]
}
```

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the application gateway |
| `resourceGroupName` | string | The resource group the application gateway was deployed into |
| `resourceId` | string | The resource ID of the application gateway |

## Template references

- [Applicationgateways](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/applicationGateways)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
