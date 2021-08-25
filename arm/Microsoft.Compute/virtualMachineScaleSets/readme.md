# Virtual Machine Scale Sets

This module deploys a virtual machine scale set

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Compute/ProximityPlacementGroups` | 2019-12-01 |
| `Microsoft.Compute/virtualMachineScaleSets/extensions` | 2020-06-01 |
| `Microsoft.Compute/virtualMachineScaleSets/providers/diagnosticSettings` | 2017-05-01-preview |
| `Microsoft.Compute/virtualMachineScaleSets/providers/roleAssignments` | 2018-09-01-preview |
| `Microsoft.Compute/virtualMachineScaleSets` | 2020-06-01 |
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `providers/locks` | 2016-09-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.
- VirtualNetwork

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `additionalUnattendContent` | array | Optional. Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. - AdditionalUnattendContent object | System.Object[] |  |
| `adminPassword` | securestring | Required. When specifying a Windows Virtual Machine, this value should be passed |  |  |
| `adminUsername` | securestring | Required. Administrator username |  |  |
| `automaticRepairsPolicyEnabled` | bool | Optional. Specifies whether automatic repairs should be enabled on the virtual machine scale set. | False |  |
| `availabilityZones` | array | Optional. The virtual machine scale set zones. NOTE: Availability zones can only be set when you create the scale set. | System.Object[] |  |
| `baseTime` | string | Generated. Do not provide a value! This date value is used to generate a registration token. | [utcNow('u')] |  |
| `bootDiagnosticStorageAccountName` | string | Optional. Storage account used to store boot diagnostic information. Boot diagnostics will be disabled if no value is provided. |  |  |
| `bootDiagnosticStorageAccountUri` | string | Optional. Storage account boot diagnostic base URI. |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `customData` | string | Optional. Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format. |  |  |
| `dataDisks` | array | Optional. Specifies the data disks. | System.Object[] |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `disableAutomaticRollback` | bool | Optional. Whether OS image rollback feature should be disabled. | False |  |
| `disablePasswordAuthentication` | bool | Optional. Specifies whether password authentication should be disabled. | False |  |
| `diskEncryptionVolumeType` | string | Optional. Type of the volume OS or Data to perform encryption operation | All | System.Object[] |
| `diskKeyEncryptionAlgorithm` | string | Optional. Specifies disk key encryption algorithm. | RSA-OAEP | System.Object[] |
| `domainJoinOptions` | int | Optional. Set of bit flags that define the join options. Default value of 3 is a combination of NETSETUP_JOIN_DOMAIN (0x00000001) & NETSETUP_ACCT_CREATE (0x00000002) i.e. will join the domain and create the account on the domain. For more information see https://msdn.microsoft.com/en-us/library/aa392154(v=vs.85).aspx | 3 |  |
| `domainJoinOU` | string | Optional. Specifies an organizational unit (OU) for the domain account. Enter the full distinguished name of the OU in quotation marks. Example: "OU=testOU; DC=domain; DC=Domain; DC=com" |  |  |
| `domainJoinPassword` | securestring | Optional. Required if domainName is specified. Password of the user specified in domainJoinUser parameter |  |  |
| `domainJoinRestart` | bool | Optional. Controls the restart of vm after executing domain join | False |  |
| `domainJoinUser` | string | Optional. Mandatory if domainName is specified. User used for the join to the domain. Format: username@domainFQDN |  |  |
| `domainName` | string | Optional. Specifies the FQDN the of the domain the VM will be joined to. Currently implemented for Windows VMs only |  |  |
| `doNotRunExtensionsOnOverprovisionedVMs` | bool | Optional. When Overprovision is enabled, extensions are launched only on the requested number of VMs which are finally kept. This property will hence ensure that the extensions do not run on the extra overprovisioned VMs. | False |  |
| `dscConfiguration` | object | Optional. The DSC configuration object |  |  |
| `enableAutomaticOSUpgrade` | bool | Optional. Indicates whether OS upgrades should automatically be applied to scale set instances in a rolling fashion when a newer version of the OS image becomes available. Default value is false. If this is set to true for Windows based scale sets, enableAutomaticUpdates is automatically set to false and cannot be set to true. | False |  |
| `enableAutomaticUpdates` | bool | Optional. Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning. | True |  |
| `enableEvictionPolicy` | bool | Optional. Specifies the eviction policy for the low priority virtual machine. Will result in 'Deallocate' eviction policy. | False |  |
| `enableLinuxDependencyAgent` | bool | Optional. Specifies if Azure Dependency Agent for Linux VM should be enabled. Requires LinuxMMAAgent to be enabled. | False |  |
| `enableLinuxDiskEncryption` | bool | Optional. Specifies if Linux VM disks should be encrypted. If enabled, boot diagnostics must be enabled as well. | False |  |
| `enableLinuxMMAAgent` | bool | Optional. Specifies if MMA agent for Linux VM should be enabled. | False |  |
| `enableMicrosoftAntiMalware` | bool | Optional. Enables Microsoft Windows Defender AV. | False |  |
| `enableNetworkWatcherLinux` | bool | Optional. Specifies if Azure Network Watcher Agent for Linux VM should be enabled. | False |  |
| `enableNetworkWatcherWindows` | bool | Optional. Specifies if Azure Network Watcher Agent for Windows VM should be enabled. | False |  |
| `enableServerSideEncryption` | bool | Optional. Specifies if Windows VM disks should be encrypted with Server-side encryption + Customer managed Key. | False |  |
| `enableWindowsDependencyAgent` | bool | Optional. Specifies if Azure Dependency Agent for Windows VM should be enabled. Requires WindowsMMAAgent to be enabled. | False |  |
| `enableWindowsDiskEncryption` | bool | Optional. Specifies if Windows VM disks should be encrypted. If enabled, boot diagnostics must be enabled as well. | False |  |
| `enableWindowsMMAAgent` | bool | Optional. Specifies if MMA agent for Windows VM should be enabled. | False |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `forceUpdateTag` | string | Optional. Pass in an unique value like a GUID everytime the operation needs to be force run | 1.0 |  |
| `gracePeriod` | string | Optional. The amount of time for which automatic repairs are suspended due to a state change on VM. The grace time starts after the state change has completed. This helps avoid premature or accidental repairs. The time duration should be specified in ISO 8601 format. The minimum allowed grace period is 30 minutes (PT30M). The maximum allowed grace period is 90 minutes (PT90M). | PT30M |  |
| `imageReference` | object | Optional. OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image. |  |  |
| `instanceCount` | string | Optional. The initial instance count of scale set VMs. | 1 |  |
| `instanceSize` | string | Optional. The SKU size of the VMs. |  |  |
| `keyEncryptionKeyURL` | string | Optional. URL of the KeyEncryptionKey used to encrypt the volume encryption key |  |  |
| `keyVaultId` | string | Optional. Resource identifier of the Key Vault instance where the Key Encryption Key (KEK) resides |  |  |
| `keyVaultUri` | string | Optional. URL of the Key Vault instance where the Key Encryption Key (KEK) resides |  |  |
| `licenseType` | string | Optional. Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system. |  | System.Object[] |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock VM from deletion. | False |  |
| `maxBatchInstancePercent` | int | Optional. The maximum percent of total virtual machine instances that will be upgraded simultaneously by the rolling upgrade in one batch. As this is a maximum, unhealthy instances in previous or future batches can cause the percentage of instances in a batch to decrease to ensure higher reliability. | 20 |  |
| `maxPriceForLowPriorityVm` | string | Optional. Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars. |  |  |
| `maxUnhealthyInstancePercent` | int | Optional. The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch | 20 |  |
| `maxUnhealthyUpgradedInstancePercent` | int | Optional. The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch. | 20 |  |
| `microsoftAntiMalwareSettings` | object | Optional. Settings for Microsoft Windows Defender AV extension. |  |  |
| `nicConfigurations` | array | Required. Configures NICs and PIPs. | System.Object[] |  |
| `osDisk` | object | Required. Specifies the OS disk. |  |  |
| `osType` | string | Optional. The chosen OS type |  | System.Object[] |
| `overprovision` | bool | Optional. Specifies whether the Virtual Machine Scale Set should be overprovisioned. | False |  |
| `pauseTimeBetweenBatches` | string | Optional. The wait time between completing the update for all virtual machines in one batch and starting the next batch. The time duration should be specified in ISO 8601 format | PT0S |  |
| `plan` | object | Optional. Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use. |  |  |
| `provisionVMAgent` | bool | Optional. Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later. | True |  |
| `proximityPlacementGroupName` | string | Optional. Creates an proximity placement group and adds the VMs to it. |  |  |
| `proximityPlacementGroupType` | string | Optional. Specifies the type of the proximity placement group. | Standard | System.Object[] |
| `publicKeys` | array | Optional. The list of SSH public keys used to authenticate with linux based VMs | System.Object[] |  |
| `resizeOSDisk` | bool | Optional. Should the OS partition be resized to occupy full OS VHD before splitting system volume | False |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `sasTokenValidityLength` | string | Optional. SAS token validity length to use to download files from storage accounts. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours. | PT8H |  |
| `scaleInPolicy` | object | Optional. Specifies the scale-in policy that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled-in |  |  |
| `scaleSetFaultDomain` | int | Optional. Fault Domain count for each placement group. | 2 |  |
| `scheduledEventsProfile` | object | Optional. Specifies Scheduled Event related configurations |  |  |
| `secrets` | array | Optional. Specifies set of certificates that should be installed onto the virtual machines in the scale set. | System.Object[] |  |
| `singlePlacementGroup` | bool | Optional. When true this limits the scale set to a single placement group, of max size 100 virtual machines. NOTE: If singlePlacementGroup is true, it may be modified to false. However, if singlePlacementGroup is false, it may not be modified to true. | True |  |
| `tags` | object | Optional. Tags of the resource. |  |  |
| `timeZone` | string | Optional. Specifies the time zone of the virtual machine. e.g. 'Pacific Standard Time'. Possible values can be TimeZoneInfo.Id value from time zones returned by TimeZoneInfo.GetSystemTimeZones. |  |  |
| `ultraSSDEnabled` | bool | Optional. The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled. | False |  |
| `upgradePolicyMode` | string | Optional. Specifies the mode of an upgrade to virtual machines in the scale set.' Manual - You control the application of updates to virtual machines in the scale set. You do this by using the manualUpgrade action. ; Automatic - All virtual machines in the scale set are automatically updated at the same time. - Automatic, Manual, Rolling | Manual | System.Object[] |
| `vmNamePrefix` | string | Optional. Specifies the computer name prefix for all of the virtual machines in the scale set. | vmssvm |  |
| `vmPriority` | string | Optional. Specifies the priority for the virtual machine. | Regular | System.Object[] |
| `vmssName` | string | Optional. Name of the VMSS. |  |  |
| `windowsScriptExtensionCommandToExecute` | securestring | Optional. Specifies the command that should be run on a Windows VM. |  |  |
| `windowsScriptExtensionFileData` | array | Optional. Array of objects that specifies URIs and the storageAccountId of the scripts that need to be downloaded and run by the Custom Script Extension on a Windows VM. | System.Object[] |  |
| `cseStorageAccountName` | string | Optional. The name of the storage account to fetch to blob data from | | |
| `cseStorageAccountKey` | string |  Optional. The key of the storage account to fetch the FileData blobs from | | |
| `cseManagedIdentity` | string | Optional. The managed identity to use to fetch the blob data. | | |
| `winRMListeners` | object | Optional. Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object. |  |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |
| `zoneBalance` | bool | Optional. Whether to force strictly even Virtual Machine distribution cross x-zones in case there is zone outage. | False |  |
| `managedIdentityType` | string | Optional. The type of identity used for the virtual machine scale set. The type 'SystemAssigned, UserAssigned' includes both an implicitly created identity and a set of user assigned identities. The type 'None' will remove any identities from the virtual machine scale set. - SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, None | | |
| `managedIdentityIdentities`| object | Optional. The list of user identities associated with the virtual machine scale set. The user identity dictionary key references will be ARM resource ids in the form: `'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'`. | | |

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

### Parameter Usage: `microsoftAntiMalwareSettings`

```json
"microsoftAntiMalwareSettings": {
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
```

### Parameter Usage: `publicKeys`

```json
"publicKeys": {
    "value": [
        {
            "path": "/home/scaleSetAdmin/.ssh/authorized_keys",
            "keyData": "ssh-rsa AAAAB3NzaC1yc2FAAAADAQABAAABgQDdOir5eO28EBwxU0Dyra7g9h0HUXDyMNFp2z8PhaTUQgHjrimkMxjYRwEOG/lxnYL7+TqZk+HcPTfbZOunHBw0Wx2CITzILt6531vmIYZGfq5YyYXbxZa5MON7L/PVivoRlPj5Z/g4RhqMhyfR7EPcZ516LJ8lXPTo8dE/bkOCS+kFBEYHvPEEKAyLs19sRcK37SeHjpX04zdg62nqtuRr00Tp7oeiTXA1xn5K5mxeAswotmd8CU0lWUcJuPBWQedo649b+L2cm52kTncOBI6YChAeyEc1PDF0Tn9FmpdOWKtI9efh+S3f8qkcVEtSTXKTeroBd31nzjAunMrZeM8Ut6dre+XeQQIjT7I8oEm+ZkIuItq0x2fls8JXP2YJDWDqu8v1+yLGTQ3Z9XVt2lMti/7bIgYxS0JvwOr7n5L4IzKvhb4fm21LLDGFa3o7Nsfe3fPb882APE0bLFCmfyIeiPh7go70WqZHakpgIr6LCWTyePez9CsI/rfWDb6eAM8= generated-by-azure"
        }
    ]
}
```


### Paramter Usage `nicConfigurations`
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
                            "id": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/agents-vmss-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-scaleset/subnets/sxx-az-subnet-weu-scaleset-linux"
                        }
                    }
                }
            ]
        }
    ]
}
```

### Parameter Usage: `windowsScriptExtensionFileData`

```json
"windowsScriptExtensionFileData": {
    "value": [
        //storage accounts with SAS token requirement
        {
            "uri": "https://storageAccount.blob.core.windows.net/wvdscripts/File1.ps1",
            "storageAccountId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName"
        },
        {
            "uri": "https://storageAccount.blob.core.windows.net/wvdscripts/File2.ps1",
            "storageAccountId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName"
        },
        //storage account with public container (no SAS token is required) OR other public URL (not a storage account)
        {
            "uri": "https://github.com/myProject/File3.ps1"
        }
    ]
}
```

### Parameter Usage: `windowsScriptExtensionFileData` with native storage account key support

```json
"windowsScriptExtensionFileData": {
    "value": [
        {
            "https://mystorageaccount.blob.core.windows.net/wvdscripts/testscript.ps1"
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

### Parameter Usage: `dscConfiguration`

```json
"dscConfiguration": {
    "value": {
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
| `vmssName` | string | The Names of the VMSS |
| `vmssResourceGroup` | string | The name of the Resource Group the VMSS was/were created in. |
| `vmssResourceIds` | string | The Resource Id of the VMSS. |

## Considerations


## Additional resources

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [ProximityPlacementGroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2019-12-01/ProximityPlacementGroups)
- [VirtualMachineScaleSets](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2020-06-01/virtualMachineScaleSets)