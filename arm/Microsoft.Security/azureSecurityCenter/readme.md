# Azure Security Center `[Microsoft.Security/azureSecurityCenter]`

This template enables Azure security center - Standard tier by default, could be overridden.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Security/autoProvisioningSettings` | 2017-08-01-preview |
| `Microsoft.Security/deviceSecurityGroups` | 2019-08-01 |
| `Microsoft.Security/iotSecuritySolutions` | 2019-08-01 |
| `Microsoft.Security/pricings` | 2018-06-01 |
| `Microsoft.Security/securityContacts` | 2017-08-01-preview |
| `Microsoft.Security/workspaceSettings` | 2017-08-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `appServicesPricingTier` | string | `Free` | `[Free, Standard]` | Optional. The pricing tier value for AppServices. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard |
| `armPricingTier` | string | `Free` | `[Free, Standard]` | Optional. The pricing tier value for ARM. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard |
| `autoProvision` | string | `On` | `[On, Off]` | Optional. Describes what kind of security agent provisioning action to take. - On or Off |
| `containerRegistryPricingTier` | string | `Free` | `[Free, Standard]` | Optional. The pricing tier value for ContainerRegistry. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard |
| `deviceSecurityGroupProperties` | object | `{object}` |  | Optional. Device Security group data |
| `dnsPricingTier` | string | `Free` | `[Free, Standard]` | Optional. The pricing tier value for DNS. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard |
| `ioTSecuritySolutionProperties` | object | `{object}` |  | Optional. Security Solution data |
| `keyVaultsPricingTier` | string | `Free` | `[Free, Standard]` | Optional. The pricing tier value for KeyVaults. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard |
| `kubernetesServicePricingTier` | string | `Free` | `[Free, Standard]` | Optional. The pricing tier value for KubernetesService. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard |
| `openSourceRelationalDatabasesTier` | string | `Free` | `[Free, Standard]` | Optional. The pricing tier value for OpenSourceRelationalDatabases. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard |
| `scope` | string |  |  | Required. All the VMs in this scope will send their security data to the mentioned workspace unless overridden by a setting with more specific scope. |
| `securityContactProperties` | object | `{object}` |  | Optional. Security contact data |
| `sqlServersPricingTier` | string | `Free` | `[Free, Standard]` | Optional. The pricing tier value for SqlServers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard |
| `sqlServerVirtualMachinesPricingTier` | string | `Free` | `[Free, Standard]` | Optional. The pricing tier value for SqlServerVirtualMachines. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard |
| `storageAccountsPricingTier` | string | `Free` | `[Free, Standard]` | Optional. The pricing tier value for StorageAccounts. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard |
| `virtualMachinesPricingTier` | string | `Free` | `[Free, Standard]` | Optional. The pricing tier value for VMs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard |
| `workspaceId` | string |  |  | Required. The full Azure ID of the workspace to save the data in. |

### Parameter Usage: `deviceSecurityGroupProperties`

```json
"deviceSecurityGroupProperties": {
    "value": {
        "thresholdRules": [
          {
            "isEnabled": "boolean",
            "ruleType": "string",
            "minThreshold": "integer",
            "maxThreshold": "integer"
          }
        ],
        "timeWindowRules": [
          {
            "isEnabled": "boolean",
            "ruleType": "string",
            "minThreshold": "integer",
            "maxThreshold": "integer",
            "timeWindowSize": "string"
          }
        ],
        "allowlistRules": [
          {
            "isEnabled": "boolean",
            "ruleType": "string",
            "allowlistValues": [
              "string"
            ]
          }
        ],
        "denylistRules": [
          {
            "isEnabled": "boolean",
            "ruleType": "string",
            "denylistValues": [
              "string"
            ]
          }
        ]
    }
}
```

### Parameter Usage: `ioTSecuritySolutionProperties`

```json
"ioTSecuritySolutionProperties": {
  "value": {
      "resourceGroup": "string",
      "workspace": "string",
      "displayName": "string",
      "status": "string",
      "export": [
        "RawEvents"
      ],
      "disabledDataSources": [
        "TwinData"
      ],
      "iotHubs": [
        "string"
      ],
      "userDefinedResources": {
        "query": "string",
        "querySubscriptions": [
          "string"
        ]
      },
      "recommendationsConfiguration": [
        {
          "recommendationType": "string",
          "status": "string"
        }
      ]
    }
}
```

### Parameter Usage: `securityContactProperties`

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `workspaceId` | string | The resource IDs of the used log analytics workspace |

## Template references

- [Autoprovisioningsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Security/2017-08-01-preview/autoProvisioningSettings)
- [Devicesecuritygroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Security/2019-08-01/deviceSecurityGroups)
- [Iotsecuritysolutions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Security/2019-08-01/iotSecuritySolutions)
- [Pricings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Security/2018-06-01/pricings)
- [Securitycontacts](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Security/2017-08-01-preview/securityContacts)
- [Workspacesettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Security/2017-08-01-preview/workspaceSettings)
