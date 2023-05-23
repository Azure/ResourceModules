# Virtual Machine Scale Sets `[Microsoft.Compute/virtualMachineScaleSets]`

This module deploys a virtual machine scale set.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Compute/virtualMachineScaleSets` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachineScaleSets) |
| `Microsoft.Compute/virtualMachineScaleSets/extensions` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachineScaleSets/extensions) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

### Resource dependency

The following resources are required to be able to deploy this resource.

- `Microsoft.Network/VirtualNetwork`

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `adminUsername` | securestring |  | Administrator username. |
| `imageReference` | object |  | OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image. |
| `name` | string |  | Name of the VMSS. |
| `nicConfigurations` | array |  | Configures NICs and PIPs. |
| `osDisk` | object |  | Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets. |
| `osType` | string | `[Linux, Windows]` | The chosen OS type. |
| `skuName` | string |  | The SKU size of the VMs. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `additionalUnattendContent` | array | `[]` |  | Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. - AdditionalUnattendContent object. |
| `adminPassword` | securestring | `''` |  | When specifying a Windows Virtual Machine, this value should be passed. |
| `automaticRepairsPolicyEnabled` | bool | `False` |  | Specifies whether automatic repairs should be enabled on the virtual machine scale set. |
| `availabilityZones` | array | `[]` |  | The virtual machine scale set zones. NOTE: Availability zones can only be set when you create the scale set. |
| `bootDiagnosticStorageAccountName` | string | `''` |  | Storage account used to store boot diagnostic information. Boot diagnostics will be disabled if no value is provided. |
| `bootDiagnosticStorageAccountUri` | string | `[format('.blob.{0}/', environment().suffixes.storage)]` |  | Storage account boot diagnostic base URI. |
| `customData` | string | `''` |  | Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format. |
| `dataDisks` | array | `[]` |  | Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `disableAutomaticRollback` | bool | `False` |  | Whether OS image rollback feature should be disabled. |
| `disablePasswordAuthentication` | bool | `False` |  | Specifies whether password authentication should be disabled. |
| `doNotRunExtensionsOnOverprovisionedVMs` | bool | `False` |  | When Overprovision is enabled, extensions are launched only on the requested number of VMs which are finally kept. This property will hence ensure that the extensions do not run on the extra overprovisioned VMs. |
| `enableAutomaticOSUpgrade` | bool | `False` |  | Indicates whether OS upgrades should automatically be applied to scale set instances in a rolling fashion when a newer version of the OS image becomes available. Default value is false. If this is set to true for Windows based scale sets, enableAutomaticUpdates is automatically set to false and cannot be set to true. |
| `enableAutomaticUpdates` | bool | `True` |  | Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableEvictionPolicy` | bool | `False` |  | Specifies the eviction policy for the low priority virtual machine. Will result in 'Deallocate' eviction policy. |
| `encryptionAtHost` | bool | `True` |  | This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your virtual machine scale sets. |
| `extensionAntiMalwareConfig` | object | `{object}` |  | The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionAzureDiskEncryptionConfig` | object | `{object}` |  | The configuration for the [Azure Disk Encryption] extension. Must at least contain the ["enabled": true] property to be executed. Restrictions: Cannot be enabled on disks that have encryption at host enabled. Managed disks encrypted using Azure Disk Encryption cannot be encrypted using customer-managed keys. |
| `extensionCustomScriptConfig` | object | `{object}` |  | The configuration for the [Custom Script] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionDependencyAgentConfig` | object | `{object}` |  | The configuration for the [Dependency Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionDomainJoinConfig` | object | `{object}` |  | The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionDomainJoinPassword` | securestring | `''` |  | Required if name is specified. Password of the user specified in user parameter. |
| `extensionDSCConfig` | object | `{object}` |  | The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionMonitoringAgentConfig` | object | `{object}` |  | The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionNetworkWatcherAgentConfig` | object | `{object}` |  | The configuration for the [Network Watcher Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| `gracePeriod` | string | `'PT30M'` |  | The amount of time for which automatic repairs are suspended due to a state change on VM. The grace time starts after the state change has completed. This helps avoid premature or accidental repairs. The time duration should be specified in ISO 8601 format. The minimum allowed grace period is 30 minutes (PT30M). The maximum allowed grace period is 90 minutes (PT90M). |
| `licenseType` | string | `''` | `['', Windows_Client, Windows_Server]` | Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `maxBatchInstancePercent` | int | `20` |  | The maximum percent of total virtual machine instances that will be upgraded simultaneously by the rolling upgrade in one batch. As this is a maximum, unhealthy instances in previous or future batches can cause the percentage of instances in a batch to decrease to ensure higher reliability. |
| `maxPriceForLowPriorityVm` | string | `''` |  | Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars. |
| `maxUnhealthyInstancePercent` | int | `20` |  | The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch. |
| `maxUnhealthyUpgradedInstancePercent` | int | `20` |  | The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch. |
| `monitoringWorkspaceId` | string | `''` |  | Resource ID of the monitoring log analytics workspace. |
| `overprovision` | bool | `False` |  | Specifies whether the Virtual Machine Scale Set should be overprovisioned. |
| `pauseTimeBetweenBatches` | string | `'PT0S'` |  | The wait time between completing the update for all virtual machines in one batch and starting the next batch. The time duration should be specified in ISO 8601 format. |
| `plan` | object | `{object}` |  | Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use. |
| `provisionVMAgent` | bool | `True` |  | Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later. |
| `proximityPlacementGroupResourceId` | string | `''` |  | Resource ID of a proximity placement group. |
| `publicIpDiagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `publicKeys` | array | `[]` |  | The list of SSH public keys used to authenticate with linux based VMs. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sasTokenValidityLength` | string | `'PT8H'` |  | SAS token validity length to use to download files from storage accounts. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours. |
| `scaleInPolicy` | object | `{object}` |  | Specifies the scale-in policy that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled-in. |
| `scaleSetFaultDomain` | int | `2` |  | Fault Domain count for each placement group. |
| `scheduledEventsProfile` | object | `{object}` |  | Specifies Scheduled Event related configurations. |
| `secrets` | array | `[]` |  | Specifies set of certificates that should be installed onto the virtual machines in the scale set. |
| `secureBootEnabled` | bool | `False` |  | Specifies whether secure boot should be enabled on the virtual machine scale set. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| `securityType` | string | `''` |  | Specifies the SecurityType of the virtual machine scale set. It is set as TrustedLaunch to enable UefiSettings. |
| `singlePlacementGroup` | bool | `True` |  | When true this limits the scale set to a single placement group, of max size 100 virtual machines. NOTE: If singlePlacementGroup is true, it may be modified to false. However, if singlePlacementGroup is false, it may not be modified to true. |
| `skuCapacity` | int | `1` |  | The initial instance count of scale set VMs. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `timeZone` | string | `''` |  | Specifies the time zone of the virtual machine. e.g. 'Pacific Standard Time'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`. |
| `ultraSSDEnabled` | bool | `False` |  | The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled. |
| `upgradePolicyMode` | string | `'Manual'` | `[Automatic, Manual, Rolling]` | Specifies the mode of an upgrade to virtual machines in the scale set.' Manual - You control the application of updates to virtual machines in the scale set. You do this by using the manualUpgrade action. ; Automatic - All virtual machines in the scale set are automatically updated at the same time. - Automatic, Manual, Rolling. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `vmNamePrefix` | string | `'vmssvm'` |  | Specifies the computer name prefix for all of the virtual machines in the scale set. |
| `vmPriority` | string | `'Regular'` | `[Low, Regular, Spot]` | Specifies the priority for the virtual machine. |
| `vTpmEnabled` | bool | `False` |  | Specifies whether vTPM should be enabled on the virtual machine scale set. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| `winRM` | object | `{object}` |  | Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object. |
| `zoneBalance` | bool | `False` |  | Whether to force strictly even Virtual Machine distribution cross x-zones in case there is zone outage. |

**Generated parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `baseTime` | string | `[utcNow('u')]` | Do not provide a value! This date value is used to generate a registration token. |


#### Marketplace images

<details>

<summary>Parameter JSON format</summary>

```json
"imageReference": {
    "value": {
        "publisher": "MicrosoftWindowsServer",
        "offer": "WindowsServer",
        "sku": "2022-datacenter-azure-edition",
        "version": "latest"
    }
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
imageReference: {
    publisher: 'MicrosoftWindowsServer'
    offer: 'WindowsServer'
    sku: '2022-datacenter-azure-edition'
    version: 'latest'
}
```

</details>

#### Custom images

<details>

<summary>Parameter JSON format</summary>

```json
"imageReference": {
    "value": {
        "id": "/subscriptions/12345-6789-1011-1213-15161718/resourceGroups/rg-name/providers/Microsoft.Compute/images/imagename"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
imageReference: {
    id: '/subscriptions/12345-6789-1011-1213-15161718/resourceGroups/rg-name/providers/Microsoft.Compute/images/imagename'
}
```

</details>
<p>

### Parameter Usage: `plan`

<details>

<summary>Parameter JSON format</summary>

```json
"plan": {
    "value": {
        "name": "qvsa-25",
        "product": "qualys-virtual-scanner",
        "publisher": "qualysguard"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
plan: {
    name: 'qvsa-25'
    product: 'qualys-virtual-scanner'
    publisher: 'qualysguard'
}
```

</details>
<p>

### Parameter Usage: `osDisk`

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
osDisk: {
    createOption: 'fromImage'
    diskSizeGB: '128'
    managedDisk: {
        storageAccountType: 'Premium_LRS'
        diskEncryptionSet: { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.
            id: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>'
        }
    }
}
```

</details>
<p>

### Parameter Usage: `dataDisks`

<details>

<summary>Parameter JSON format</summary>

```json
"dataDisks": {
    "value": [
        {
            "caching": "ReadOnly",
            "createOption": "Empty",
            "diskSizeGB": "256",
            "writeAcceleratorEnabled": true,
            "managedDisk": {
                "storageAccountType": "Premium_LRS",
                "diskEncryptionSet": { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.
                    "id": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>"
                }
            }
        },
        {
            "caching": "ReadOnly",
            "createOption": "Empty",
            "diskSizeGB": "128",
            "writeAcceleratorEnabled": true,
            "managedDisk": {
                "storageAccountType": "Premium_LRS",
                "diskEncryptionSet": { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.
                    "id": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>"
                }
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
dataDisks: [
    {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: '256'
        writeAcceleratorEnabled: true
        managedDisk: {
            storageAccountType: 'Premium_LRS'
            diskEncryptionSet: { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.
                id: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>'
            }
        }
    }
    {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: '128'
        writeAcceleratorEnabled: true
        managedDisk: {
            storageAccountType: 'Premium_LRS'diskEncryptionSet: { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.
                id: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>'
            }
        }
    }
]
```

</details>
<p>

### Parameter Usage: `nicConfigurations`

Comments:
- The field `nicSuffix` is mandatory.
- If not disabled, `enableAcceleratedNetworking` is considered `true` by default and requires the VMSS to be deployed with a supported OS and VM size.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
nicConfigurations: [
    {
        nicSuffix: '-nic01'
        ipConfigurations: [
            {
                name: 'ipconfig1'
                properties: {
                    subnet: {
                        id: '/subscriptions/<<subscriptionId>>/resourceGroups/agents-vmss-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-scaleset/subnets/sxx-az-subnet-scaleset-linux'
                    }
                }
            }
        ]
    }
]
```

</details>
<p>

### Parameter Usage: `extensionDomainJoinConfig`

<details>

<summary>Parameter JSON format</summary>

```json
"extensionDomainJoinConfig": {
  "value": {
    "enabled": true,
    "settings": {
      "name": "contoso.com",
      "user": "test.user@testcompany.com",
      "ouPath": "OU=testOU; DC=contoso; DC=com",
      "restart": true,
      "options": 3
    }
  }
},
"extensionDomainJoinPassword": {
  "reference": {
    "keyVault": {
      "id": "/subscriptions/<<subscriptionId>/resourceGroups/myRG/providers/Microsoft.KeyVault/vaults/myKvlt"
    },
    "secretName": "domainJoinUser02-Password"
  }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionDomainJoinConfig: {
    enabled: true
    settings: {
      name: 'contoso.com'
      user: 'test.user@testcompany.com'
      ouPath: 'OU=testOU; DC=contoso; DC=com'
      restart: true
      options: 3
    }
}

resource kv1 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'adp-<<namePrefix>>-az-kv-x-001'
  scope: resourceGroup('<<subscriptionId>>','validation-rg')
}

extensionDomainJoinPassword: kv1.getSecret('domainJoinUser02-Password')
```

</details>
<p>

### Parameter Usage: `extensionNetworkWatcherAgentConfig`

<details>

<summary>Parameter JSON format</summary>

```json
"extensionNetworkWatcherAgentConfig": {
    "value": {
        "enabled": true
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionNetworkWatcherAgentConfig: {
    enabled: true
}
```

</details>
<p>

### Parameter Usage: `extensionAntiMalwareConfig`

Only for OSType Windows

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionAntiMalwareConfig: {
    enabled: true
    settings: {
        AntimalwareEnabled: true
        Exclusions: {
            Extensions: '.log;.ldf'
            Paths: 'D:\\IISlogs;D:\\DatabaseLogs'
            Processes: 'mssence.svc'
        }
        RealtimeProtectionEnabled: true
        ScheduledScanSettings: {
            isEnabled: 'true'
            scanType: 'Quick'
            day: '7'
            time: '120'
        }
    }
}
```

</details>
<p>

### Parameter Usage: `extensionAzureDiskEncryptionConfig`

<details>

<summary>Parameter JSON format</summary>

```json
"extensionAzureDiskEncryptionConfig": {
    // Restrictions: Cannot be enabled on disks that have encryption at host enabled. Managed disks encrypted using Azure Disk Encryption cannot be encrypted using customer-managed keys.
    "value": {
        "enabled": true,
        "settings": {
            "EncryptionOperation": "EnableEncryption",
            "KeyVaultURL": "https://mykeyvault.vault.azure.net/",
            "KeyVaultResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-sxx-az-kv-x-001",
            "KeyEncryptionKeyURL": "https://mykeyvault.vault.azure.net/keys/keyEncryptionKey/bc3bb46d95c64367975d722f473eeae5", // ID must be updated for new keys
            "KekVaultResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-sxx-az-kv-x-001",
            "KeyEncryptionAlgorithm": "RSA-OAEP", //'RSA-OAEP'/'RSA-OAEP-256'/'RSA1_5'
            "VolumeType": "All", //'OS'/'Data'/'All'
            "ResizeOSDisk": "false"
        }
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionAzureDiskEncryptionConfig: {
    // Restrictions: Cannot be enabled on disks that have encryption at host enabled. Managed disks encrypted using Azure Disk Encryption cannot be encrypted using customer-managed keys.
    enabled: true
    settings: {
        EncryptionOperation: 'EnableEncryption'
        KeyVaultURL: 'https://mykeyvault.vault.azure.net/'
        KeyVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-sxx-az-kv-x-001'
        KeyEncryptionKeyURL: 'https://mykeyvault.vault.azure.net/keys/keyEncryptionKey/bc3bb46d95c64367975d722f473eeae5' // ID must be updated for new keys
        KekVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-sxx-az-kv-x-001'
        KeyEncryptionAlgorithm: 'RSA-OAEP' //'RSA-OAEP'/'RSA-OAEP-256'/'RSA1_5'
        VolumeType: 'All' //'OS'/'Data'/'All'
        ResizeOSDisk: 'false'
    }
}
```

</details>
<p>

### Parameter Usage: `extensionCustomScriptConfig`

<details>

<summary>Parameter JSON format</summary>

```json
"extensionCustomScriptConfig": {
  "value": {
    "enabled": true,
    "fileData": [
      //storage accounts with SAS token requirement
      {
        "uri": "https://mystorageaccount.blob.core.windows.net/avdscripts/File1.ps1",
        "storageAccountId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName"
      },
      {
        "uri": "https://mystorageaccount.blob.core.windows.net/avdscripts/File2.ps1",
        "storageAccountId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName"
      },
      //storage account with public container (no SAS token is required) OR other public URL (not a storage account)
      {
        "uri": "https://github.com/myProject/File3.ps1",
        "storageAccountId": ""
      }
    ],
    "settings": {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File testscript.ps1"
    }
  }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionCustomScriptConfig: {
    enabled: true
    fileData: [
        //storage accounts with SAS token requirement
        {
            uri: 'https://mystorageaccount.blob.core.windows.net/avdscripts/File1.ps1'
            storageAccountId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName'
        }
        {
            uri: 'https://mystorageaccount.blob.core.windows.net/avdscripts/File2.ps1'
            storageAccountId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rgName/providers/Microsoft.Storage/storageAccounts/storageAccountName'
        }
        //storage account with public container (no SAS token is required) OR other public URL (not a storage account)
        {
            uri: 'https://github.com/myProject/File3.ps1'
            storageAccountId: ''
        }
    ]
    settings: {
        commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File testscript.ps1'
    }
}
```

</details>
<p>

### Parameter Usage: `extensionDSCConfig`

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionDSCConfig: {
    enabled: true
    settings: {
        wmfVersion: 'latest'
        configuration: {
            url: 'http://validURLToConfigLocation'
            script: 'ConfigurationScript.ps1'
            function: 'ConfigurationFunction'
        }
        configurationArguments: {
            argument1: 'Value1'
            argument2: 'Value2'
        }
        configurationData: {
            url: 'https://foo.psd1'
        }
        privacy: {
            dataCollection: 'enable'
        }
        advancedOptions: {
            forcePullAndApply: false
            downloadMappings: {
                specificDependencyKey: 'https://myCustomDependencyLocation'
            }
        }
    }
    protectedSettings: {
        configurationArguments: {
            mySecret: 'MyPlaceholder'
        }
        configurationUrlSasToken: 'MyPlaceholder'
        configurationDataUrlSasToken: 'MyPlaceholder'
    }
}
```

</details>
<p>

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the virtual machine scale set. |
| `resourceGroupName` | string | The resource group of the virtual machine scale set. |
| `resourceId` | string | The resource ID of the virtual machine scale set. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Linux</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineScaleSets './compute/virtual-machine-scale-sets/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cvmsslin'
  params: {
    // Required parameters
    adminUsername: 'scaleSetAdmin'
    imageReference: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'Canonical'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    name: '<<namePrefix>>cvmsslin001'
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    availabilityZones: [
      '2'
    ]
    bootDiagnosticStorageAccountName: '<bootDiagnosticStorageAccountName>'
    dataDisks: [
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: '256'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    disablePasswordAuthentication: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    encryptionAtHost: false
    extensionAzureDiskEncryptionConfig: {
      enabled: true
      settings: {
        EncryptionOperation: 'EnableEncryption'
        KekVaultResourceId: '<KekVaultResourceId>'
        KeyEncryptionAlgorithm: 'RSA-OAEP'
        KeyEncryptionKeyURL: '<KeyEncryptionKeyURL>'
        KeyVaultResourceId: '<KeyVaultResourceId>'
        KeyVaultURL: '<KeyVaultURL>'
        ResizeOSDisk: 'false'
        VolumeType: 'All'
      }
    }
    extensionCustomScriptConfig: {
      enabled: true
      fileData: [
        {
          storageAccountId: '<storageAccountId>'
          uri: '<uri>'
        }
      ]
      protectedSettings: {
        commandToExecute: 'sudo apt-get update'
      }
    }
    extensionDependencyAgentConfig: {
      enabled: true
    }
    extensionMonitoringAgentConfig: {
      enabled: true
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
    }
    lock: 'CanNotDelete'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              subnet: {
                id: '<id>'
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    publicKeys: [
      {
        keyData: '<keyData>'
        path: '/home/scaleSetAdmin/.ssh/authorized_keys'
      }
    ]
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    scaleSetFaultDomain: 1
    skuCapacity: 1
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    upgradePolicyMode: 'Manual'
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
    vmNamePrefix: 'vmsslinvm'
    vmPriority: 'Regular'
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
    "adminUsername": {
      "value": "scaleSetAdmin"
    },
    "imageReference": {
      "value": {
        "offer": "0001-com-ubuntu-server-jammy",
        "publisher": "Canonical",
        "sku": "22_04-lts-gen2",
        "version": "latest"
      }
    },
    "name": {
      "value": "<<namePrefix>>cvmsslin001"
    },
    "osDisk": {
      "value": {
        "createOption": "fromImage",
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "skuName": {
      "value": "Standard_B12ms"
    },
    // Non-required parameters
    "availabilityZones": {
      "value": [
        "2"
      ]
    },
    "bootDiagnosticStorageAccountName": {
      "value": "<bootDiagnosticStorageAccountName>"
    },
    "dataDisks": {
      "value": [
        {
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
        }
      ]
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "disablePasswordAuthentication": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "encryptionAtHost": {
      "value": false
    },
    "extensionAzureDiskEncryptionConfig": {
      "value": {
        "enabled": true,
        "settings": {
          "EncryptionOperation": "EnableEncryption",
          "KekVaultResourceId": "<KekVaultResourceId>",
          "KeyEncryptionAlgorithm": "RSA-OAEP",
          "KeyEncryptionKeyURL": "<KeyEncryptionKeyURL>",
          "KeyVaultResourceId": "<KeyVaultResourceId>",
          "KeyVaultURL": "<KeyVaultURL>",
          "ResizeOSDisk": "false",
          "VolumeType": "All"
        }
      }
    },
    "extensionCustomScriptConfig": {
      "value": {
        "enabled": true,
        "fileData": [
          {
            "storageAccountId": "<storageAccountId>",
            "uri": "<uri>"
          }
        ],
        "protectedSettings": {
          "commandToExecute": "sudo apt-get update"
        }
      }
    },
    "extensionDependencyAgentConfig": {
      "value": {
        "enabled": true
      }
    },
    "extensionMonitoringAgentConfig": {
      "value": {
        "enabled": true
      }
    },
    "extensionNetworkWatcherAgentConfig": {
      "value": {
        "enabled": true
      }
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig1",
              "properties": {
                "subnet": {
                  "id": "<id>"
                }
              }
            }
          ],
          "nicSuffix": "-nic01"
        }
      ]
    },
    "publicKeys": {
      "value": [
        {
          "keyData": "<keyData>",
          "path": "/home/scaleSetAdmin/.ssh/authorized_keys"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "scaleSetFaultDomain": {
      "value": 1
    },
    "skuCapacity": {
      "value": 1
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    },
    "upgradePolicyMode": {
      "value": "Manual"
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    },
    "vmNamePrefix": {
      "value": "vmsslinvm"
    },
    "vmPriority": {
      "value": "Regular"
    }
  }
}
```

</details>
<p>

<h3>Example 2: Linux.Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineScaleSets './compute/virtual-machine-scale-sets/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cvmsslinmin'
  params: {
    // Required parameters
    adminUsername: 'scaleSetAdmin'
    imageReference: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'Canonical'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    name: '<<namePrefix>>cvmsslinmin001'
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    disablePasswordAuthentication: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              subnet: {
                id: '<id>'
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    publicKeys: [
      {
        keyData: '<keyData>'
        path: '/home/scaleSetAdmin/.ssh/authorized_keys'
      }
    ]
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
    "adminUsername": {
      "value": "scaleSetAdmin"
    },
    "imageReference": {
      "value": {
        "offer": "0001-com-ubuntu-server-jammy",
        "publisher": "Canonical",
        "sku": "22_04-lts-gen2",
        "version": "latest"
      }
    },
    "name": {
      "value": "<<namePrefix>>cvmsslinmin001"
    },
    "osDisk": {
      "value": {
        "createOption": "fromImage",
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "skuName": {
      "value": "Standard_B12ms"
    },
    // Non-required parameters
    "disablePasswordAuthentication": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig1",
              "properties": {
                "subnet": {
                  "id": "<id>"
                }
              }
            }
          ],
          "nicSuffix": "-nic01"
        }
      ]
    },
    "publicKeys": {
      "value": [
        {
          "keyData": "<keyData>",
          "path": "/home/scaleSetAdmin/.ssh/authorized_keys"
        }
      ]
    }
  }
}
```

</details>
<p>

<h3>Example 3: Linux.Ssecmk</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineScaleSets './compute/virtual-machine-scale-sets/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cvmsslcmk'
  params: {
    // Required parameters
    adminUsername: 'scaleSetAdmin'
    imageReference: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'Canonical'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    name: '<<namePrefix>>cvmsslcmk001'
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: '128'
      managedDisk: {
        diskEncryptionSet: {
          id: '<id>'
        }
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    dataDisks: [
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: '128'
        managedDisk: {
          diskEncryptionSet: {
            id: '<id>'
          }
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    disablePasswordAuthentication: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              subnet: {
                id: '<id>'
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    publicKeys: [
      {
        keyData: '<keyData>'
        path: '/home/scaleSetAdmin/.ssh/authorized_keys'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
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
    "adminUsername": {
      "value": "scaleSetAdmin"
    },
    "imageReference": {
      "value": {
        "offer": "0001-com-ubuntu-server-jammy",
        "publisher": "Canonical",
        "sku": "22_04-lts-gen2",
        "version": "latest"
      }
    },
    "name": {
      "value": "<<namePrefix>>cvmsslcmk001"
    },
    "osDisk": {
      "value": {
        "createOption": "fromImage",
        "diskSizeGB": "128",
        "managedDisk": {
          "diskEncryptionSet": {
            "id": "<id>"
          },
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "skuName": {
      "value": "Standard_B12ms"
    },
    // Non-required parameters
    "dataDisks": {
      "value": [
        {
          "caching": "ReadOnly",
          "createOption": "Empty",
          "diskSizeGB": "128",
          "managedDisk": {
            "diskEncryptionSet": {
              "id": "<id>"
            },
            "storageAccountType": "Premium_LRS"
          }
        }
      ]
    },
    "disablePasswordAuthentication": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "location": {
      "value": "<location>"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig1",
              "properties": {
                "subnet": {
                  "id": "<id>"
                }
              }
            }
          ],
          "nicSuffix": "-nic01"
        }
      ]
    },
    "publicKeys": {
      "value": [
        {
          "keyData": "<keyData>",
          "path": "/home/scaleSetAdmin/.ssh/authorized_keys"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 4: Windows</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineScaleSets './compute/virtual-machine-scale-sets/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cvmsswin'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: '<<namePrefix>>cvmsswin001'
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    encryptionAtHost: false
    extensionAntiMalwareConfig: {
      enabled: true
      settings: {
        AntimalwareEnabled: true
        Exclusions: {
          Extensions: '.log;.ldf'
          Paths: 'D:\\IISlogs;D:\\DatabaseLogs'
          Processes: 'mssence.svc'
        }
        RealtimeProtectionEnabled: true
        ScheduledScanSettings: {
          day: '7'
          isEnabled: 'true'
          scanType: 'Quick'
          time: '120'
        }
      }
    }
    extensionAzureDiskEncryptionConfig: {
      enabled: true
      settings: {
        EncryptionOperation: 'EnableEncryption'
        KekVaultResourceId: '<KekVaultResourceId>'
        KeyEncryptionAlgorithm: 'RSA-OAEP'
        KeyEncryptionKeyURL: '<KeyEncryptionKeyURL>'
        KeyVaultResourceId: '<KeyVaultResourceId>'
        KeyVaultURL: '<KeyVaultURL>'
        ResizeOSDisk: 'false'
        VolumeType: 'All'
      }
    }
    extensionCustomScriptConfig: {
      enabled: true
      fileData: [
        {
          storageAccountId: '<storageAccountId>'
          uri: '<uri>'
        }
      ]
      protectedSettings: {
        commandToExecute: '<commandToExecute>'
      }
    }
    extensionDependencyAgentConfig: {
      enabled: true
    }
    extensionDSCConfig: {
      enabled: true
    }
    extensionMonitoringAgentConfig: {
      enabled: true
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
    }
    lock: 'CanNotDelete'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              subnet: {
                id: '<id>'
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    proximityPlacementGroupResourceId: '<proximityPlacementGroupResourceId>'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    skuCapacity: 1
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    upgradePolicyMode: 'Manual'
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
    vmNamePrefix: 'vmsswinvm'
    vmPriority: 'Regular'
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
    "adminUsername": {
      "value": "localAdminUser"
    },
    "imageReference": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "MicrosoftWindowsServer",
        "sku": "2022-datacenter-azure-edition",
        "version": "latest"
      }
    },
    "name": {
      "value": "<<namePrefix>>cvmsswin001"
    },
    "osDisk": {
      "value": {
        "createOption": "fromImage",
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "skuName": {
      "value": "Standard_B12ms"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "encryptionAtHost": {
      "value": false
    },
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
            "day": "7",
            "isEnabled": "true",
            "scanType": "Quick",
            "time": "120"
          }
        }
      }
    },
    "extensionAzureDiskEncryptionConfig": {
      "value": {
        "enabled": true,
        "settings": {
          "EncryptionOperation": "EnableEncryption",
          "KekVaultResourceId": "<KekVaultResourceId>",
          "KeyEncryptionAlgorithm": "RSA-OAEP",
          "KeyEncryptionKeyURL": "<KeyEncryptionKeyURL>",
          "KeyVaultResourceId": "<KeyVaultResourceId>",
          "KeyVaultURL": "<KeyVaultURL>",
          "ResizeOSDisk": "false",
          "VolumeType": "All"
        }
      }
    },
    "extensionCustomScriptConfig": {
      "value": {
        "enabled": true,
        "fileData": [
          {
            "storageAccountId": "<storageAccountId>",
            "uri": "<uri>"
          }
        ],
        "protectedSettings": {
          "commandToExecute": "<commandToExecute>"
        }
      }
    },
    "extensionDependencyAgentConfig": {
      "value": {
        "enabled": true
      }
    },
    "extensionDSCConfig": {
      "value": {
        "enabled": true
      }
    },
    "extensionMonitoringAgentConfig": {
      "value": {
        "enabled": true
      }
    },
    "extensionNetworkWatcherAgentConfig": {
      "value": {
        "enabled": true
      }
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig1",
              "properties": {
                "subnet": {
                  "id": "<id>"
                }
              }
            }
          ],
          "nicSuffix": "-nic01"
        }
      ]
    },
    "proximityPlacementGroupResourceId": {
      "value": "<proximityPlacementGroupResourceId>"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "skuCapacity": {
      "value": 1
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    },
    "upgradePolicyMode": {
      "value": "Manual"
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    },
    "vmNamePrefix": {
      "value": "vmsswinvm"
    },
    "vmPriority": {
      "value": "Regular"
    }
  }
}
```

</details>
<p>

<h3>Example 5: Windows.Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineScaleSets './compute/virtual-machine-scale-sets/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cvmsswinmin'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: '<<namePrefix>>cvmsswinmin001'
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              subnet: {
                id: '<id>'
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
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
    "adminUsername": {
      "value": "localAdminUser"
    },
    "imageReference": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "MicrosoftWindowsServer",
        "sku": "2022-datacenter-azure-edition",
        "version": "latest"
      }
    },
    "name": {
      "value": "<<namePrefix>>cvmsswinmin001"
    },
    "osDisk": {
      "value": {
        "createOption": "fromImage",
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "skuName": {
      "value": "Standard_B12ms"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig1",
              "properties": {
                "subnet": {
                  "id": "<id>"
                }
              }
            }
          ],
          "nicSuffix": "-nic01"
        }
      ]
    }
  }
}
```

</details>
<p>
