# Azure Security Center `[Microsoft.Security/azureSecurityCenter]`

This template enables Azure security center - Standard tier by default, could be overridden.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Security/autoProvisioningSettings` | [2017-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2017-08-01-preview/autoProvisioningSettings) |
| `Microsoft.Security/deviceSecurityGroups` | [2019-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2019-08-01/deviceSecurityGroups) |
| `Microsoft.Security/iotSecuritySolutions` | [2019-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2019-08-01/iotSecuritySolutions) |
| `Microsoft.Security/pricings` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2018-06-01/pricings) |
| `Microsoft.Security/securityContacts` | [2017-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2017-08-01-preview/securityContacts) |
| `Microsoft.Security/workspaceSettings` | [2017-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2017-08-01-preview/workspaceSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `scope` | string | All the VMs in this scope will send their security data to the mentioned workspace unless overridden by a setting with more specific scope. |
| `workspaceId` | string | The full Azure ID of the workspace to save the data in. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appServicesPricingTier` | string | `'Free'` | `[Free, Standard]` | The pricing tier value for AppServices. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| `armPricingTier` | string | `'Free'` | `[Free, Standard]` | The pricing tier value for ARM. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| `autoProvision` | string | `'On'` | `[Off, On]` | Describes what kind of security agent provisioning action to take. - On or Off. |
| `containerRegistryPricingTier` | string | `'Free'` | `[Free, Standard]` | The pricing tier value for ContainerRegistry. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| `containersTier` | string | `'Free'` | `[Free, Standard]` | The pricing tier value for containers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| `cosmosDbsTier` | string | `'Free'` | `[Free, Standard]` | The pricing tier value for CosmosDbs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| `deviceSecurityGroupProperties` | object | `{object}` |  | Device Security group data. |
| `dnsPricingTier` | string | `'Free'` | `[Free, Standard]` | The pricing tier value for DNS. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `ioTSecuritySolutionProperties` | object | `{object}` |  | Security Solution data. |
| `keyVaultsPricingTier` | string | `'Free'` | `[Free, Standard]` | The pricing tier value for KeyVaults. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| `kubernetesServicePricingTier` | string | `'Free'` | `[Free, Standard]` | The pricing tier value for KubernetesService. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| `location` | string | `[deployment().location]` |  | Location deployment metadata. |
| `openSourceRelationalDatabasesTier` | string | `'Free'` | `[Free, Standard]` | The pricing tier value for OpenSourceRelationalDatabases. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| `securityContactProperties` | object | `{object}` |  | Security contact data. |
| `sqlServersPricingTier` | string | `'Free'` | `[Free, Standard]` | The pricing tier value for SqlServers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| `sqlServerVirtualMachinesPricingTier` | string | `'Free'` | `[Free, Standard]` | The pricing tier value for SqlServerVirtualMachines. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| `storageAccountsPricingTier` | string | `'Free'` | `[Free, Standard]` | The pricing tier value for StorageAccounts. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| `virtualMachinesPricingTier` | string | `'Free'` | `[Free, Standard]` | The pricing tier value for VMs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |


### Parameter Usage: `securityContactProperties`

<details>

<summary>Parameter JSON format</summary>

```json
"securityContactProperties": {
  "value": {
      "email": "test@contoso.com",
      "phone": "+12345678",
      "alertNotifications": "On",
      "alertsToAdmins": "Off"
  }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
securityContactProperties: {
    email: 'test@contoso.com'
    phone: '+12345678'
    alertNotifications: 'On'
    alertsToAdmins: 'Off'
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the security center. |
| `workspaceId` | string | The resource ID of the used log analytics workspace. |

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
module azureSecurityCenter './security/azure-security-center/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-sasccom'
  params: {
    // Required parameters
    workspaceId: '<workspaceId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    securityContactProperties: {
      alertNotifications: 'Off'
      alertsToAdmins: 'Off'
      email: 'foo@contoso.com'
      phone: '+12345678'
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
    "workspaceId": {
      "value": "<workspaceId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "securityContactProperties": {
      "value": {
        "alertNotifications": "Off",
        "alertsToAdmins": "Off",
        "email": "foo@contoso.com",
        "phone": "+12345678"
      }
    }
  }
}
```

</details>
<p>
