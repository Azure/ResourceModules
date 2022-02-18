# Virtual Machine Scale Sets `[Microsoft.Compute/virtualMachineScaleSets]`

This module deploys a virtual machine scale set.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Compute/proximityPlacementGroups` | 2021-04-01 |
| `Microsoft.Compute/virtualMachineScaleSets` | 2021-04-01 |
| `Microsoft.Compute/virtualMachineScaleSets/extensions` | 2021-07-01 |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |

### Resource dependency

The following resources are required to be able to deploy this resource.

- `Microsoft.Network/VirtualNetwork`

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `additionalUnattendContent` | array | `[]` |  | Optional. Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. - AdditionalUnattendContent object |
| `adminPassword` | secureString |  |  | Optional. When specifying a Windows Virtual Machine, this value should be passed |
| `adminUsername` | secureString |  |  | Required. Administrator username |
| `automaticRepairsPolicyEnabled` | bool |  |  | Optional. Specifies whether automatic repairs should be enabled on the virtual machine scale set. |
| `availabilityZones` | array | `[]` |  | Optional. The virtual machine scale set zones. NOTE: Availability zones can only be set when you create the scale set. |
| `baseTime` | string | `[utcNow('u')]` |  | Generated. Do not provide a value! This date value is used to generate a registration token. |
| `bootDiagnosticStorageAccountName` | string |  |  | Optional. Storage account used to store boot diagnostic information. Boot diagnostics will be disabled if no value is provided. |
| `bootDiagnosticStorageAccountUri` | string | `[format('.blob.{0}/', environment().suffixes.storage)]` |  | Optional. Storage account boot diagnostic base URI. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `customData` | string |  |  | Optional. Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format. |
| `dataDisks` | array | `[]` |  | Optional. Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets. |
| `diagnosticEventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string |  |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string |  |  | Optional. Resource ID of the diagnostic log analytics workspace. |
| `disableAutomaticRollback` | bool |  |  | Optional. Whether OS image rollback feature should be disabled. |
| `disablePasswordAuthentication` | bool |  |  | Optional. Specifies whether password authentication should be disabled. |
| `doNotRunExtensionsOnOverprovisionedVMs` | bool |  |  | Optional. When Overprovision is enabled, extensions are launched only on the requested number of VMs which are finally kept. This property will hence ensure that the extensions do not run on the extra overprovisioned VMs. |
| `enableAutomaticOSUpgrade` | bool |  |  | Optional. Indicates whether OS upgrades should automatically be applied to scale set instances in a rolling fashion when a newer version of the OS image becomes available. Default value is false. If this is set to true for Windows based scale sets, enableAutomaticUpdates is automatically set to false and cannot be set to true. |
| `enableAutomaticUpdates` | bool | `True` |  | Optional. Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning. |
| `enableEvictionPolicy` | bool |  |  | Optional. Specifies the eviction policy for the low priority virtual machine. Will result in 'Deallocate' eviction policy. |
| `enableServerSideEncryption` | bool |  |  | Optional. Specifies if Windows VM disks should be encrypted with Server-side encryption + Customer managed Key. |
| `encryptionAtHost` | bool | `True` |  | Optional. This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine scale set. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets. |
| `extensionAntiMalwareConfig` | object | `{object}` |  | Optional. The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionCustomScriptConfig` | object | `{object}` |  | Optional. The configuration for the [Custom Script] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionDependencyAgentConfig` | object | `{object}` |  | Optional. The configuration for the [Dependency Agent] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionDiskEncryptionConfig` | object | `{object}` |  | Optional. The configuration for the [Disk Encryption] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionDomainJoinConfig` | object | `{object}` |  | Optional. The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionDomainJoinPassword` | secureString |  |  | Optional. Required if domainName is specified. Password of the user specified in domainJoinUser parameter |
| `extensionDSCConfig` | object | `{object}` |  | Optional. The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionMonitoringAgentConfig` | object | `{object}` |  | Optional. The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionNetworkWatcherAgentConfig` | object | `{object}` |  | Optional. The configuration for the [Network Watcher Agent] extension. Must at least contain the ["enabled": true] property to be executed |
| `gracePeriod` | string | `PT30M` |  | Optional. The amount of time for which automatic repairs are suspended due to a state change on VM. The grace time starts after the state change has completed. This helps avoid premature or accidental repairs. The time duration should be specified in ISO 8601 format. The minimum allowed grace period is 30 minutes (PT30M). The maximum allowed grace period is 90 minutes (PT90M). |
| `imageReference` | object |  |  | Required. OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image. |
| `licenseType` | string |  | `[Windows_Client, Windows_Server, ]` | Optional. Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `maxBatchInstancePercent` | int | `20` |  | Optional. The maximum percent of total virtual machine instances that will be upgraded simultaneously by the rolling upgrade in one batch. As this is a maximum, unhealthy instances in previous or future batches can cause the percentage of instances in a batch to decrease to ensure higher reliability. |
| `maxPriceForLowPriorityVm` | string |  |  | Optional. Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars. |
| `maxUnhealthyInstancePercent` | int | `20` |  | Optional. The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch |
| `maxUnhealthyUpgradedInstancePercent` | int | `20` |  | Optional. The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `monitoringWorkspaceId` | string |  |  | Optional. Resource ID of the monitoring log analytics workspace. |
| `name` | string |  |  | Required. Name of the VMSS. |
| `nicConfigurations` | array | `[]` |  | Required. Configures NICs and PIPs. |
| `osDisk` | object |  |  | Required. Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.|
| `osType` | string |  | `[Windows, Linux]` | Required. The chosen OS type |
| `overprovision` | bool |  |  | Optional. Specifies whether the Virtual Machine Scale Set should be overprovisioned. |
| `pauseTimeBetweenBatches` | string | `PT0S` |  | Optional. The wait time between completing the update for all virtual machines in one batch and starting the next batch. The time duration should be specified in ISO 8601 format |
| `plan` | object | `{object}` |  | Optional. Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use. |
| `provisionVMAgent` | bool | `True` |  | Optional. Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later. |
| `proximityPlacementGroupName` | string |  |  | Optional. Creates an proximity placement group and adds the VMs to it. |
| `proximityPlacementGroupType` | string | `Standard` | `[Standard, Ultra]` | Optional. Specifies the type of the proximity placement group. |
| `publicKeys` | array | `[]` |  | Optional. The list of SSH public keys used to authenticate with linux based VMs |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sasTokenValidityLength` | string | `PT8H` |  | Optional. SAS token validity length to use to download files from storage accounts. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours. |
| `scaleInPolicy` | object | `{object}` |  | Optional. Specifies the scale-in policy that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled-in |
| `scaleSetFaultDomain` | int | `2` |  | Optional. Fault Domain count for each placement group. |
| `scheduledEventsProfile` | object | `{object}` |  | Optional. Specifies Scheduled Event related configurations |
| `secrets` | array | `[]` |  | Optional. Specifies set of certificates that should be installed onto the virtual machines in the scale set. |
| `securityType` | string |  | `TrustedLaunch` | Optional. Specifies the SecurityType of the virtual machine scale set. It is set as TrustedLaunch to enable UefiSettings. |
| `secureBootEnabled` | bool |  `False`  | | Optional. Specifies whether secure boot should be enabled on the virtual machine scale set. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| `singlePlacementGroup` | bool | `True` |  | Optional. When true this limits the scale set to a single placement group, of max size 100 virtual machines. NOTE: If singlePlacementGroup is true, it may be modified to false. However, if singlePlacementGroup is false, it may not be modified to true. |
| `skuCapacity` | int | `1` |  | Optional. The initial instance count of scale set VMs. |
| `skuName` | string |  |  | Required. The SKU size of the VMs. |
| `systemAssignedIdentity` | bool |  |  | Optional. Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `timeZone` | string |  |  | Optional. Specifies the time zone of the virtual machine. e.g. 'Pacific Standard Time'. Possible values can be 'TimeZoneInfo.id' value from time zones returned by TimeZoneInfo.GetSystemTimeZones. |
| `ultraSSDEnabled` | bool |  |  | Optional. The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled. |
| `upgradePolicyMode` | string | `Manual` | `[Manual, Automatic, Rolling]` | Optional. Specifies the mode of an upgrade to virtual machines in the scale set.' Manual - You control the application of updates to virtual machines in the scale set. You do this by using the manualUpgrade action. ; Automatic - All virtual machines in the scale set are automatically updated at the same time. - Automatic, Manual, Rolling |
| `userAssignedIdentities` | object | `{object}` |  | Optional. The ID(s) to assign to the resource. |
| `vmNamePrefix` | string | `vmssvm` |  | Optional. Specifies the computer name prefix for all of the virtual machines in the scale set. |
| `vmPriority` | string | `Regular` | `[Regular, Low, Spot]` | Optional. Specifies the priority for the virtual machine. |
| `vTpmEnabled` | bool | `False` |  | Optional. Specifies whether vTPM should be enabled on the virtual machine scale set. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| `winRM` | object | `{object}` |  | Optional. Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object. |
| `zoneBalance` | bool |  |  | Optional. Whether to force strictly even Virtual Machine distribution cross x-zones in case there is zone outage. |

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
            "storageAccountType": "Premium_LRS",
            "diskEncryptionSet": { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.
                        "id": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>"
              }
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
        "writeAcceleratorEnabled": true,
        "managedDisk": {
            "storageAccountType": "Premium_LRS"
        }
    },
    {
        "caching": "ReadOnly",
        "createOption": "Empty",
        "diskSizeGB": "128",
        "writeAcceleratorEnabled": true,
        "managedDisk": {
            "storageAccountType": "Premium_LRS"
        }
    }]
}
```

### Parameter Usage `nicConfigurations`

```json
"nicConfigurations": {
    "value": [
        {
            "nicSuffix": "-nic01",
            "ipConfigurations": [
                {
                    "name": "ipconfig1",
                    "properties": {
                        "subnet": {
                            "id": "/subscriptions/<<subscriptionId>>/resourceGroups/agents-vmss-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-scaleset/subnets/sxx-az-subnet-scaleset-linux"
                        }
                    }
                }
            ]
        }
    ]
}
```


### Parameter Usage `extensionDomainJoinConfig`


```json
"windowsScriptExtensionFileData": {
    "value": [
        //storage accounts with SAS token requirement
        {
            "uri": "https://mystorageAccount.blob.core.windows.net/avdscripts/File1.ps1",
            "storageAccountId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName"
        },
        {
            "uri": "https://mystorageAccount.blob.core.windows.net/avdscripts/File2.ps1",
            "storageAccountId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName"
        },
        "secretName": "domainJoinUser-Password"
    }
}
```

### Parameter Usage `extensionNetworkWatcherAgentConfig`

```json
"extensionNetworkWatcherAgentConfig": {
    "value": {
        "enabled": true
    }
}
```

### Parameter Usage: `microsoftAntiMalwareSettings`

Only for OSType Windows

```json
"extensionAntiMalwareConfig": {
    "value": {
        "enabled": true,
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

### Parameter Usage: `extensionDiskEncryptionConfig`

```json
"extensionDiskEncryptionConfig": {
    "value": {
        "enabled": true,
        "settings": {
            "EncryptionOperation": "EnableEncryption",
            "KeyVaultURL": "https://mykeyvault.vault.azure.net/",
            "KeyVaultResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-sxx-az-kv-x-001",
            "KeyEncryptionKeyURL": "https://mykeyvault.vault.azure.net/keys/keyEncryptionKey/3e13110def0d4a26ac38341c73c059bb",
            "KekVaultResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-sxx-az-kv-x-001",
            "KeyEncryptionAlgorithm": "RSA-OAEP",
            "VolumeType": "All",
            "ResizeOSDisk": "false"
        }
    }
}
```

### Parameter Usage: `windowsScriptExtensionFileData`

```json
"extensionCustomScriptConfig": {
    "value": {
        "enabled": true,
        "fileData": [
             //storage accounts with SAS token requirement
            {
                "uri": "https://<<storageAccountName>>.blob.core.windows.net/scripts/File1.ps1",
                "storageAccountId": "/subscriptions/<<subscriptionId>>/resourceGroups/WVD-Mgmt-TO-RG/providers/Microsoft.Storage/storageAccounts/wvdtoassetsstore"
            },
            {
                "uri": "https://<<storageAccountName>>.blob.core.windows.net/scripts/File2.ps1",
                "storageAccountId": "/subscriptions/<<subscriptionId>>/resourceGroups/WVD-Mgmt-TO-RG/providers/Microsoft.Storage/storageAccounts/wvdtoassetsstore"
            },
             //storage account with public container (no SAS token is required) OR other public URL (not a storage account)
            {
                "uri": "https://github.com/myProject/File3.ps1"
            }
        ],
        "protectedSettings": {
            "commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command \"& .\\scriptExtensionMasterInstaller.ps1\""
        }
    }
}
```

### Parameter Usage: `windowsScriptExtensionFileData` with native storage account key support

```json
"extensionCustomScriptConfig": {
    "value": {
        "enabled": true,
        "fileData": [
            {
                "uri": "https://<<storageAccountName>>.blob.core.windows.net/scripts/File1.ps1"
            }
        ],
        "protectedSettings": {
            "commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command \"& .\\scriptExtensionMasterInstaller.ps1\"",
            "cseStorageAccountName": "mystorageaccount",
            "cseStorageAccountKey": "MyPlaceholder",
        }
    }
}
```

### Parameter Usage: `extensionDSCConfig`

```json
"extensionDSCConfig": {
    "value": {
        "enabled": true,
        "settings": {
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
| `name` | string | The name of the virtual machine scale set |
| `resourceGroupName` | string | The resource group of the virtual machine scale set |
| `resourceId` | string | The resource ID of the virtual machine scale set |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Proximityplacementgroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-04-01/proximityPlacementGroups)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Virtualmachinescalesets](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-04-01/virtualMachineScaleSets)
- [Virtualmachinescalesets/Extensions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-07-01/virtualMachineScaleSets/extensions)
