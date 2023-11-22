# Azure Security Center (Defender for Cloud) `[Microsoft.Security/azuresecuritycenter]`

This module deploys an Azure Security Center (Defender for Cloud) Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Security/autoProvisioningSettings` | [2017-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2017-08-01-preview/autoProvisioningSettings) |
| `Microsoft.Security/deviceSecurityGroups` | [2019-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2019-08-01/deviceSecurityGroups) |
| `Microsoft.Security/iotSecuritySolutions` | [2019-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2019-08-01/iotSecuritySolutions) |
| `Microsoft.Security/pricings` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2018-06-01/pricings) |
| `Microsoft.Security/securityContacts` | [2017-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2017-08-01-preview/securityContacts) |
| `Microsoft.Security/workspaceSettings` | [2017-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2017-08-01-preview/workspaceSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/security.azure-security-center:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module azureSecurityCenter 'br:bicep/modules/security.azure-security-center:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-sascmax'
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

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module azureSecurityCenter 'br:bicep/modules/security.azure-security-center:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-sascwaf'
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`scope`](#parameter-scope) | string | All the VMs in this scope will send their security data to the mentioned workspace unless overridden by a setting with more specific scope. |
| [`workspaceId`](#parameter-workspaceid) | string | The full Azure ID of the workspace to save the data in. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appServicesPricingTier`](#parameter-appservicespricingtier) | string | The pricing tier value for AppServices. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`armPricingTier`](#parameter-armpricingtier) | string | The pricing tier value for ARM. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`autoProvision`](#parameter-autoprovision) | string | Describes what kind of security agent provisioning action to take. - On or Off. |
| [`containerRegistryPricingTier`](#parameter-containerregistrypricingtier) | string | The pricing tier value for ContainerRegistry. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`containersTier`](#parameter-containerstier) | string | The pricing tier value for containers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`cosmosDbsTier`](#parameter-cosmosdbstier) | string | The pricing tier value for CosmosDbs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`deviceSecurityGroupProperties`](#parameter-devicesecuritygroupproperties) | object | Device Security group data. |
| [`dnsPricingTier`](#parameter-dnspricingtier) | string | The pricing tier value for DNS. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`ioTSecuritySolutionProperties`](#parameter-iotsecuritysolutionproperties) | object | Security Solution data. |
| [`keyVaultsPricingTier`](#parameter-keyvaultspricingtier) | string | The pricing tier value for KeyVaults. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`kubernetesServicePricingTier`](#parameter-kubernetesservicepricingtier) | string | The pricing tier value for KubernetesService. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`openSourceRelationalDatabasesTier`](#parameter-opensourcerelationaldatabasestier) | string | The pricing tier value for OpenSourceRelationalDatabases. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`securityContactProperties`](#parameter-securitycontactproperties) | object | Security contact data. |
| [`sqlServersPricingTier`](#parameter-sqlserverspricingtier) | string | The pricing tier value for SqlServers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`sqlServerVirtualMachinesPricingTier`](#parameter-sqlservervirtualmachinespricingtier) | string | The pricing tier value for SqlServerVirtualMachines. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`storageAccountsPricingTier`](#parameter-storageaccountspricingtier) | string | The pricing tier value for StorageAccounts. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`virtualMachinesPricingTier`](#parameter-virtualmachinespricingtier) | string | The pricing tier value for VMs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |

### Parameter: `appServicesPricingTier`

The pricing tier value for AppServices. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `armPricingTier`

The pricing tier value for ARM. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `autoProvision`

Describes what kind of security agent provisioning action to take. - On or Off.
- Required: No
- Type: string
- Default: `'On'`
- Allowed:
  ```Bicep
  [
    'Off'
    'On'
  ]
  ```

### Parameter: `containerRegistryPricingTier`

The pricing tier value for ContainerRegistry. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `containersTier`

The pricing tier value for containers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `cosmosDbsTier`

The pricing tier value for CosmosDbs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `deviceSecurityGroupProperties`

Device Security group data.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `dnsPricingTier`

The pricing tier value for DNS. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `ioTSecuritySolutionProperties`

Security Solution data.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `keyVaultsPricingTier`

The pricing tier value for KeyVaults. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `kubernetesServicePricingTier`

The pricing tier value for KubernetesService. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `location`

Location deployment metadata.
- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `openSourceRelationalDatabasesTier`

The pricing tier value for OpenSourceRelationalDatabases. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `scope`

All the VMs in this scope will send their security data to the mentioned workspace unless overridden by a setting with more specific scope.
- Required: Yes
- Type: string

### Parameter: `securityContactProperties`

Security contact data.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `sqlServersPricingTier`

The pricing tier value for SqlServers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `sqlServerVirtualMachinesPricingTier`

The pricing tier value for SqlServerVirtualMachines. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `storageAccountsPricingTier`

The pricing tier value for StorageAccounts. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `virtualMachinesPricingTier`

The pricing tier value for VMs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `workspaceId`

The full Azure ID of the workspace to save the data in.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the security center. |
| `workspaceId` | string | The resource ID of the used log analytics workspace. |

## Cross-referenced modules

_None_
