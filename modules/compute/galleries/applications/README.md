# Compute Galleries Applications `[Microsoft.Compute/galleries/applications]`

This module deploys an Azure Compute Gallery Application.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Compute/galleries/applications` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries/applications) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the application definition. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `galleryName` | string | The name of the parent Azure Compute Gallery. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `customActions` | array | `[]` |  | A list of custom actions that can be performed with all of the Gallery Application Versions within this Gallery Application. |
| `description` | string | `''` |  | The description of this gallery Application Definition resource. This property is updatable. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `endOfLifeDate` | string | `''` |  | The end of life date of the gallery Image Definition. This property can be used for decommissioning purposes. This property is updatable. Allowed format: 2020-01-10T23:00:00.000Z. |
| `eula` | string | `''` |  | The Eula agreement for the gallery Application Definition. Has to be a valid URL. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `privacyStatementUri` | string | `''` |  | The privacy statement uri. Has to be a valid URL. |
| `releaseNoteUri` | string | `''` |  | The release note uri. Has to be a valid URL. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `supportedOSType` | string | `'Windows'` | `[Linux, Windows]` | This property allows you to specify the supported type of the OS that application is built for. |
| `tags` | object | `{object}` |  | Tags for all resources. |


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

<p>
### Parameter Usage: `customActions`

Create a list of custom actions that can be performed with all of the Gallery Application Versions within this Gallery Application.

<details>

<summary>Parameter JSON format</summary>

```json
"customActions": {
    "value": [
        {
            "description": "This is a sample custom action",
            "name": "Name of the custom action 1 (Required). Must be unique within the Compute Gallery",
            "parameters": [
                {
                    "defaultValue": "Default Value of Parameter1. Only applies to string types.",
                    "description": "a description value to help others understands what it means.",
                    "name": "The parameter name. (Required)",
                    "required": True,
                    "type": "ConfigurationDataBlob, LogOutputBlob, or String"
                },
                {
                    "defaultValue": "Default Value of Parameter2. Only applies to string types.",
                    "description": "a description value to help others understands what it means.",
                    "name": "The parameter name. (Required)",
                    "required": False,
                    "type": "ConfigurationDataBlob, LogOutputBlob, or String"
                }
            ],
            "script": "The script to run when executing this custom action. (Required)"
        },
        {
            "description": "This is another sample custom action",
            "name": "Name of the custom action 2 (Required). Must be unique within the Compute Gallery",
            "parameters": [
                {
                    "defaultValue": "Default Value of Parameter1. Only applies to string types.",
                    "description": "a description value to help others understands what it means.",
                    "name": "The parameter name. (Required)",
                    "required": True,
                    "type": "ConfigurationDataBlob, LogOutputBlob, or String"
                }
            ],
            "script": "The script to run when executing this custom action. (Required)"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
customActions: [
    {
        description: "This is a sample custom action"
        name: "Name of the custom action 1 (Required). Must be unique within the Compute Gallery"
        parameters: [
            {
                defaultValue: "Default Value of Parameter 1. Only applies to string types."
                description: "a description value to help others understands what it means."
                name: "The parameter name. (Required)"
                required: True,
                type: "ConfigurationDataBlob, LogOutputBlob, or String"
            }
            {
                defaultValue: "Default Value of Parameter 2. Only applies to string types."
                description: "a description value to help others understands what it means."
                name: "The parameter name. (Required)"
                required: True,
                type: "ConfigurationDataBlob, LogOutputBlob, or String"
            }
        ]
        script: "The script to run when executing this custom action. (Required)"
    }
    {
        description: "This is another sample custom action"
        name: "Name of the custom action 2 (Required). Must be unique within the Compute Gallery"
        parameters: [
            {
                defaultValue: "Default Value of Parameter. Only applies to string types."
                description: "a description value to help others understands what it means."
                name: "The paramter name. (Required)"
                required: True,
                type: "ConfigurationDataBlob, LogOutputBlob, or String"
            }
        ]
        script: "The script to run when executing this custom action. (Required)"
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the image. |
| `resourceGroupName` | string | The resource group the image was deployed into. |
| `resourceId` | string | The resource ID of the image. |

## Cross-referenced modules

_None_
