# Deployment Scripts `[Microsoft.Resources/deploymentScripts]`

This module deploys a Deployment Script.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Resources/deploymentScripts` | [2020-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-10-01/deploymentScripts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/resources.deployment-script:1.0.0`.

- [Cli](#example-1-cli)
- [Ps](#example-2-ps)

### Example 1: _Cli_

<details>

<summary>via Bicep module</summary>

```bicep
module deploymentScript 'br:bicep/modules/resources.deployment-script:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-rdscli'
  params: {
    // Required parameters
    name: 'rdscli001'
    // Non-required parameters
    azCliVersion: '2.40.0'
    cleanupPreference: 'Always'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    environmentVariables: {
      secureList: [
        {
          name: 'var1'
          value: 'test'
        }
        {
          name: 'var2'
          secureValue: '<secureValue>'
        }
      ]
    }
    kind: 'AzureCLI'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    retentionInterval: 'P1D'
    runOnce: false
    scriptContent: 'echo \'echo echo echo\''
    storageAccountResourceId: '<storageAccountResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    timeout: 'PT30M'
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
      "value": "rdscli001"
    },
    // Non-required parameters
    "azCliVersion": {
      "value": "2.40.0"
    },
    "cleanupPreference": {
      "value": "Always"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "environmentVariables": {
      "value": {
        "secureList": [
          {
            "name": "var1",
            "value": "test"
          },
          {
            "name": "var2",
            "secureValue": "<secureValue>"
          }
        ]
      }
    },
    "kind": {
      "value": "AzureCLI"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "retentionInterval": {
      "value": "P1D"
    },
    "runOnce": {
      "value": false
    },
    "scriptContent": {
      "value": "echo \"echo echo echo\""
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "timeout": {
      "value": "PT30M"
    }
  }
}
```

</details>
<p>

### Example 2: _Ps_

<details>

<summary>via Bicep module</summary>

```bicep
module deploymentScript 'br:bicep/modules/resources.deployment-script:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-rdsps'
  params: {
    // Required parameters
    name: 'rdsps001'
    // Non-required parameters
    azPowerShellVersion: '8.0'
    cleanupPreference: 'Always'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'AzurePowerShell'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    retentionInterval: 'P1D'
    runOnce: false
    scriptContent: 'Write-Host \'The cake is a lie!\''
    storageAccountResourceId: '<storageAccountResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    timeout: 'PT30M'
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
      "value": "rdsps001"
    },
    // Non-required parameters
    "azPowerShellVersion": {
      "value": "8.0"
    },
    "cleanupPreference": {
      "value": "Always"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "AzurePowerShell"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "retentionInterval": {
      "value": "P1D"
    },
    "runOnce": {
      "value": false
    },
    "scriptContent": {
      "value": "Write-Host \"The cake is a lie!\""
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "timeout": {
      "value": "PT30M"
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Display name of the script to be run. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`arguments`](#parameter-arguments) | string | Command-line arguments to pass to the script. Arguments are separated by spaces. |
| [`azCliVersion`](#parameter-azcliversion) | string | Azure CLI module version to be used. |
| [`azPowerShellVersion`](#parameter-azpowershellversion) | string | Azure PowerShell module version to be used. |
| [`cleanupPreference`](#parameter-cleanuppreference) | string | The clean up preference when the script execution gets in a terminal state. Specify the preference on when to delete the deployment script resources. The default value is Always, which means the deployment script resources are deleted despite the terminal state (Succeeded, Failed, canceled). |
| [`containerGroupName`](#parameter-containergroupname) | string | Container group name, if not specified then the name will get auto-generated. Not specifying a 'containerGroupName' indicates the system to generate a unique name which might end up flagging an Azure Policy as non-compliant. Use 'containerGroupName' when you have an Azure Policy that expects a specific naming convention or when you want to fully control the name. 'containerGroupName' property must be between 1 and 63 characters long, must contain only lowercase letters, numbers, and dashes and it cannot start or end with a dash and consecutive dashes are not allowed. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`environmentVariables`](#parameter-environmentvariables) | secureObject | The environment variables to pass over to the script. The list is passed as an object with a key name "secureList" and the value is the list of environment variables (array). The list must have a 'name' and a 'value' or a 'secretValue' property for each object. |
| [`kind`](#parameter-kind) | string | Type of the script. AzurePowerShell, AzureCLI. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`primaryScriptUri`](#parameter-primaryscripturi) | string | Uri for the external script. This is the entry point for the external script. To run an internal script, use the scriptContent instead. |
| [`retentionInterval`](#parameter-retentioninterval) | string | Interval for which the service retains the script resource after it reaches a terminal state. Resource will be deleted when this duration expires. Duration is based on ISO 8601 pattern (for example P7D means one week). |
| [`runOnce`](#parameter-runonce) | bool | When set to false, script will run every time the template is deployed. When set to true, the script will only run once. |
| [`scriptContent`](#parameter-scriptcontent) | string | Script body. Max length: 32000 characters. To run an external script, use primaryScriptURI instead. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | The resource ID of the storage account to use for this deployment script. If none is provided, the deployment script uses a temporary, managed storage account. |
| [`supportingScriptUris`](#parameter-supportingscripturis) | array | List of supporting files for the external script (defined in primaryScriptUri). Does not work with internal scripts (code defined in scriptContent). |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`timeout`](#parameter-timeout) | string | Maximum allowed script execution time specified in ISO 8601 format. Default value is PT1H - 1 hour; 'PT30M' - 30 minutes; 'P5D' - 5 days; 'P1Y' 1 year. |

**Generated parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseTime`](#parameter-basetime) | string | Do not provide a value! This date value is used to make sure the script run every time the template is deployed. |

### Parameter: `arguments`

Command-line arguments to pass to the script. Arguments are separated by spaces.
- Required: No
- Type: string
- Default: `''`

### Parameter: `azCliVersion`

Azure CLI module version to be used.
- Required: No
- Type: string
- Default: `''`

### Parameter: `azPowerShellVersion`

Azure PowerShell module version to be used.
- Required: No
- Type: string
- Default: `'3.0'`

### Parameter: `baseTime`

Do not provide a value! This date value is used to make sure the script run every time the template is deployed.
- Required: No
- Type: string
- Default: `[utcNow('yyyy-MM-dd-HH-mm-ss')]`

### Parameter: `cleanupPreference`

The clean up preference when the script execution gets in a terminal state. Specify the preference on when to delete the deployment script resources. The default value is Always, which means the deployment script resources are deleted despite the terminal state (Succeeded, Failed, canceled).
- Required: No
- Type: string
- Default: `'Always'`
- Allowed:
  ```Bicep
  [
    'Always'
    'OnExpiration'
    'OnSuccess'
  ]
  ```

### Parameter: `containerGroupName`

Container group name, if not specified then the name will get auto-generated. Not specifying a 'containerGroupName' indicates the system to generate a unique name which might end up flagging an Azure Policy as non-compliant. Use 'containerGroupName' when you have an Azure Policy that expects a specific naming convention or when you want to fully control the name. 'containerGroupName' property must be between 1 and 63 characters long, must contain only lowercase letters, numbers, and dashes and it cannot start or end with a dash and consecutive dashes are not allowed.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `environmentVariables`

The environment variables to pass over to the script. The list is passed as an object with a key name "secureList" and the value is the list of environment variables (array). The list must have a 'name' and a 'value' or a 'secretValue' property for each object.
- Required: No
- Type: secureObject
- Default: `{}`

### Parameter: `kind`

Type of the script. AzurePowerShell, AzureCLI.
- Required: No
- Type: string
- Default: `'AzurePowerShell'`
- Allowed:
  ```Bicep
  [
    'AzureCLI'
    'AzurePowerShell'
  ]
  ```

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | Yes | array | Optional. The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.userAssignedResourceIds`

Optional. The resource ID(s) to assign to the resource.

- Required: Yes
- Type: array

### Parameter: `name`

Display name of the script to be run.
- Required: Yes
- Type: string

### Parameter: `primaryScriptUri`

Uri for the external script. This is the entry point for the external script. To run an internal script, use the scriptContent instead.
- Required: No
- Type: string
- Default: `''`

### Parameter: `retentionInterval`

Interval for which the service retains the script resource after it reaches a terminal state. Resource will be deleted when this duration expires. Duration is based on ISO 8601 pattern (for example P7D means one week).
- Required: No
- Type: string
- Default: `'P1D'`

### Parameter: `runOnce`

When set to false, script will run every time the template is deployed. When set to true, the script will only run once.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `scriptContent`

Script body. Max length: 32000 characters. To run an external script, use primaryScriptURI instead.
- Required: No
- Type: string
- Default: `''`

### Parameter: `storageAccountResourceId`

The resource ID of the storage account to use for this deployment script. If none is provided, the deployment script uses a temporary, managed storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `supportingScriptUris`

List of supporting files for the external script (defined in primaryScriptUri). Does not work with internal scripts (code defined in scriptContent).
- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object

### Parameter: `timeout`

Maximum allowed script execution time specified in ISO 8601 format. Default value is PT1H - 1 hour; 'PT30M' - 30 minutes; 'P5D' - 5 days; 'P1Y' 1 year.
- Required: No
- Type: string
- Default: `'PT1H'`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployment script. |
| `outputs` | object | The output of the deployment script. |
| `resourceGroupName` | string | The resource group the deployment script was deployed into. |
| `resourceId` | string | The resource ID of the deployment script. |

## Cross-referenced modules

_None_
