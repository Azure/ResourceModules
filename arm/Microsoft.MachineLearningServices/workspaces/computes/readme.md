# Machine Learning Workspaces Computes `[Microsoft.MachineLearningServices/workspaces/computes]`

This module deploys computes for an Machine Learning Workspace.
Attaching a compute is not idempotent and will fail in case you try to redeploy over an existing compute in AML (see parameter `deployCompute`).

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.MachineLearningServices/workspaces/computes` | [2022-01-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-01-01-preview/workspaces/computes) |

## Parameters

**Required parameters**
| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `computeType` | string | `[AKS, AmlCompute, ComputeInstance, Databricks, DataFactory, DataLakeAnalytics, HDInsight, Kubernetes, SynapseSpark, VirtualMachine]` | Set the object type. |
| `name` | string |  | Name of the compute. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `machineLearningWorkspaceName` | string | The name of the parent Machine Learning Workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `computeLocation` | string | `[resourceGroup().location]` |  | Location for the underlying compute. Ignored when attaching a compute resource, i.e. when you provide a resource ID. |
| `deployCompute` | bool | `True` |  | Flag to specify whether to deploy the compute. Required only for attach (i.e. providing a resource ID), as in this case the operation is not idempontent, i.e. a second deployment will fail. Therefore, this flag needs to be set to "false" as long as the compute resource exists. |
| `description` | string | `''` |  | The description of the Machine Learning compute. |
| `disableLocalAuth` | bool | `False` |  | Opt-out of local authentication and ensure customers can use only MSI and AAD exclusively for authentication. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Specifies the location of the resource. |
| `properties` | object | `{object}` |  | The properties of the compute. Will be ignored in case "resourceId" is set. |
| `resourceId` | string | `''` |  | ARM resource ID of the underlying compute. |
| `sku` | string | `''` | `[Basic, Enterprise, ]` | Specifies the sku, also referred as "edition". Required for creating a compute resource. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. Ignored when attaching a compute resource, i.e. when you provide a resource ID. |
| `tags` | object | `{object}` |  | Contains resource tags defined as key-value pairs. Ignored when attaching a compute resource, i.e. when you provide a resource ID. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. Ignored when attaching a compute resource, i.e. when you provide a resource ID. |


### Parameter Usage: `properties`

Properties for the compute resource to create.
Will be ignored in case a resource ID is provided.

<details>

<summary>Parameter JSON format</summary>

```json
"properties": {
    "value": {
        // See https://docs.microsoft.com/en-us/azure/templates/microsoft.machinelearningservices/workspaces/computes?tabs=bicep#compute for the properties for the difference compute types
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
properties: {
    // See https://docs.microsoft.com/en-us/azure/templates/microsoft.machinelearningservices/workspaces/computes?tabs=bicep#compute for the properties for the difference compute types
}
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
| `name` | string | The name of the compute. |
| `resourceGroupName` | string | The resource group the compute was deployed into. |
| `resourceId` | string | The resource ID of the compute. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. Is null in case of attaching a compute resource, i.e. when you provide a resource ID. |
