# Role Assignments `[Microsoft.Authorization/roleAssignments-multiRolesMultiPrincipals]`

This module deploys Role Assignments.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Considerations](#Considerations)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Parameters

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[deployment().location]` | Location for all resources. |
| `managementGroupId` | string | `''` | Group ID of the Management Group to assign the RBAC role to. If no Subscription is provided, the module deploys at management group level, therefore assigns the provided RBAC role to the management group. |
| `resourceGroupName` | string | `''` | Name of the Resource Group to assign the RBAC role to. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription. |
| `roleAssignments` | array | `[]` | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `subscriptionId` | string | `''` | Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription. |


### Parameter Usage: `managementGroupId`

To deploy resource to a Management Group, provide the `managementGroupId` as an input parameter to the module.

```json
"managementGroupId": {
 "value": "contoso-group"
}
```

> The name of the Management Group in the deployment does not have to match the value of the `managementGroupId` in the input parameters.

### Parameter Usage: `subscriptionId`

To deploy resource to an Azure Subscription, provide the `subscriptionId` as an input parameter to the module. **Example**:

```json
"subscriptionId": {
    "value": "12345678-b049-471c-95af-123456789012"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
subscriptionId: '12345678-b049-471c-95af-123456789012'
```

</details>
<p>

### Parameter Usage: `resourceGroupName`

To deploy resource to a Resource Group, provide the `subscriptionId` and `resourceGroupName` as an input parameter to the module. **Example**:

```json
"subscriptionId": {
 "value": "12345678-b049-471c-95af-123456789012"
},
"resourceGroupName": {
 "value": "target-resourceGroup"
}
```

> The `subscriptionId` is used to enable deployment to a Resource Group Scope, allowing the use of the `resourceGroup()` function from a Management Group Scope. [Additional Details](https://github.com/Azure/bicep/pull/1420).

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `roleAssignments` | array | The names of the deployed role assignments. |
| `roleAssignmentScope` | string | The scope of the deployed role assignments. |

## Considerations

This module can be deployed both at management group, subscription or resource group level:

- To deploy the module at resource group level, provide a valid name of an existing Resource Group in the `resourceGroupName` parameter, along side the `subscriptionId` parameter.
- To deploy the module at the subscription level, only provide the `subscriptionId` parameter.
- To deploy the module at the management group level, only provide the `managementGroupId` parameter.

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Parameters</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignments-multiRolesMultiPrincipals './Microsoft.Authorization/roleAssignments-multiRolesMultiPrincipals/main.bicep' = {
  name: '${uniqueString(deployment().name)}-RoleAssignments-multiRolesMultiPrincipals'
  params: {
    resourceGroupName: 'validation-rg'
    roleAssignments: [
      {
        principalIds: []
        roleDefinitionIdOrName: 'Owner'
      }
      {
        principalIds: []
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
      }
    ]
    subscriptionId: '[[subscriptionId]]'
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
    "resourceGroupName": {
      "value": "validation-rg"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [],
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "principalIds": [],
          "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11"
        }
      ]
    },
    "subscriptionId": {
      "value": "[[subscriptionId]]"
    }
  }
}
```

</details>
<p>
