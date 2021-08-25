# Virtual Machines

This module deploys one or multiple Virtual Machines.


## Resource types

|Resource Type|ApiVersion|
|:--|:--|
| `Microsoft.Compute/availabilitySets` | 2020-12-01 |
| `Microsoft.Compute/proximityPlacementGroups` | 2020-12-01 |
| `Microsoft.Resources/deployments` | 2020-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `adminPassword` | securestring |  |  | Required. When specifying a Windows Virtual Machine, this value should be passed |
| `adminUsername` | securestring |  |  | Required. Administrator username |
| `allowExtensionOperations` | bool | True |  | Optional. Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine. |
| `availabilitySetFaultDomain` | int | 2 |  | Optional. The number of fault domains to use. |
| `availabilitySetName` | string |  |  | Optional. Creates an availability set with the given name and adds the VMs to it. Cannot be used in combination with availability zone nor scale set. |
| `availabilitySetNames` | array | System.Object[] |  | Optional. Name(s) of the availability set(s). If no explicit names are provided, availability set name(s) will be generated based on the availabilitySetName, vmNumberOfInstances and maxNumberOfVmsPerAvSet parameters. |
| `availabilitySetSku` | string | Aligned |  | Optional. Sku of the availability set. Use 'Aligned' for virtual machines with managed disks and 'Classic' for virtual machines with unmanaged disks. |    
| `availabilitySetUpdateDomain` | int | 5 |  | Optional. The number of update domains to use. |
| `availabilityZone` | int | 0 | System.Object[] | Optional. If set to 1, 2 or 3, the availability zone for all VMs is hardcoded to that value. If zero, then the automatic algorithm will be used to give every VM in a different zone (up to three zones). Cannot be used in combination with availability set nor scale set. |
| `backupPolicyName` | string | DefaultPolicy |  | Optional. Backup policy the VMs should be using for backup. |
| `backupVaultName` | string |  |  | Optional. Recovery service vault name to add VMs to backup. |
| `backupVaultResourceGroup` | string |  |  | Optional. Resource group of the backup recovery service vault. |
| `baseTime` | string | [utcNow('u')] |  | Generated. Do not provide a value! This date value is used to generate a registration token. |
| `bootDiagnosticStorageAccountName` | string |  |  | Optional. Storage account used to store boot diagnostic information. Boot diagnostics will be disabled if no value is provided. |
| `bootDiagnosticStorageAccountUri` | string | .blob.core.windows.net/ |  | Optional. Storage account boot diagnostic base URI. |
| `certificatesToBeInstalled` | array | System.Object[] |  | Optional. Specifies set of certificates that should be installed onto the virtual machine. |
| `cseManagedIdentity` | object |  |  | Optional. A managed identity to use for the CSE. |
| `cseStorageAccountKey` | string |  |  | Optional. The storage key of the storage account to access for the CSE script(s). |
| `cseStorageAccountName` | string |  |  | Optional. The name of the storage account to access for the CSE script(s). |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `customData` | string |  |  | Optional. Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format. |
| `dataDisks` | array | System.Object[] |  | Optional. Specifies the data disks. |
| `dedicatedHostId` | string |  |  | Optional. Specifies resource Id about the dedicated host that the virtual machine resides in. |
| `diagnosticLogsRetentionInDays` | int | 365 |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticSettingName` | string | service |  | Optional. The name of the Diagnostic setting. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `diskEncryptionVolumeType` | string | All | System.Object[] | Optional. Type of the volume OS or Data to perform encryption operation |
| `diskKeyEncryptionAlgorithm` | string | RSA-OAEP | System.Object[] | Optional. Specifies disk key encryption algorithm. |
| `domainJoinOptions` | int | 3 |  | Optional. Set of bit flags that define the join options. Default value of 3 is a combination of NETSETUP_JOIN_DOMAIN (0x00000001) & NETSETUP_ACCT_CREATE (0x00000002) i.e. will join the domain and create the account on the domain. For more information see https://msdn.microsoft.com/en-us/library/aa392154(v=vs.85).aspx |
| `domainJoinOU` | string |  |  | Optional. Specifies an organizational unit (OU) for the domain account. Enter the full distinguished name of the OU in quotation marks. Example: "OU=testOU; DC=domain; DC=Domain; DC=com" |
| `domainJoinPassword` | securestring |  |  | Optional. Required if domainName is specified. Password of the user specified in domainJoinUser parameter |
| `domainJoinRestart` | bool | False |  | Optional. Controls the restart of vm after executing domain join |
| `domainJoinUser` | string |  |  | Optional. Mandatory if domainName is specified. User used for the join to the domain. Format: username@domainFQDN |
| `domainName` | string |  |  | Optional. Specifies the FQDN the of the domain the VM will be joined to. Currently implemented for Windows VMs only |
| `dscConfiguration` | object |  |  | Optional. The DSC configuration object |
| `enableEvictionPolicy` | bool | False |  | Optional. Specifies the eviction policy for the low priority virtual machine. Will result in 'Deallocate' eviction policy. |
| `enableLinuxDependencyAgent` | bool | False |  | Optional. Specifies if Azure Dependency Agent for Linux VM should be enabled. Requires LinuxMMAAgent to be enabled. |
| `enableLinuxDiskEncryption` | bool | False |  | Optional. Specifies if Linux VM disks should be encrypted. If enabled, boot diagnostics must be enabled as well. |
| `enableLinuxMMAAgent` | bool | False |  | Optional. Specifies if MMA agent for Linux VM should be enabled. |
| `enableMicrosoftAntiMalware` | bool | False |  | Optional. Enables Microsoft Windows Defender AV. |
| `enableNetworkWatcherLinux` | bool | False |  | Optional. Specifies if Azure Network Watcher Agent for Linux VM should be enabled. |
| `enableNetworkWatcherWindows` | bool | False |  | Optional. Specifies if Azure Network Watcher Agent for Windows VM should be enabled. |
| `enableServerSideEncryption` | bool | False |  | Optional. Specifies if Windows VM disks should be encrypted with Server-side encryption + Customer managed Key. |
| `enableWindowsDependencyAgent` | bool | False |  | Optional. Specifies if Azure Dependency Agent for Windows VM should be enabled. Requires WindowsMMAAgent to be enabled. |
| `enableWindowsDiskEncryption` | bool | False |  | Optional. Specifies if Windows VM disks should be encrypted. If enabled, boot diagnostics must be enabled as well. |
| `enableWindowsMMAAgent` | bool | False |  | Optional. Specifies if MMA agent for Windows VM should be enabled. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `forceUpdateTag` | string | 1.0 |  | Optional. Pass in an unique value like a GUID everytime the operation needs to be force run |
| `imageReference` | object |  |  | Optional. OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image. |
| `keyEncryptionKeyURL` | string |  |  | Optional. URL of the KeyEncryptionKey used to encrypt the volume encryption key |
| `keyVaultId` | string |  |  | Optional. Resource identifier of the Key Vault instance where the Key Encryption Key (KEK) resides |
| `keyVaultUri` | string |  |  | Optional. URL of the Key Vault instance where the Key Encryption Key (KEK) resides |
| `licenseType` | string |  | System.Object[] | Optional. Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system. |
| `linuxConfiguration` | object |  |  | Optional. Specifies the Linux operating system settings on the virtual machine. |
| `location` | string | [resourceGroup().location] |  | Optional. Location for all resources. |
| `managedServiceIdentity` | string | None | None, SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, UserAssigned, SystemAssigned | Optional. The type of identity used for the virtual machine. The type 'SystemAssigned, UserAssigned' includes both an implicitly created identity and a set of user assigned identities. The type 'None' (default) will remove any identities from the virtual machine. |
| `lockForDeletion` | bool | False |  | Optional. Switch to lock VM from deletion. |
| `maxNumberOfVmsPerAvSet` | int | 200 |  | Optional. The maximum number of VMs allowed in an availability set. The template will create additional availability sets if the number of VMs to be deployed exceeds this quota. |
| `maxNumberOfVmsPerDeployment` | int | 50 |  | Optional. The maximum number of VMs allowed in a single deployment. The template will create additional deployments if the number of VMs to be deployed exceeds this quota. |
| `maxPriceForLowPriorityVm` | string |  |  | Optional. Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars. |
| `microsoftAntiMalwareSettings` | object |  |  | Optional. Settings for Microsoft Windows Defender AV extension. |
| `nicConfigurations` | array |  |  | Required. Configures NICs and PIPs. |
| `osDisk` | object |  |  | Required. Specifies the OS disk. |
| `plan` | object |  |  | Optional. Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use. |
| `proximityPlacementGroupName` | string |  |  | Optional. Creates an proximity placement group and adds the VMs to it. |
| `proximityPlacementGroupType` | string | Standard | System.Object[] | Optional. Specifies the type of the proximity placement group. |
| `resizeOSDisk` | bool | False |  | Optional. Should the OS partition be resized to occupy full OS VHD before splitting system volume |
| `roleAssignments` | array | System.Object[] |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sasTokenValidityLength` | string | PT8H |  | Optional. SAS token validity length to use to download files from storage accounts. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours. |
| `tags` | object |  |  | Optional. Tags of the resource. |
| `ultraSSDEnabled` | bool | False |  | Optional. The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled. |
| `useAvailabilityZone` | bool | False |  | Optional. Creates an availability zone and adds the VMs to it. Cannot be used in combination with availability set nor scale set. |
| `userAssignedIdentities` | object |  |  | Optional. Mandatory if 'managedServiceIdentity' contains 'UserAssigned'. The list of user identities associated with the Virtual Machine. |
| `vmComputerNames` | object |  |  | Optional. Specifies the VM computer names for the VMs. If the VM name is not in the object as key the VM name is used as computer name. Be aware of the maximum size of 15 characters and limitations regarding special characters for the computer name. Once set it can't be changed via template. |
| `vmComputerNamesTransformation` | string | none |  | Optional. Specifies whether the computer names should be transformed. The transformation is performed on all computer names. Available transformations are 'none' (Default), 'uppercase' and 'lowercase'. |
| `vmInitialNumber` | int | 1 |  | Optional. If no explicit values were provided in the vmNames parameter, this parameter will be used to generate VM names, using the vmNamePrefix and the vmNumberOfInstances values. |
| `vmNamePrefix` | string | [take(toLower(uniqueString(resourceGroup().name)),10)] |  | Optional. If no explicit values were provided in the vmNames parameter, this prefix will be used in combination with the vmNumberOfInstances and the vmInitialNumber parameters to create unique VM names. You should use a unique prefix to reduce name collisions in Active Directory. If no value is provided, a 10 character long unique string will be generated based on the Resource Group's name. |
| `vmNames` | array | System.Object[] |  | Optional. Name(s) of the virtual machine(s). If no explicit names are provided, VM name(s) will be generated based on the vmNamePrefix, vmNumberOfInstances and vmInitialNumber parameters. |
| `vmNumberOfInstances` | int | 1 |  | Optional. If no explicit values were provided in the vmNames parameter, this parameter will be used to generate VM names, using the vmNamePrefix and the vmInitialNumber values. |
| `vmPriority` | string | Regular | System.Object[] | Optional. Specifies the priority for the virtual machine. |
| `vmSize` | string | Standard_D2s_v3 |  | Optional. Specifies the size for the VMs |
| `windowsConfiguration` | object |  |  | Optional. Specifies Windows operating system settings on the virtual machine. |
| `windowsScriptExtensionCommandToExecute` | securestring |  |  | Optional. Specifies the command that should be run on a Windows VM. |
| `windowsScriptExtensionFileData` | array | System.Object[] |  | Optional. Array of objects that specifies URIs and the storageAccountId of the scripts that need to be downloaded and run by the Custom Script Extension on a Windows VM. |
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
"value": [{
    "nicSuffix": "-nic-01",
    "enableIPForwarding": false,
    "enableAcceleratedNetworking": false,
    "dnsServers": [
        "8.8.8.8"
    ],
    "ipConfigurations": [{
            "name": "ipconfig1",
            "vmIPAddress": "",
            "subnetId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Network/virtualNetworks/vnetName/subnets/subnetName",
            "enablePublicIP": true,
            "publicIpNameSuffix": "-pip-01",
            "publicIPPrefixId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Network/publicIPPrefixes/pippfx-europe",
            "loadBalancerBackendAddressPools": "",
            "applicationSecurityGroups": ""
        },
        {
            "name": "ipconfig2",
            "vmIPAddress": "",
            "subnetId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Network/virtualNetworks/vnetName/subnets/subnetName",
            "enablePublicIP": false,
            "publicIpNameSuffix": "",
            "loadBalancerBackendAddressPools": "",
            "applicationSecurityGroups": ""
        }
    ]
},
{
    "nicSuffix": "-nic-02",
    "enableIPForwarding": false,
    "enableAcceleratedNetworking": false,
    "dnsServers": [
        "8.8.8.8"
    ],
    "ipConfigurations": [{
        "name": "ipconfig1",
        "vmIPAddress": "",
        "subnetId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Network/virtualNetworks/vnetName/subnets/subnetName",
        "enablePublicIP": true,
        "publicIpNameSuffix": "-pip-02",
        "loadBalancerBackendPoolId": "",
        "applicationSecurityGroupId": ""
    }]
}
]

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
            "uri": "https://github.com/myProject/File3.ps1",
            "storageAccountId": ""
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
| `deploymentCount` | int | The number of VM deployments. |
| `virtualMachinesName` | array | The Names of the VMs. |
| `virtualMachinesResourceGroup` | string | The name of the Resource Group the VM(s) was/were created in. |
| `virtualMachinesResourceId` | array | The Resource Id(s) of the VM(s). |

