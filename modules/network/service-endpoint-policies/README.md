# Service Endpoint Policies `[Microsoft.Network/serviceEndpointPolicies]`

This module deploys a Service Endpoint Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/serviceEndpointPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/serviceEndpointPolicies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Service Endpoint Policy name. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `contextualServiceEndpointPolicies` | array | `[]` | An Array of contextual service endpoint policy. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `serviceAlias` | string | `''` | The alias indicating if the policy belongs to a service. |
| `serviceEndpointPolicyDefinitions` | array | `[]` | An Array of service endpoint policy definitions. |
| `tags` | object | `{object}` | Tags of the resource. |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

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
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Service Endpoint Policy. |
| `resourceGroupName` | string | The resource group the Service Endpoint Policy was deployed into. |
| `resourceId` | string | The resource ID of the Service Endpoint Policy. |

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
module serviceEndpointPolicies './network/service-endpoint-policies/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nsnpcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>nsnpcom001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    serviceEndpointPolicyDefinitions: [
      {
        name: 'Storage.ServiceEndpoint'
        properties: {
          description: 'Allow Microsoft.Storage'
          service: 'Microsoft.Storage'
          serviceResources: [
            '<id>'
          ]
        }
        type: 'Microsoft.Network/serviceEndpointPolicies/serviceEndpointPolicyDefinitions'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
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
      "value": "<<namePrefix>>nsnpcom001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "serviceEndpointPolicyDefinitions": {
      "value": [
        {
          "name": "Storage.ServiceEndpoint",
          "properties": {
            "description": "Allow Microsoft.Storage",
            "service": "Microsoft.Storage",
            "serviceResources": [
              "<id>"
            ]
          },
          "type": "Microsoft.Network/serviceEndpointPolicies/serviceEndpointPolicyDefinitions"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module serviceEndpointPolicies './network/service-endpoint-policies/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nsnpmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>nsnpmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    serviceEndpointPolicyDefinitions: []
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
      "value": "<<namePrefix>>nsnpmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "serviceEndpointPolicyDefinitions": {
      "value": []
    }
  }
}
```

</details>
<p>
