# Deployment Scripts `[Microsoft.Resources/deploymentScripts]`

This module deploys a deployment script.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Resources/deploymentScripts` | 2020-10-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `arguments` | string |  |  | Optional. Command-line arguments to pass to the script. Arguments are separated by spaces. |
| `azCliVersion` | string |  |  | Optional. Azure CLI module version to be used. |
| `azPowerShellVersion` | string | `3.0` |  | Optional. Azure PowerShell module version to be used. |
| `baseTime` | string | `[utcNow('yyyy-MM-dd-HH-mm-ss')]` |  | Generated. Do not provide a value! This date value is used to make sure the script run every time the template is deployed. |
| `cleanupPreference` | string | `Always` | `[Always, OnSuccess, OnExpiration]` | Optional. The clean up preference when the script execution gets in a terminal state. Specify the preference on when to delete the deployment script resources. The default value is Always, which means the deployment script resources are deleted despite the terminal state (Succeeded, Failed, canceled). |
| `containerGroupName` | string |  |  | Optional. Container group name, if not specified then the name will get auto-generated. Not specifying a 'containerGroupName' indicates the system to generate a unique name which might end up flagging an Azure Policy as non-compliant. Use 'containerGroupName' when you have an Azure Policy that expects a specific naming convention or when you want to fully control the name. 'containerGroupName' property must be between 1 and 63 characters long, must contain only lowercase letters, numbers, and dashes and it cannot start or end with a dash and consecutive dashes are not allowed. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `environmentVariables` | array | `[]` |  | Optional. The environment variables to pass over to the script. Must have a 'name' and a 'value' or a 'secretValue' property. |
| `kind` | string | `AzurePowerShell` | `[AzurePowerShell, AzureCLI]` | Optional. Type of the script. AzurePowerShell, AzureCLI. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `name` | string |  |  | Required. Display name of the script to be run. |
| `primaryScriptUri` | string |  |  | Optional. Uri for the external script. This is the entry point for the external script. To run an internal script, use the scriptContent instead. |
| `retentionInterval` | string | `P1D` |  | Optional. Interval for which the service retains the script resource after it reaches a terminal state. Resource will be deleted when this duration expires. Duration is based on ISO 8601 pattern (for example P7D means one week). |
| `runOnce` | bool |  |  | Optional. When set to false, script will run every time the template is deployed. When set to true, the script will only run once. |
| `scriptContent` | string |  |  | Optional. Script body. Max length: 32000 characters. To run an external script, use primaryScriptURI instead. |
| `supportingScriptUris` | array | `[]` |  | Optional. List of supporting files for the external script (defined in primaryScriptUri). Does not work with internal scripts (code defined in scriptContent). |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `timeout` | string | `PT1H` |  | Optional. Maximum allowed script execution time specified in ISO 8601 format. Default value is PT1H - 1 hour; 'PT30M' - 30 minutes; 'P5D' - 5 days; 'P1Y' 1 year. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. The ID(s) to assign to the resource. |

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
| `deploymentScriptName` | string | The name of the deployment script |
| `deploymentScriptResourceGroup` | string | The resource group the deployment script was deployed into |
| `deploymentScriptResourceId` | string | The resource ID of the deployment script |

## Considerations

This module requires a User Assigned Identity (MSI, managed service identity) to exist, and this MSI has to have contributor rights on the subscription - that allows the Deployment Script to create the required Storage Account and the Azure Container Instance.

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Deploymentscripts](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-10-01/deploymentScripts)
