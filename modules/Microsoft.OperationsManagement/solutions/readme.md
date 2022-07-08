# OperationsManagement Solutions `[Microsoft.OperationsManagement/solutions]`

This module deploys OperationsManagement Solutions.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `logAnalyticsWorkspaceName` | string | Name of the Log Analytics workspace where the solution will be deployed/enabled. |
| `name` | string | Name of the solution. For Microsoft published gallery solution the target solution resource name will be composed as `{name}({logAnalyticsWorkspaceName})`. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `product` | string | `'OMSGallery'` | The product of the deployed solution. For Microsoft published gallery solution it should be `OMSGallery` and the target solution resource product will be composed as `OMSGallery/{name}`. For third party solution, it can be anything. This is case sensitive. |
| `publisher` | string | `'Microsoft'` | The publisher name of the deployed solution. For Microsoft published gallery solution, it is `Microsoft`. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed solution. |
| `resourceGroupName` | string | The resource group where the solution is deployed. |
| `resourceId` | string | The resource ID of the deployed solution. |

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
            "value": "Updates"
        },
        "logAnalyticsWorkspaceName": {
            "value": "adp-<<namePrefix>>-az-law-sol-001"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module solutions './Microsoft.OperationsManagement/solutions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-solutions'
  params: {
    name: 'Updates'
    logAnalyticsWorkspaceName: 'adp-<<namePrefix>>-az-law-sol-001'
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
            "value": "AzureAutomation"
        },
        "logAnalyticsWorkspaceName": {
            "value": "adp-<<namePrefix>>-az-law-sol-001"
        },
        "product": {
            "value": "OMSGallery"
        },
        "publisher": {
            "value": "Microsoft"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module solutions './Microsoft.OperationsManagement/solutions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-solutions'
  params: {
    name: 'AzureAutomation'
    logAnalyticsWorkspaceName: 'adp-<<namePrefix>>-az-law-sol-001'
    product: 'OMSGallery'
    publisher: 'Microsoft'
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
            "value": "nonmsTestSolution"
        },
        "logAnalyticsWorkspaceName": {
            "value": "adp-<<namePrefix>>-az-law-sol-001"
        },
        "product": {
            "value": "nonmsTestSolutionProduct"
        },
        "publisher": {
            "value": "nonmsTestSolutionPublisher"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module solutions './Microsoft.OperationsManagement/solutions/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-solutions'
  params: {
    name: 'nonmsTestSolution'
    logAnalyticsWorkspaceName: 'adp-<<namePrefix>>-az-law-sol-001'
    product: 'nonmsTestSolutionProduct'
    publisher: 'nonmsTestSolutionPublisher'
  }
}
```

</details>
<p>
