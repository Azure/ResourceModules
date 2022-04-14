# Machine Learning Workspaces Computes `[Microsoft.MachineLearningServices/workspaces/computes]`

This module deploys computes for an Machine Learning Workspace.
Deploying a compute is not idempotent and will fail in case you try to redeploy over an existing compute in AML (see parameter `deployCompute`).

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.MachineLearningServices/workspaces/computes` | 2022-01-01-preview |

## Parameters

**Required parameters**
| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `computeType` | string | `[AKS, AmlCompute, ComputeInstance, Databricks, DataFactory, DataLakeAnalytics, HDInsight, Kubernetes, SynapseSpark, VirtualMachine]` | Set the object type. |
| `deployCompute` | bool |  | Flag to specify whether to deploy the compute. Necessary as the compute resource is not idempontent, i.e. a second deployment will fail. Therefore, this flag needs to be set to "false" as long as the compute resource exists. |
| `machineLearningWorkspaceName` | string |  | Name of the Machine Learning Workspace. |
| `name` | string |  | Name of the compute. |
| `sku` | string | `[Basic, Enterprise]` | Specifies the sku, also referred as "edition". |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `computeDescription` | string | `''` | The description of the Machine Learning compute. |
| `computeDisableLocalAuth` | bool | `False` | Opt-out of local authentication and ensure customers can use only MSI and AAD exclusively for authentication. |
| `computeLocation` | string | `[resourceGroup().location]` | Location for the underlying compute. |
| `computeProperties` | object | `{object}` | The properties of the compute. Will be ignored in case "computeResourceId" is set. |
| `computeResourceId` | string | `''` | ARM resource ID of the underlying compute. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `identity` | object | `{object}` | Identity for the resource. |
| `location` | string | `[resourceGroup().location]` | Specifies the location of the resource. |
| `tags` | object | `{object}` | Contains resource tags defined as key-value pairs. |


### Parameter Usage: `identity`

Identity object for the resource. Allows system as well as user assigned identities.

```json
"identity": {
    "value": {
        "type": "SystemAssigned,UserAssigned",
        "userAssignedIdentities": {
            "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resource-group-name/providers/Microsoft.ManagedIdentity/userAssignedIdentities/firstIdentity": {}
        }
    }
}
```

### Parameter Usage: `computeProperties`

Properties for the compute resource to create.
Will be ignored in case a resource ID is provided.

```json
"computeProperties": {
    "value": {
        // See https://docs.microsoft.com/en-us/azure/templates/microsoft.machinelearningservices/workspaces/computes?tabs=bicep#compute for the properties for the difference compute types
    }
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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the compute. |
| `resourceGroupName` | string | The resource group the compute was deployed into. |
| `resourceId` | string | The resource ID of the compute. |


## Template references

- [Workspaces/Computes](https://docs.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-01-01-preview/workspaces/computes)
