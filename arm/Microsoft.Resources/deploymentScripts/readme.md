# Deployment Scripts

This module deploys Deployment Scripts.

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`providers/locks`|2016-09-01|
|`Microsoft.Resources/deploymentScripts`|2019-10-01-preview|

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `scriptName` | string | | | Required. Display name of the script to be run.
| `userMsiName` | string | "" | | Required. Name of the User Assigned Identity to be used to deploy Image Templates in Azure Image Builder.
| `userMsiResourceGroup` | string | `resourceGroup().name` | | Optional. Resource group of the user assigned identity. |
| `location` | string | `[resourceGroup().location]` | | Optional. Location for all resources.
| `kind` | string | AzurePowerShell | AzurePowerShell, AzureCLI | Optional. Type of the script. AzurePowerShell, AzureCLI.
| `azPowerShellVersion` | string | 3.0 | | Optional. Azure PowerShell module version to be used.
| `azCliVersion` | string | | | Optional. Azure CLI module version to be used.
| `scriptContent` | string | "" | | Optional. Script body. Max length: 32000 characters. To run an external script, use primaryScriptURI instead.
| `primaryScriptUri` | string | "" | | Optional. Uri for the external script. This is the entry point for the external script. To run an internal script, use the scriptContent instead.
| `environmentVariables` | array | [] | | Optional. The environment variables to pass over to the script. Must have a 'name' and a 'value' or a 'secretValue' property.
| `supportingScriptUris` | array | [] | | Optional. List of supporting files for the external script (defined in primaryScriptUri). Does not work with internal scripts (code defined in scriptContent).
| `arguments` | string | "" | | Optional. Command line arguments to pass to the script. Arguments are separated by spaces.
| `retentionInterval` | string | P1D | | Optional. Interval for which the service retains the script resource after it reaches a terminal state. Resource will be deleted when this duration expires. Duration is based on ISO 8601 pattern (for example P7D means one week).
| `runOnce` | bool | false | | Optional. When set to false, script will run every time the template is deployed. When set to true, the script will only run once.
| `cleanupPreference` | string | Always | Always, OnSuccess, OnExpiration | Optional. The clean up preference when the script execution gets in a terminal state. Specify the preference on when to delete the deployment script resources. The default value is Always, which means the deployment script resources are deleted despite the terminal state (Succeeded, Failed, canceled).
| `containerGroupName` | string | | | Optional. Container group name, if not specified then the name will get auto-generated. Not specifying a 'containerGroupName' indicates the system to generate a unique name which might end up flagging an Azure Policy as non-compliant. Use 'containerGroupName' when you have an Azure Policy that expects a specific naming convention or when you want to fully control the name. 'containerGroupName' property must be between 1 and 63 characters long, must contain only lowercase letters, numbers, and dashes and it cannot start or end with a dash and consecutive dashes are not allowed.
| `timeout` | string | PT1H | | Optional. Maximum allowed script execution time specified in ISO 8601 format. Default value is PT1H - 1 hour; 'PT30M' - 30 minutes; 'P5D' - 5 days; 'P1Y' 1 year.
| `baseTime` | string | `utcNow('yyyy-MM-dd-HH-mm-ss')` | | Generated. Do not provide a value! This date value is used to make sure the script run every time the template is deployed.
| `lockForDeletion` | bool | `true` | | Optional. Switch to lock Virtual Network Gateway from deletion.
| `tags` | object | {} | Complex structure, see below. | Optional. Tags of the Virtual Network Gateway resource.
| `cuaId` | string | "" | | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered

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
| `deploymentScriptName` | string | The Name of the Deployment Script. |
| `deploymentScriptResourceGroup` | string | The Resource Group the Deployment Script was deployed to. |
| `deploymentScriptResourceId` | string | The Resource Id of the Deployment Script. |

## Considerations

This module requires a User Assigned Identity (MSI, managed service identity) to exist, and this MSI has to have contributor rights on the subscription - that allows the Deployment Script to create the required Storage Account and the Azure Container Instance.

## Additional resources

- [Tutorial: Use deployment scripts to create a self-signed certificate (Preview)](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-tutorial-deployment-script)
- [Microsoft.Resources deploymentScripts template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.resources/2019-10-01-preview/deploymentscripts)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)