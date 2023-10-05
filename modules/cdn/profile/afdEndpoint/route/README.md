# CDN Profiles AFD Endpoint Route `[Microsoft.Cdn/profiles/afdEndpoints/routes]`

This module deploys a CDN Profile AFD Endpoint route.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/afdEndpoints/routes` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/profiles/afdEndpoints/routes) |

## Parameters

**Required parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `afdEndpointName` | string |  | The name of the AFD endpoint. |
| `name` | string |  | The name of the route. |
| `originGroupName` | string | `''` | The name of the origin group. The origin group must be defined in the profile originGroups. |
| `profileName` | string |  | The name of the parent CDN profile. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cacheConfiguration` | object | `{object}` |  | The caching configuration for this route. To disable caching, do not provide a cacheConfiguration object. |
| `customDomainName` | string |  |  | The name of the custom domain. The custom domain must be defined in the profile customDomains. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enabledState` | string | `'Enabled'` | `[Disabled, Enabled]` | Whether this route is enabled. |
| `forwardingProtocol` | string | `'MatchRequest'` | `[HttpOnly, HttpsOnly, MatchRequest]` | The protocol this rule will use when forwarding traffic to backends. |
| `httpsRedirect` | string | `'Enabled'` | `[Disabled, Enabled]` | Whether to automatically redirect HTTP traffic to HTTPS traffic. |
| `linkToDefaultDomain` | string | `'Enabled'` | `[Disabled, Enabled]` | Whether this route will be linked to the default endpoint domain. |
| `originPath` | string | `''` |  | A directory path on the origin that AzureFrontDoor can use to retrieve content from, e.g. contoso.cloudapp.net/originpath. |
| `patternsToMatch` | array | `[]` |  | The route patterns of the rule. |
| `ruleSets` | array | `[]` |  | The rule sets of the rule. The rule sets must be defined in the profile ruleSets. |
| `supportedProtocols` | array | `[]` | `[Http, Https]` | The supported protocols of the rule. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the route. |
| `resourceGroupName` | string | The name of the resource group the route was created in. |
| `resourceId` | string | The ID of the route. |

## Cross-referenced modules

_None_
