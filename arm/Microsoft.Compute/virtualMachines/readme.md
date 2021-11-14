# Virtual Machines `[Microsoft.Compute/virtualMachines]`

This module deploys one Virtual Machine with one or multiple nics and optionally one or multiple public IPs.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Compute/virtualMachines` | 2021-04-01 |
| `Microsoft.Compute/virtualMachines/extensions` | 2021-04-01 |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/networkInterfaces` | 2021-02-01 |
| `Microsoft.Network/publicIPAddresses` | 2021-02-01 |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `adminPassword` | secureString |  |  | Required. When specifying a Windows Virtual Machine, this value should be passed |
| `adminUsername` | secureString |  |  | Required. Administrator username |
| `allowExtensionOperations` | bool | `True` |  | Optional. Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine. |
| `availabilitySetName` | string |  |  | Optional. Resource name of an availability set. Cannot be used in combination with availability zone nor scale set. |
| `availabilityZone` | int |  | `[0, 1, 2, 3]` | Optional. If set to 1, 2 or 3, the availability zone for all VMs is hardcoded to that value. If zero, then the automatic algorithm will be used to give every VM in a different zone (up to three zones). Cannot be used in combination with availability set nor scale set. |
| `backupPolicyName` | string | `DefaultPolicy` |  | Optional. Backup policy the VMs should be using for backup. |
| `backupVaultName` | string |  |  | Optional. Recovery service vault name to add VMs to backup. |
| `backupVaultResourceGroup` | string | `[resourceGroup().name]` |  | Optional. Resource group of the backup recovery service vault. If not provided the current resource group name is considered by default. |
| `baseTime` | string | `[utcNow('u')]` |  | Generated. Do not provide a value! This date value is used to generate a registration token. |
| `bootDiagnosticStorageAccountName` | string |  |  | Optional. Storage account used to store boot diagnostic information. Boot diagnostics will be disabled if no value is provided. |
| `bootDiagnosticStorageAccountUri` | string | `.blob.core.windows.net/` |  | Optional. Storage account boot diagnostic base URI. |
| `certificatesToBeInstalled` | array | `[]` |  | Optional. Specifies set of certificates that should be installed onto the virtual machine. |
| `cseManagedIdentity` | object | `{object}` |  | Optional. A managed identity to use for the CSE. |
| `cseStorageAccountKey` | string |  |  | Optional. The storage key of the storage account to access for the CSE script(s). |
| `cseStorageAccountName` | string |  |  | Optional. The name of the storage account to access for the CSE script(s). |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `customData` | string |  |  | Optional. Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format. |
| `dataDisks` | array | `[]` |  | Optional. Specifies the data disks. |
| `dedicatedHostId` | string |  |  | Optional. Specifies resource Id about the dedicated host that the virtual machine resides in. |
| `desiredStateConfigurationSettings` | object | `{object}` |  | Optional. The DSC configuration object |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `diskEncryptionSettings` | object | `{object}` |  | Optional. Settings for Azure Disk Encription extension. |
| `domainJoinPassword` | secureString |  |  | Optional. Required if domainName is specified. Password of the user specified in domainJoinUser parameter |
| `domainJoinSettings` | object | `{object}` |  | Optional. The Domain Join configuration object |
| `enableCustomScriptExtension` | bool |  |  | Optional. Specifies if Custom Script Extension should be enabled. |
| `enableDesiredStateConfiguration` | bool |  |  | Optional. Specifies if Desired State Configuration Extension should be enabled. |
| `enableDomainJoinExtension` | bool |  |  | Optional. Specifies if the Domain Join Extension should be enabled. |
| `enableEvictionPolicy` | bool |  |  | Optional. Specifies the eviction policy for the low priority virtual machine. Will result in 'Deallocate' eviction policy. |
| `enableLinuxDependencyAgent` | bool |  |  | Optional. Specifies if Azure Dependency Agent for Linux VM should be enabled. Requires LinuxMMAAgent to be enabled. |
| `enableLinuxDiskEncryption` | bool |  |  | Optional. Specifies if Linux VM disks should be encrypted. If enabled, boot diagnostics must be enabled as well. |
| `enableLinuxMMAAgent` | bool |  |  | Optional. Specifies if MMA agent for Linux VM should be enabled. |
| `enableMicrosoftAntiMalware` | bool |  |  | Optional. Enables Microsoft Windows Defender AV. |
| `enableNetworkWatcherLinux` | bool |  |  | Optional. Specifies if Azure Network Watcher Agent for Linux VM should be enabled. |
| `enableNetworkWatcherWindows` | bool |  |  | Optional. Specifies if Azure Network Watcher Agent for Windows VM should be enabled. |
| `enableServerSideEncryption` | bool |  |  | Optional. Specifies if Windows VM disks should be encrypted with Server-side encryption + Customer managed Key. |
| `enableWindowsDependencyAgent` | bool |  |  | Optional. Specifies if Azure Dependency Agent for Windows VM should be enabled. Requires WindowsMMAAgent to be enabled. |
| `enableWindowsDiskEncryption` | bool |  |  | Optional. Specifies if Windows VM disks should be encrypted. If enabled, boot diagnostics must be enabled as well. |
| `enableWindowsMMAAgent` | bool |  |  | Optional. Specifies if MMA agent for Windows VM should be enabled. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `forceUpdateTag` | string | `1.0` |  | Optional. Pass in an unique value like a GUID everytime the operation needs to be force run |
| `imageReference` | object | `{object}` |  | Optional. OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image. |
| `licenseType` | string |  | `[Windows_Client, Windows_Server, ]` | Optional. Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system. |
| `linuxConfiguration` | object | `{object}` |  | Optional. Specifies the Linux operating system settings on the virtual machine. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `managedServiceIdentity` | string | `None` | `[None, SystemAssigned, SystemAssigned, UserAssigned, UserAssigned]` | Optional. The type of identity used for the virtual machine. The type 'SystemAssigned, UserAssigned' includes both an implicitly created identity and a set of user assigned identities. The type 'None' (default) will remove any identities from the virtual machine. |
| `maxPriceForLowPriorityVm` | string |  |  | Optional. Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars. |
| `microsoftAntiMalwareSettings` | object | `{object}` |  | Optional. Settings for Microsoft Windows Defender AV extension. |
| `nicConfigurations` | array |  |  | Required. Configures NICs and PIPs. |
| `nicMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `osDisk` | object |  |  | Required. Specifies the OS disk. |
| `pipLogsToEnable` | array | `[DDoSProtectionNotifications, DDoSMitigationFlowLogs, DDoSMitigationReports]` | `[DDoSProtectionNotifications, DDoSMitigationFlowLogs, DDoSMitigationReports]` | Optional. The name of logs that will be streamed. |
| `pipMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `plan` | object | `{object}` |  | Optional. Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use. |
| `proximityPlacementGroupName` | string |  |  | Optional. Resource name of a proximity placement group. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sasTokenValidityLength` | string | `PT8H` |  | Optional. SAS token validity length to use to download files from storage accounts. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `ultraSSDEnabled` | bool |  |  | Optional. The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled. |
| `useAvailabilityZone` | bool |  |  | Optional. Creates an availability zone and adds the VMs to it. Cannot be used in combination with availability set nor scale set. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. Mandatory if 'managedServiceIdentity' contains UserAssigned. The list of user identities associated with the Virtual Machine. |
| `virtualMachineName` | string | `[take(toLower(uniqueString(resourceGroup().name)), 10)]` |  | Optional. The name of the virtual machine to be created. You should use a unique prefix to reduce name collisions in Active Directory. If no value is provided, a 10 character long unique string will be generated based on the Resource Group's name. |
| `vmComputerNamesTransformation` | string | `none` |  | Optional. Specifies whether the computer names should be transformed. The transformation is performed on all computer names. Available transformations are 'none' (Default), 'uppercase' and 'lowercase'. |
| `vmPriority` | string | `Regular` | `[Regular, Low, Spot]` | Optional. Specifies the priority for the virtual machine. |
| `vmSize` | string | `Standard_D2s_v3` |  | Optional. Specifies the size for the VMs |
| `windowsConfiguration` | object | `{object}` |  | Optional. Specifies Windows operating system settings on the virtual machine. |
| `windowsScriptExtensionCommandToExecute` | secureString |  |  | Optional. Specifies the command that should be run on a Windows VM. |
| `windowsScriptExtensionFileData` | array | `[]` |  | Optional. Array of objects that specifies URIs and the storageAccountId of the scripts that need to be downloaded and run by the Custom Script Extension on a Windows VM. |
| `workspaceId` | string |  |  | Optional. Resource identifier of Log Analytics. |

### Parameter Usage: `imageReference`

#### Marketplace images

```json
"imageReference": {
    "value": {
        "publisher": "MicrosoftWindowsServer",
        "offer": "WindowsServer",
        "sku": "2016-Datacenter",
        "version": "latest"
    }
}
```

#### Custom images

```json
"imageReference": {
    "value": {
        "id": "/subscriptions/12345-6789-1011-1213-15161718/resourceGroups/rg-name/providers/Microsoft.Compute/images/imagename"
    }
}
```

### Parameter Usage: `plan`

```json
"plan": {
    "value": {
        "name": "qvsa-25",
        "product": "qualys-virtual-scanner",
        "publisher": "qualysguard"
    }
}
```

### Parameter Usage: `osDisk`

```json
 "osDisk": {
    "value": {
        "createOption": "fromImage",
        "diskSizeGB": "128",
        "managedDisk": {
            "storageAccountType": "Premium_LRS"
        }
    }
}
```

### Parameter Usage: `dataDisks`

```json
"dataDisks": {
    "value": [{
        "caching": "ReadOnly",
        "createOption": "Empty",
        "diskSizeGB": "256",
        "managedDisk": {
            "storageAccountType": "Premium_LRS"
        }
    },
    {
        "caching": "ReadOnly",
        "createOption": "Empty",
        "diskSizeGB": "128",
        "managedDisk": {
            "storageAccountType": "Premium_LRS"
        }
    }]
}
```

### Parameter Usage: `windowsConfiguration`

To set the time zone of a VM with the timeZone parameter inside windowsConfiguration, use the following PS command to get the correct options:

```powershell
Get-TimeZone -ListAvailable | Select Id
```

```json
"windowsConfiguration": {
  "provisionVMAgent": "boolean",
  "enableAutomaticUpdates": "boolean",
  "timeZone": "string",
  "additionalUnattendContent": [
    {
      "passName": "OobeSystem",
      "componentName": "Microsoft-Windows-Shell-Setup",
      "settingName": "string",
      "content": "string"
    }
  ],
  "winRM": {
    "listeners": [
      {
        "protocol": "string",
        "certificateUrl": "string"
      }
    ]
  }
}
```

### Parameter Usage: `linuxConfiguration`

```json
"linuxConfiguration": {
    "disablePasswordAuthentication": "boolean",
    "ssh": {
        "publicKeys": [
        {
            "path": "string",
            "keyData": "string"
        }
        ]
    },
    "provisionVMAgent": "boolean"
    },
    "secrets": [
    {
        "sourceVault": {
        "id": "string"
        },
        "vaultCertificates": [
        {
            "certificateUrl": "string",
            "certificateStore": "string"
        }
        ]
    }
    ],
    "allowExtensionOperations": "boolean",
    "requireGuestProvisionSignal": "boolean"
}
```

### Parameter Usage: `nicConfigurations`

The field `nicSuffix` and `subnetId` are mandatory. If `enablePublicIP` is set to true, then `publicIpNameSuffix` is also mandatory. Each IP config needs to have the mandatory field `name`.

```json
"nicConfigurations": {
  "value": [
    {
      "nicSuffix": "-nic-01",
      "ipConfigurations": [
        {
          "name": "ipconfig1",
          "subnetId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>",
          "pipConfiguration": {
            "publicIpNameSuffix": "-pip-01",
            "roleAssignments": [
              {
                "roleDefinitionIdOrName": "Reader",
                "principalIds": [
                  "<principalId>"
                ]
              }
            ]
          }
        },
        {
          "name": "ipconfig2",
          "subnetId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>",
        }
      ],
      "nsgId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/networkSecurityGroups/<nsgName>",
      "roleAssignments": [
        {
          "roleDefinitionIdOrName": "Reader",
          "principalIds": [
            "<principalId>"
          ]
        }
      ]
    },
    {
      "nicSuffix": "-nic-02",
      "ipConfigurations": [
        {
          "name": "ipconfig1",
          "subnetId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>",
          "pipConfiguration": {
            "publicIpNameSuffix": "-pip-02"
          }
        },
        {
          "name": "ipconfig2",
          "subnetId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>",
          "privateIPAllocationMethod": "Static",
          "vmIPAddress": "10.0.0.9"
        }
      ]
    }
  ]
}
```

### Parameter Usage: `domainJoinSettings`

```json
"enableDomainJoinExtension": {
  "value": true
},
"domainJoinSettings": {
  "value": {
    "settings": {
      "domainName": "contoso.com",
      "domainJoinUser": "domainJoinUser@contoso.com",
      "domainJoinOU": "OU=testOU; DC=contoso; DC=com",
      "domainJoinRestart": true,
      "domainJoinOptions": 3
    }
  }
},
"domainJoinPassword": {
  "keyVault": {
    "id": "/subscriptions/62826c76-d304-46d8-a0f6-718dbdcc536c/resourceGroups/WVD-Mgmt-TO-RG/providers/Microsoft.KeyVault/vaults/wvd-to-kvlt"
  },
  "secretName": "domainJoinUser02-Password"
}
```

### Parameter Usage: `microsoftAntiMalwareSettings`

```json
"enableMicrosoftAntiMalware": {
  "value": true
},
"microsoftAntiMalwareSettings": {
  "value": {
    "settings": {
      "AntimalwareEnabled": true,
      "Exclusions": {
        "Extensions": ".log;.ldf",
        "Paths": "D:\\IISlogs;D:\\DatabaseLogs",
        "Processes": "mssence.svc"
      },
      "RealtimeProtectionEnabled": true,
      "ScheduledScanSettings": {
        "isEnabled": "true",
        "scanType": "Quick",
        "day": "7",
        "time": "120"
      }
    }
  }
}
```

### Parameter Usage: `diskEncryptionSettings`

```json
"enableWindowsDiskEncryption": {
  "value": true
},
"diskEncryptionSettings": {
  "value": {
    "settings": {
      "EncryptionOperation": "EnableEncryption",
      "KeyVaultURL": "https://adp-sxx-az-kv-x-001.vault.azure.net/",
      "KeyVaultResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-sxx-az-kv-x-001",
      "KeyEncryptionKeyURL": "https://adp-sxx-az-kv-x-001.vault.azure.net/keys/keyEncryptionKey/685153483a1140e3856f004a753e1ab4",
      "KekVaultResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-sxx-az-kv-x-001",
      "KeyEncryptionAlgorithm": "RSA-OAEP", //'RSA-OAEP'/'RSA-OAEP-256'/'RSA1_5'
      "VolumeType": "All", //'OS'/'Data'/'All'
      "ResizeOSDisk": "false"
    }
  }
}
```

### Parameter Usage: `desiredStateConfigurationSettings`

```json
"enableDesiredStateConfiguration": {
  "value": true
},
"desiredStateConfigurationSettings": {
  "value": {
    {
      "wmfVersion": "latest",
      "configuration": {
        "url": "http://validURLToConfigLocation",
        "script": "ConfigurationScript.ps1",
        "function": "ConfigurationFunction"
      },
      "configurationArguments": {
        "argument1": "Value1",
        "argument2": "Value2"
      },
      "configurationData": {
        "url": "https://foo.psd1"
      },
      "privacy": {
        "dataCollection": "enable"
      },
      "advancedOptions": {
        "forcePullAndApply": false,
        "downloadMappings": {
          "specificDependencyKey": "https://myCustomDependencyLocation"
        }
      }
    },
    "protectedSettings": {
      "configurationArguments": {
        "mySecret": "MyPlaceholder"
      },
      "configurationUrlSasToken": "MyPlaceholder",
      "configurationDataUrlSasToken": "MyPlaceholder"
    }
  }
}
```

### Parameter Usage: `windowsScriptExtensionFileData`

```json
"enableCustomScriptExtension": {
  "value": true
},
"windowsScriptExtensionFileData": {
  "value": [
    //storage accounts with SAS token requirement
    {
      "uri": "https://storageAccount.blob.core.windows.net/avdscripts/File1.ps1",
      "storageAccountId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName"
    },
    {
      "uri": "https://storageAccount.blob.core.windows.net/avdscripts/File2.ps1",
      "storageAccountId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName"
    },
    //storage account with public container (no SAS token is required) OR other public URL (not a storage account)
    {
      "uri": "https://github.com/myProject/File3.ps1",
      "storageAccountId": ""
    }
  ]
}
```

### Parameter Usage: `windowsScriptExtensionFileData` with native storage account key support

```json
"enableCustomScriptExtension": {
  "value": true
},
"windowsScriptExtensionFileData": {
  "value": [
    {
      "https://mystorageaccount.blob.core.windows.net/avdscripts/testscript.ps1"
    }
  ]
},
"windowsScriptExtensionCommandToExecute": {
  "value": "powershell -ExecutionPolicy Unrestricted -File testscript.ps1"
},
"cseStorageAccountName": {
  "value": "mystorageaccount"
},
"cseStorageAccountKey": {
  "value": "MyPlaceholder"
}
```

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
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
| `virtualMachineName` | string | The name of the VM. |
| `virtualMachineResourceGroup` | string | The name of the Resource Group the VM was created in. |
| `virtualMachineResourceId` | string | The Resource Id of the VM. |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Virtualmachines](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-04-01/virtualMachines)
- [Virtualmachines/Extensions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-04-01/virtualMachines/extensions)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Networkinterfaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/networkInterfaces)
- [Publicipaddresses](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/publicIPAddresses)
- [Vaults/Backupfabrics/Protectioncontainers/Protecteditems](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-06-01/vaults/backupFabrics/protectionContainers/protectedItems)
