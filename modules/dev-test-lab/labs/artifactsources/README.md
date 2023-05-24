# DevTestLab Labs ArtifactSources `[Microsoft.DevTestLab/labs/artifactsources]`

This module deploys DevTestLab Labs ArtifactSources.

An artifact source allows you to create custom artifacts for the VMs in the lab, or  use Azure Resource Manager templates to create a custom test environment. You must add a private Git repository for the artifacts or Resource Manager templates that your team creates. The repository can be hosted on GitHub or on Azure DevOps Services.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevTestLab/labs/artifactsources` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/artifactsources) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the artifact source. |
| `uri` | string | The artifact source's URI. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `armTemplateFolderPath` | string | `''` | The folder containing Azure Resource Manager templates. Required if "folderPath" is empty. |
| `folderPath` | string | `''` | The folder containing artifacts. At least one folder path is required. Required if "armTemplateFolderPath" is empty. |
| `labName` | string |  | The name of the parent lab. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `branchRef` | string | `''` |  | The artifact source's branch reference (e.g. main or master). |
| `displayName` | string | `[parameters('name')]` |  | The artifact source's display name. Default is the name of the artifact source. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `securityToken` | securestring | `''` |  | The security token to authenticate to the artifact source. |
| `sourceType` | string | `''` | `['', GitHub, StorageAccount, VsoGit]` | The artifact source's type. |
| `status` | string | `'Enabled'` | `[Disabled, Enabled]` | Indicates if the artifact source is enabled (values: Enabled, Disabled). Default is "Enabled". |
| `tags` | object | `{object}` |  | Tags of the resource. |


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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the artifact source. |
| `resourceGroupName` | string | The name of the resource group the artifact source was created in. |
| `resourceId` | string | The resource ID of the artifact source. |

## Cross-referenced modules

_None_