## Considerations

**NOTE**: Since some time in the beginning of _2021_, [new limits regarding deployment sizes](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/error-job-size-exceeded) were put into place and restrict the number of VMs you can deploy with this module.
Tests that deployed only VMs with only one NIC each, without any extra resources such as DataDisks, public IPs or VM extensions, showed the maximum number of VMs you can deploy is about **`700`**. However, this number may be less depending on the amount of additional resources you want to deploy in one go.
The reason for this restriction is twofold:
- One the one hand, the deployment is restrictd by a limitation of the storage table used by the resource manager to store deployment-metadata in. This forces us to split the deployments into smaller chunks to archieve higher numbers. The metadata is a blackbox we're unable to influence for the most part and results into an `InternalSystemLimitations` error if exceeded.
- The second restriction is the `800` deployments per resource group limit. Cutting the deployments into chunks allows a large number of deployments to run concurrently, but as a side-effect the deployment-garbage-collection automatic deletions aren't processed fast enough to reduce the total number.

## Additional resources

- [Overview of Windows virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/overview)
- [Microsoft.Compute virtualMachines template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/allversions)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [PowerShell DSC Extension](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-windows#extension-schema)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [Azure Resource Manager template reference](https://docs.microsoft.com/en-us/azure/templates/)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [ProximityPlacementGroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2020-12-01/proximityPlacementGroups)
- [Availability Sets](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2020-12-01/availabilitySets)
- [Deployment Quota Exceeded](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-quota-exceeded)