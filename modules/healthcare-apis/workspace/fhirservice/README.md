# Healthcare API Workspace FHIR Services `[Microsoft.HealthcareApis/workspaces/fhirservices]`

This module deploys a Healthcare API Workspace FHIR Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.HealthcareApis/workspaces/fhirservices` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/workspaces) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the FHIR service. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `workspaceName` | string | The name of the parent health data services workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `accessPolicyObjectIds` | array | `[]` |  | List of Azure AD object IDs (User or Apps) that is allowed access to the FHIR service. |
| `acrLoginServers` | array | `[]` |  | The list of the Azure container registry login servers. |
| `acrOciArtifacts` | array | `[]` |  | The list of Open Container Initiative (OCI) artifacts. |
| `authenticationAudience` | string | `[format('https://{0}-{1}.fhir.azurehealthcareapis.com', parameters('workspaceName'), parameters('name'))]` |  | The audience url for the service. |
| `authenticationAuthority` | string | `[uri(environment().authentication.loginEndpoint, subscription().tenantId)]` |  | The authority url for the service. |
| `corsAllowCredentials` | bool | `False` |  | Use this setting to indicate that cookies should be included in CORS requests. |
| `corsHeaders` | array | `[]` |  | Specify HTTP headers which can be used during the request. Use "*" for any header. |
| `corsMaxAge` | int | `-1` |  | Specify how long a result from a request can be cached in seconds. Example: 600 means 10 minutes. |
| `corsMethods` | array | `[]` | `[DELETE, GET, OPTIONS, PATCH, POST, PUT]` | Specify the allowed HTTP methods. |
| `corsOrigins` | array | `[]` |  | Specify URLs of origin sites that can access this API, or use "*" to allow access from any site. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[AuditLogs]` | `[AuditLogs]` | The name of logs that will be streamed. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `exportStorageAccountName` | string | `''` |  | The name of the default export storage account. |
| `importEnabled` | bool | `False` |  | If the import operation is enabled. |
| `importStorageAccountName` | string | `''` |  | The name of the default integration storage account. |
| `initialImportMode` | bool | `False` |  | If the FHIR service is in InitialImportMode. |
| `kind` | string | `'fhir-R4'` | `[fhir-R4, fhir-Stu3]` | The kind of the service. Defaults to R4. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `publicNetworkAccess` | string | `'Disabled'` | `[Disabled, Enabled]` | Control permission for data plane traffic coming from public networks while private endpoint is enabled. |
| `resourceVersionOverrides` | object | `{object}` |  | A list of FHIR Resources and their version policy overrides. |
| `resourceVersionPolicy` | string | `'versioned'` | `[no-version, versioned, versioned-update]` | The default value for tracking history across all resources. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `smartProxyEnabled` | bool | `False` |  | If the SMART on FHIR proxy is enabled. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the fhir service. |
| `resourceGroupName` | string | The resource group where the namespace is deployed. |
| `resourceId` | string | The resource ID of the fhir service. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |
| `workspaceName` | string | The name of the fhir workspace. |

## Cross-referenced modules

_None_

## Notes

### Parameter Usage: `acrOciArtifacts`

You can specify multiple Azure Container OCI artifacts using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"acrOciArtifacts": {
    "value": {
        [{
          "digest": "sha256:0a2e01852872580b2c2fea9380ff8d7b637d3928783c55beb3f21a6e58d5d108",
          "imageName": "myimage:v1",
          "loginServer": "myregistry.azurecr.io"
        }]
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
acrOciArtifacts: [
    {
        digest: 'sha256:0a2e01852872580b2c2fea9380ff8d7b637d3928783c55beb3f21a6e58d5d108'
        imageName: 'myimage:v1'
        loginServer: 'myregistry.azurecr.io'
    }
]
```

</details>

<p>
