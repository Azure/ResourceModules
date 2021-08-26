# CognitiveServices

This module deploys different kinds of Cognitive Services resources

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.CognitiveServices/accounts` | 2017-04-18 |
| `Microsoft.CognitiveServices/accounts/providers/diagnosticsettings` | 2017-05-01-preview |
| `Microsoft.CognitiveServices/accounts/providers/roleAssignments` | 2018-09-01-preview |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2020-05-01 |
| `Microsoft.Network/privateEndpoints` | 2020-05-01 |
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `providers/locks` | 2016-09-01 |

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `accountName` | string | Required. The name of Cognitive Services account |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `customSubDomainName` | string | Optional. Subdomain name used for token-based authentication. Required if 'networkAcls' are set. | |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `kind` | string | Required. Kind of the Cognitive Services. Use `Get-AzCognitiveServicesAccountSku` to determine a valid pairs of 'kind' and 'sku' for your Azure region. |  | "AnomalyDetector", "Bing.Autosuggest.v7", "Bing.CustomSearch", "Bing.EntitySearch", "Bing.Search.v7", "Bing.SpellCheck.v7", "CognitiveServices", "ComputerVision" "ContentModerator", "CustomVision.Prediction", "CustomVision.Training", "Face", "FormRecognizer", "ImmersiveReader", "Internal.AllInOne", "LUIS", "LUIS.Authoring", "Personalizer", "QnAMaker", "SpeechServices", "TextAnalytics", "TextTranslation" |
| `location` | string | Optional. Location for all Resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Cognitive Services from deletion. | False |  |
| `managedIdentity` | string | Optional. Type of managed service identity. | None | "None", "SystemAssigned" |
| `networkAcls` | object | Optional. Service endpoint object information |  |  |
| `publicNetworkAccess` | string | Optional. Subdomain name used for token-based authentication. Must be set if 'networkAcls' are set. | Enabled | "Enabled", "Disabled" |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | [] |  |
| `privateEndpoints` | array | Optional. Configuration Details for private endpoints.  | System.Object[] | |
| `sku` | string | Optional. SKU of the Cognitive Services resource. Use `Get-AzCognitiveServicesAccountSku` to determine a valid combinations of 'kind' and 'sku' for your Azure region. | S0 | "C2", "C3", "C4", "F0", "F1", "S", "S0", "S1", "S10", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S9" |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Desktop Virtualization User",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
        }
    ]
}
```

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.

- Although not strictly required, it is highly recommened to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-sa-cac-y-123-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-001/subnets/sxx-az-subnet-weu-x-001",
            "service": "vault",
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
            ],
            "customDnsConfigs": [ // Optional
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
            ]
        }
    ]
}
```

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

### Parameter Usage: `networkAcls`

```json
"networkAcls": {
  "value": {
    "defaultAction": "Deny",
    "virtualNetworkRules": [
      {
        "id": "/subscriptions/<subscription-id>/resourceGroups/resourceGroup/providers/Microsoft.Network/virtualNetworks/<vnet-name>/subnets/<subnet-name>",
        "ignoreMissingVnetServiceEndpoint": false
      }
    ],
    "ipRules": [
      {
        "value": "1.1.1.1"
      },
      {
        "value": "<IP address or CIDR>"
      }
    ]
  }
},
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `cognitiveServicesEndpoint` | string | Cognitive Services Endpoint |
| `cognitiveServicesKey1` | string | Cognitive Services Key1 |
| `cognitiveServicesKey2` | string | Cognitive Services Key2 |
| `cognitiveServicesKeys` | object | Cognitive Services Keys |
| `cognitiveServicesName` | string | The Name of the Cognitive Services |
| `cognitiveServicesResourceGroup` | string | The name of the Resource Group with the Cognitive Services |
| `cognitiveServicesResourceId` | string | The Resource Id of the Cognitive Services |
| `principalId` | string | Cognitive Services identity Principal ID (if applicable). |

## Considerations

- Not all combinations of parameters `kind` and `sku` are valid and they may vary in different Azure Regions. Please use PowerShell CmdLet `Get-AzCognitiveServicesAccountSku` or another methods to determine valid values in your region.
- Not all kinds of Cognitive Services support virtual networks. Please visit the link below to determine supported services.

### References

#### Template references

- [Cognitive Services Accounts](https://docs.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2017-04-18/accounts)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)

## Additional resources

- [What are Azure Cognitive Services?](https://docs.microsoft.com/en-us/azure/cognitive-services/welcome)
- [Get-AzCognitiveServicesAccountSku](https://docs.microsoft.com/en-us/powershell/module/az.cognitiveservices/get-azcognitiveservicesaccountsku)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [Azure Cognitive Services virtual networks](https://docs.microsoft.com/en-us/azure/cognitive-services/cognitive-services-virtual-networks)
