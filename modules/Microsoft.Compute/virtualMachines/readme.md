# Virtual Machines `[Microsoft.Compute/virtualMachines]`

This module deploys one Virtual Machine with one or multiple nics and optionally one or multiple public IPs.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Considerations](#Considerations)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Automanage/configurationProfileAssignments` | [2021-04-30-preview](https://docs.microsoft.com/en-us/azure/templates) |
| `Microsoft.Compute/virtualMachines` | [2021-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-07-01/virtualMachines) |
| `Microsoft.Compute/virtualMachines/extensions` | [2021-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2021-07-01/virtualMachines/extensions) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/networkInterfaces` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/networkInterfaces) |
| `Microsoft.Network/publicIPAddresses` | [2021-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/publicIPAddresses) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-06-01/vaults/backupFabrics/protectionContainers/protectedItems) |

## Parameters

**Required parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `adminUsername` | secureString |  |  | Administrator username. |
| `configurationProfile` | string | `''` | `[/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction, /providers/Microsoft.Automanage/bestPractices/AzureBestPracticesDevTest, ]` | The configuration profile of automanage. |
| `imageReference` | object |  |  | OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image. |
| `nicConfigurations` | array |  |  | Configures NICs and PIPs. |
| `osDisk` | object |  |  | Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object.  Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| `osType` | string |  | `[Windows, Linux]` | The chosen OS type. |
| `vmSize` | string |  |  | Specifies the size for the VMs. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `additionalUnattendContent` | array | `[]` |  | Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. - AdditionalUnattendContent object. |
| `adminPassword` | secureString | `''` |  | When specifying a Windows Virtual Machine, this value should be passed. |
| `allowExtensionOperations` | bool | `True` |  | Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine. |
| `availabilitySetName` | string | `''` |  | Resource name of an availability set. Cannot be used in combination with availability zone nor scale set. |
| `availabilityZone` | int | `0` | `[0, 1, 2, 3]` | If set to 1, 2 or 3, the availability zone for all VMs is hardcoded to that value. If zero, then availability zones is not used. Cannot be used in combination with availability set nor scale set. |
| `backupPolicyName` | string | `'DefaultPolicy'` |  | Backup policy the VMs should be using for backup. If not provided, it will use the DefaultPolicy from the backup recovery service vault. |
| `backupVaultName` | string | `''` |  | Recovery service vault name to add VMs to backup. |
| `backupVaultResourceGroup` | string | `[resourceGroup().name]` |  | Resource group of the backup recovery service vault. If not provided the current resource group name is considered by default. |
| `bootDiagnostics` | bool | `False` |  | Whether boot diagnostics should be enabled on the Virtual Machine. Boot diagnostics will be enabled with a managed storage account if no bootDiagnosticsStorageAccountName value is provided. If bootDiagnostics and bootDiagnosticsStorageAccountName values are not provided, boot diagnostics will be disabled. |
| `bootDiagnosticStorageAccountName` | string | `''` |  | Custom storage account used to store boot diagnostic information. Boot diagnostics will be enabled with a custom storage account if a value is provided. |
| `bootDiagnosticStorageAccountUri` | string | `[format('.blob.{0}/', environment().suffixes.storage)]` |  | Storage account boot diagnostic base URI. |
| `certificatesToBeInstalled` | array | `[]` |  | Specifies set of certificates that should be installed onto the virtual machine. |
| `customData` | string | `''` |  | Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format. |
| `dataDisks` | array | `[]` |  | Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| `dedicatedHostId` | string | `''` |  | Specifies resource ID about the dedicated host that the virtual machine resides in. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `disablePasswordAuthentication` | bool | `False` |  | Specifies whether password authentication should be disabled. |
| `enableAutomaticUpdates` | bool | `True` |  | Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `enableEvictionPolicy` | bool | `False` |  | Specifies the eviction policy for the low priority virtual machine. Will result in 'Deallocate' eviction policy. |
| `enableServerSideEncryption` | bool | `False` |  | Specifies if Windows VM disks should be encrypted with Server-side encryption + Customer managed Key. |
| `encryptionAtHost` | bool | `True` |  | This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| `extensionAntiMalwareConfig` | object | `{object}` |  | The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionCustomScriptConfig` | object | `{object}` |  | The configuration for the [Custom Script] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionCustomScriptProtectedSetting` | secureObject | `{object}` |  | Any object that contains the extension specific protected settings. |
| `extensionDependencyAgentConfig` | object | `{object}` |  | The configuration for the [Dependency Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionDiskEncryptionConfig` | object | `{object}` |  | The configuration for the [Disk Encryption] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionDomainJoinConfig` | object | `{object}` |  | The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionDomainJoinPassword` | secureString | `''` |  | Required if domainName is specified. Password of the user specified in domainJoinUser parameter. |
| `extensionDSCConfig` | object | `{object}` |  | The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionMonitoringAgentConfig` | object | `{object}` |  | The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionNetworkWatcherAgentConfig` | object | `{object}` |  | The configuration for the [Network Watcher Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| `licenseType` | string | `''` | `[Windows_Client, Windows_Server, ]` | Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `maxPriceForLowPriorityVm` | string | `''` |  | Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars. |
| `monitoringWorkspaceId` | string | `''` |  | Resource ID of the monitoring log analytics workspace. Must be set when extensionMonitoringAgentConfig is set to true. |
| `name` | string | `[take(toLower(uniqueString(resourceGroup().name)), 10)]` |  | The name of the virtual machine to be created. You should use a unique prefix to reduce name collisions in Active Directory. If no value is provided, a 10 character long unique string will be generated based on the Resource Group's name. |
| `nicdiagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `nicDiagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the NIC diagnostic setting, if deployed. |
| `pipdiagnosticLogCategoriesToEnable` | array | `[DDoSProtectionNotifications, DDoSMitigationFlowLogs, DDoSMitigationReports]` | `[DDoSProtectionNotifications, DDoSMitigationFlowLogs, DDoSMitigationReports]` | The name of logs that will be streamed. |
| `pipdiagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `pipDiagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the PIP diagnostic setting, if deployed. |
| `plan` | object | `{object}` |  | Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use. |
| `provisionVMAgent` | bool | `True` |  | Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later. |
| `proximityPlacementGroupName` | string | `''` |  | Resource name of a proximity placement group. |
| `publicKeys` | array | `[]` |  | The list of SSH public keys used to authenticate with linux based VMs. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sasTokenValidityLength` | string | `'PT8H'` |  | SAS token validity length to use to download files from storage accounts. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours. |
| `secureBootEnabled` | bool | `False` |  | Specifies whether secure boot should be enabled on the virtual machine. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| `securityType` | string | `''` |  | Specifies the SecurityType of the virtual machine. It is set as TrustedLaunch to enable UefiSettings. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `timeZone` | string | `''` |  | Specifies the time zone of the virtual machine. e.g. 'Pacific Standard Time'. Possible values can be TimeZoneInfo.id value from time zones returned by TimeZoneInfo.GetSystemTimeZones. |
| `ultraSSDEnabled` | bool | `False` |  | The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `vmComputerNamesTransformation` | string | `'none'` | `[none, uppercase, lowercase]` | Specifies whether the computer names should be transformed. The transformation is performed on all computer names. Available transformations are 'none' (Default), 'uppercase' and 'lowercase'. |
| `vmPriority` | string | `'Regular'` | `[Regular, Low, Spot]` | Specifies the priority for the virtual machine. |
| `vTpmEnabled` | bool | `False` |  | Specifies whether vTPM should be enabled on the virtual machine. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| `winRM` | object | `{object}` |  | Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object. |

**Generated parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `baseTime` | string | `[utcNow('u')]` | Do not provide a value! This date value is used to generate a registration token. |


### Parameter Usage: `imageReference`

#### Marketplace images

<details>

<summary>Parameter JSON format</summary>

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

</details>
<details>

<summary>Bicep format</summary>

```bicep
imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2016-Datacenter'
      version: 'latest'
}
```

</details>
<p>

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
        "deleteOption": "Delete", // Optional. Can be 'Delete' or 'Detach'
        "diskSizeGB": "128",
        "managedDisk": {
            "storageAccountType": "Premium_LRS",
             "diskEncryptionSet": { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.
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
    deleteOption: 'Delete' // Optional. Can be 'Delete' or 'Detach'
    diskSizeGB: '128'
    managedDisk: {
        storageAccountType: 'Premium_LRS'
        diskEncryptionSet: { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.
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
            "deleteOption": "Delete", // Optional. Can be 'Delete' or 'Detach'
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
        deleteOption: 'Delete' // Optional. Can be 'Delete' or 'Detach'
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
```

</details>
<p>

### Parameter Usage: `nicConfigurations`

Comments:
- The field `nicSuffix` and `subnetId` are mandatory.
- If `enablePublicIP` is set to true, then `publicIpNameSuffix` is also mandatory.
- Each IP config needs to have the mandatory field `name`.
- If not disabled, `enableAcceleratedNetworking` is considered `true` by default and requires the VM to be deployed with a supported OS and VM size.

<details>

<summary>Parameter JSON format</summary>

```json
"nicConfigurations": {
  "value": [
    {
      "nicSuffix": "-nic-01",
      "deleteOption": "Delete", // Optional. Can be 'Delete' or 'Detach'
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

</details>

<details>

<summary>Bicep format</summary>

```bicep
nicConfigurations: {
  value: [
    {
      nicSuffix: '-nic-01'
      deleteOption: 'Delete' // Optional. Can be 'Delete' or 'Detach'
      ipConfigurations: [
        {
          name: 'ipconfig1'
          subnetId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>'
          pipConfiguration: {
            publicIpNameSuffix: '-pip-01'
            roleAssignments: [
              {
                roleDefinitionIdOrName: 'Reader'
                principalIds: [
                  '<principalId>'
                ]
              }
            ]
          }
        }
        {
          name: 'ipconfig2'
          subnetId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>'
        }
      ]
      nsgId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/networkSecurityGroups/<nsgName>'
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Reader'
          principalIds: [
            '<principalId>'
          ]
        }
      ]
    }
    {
      nicSuffix: '-nic-02'
      ipConfigurations: [
        {
          name: 'ipconfig1'
          subnetId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>'
          pipConfiguration: {
            publicIpNameSuffix: '-pip-02'
          }
        }
        {
          name: 'ipconfig2'
          subnetId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>'
          privateIPAllocationMethod: 'Static'
          vmIPAddress: '10.0.0.9'
        }
      ]
    }
  ]
}
```

</details>
<p>

### Parameter Usage: `configurationProfileAssignments`

<details>

<summary>Parameter JSON format</summary>

```json
"configurationProfileAssignments": {
    "value": [
        "/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction",
        "/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesDevTest"
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
configurationProfileAssignments: [
    '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'
    '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesDevTest'
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
      "domainName": "contoso.com",
      "domainJoinUser": "test.user@testcompany.com",
      "domainJoinOU": "OU=testOU; DC=contoso; DC=com",
      "domainJoinRestart": true,
      "domainJoinOptions": 3
    }
  }
},
"extensionDomainJoinPassword": {
  "keyVault": {
    "id": "/subscriptions/62826c76-d304-46d8-a0f6-718dbdcc536c/resourceGroups/WVD-Mgmt-TO-RG/providers/Microsoft.KeyVault/vaults/wvd-to-kvlt"
  },
  "secretName": "domainJoinUser02-Password"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionDomainJoinConfig: {
    enabled: true
    settings: {
      domainName: 'contoso.com'
      domainJoinUser: 'test.user@testcompany.com'
      domainJoinOU: 'OU=testOU; DC=contoso; DC=com'
      domainJoinRestart: true
      domainJoinOptions: 3
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

### Parameter Usage: `extensionDiskEncryptionConfig`

<details>

<summary>Parameter JSON format</summary>

```json
"extensionDiskEncryptionConfig": {
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
extensionDiskEncryptionConfig: {
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

### Parameter Usage: `extensionDSCConfig`

<details>

<summary>Parameter JSON format</summary>

```json
"extensionDSCConfig": {
  "value": {
    {
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
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionDSCConfig: {
    {
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

### Parameter Usage: `extensionCustomScriptProtectedSetting`

This is used if you are going to use secrets or other sensitive information that you don't want to be visible in the deployment and logs.

<details>

<summary>Parameter JSON format</summary>

```json
"extensionCustomScriptProtectedSetting": {
  "value": [
    {
      "commandToExecute": "mycommandToRun -someParam MYSECRET"
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
extensionCustomScriptProtectedSetting: [
    {
        commandToExecute: 'mycommandToRun -someParam MYSECRET'
    }
]
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
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Considerations

Enabling automanage triggers the creation of additional resources outside of the specific virtual machine deployment, such as:
- an `Automanage-Automate-<timestamp>` in the same Virtual Machine Resource Group and linking to the log analytics workspace leveraged by Azure Security Center.
- a `DefaultResourceGroup-<locationId>` rg hosting a recovery services vault `DefaultBackupVault-<location>` where vm backups are stored
For further details on automanage please refer to [Automanage virtual machines](https://docs.microsoft.com/en-us/azure/automanage/automanage-virtual-machines).

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the VM. |
| `resourceGroupName` | string | The name of the resource group the VM was created in. |
| `resourceId` | string | The resource ID of the VM. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-vm-linux-autmg-01"
        },
        "osType": {
            "value": "Linux"
        },
        "imageReference": {
            "value": {
                "publisher": "Canonical",
                "offer": "UbuntuServer",
                "sku": "18.04-LTS",
                "version": "latest"
            }
        },
        "osDisk": {
            "value": {
                "diskSizeGB": "128",
                "managedDisk": {
                    "storageAccountType": "Premium_LRS"
                }
            }
        },
        "vmSize": {
            "value": "Standard_B12ms"
        },
        "adminUsername": {
            "value": "localAdminUser"
        },
        "disablePasswordAuthentication": {
            "value": true
        },
        "publicKeys": {
            "value": [
                {
                    "path": "/home/localAdminUser/.ssh/authorized_keys",
                    "keyData": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdOir5eO28EBwxU0Dyra7g9h0HUXDyMNFp2z8PhaTUQgHjrimkMxjYRwEOG/lxnYL7+TqZk+HcPTfbZOunHBw0Wx2CITzILt6531vmIYZGfq5YyYXbxZa5MON7L/PVivoRlPj5Z/t4RhqMhyfR7EPcZ516LJ8lXPTo8dE/bkOCS+kFBEYHvPEEKAyLs19sRcK37SeHjpX04zdg62nqtuRr00Tp7oeiTXA1xn5K5mxeAswotmd8CU0lWUcJuPBWQedo649b+L2cm52kTncOBI6YChAeyEc1PDF0Tn9FmpdOWKtI9efh+S3f8qkcVEtSTXoTeroBd31nzjAunMrZeM8Ut6dre+XeQQIjT7I8oEm+ZkIuIyq0x2fls8JXP2YJDWDqu8v1+yLGTQ3Z9XVt2lMti/7bIgYxS0JvwOr5n5L4IzKvhb4fm13LLDGFa3o7Nsfe3fPb882APE0bLFCmfyIeiPh7go70WqZHakpgIr6LCWTyePez9CsI/rfWDb6eAM8= generated-by-azure"
                }
            ]
        },
        "nicConfigurations": {
            "value": [
                {
                    "nicSuffix": "-nic-01",
                    "ipConfigurations": [
                        {
                            "name": "ipconfig01",
                            "subnetId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001",
                            "pipConfiguration": {
                                "publicIpNameSuffix": "-pip-01"
                            }
                        }
                    ]
                }
            ]
        },
        "configurationProfile": {
            "value": "/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachines './Microsoft.Compute/virtualMachines/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-virtualMachines'
  params: {
    name: '<<namePrefix>>-vm-linux-autmg-01'
    osType: 'Linux'
    imageReference: {
      publisher: 'Canonical'
      offer: 'UbuntuServer'
      sku: '18.04-LTS'
      version: 'latest'
    }
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    vmSize: 'Standard_B12ms'
    adminUsername: 'localAdminUser'
    disablePasswordAuthentication: true
    publicKeys: [
      {
        path: '/home/localAdminUser/.ssh/authorized_keys'
        keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdOir5eO28EBwxU0Dyra7g9h0HUXDyMNFp2z8PhaTUQgHjrimkMxjYRwEOG/lxnYL7+TqZk+HcPTfbZOunHBw0Wx2CITzILt6531vmIYZGfq5YyYXbxZa5MON7L/PVivoRlPj5Z/t4RhqMhyfR7EPcZ516LJ8lXPTo8dE/bkOCS+kFBEYHvPEEKAyLs19sRcK37SeHjpX04zdg62nqtuRr00Tp7oeiTXA1xn5K5mxeAswotmd8CU0lWUcJuPBWQedo649b+L2cm52kTncOBI6YChAeyEc1PDF0Tn9FmpdOWKtI9efh+S3f8qkcVEtSTXoTeroBd31nzjAunMrZeM8Ut6dre+XeQQIjT7I8oEm+ZkIuIyq0x2fls8JXP2YJDWDqu8v1+yLGTQ3Z9XVt2lMti/7bIgYxS0JvwOr5n5L4IzKvhb4fm13LLDGFa3o7Nsfe3fPb882APE0bLFCmfyIeiPh7go70WqZHakpgIr6LCWTyePez9CsI/rfWDb6eAM8= generated-by-azure'
      }
    ]
    nicConfigurations: [
      {
        nicSuffix: '-nic-01'
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
            }
          }
        ]
      }
    ]
    configurationProfile: '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'
  }
}
```

</details>
<p>

<h3>Example 2</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-vm-linux-min-01"
        },
        "osType": {
            "value": "Linux"
        },
        "imageReference": {
            "value": {
                "publisher": "Canonical",
                "offer": "UbuntuServer",
                "sku": "18.04-LTS",
                "version": "latest"
            }
        },
        "osDisk": {
            "value": {
                "diskSizeGB": "128",
                "managedDisk": {
                    "storageAccountType": "Premium_LRS"
                }
            }
        },
        "vmSize": {
            "value": "Standard_B12ms"
        },
        "adminUsername": {
            "value": "localAdminUser"
        },
        "disablePasswordAuthentication": {
            "value": true
        },
        "publicKeys": {
            "value": [
                {
                    "path": "/home/localAdminUser/.ssh/authorized_keys",
                    "keyData": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdOir5eO28EBwxU0Dyra7g9h0HUXDyMNFp2z8PhaTUQgHjrimkMxjYRwEOG/lxnYL7+TqZk+HcPTfbZOunHBw0Wx2CITzILt6531vmIYZGfq5YyYXbxZa5MON7L/PVivoRlPj5Z/t4RhqMhyfR7EPcZ516LJ8lXPTo8dE/bkOCS+kFBEYHvPEEKAyLs19sRcK37SeHjpX04zdg62nqtuRr00Tp7oeiTXA1xn5K5mxeAswotmd8CU0lWUcJuPBWQedo649b+L2cm52kTncOBI6YChAeyEc1PDF0Tn9FmpdOWKtI9efh+S3f8qkcVEtSTXoTeroBd31nzjAunMrZeM8Ut6dre+XeQQIjT7I8oEm+ZkIuIyq0x2fls8JXP2YJDWDqu8v1+yLGTQ3Z9XVt2lMti/7bIgYxS0JvwOr5n5L4IzKvhb4fm13LLDGFa3o7Nsfe3fPb882APE0bLFCmfyIeiPh7go70WqZHakpgIr6LCWTyePez9CsI/rfWDb6eAM8= generated-by-azure"
                }
            ]
        },
        "nicConfigurations": {
            "value": [
                {
                    "nicSuffix": "-nic-01",
                    "ipConfigurations": [
                        {
                            "name": "ipconfig01",
                            "subnetId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001",
                            "pipConfiguration": {
                                "publicIpNameSuffix": "-pip-01"
                            }
                        }
                    ]
                }
            ]
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachines './Microsoft.Compute/virtualMachines/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-virtualMachines'
  params: {
    name: '<<namePrefix>>-vm-linux-min-01'
    osType: 'Linux'
    imageReference: {
      publisher: 'Canonical'
      offer: 'UbuntuServer'
      sku: '18.04-LTS'
      version: 'latest'
    }
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    vmSize: 'Standard_B12ms'
    adminUsername: 'localAdminUser'
    disablePasswordAuthentication: true
    publicKeys: [
      {
        path: '/home/localAdminUser/.ssh/authorized_keys'
        keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdOir5eO28EBwxU0Dyra7g9h0HUXDyMNFp2z8PhaTUQgHjrimkMxjYRwEOG/lxnYL7+TqZk+HcPTfbZOunHBw0Wx2CITzILt6531vmIYZGfq5YyYXbxZa5MON7L/PVivoRlPj5Z/t4RhqMhyfR7EPcZ516LJ8lXPTo8dE/bkOCS+kFBEYHvPEEKAyLs19sRcK37SeHjpX04zdg62nqtuRr00Tp7oeiTXA1xn5K5mxeAswotmd8CU0lWUcJuPBWQedo649b+L2cm52kTncOBI6YChAeyEc1PDF0Tn9FmpdOWKtI9efh+S3f8qkcVEtSTXoTeroBd31nzjAunMrZeM8Ut6dre+XeQQIjT7I8oEm+ZkIuIyq0x2fls8JXP2YJDWDqu8v1+yLGTQ3Z9XVt2lMti/7bIgYxS0JvwOr5n5L4IzKvhb4fm13LLDGFa3o7Nsfe3fPb882APE0bLFCmfyIeiPh7go70WqZHakpgIr6LCWTyePez9CsI/rfWDb6eAM8= generated-by-azure'
      }
    ]
    nicConfigurations: [
      {
        nicSuffix: '-nic-01'
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
            }
          }
        ]
      }
    ]
  }
}
```

</details>
<p>

<h3>Example 3</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-vm-linux-01"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "systemAssignedIdentity": {
            "value": true
        },
        "userAssignedIdentities": {
            "value": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            }
        },
        "osType": {
            "value": "Linux"
        },
        "encryptionAtHost": {
            "value": false
        },
        "availabilityZone": {
            "value": 1
        },
        "vmSize": {
            "value": "Standard_B12ms"
        },
        "imageReference": {
            "value": {
                "publisher": "Canonical",
                "offer": "UbuntuServer",
                "sku": "18.04-LTS",
                "version": "latest"
            }
        },
        "osDisk": {
            "value": {
                "createOption": "fromImage",
                "deleteOption": "Delete",
                "caching": "ReadOnly",
                "diskSizeGB": "128",
                "managedDisk": {
                    "storageAccountType": "Premium_LRS"
                }
            }
        },
        "dataDisks": {
            "value": [
                {
                    "createOption": "Empty",
                    "deleteOption": "Delete",
                    "caching": "ReadWrite",
                    "diskSizeGB": "128",
                    "managedDisk": {
                        "storageAccountType": "Premium_LRS"
                    }
                },
                {
                    "createOption": "Empty",
                    "deleteOption": "Delete",
                    "caching": "ReadWrite",
                    "diskSizeGB": "128",
                    "managedDisk": {
                        "storageAccountType": "Premium_LRS"
                    }
                }
            ]
        },
        "adminUsername": {
            "value": "localAdminUser"
        },
        "disablePasswordAuthentication": {
            "value": true
        },
        "publicKeys": {
            "value": [
                {
                    "path": "/home/localAdminUser/.ssh/authorized_keys",
                    "keyData": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdOir5eO28EBwxU0Dyra7g9h0HUXDyMNFp2z8PhaTUQgHjrimkMxjYRwEOG/lxnYL7+TqZk+HcPTfbZOunHBw0Wx2CITzILt6531vmIYZGfq5YyYXbxZa5MON7L/PVivoRlPj5Z/t4RhqMhyfR7EPcZ516LJ8lXPTo8dE/bkOCS+kFBEYHvPEEKAyLs19sRcK37SeHjpX04zdg62nqtuRr00Tp7oeiTXA1xn5K5mxeAswotmd8CU0lWUcJuPBWQedo649b+L2cm52kTncOBI6YChAeyEc1PDF0Tn9FmpdOWKtI9efh+S3f8qkcVEtSTXoTeroBd31nzjAunMrZeM8Ut6dre+XeQQIjT7I8oEm+ZkIuIyq0x2fls8JXP2YJDWDqu8v1+yLGTQ3Z9XVt2lMti/7bIgYxS0JvwOr5n5L4IzKvhb4fm13LLDGFa3o7Nsfe3fPb882APE0bLFCmfyIeiPh7go70WqZHakpgIr6LCWTyePez9CsI/rfWDb6eAM8= generated-by-azure"
                }
            ]
        },
        "nicConfigurations": {
            "value": [
                {
                    "nicSuffix": "-nic-01",
                    "deleteOption": "Delete",
                    "ipConfigurations": [
                        {
                            "name": "ipconfig01",
                            "subnetId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001",
                            "pipConfiguration": {
                                "publicIpNameSuffix": "-pip-01",
                                "roleAssignments": [
                                    {
                                        "roleDefinitionIdOrName": "Reader",
                                        "principalIds": [
                                            "<<deploymentSpId>>"
                                        ]
                                    }
                                ]
                            },
                            "loadBalancerBackendAddressPools": [
                                {
                                    "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/loadBalancers/adp-<<namePrefix>>-az-lb-internal-001/backendAddressPools/servers"
                                }
                            ],
                            "applicationSecurityGroups": [
                                {
                                    "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/applicationSecurityGroups/adp-<<namePrefix>>-az-asg-x-001"
                                }
                            ]
                        }
                    ],
                    "roleAssignments": [
                        {
                            "roleDefinitionIdOrName": "Reader",
                            "principalIds": [
                                "<<deploymentSpId>>"
                            ]
                        }
                    ]
                }
            ]
        },
        "backupVaultName": {
            "value": "adp-<<namePrefix>>-az-rsv-x-001"
        },
        "backupVaultResourceGroup": {
            "value": "validation-rg"
        },
        "backupPolicyName": {
            "value": "VMpolicy"
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        },
        "diagnosticLogsRetentionInDays": {
            "value": 7
        },
        "diagnosticStorageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "diagnosticWorkspaceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        },
        "diagnosticEventHubAuthorizationRuleId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
        },
        "diagnosticEventHubName": {
            "value": "adp-<<namePrefix>>-az-evh-x-001"
        },
        "extensionMonitoringAgentConfig": {
            "value": {
                "enabled": true
            }
        },
        "monitoringWorkspaceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        },
        "extensionDependencyAgentConfig": {
            "value": {
                "enabled": true
            }
        },
        "extensionNetworkWatcherAgentConfig": {
            "value": {
                "enabled": true
            }
        },
        "extensionDiskEncryptionConfig": {
            "value": {
                "enabled": true,
                "settings": {
                    "EncryptionOperation": "EnableEncryption",
                    "KeyVaultURL": "https://adp-<<namePrefix>>-az-kv-x-001.vault.azure.net/",
                    "KeyVaultResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001",
                    "KeyEncryptionKeyURL": "https://adp-<<namePrefix>>-az-kv-x-001.vault.azure.net/keys/keyEncryptionKey/bc3bb46d95c64367975d722f473eeae5", // ID must be updated for new keys
                    "KekVaultResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001",
                    "KeyEncryptionAlgorithm": "RSA-OAEP",
                    "VolumeType": "All",
                    "ResizeOSDisk": "false"
                }
            }
        },
        "extensionDSCConfig": {
            "value": {
                "enabled": false
            }
        },
        "extensionCustomScriptConfig": {
            "value": {
                "enabled": true,
                "fileData": [
                    {
                        "uri": "https://adp<<namePrefix>>azsax001.blob.core.windows.net/scripts/scriptExtensionMasterInstaller.ps1",
                        "storageAccountId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
                    }
                ]
            }
        },
        "extensionCustomScriptProtectedSetting": {
            "value": {
                "commandToExecute": "sudo apt-get update"
            }
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachines './Microsoft.Compute/virtualMachines/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-virtualMachines'
  params: {
    name: '<<namePrefix>>-vm-linux-01'
    lock: 'CanNotDelete'
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
    osType: 'Linux'
    encryptionAtHost: false
    availabilityZone: 1
    vmSize: 'Standard_B12ms'
    imageReference: {
      publisher: 'Canonical'
      offer: 'UbuntuServer'
      sku: '18.04-LTS'
      version: 'latest'
    }
    osDisk: {
      createOption: 'fromImage'
      deleteOption: 'Delete'
      caching: 'ReadOnly'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    dataDisks: [
      {
        createOption: 'Empty'
        deleteOption: 'Delete'
        caching: 'ReadWrite'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        createOption: 'Empty'
        deleteOption: 'Delete'
        caching: 'ReadWrite'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    adminUsername: 'localAdminUser'
    disablePasswordAuthentication: true
    publicKeys: [
      {
        path: '/home/localAdminUser/.ssh/authorized_keys'
        keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdOir5eO28EBwxU0Dyra7g9h0HUXDyMNFp2z8PhaTUQgHjrimkMxjYRwEOG/lxnYL7+TqZk+HcPTfbZOunHBw0Wx2CITzILt6531vmIYZGfq5YyYXbxZa5MON7L/PVivoRlPj5Z/t4RhqMhyfR7EPcZ516LJ8lXPTo8dE/bkOCS+kFBEYHvPEEKAyLs19sRcK37SeHjpX04zdg62nqtuRr00Tp7oeiTXA1xn5K5mxeAswotmd8CU0lWUcJuPBWQedo649b+L2cm52kTncOBI6YChAeyEc1PDF0Tn9FmpdOWKtI9efh+S3f8qkcVEtSTXoTeroBd31nzjAunMrZeM8Ut6dre+XeQQIjT7I8oEm+ZkIuIyq0x2fls8JXP2YJDWDqu8v1+yLGTQ3Z9XVt2lMti/7bIgYxS0JvwOr5n5L4IzKvhb4fm13LLDGFa3o7Nsfe3fPb882APE0bLFCmfyIeiPh7go70WqZHakpgIr6LCWTyePez9CsI/rfWDb6eAM8= generated-by-azure'
      }
    ]
    nicConfigurations: [
      {
        nicSuffix: '-nic-01'
        deleteOption: 'Delete'
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
              roleAssignments: [
                {
                  roleDefinitionIdOrName: 'Reader'
                  principalIds: [
                    '<<deploymentSpId>>'
                  ]
                }
              ]
            }
            loadBalancerBackendAddressPools: [
              {
                id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/loadBalancers/adp-<<namePrefix>>-az-lb-internal-001/backendAddressPools/servers'
              }
            ]
            applicationSecurityGroups: [
              {
                id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/applicationSecurityGroups/adp-<<namePrefix>>-az-asg-x-001'
              }
            ]
          }
        ]
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalIds: [
              '<<deploymentSpId>>'
            ]
          }
        ]
      }
    ]
    backupVaultName: 'adp-<<namePrefix>>-az-rsv-x-001'
    backupVaultResourceGroup: 'validation-rg'
    backupPolicyName: 'VMpolicy'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    extensionMonitoringAgentConfig: {
      enabled: true
    }
    monitoringWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    extensionDependencyAgentConfig: {
      enabled: true
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
    }
    extensionDiskEncryptionConfig: {
      enabled: true
      settings: {
        EncryptionOperation: 'EnableEncryption'
        KeyVaultURL: 'https://adp-<<namePrefix>>-az-kv-x-001.vault.azure.net/'
        KeyVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001'
        KeyEncryptionKeyURL: 'https://adp-<<namePrefix>>-az-kv-x-001.vault.azure.net/keys/keyEncryptionKey/bc3bb46d95c64367975d722f473eeae5'
        KekVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001'
        KeyEncryptionAlgorithm: 'RSA-OAEP'
        VolumeType: 'All'
        ResizeOSDisk: 'false'
      }
    }
    extensionDSCConfig: {
      enabled: false
    }
    extensionCustomScriptConfig: {
      enabled: true
      fileData: [
        {
          uri: 'https://adp<<namePrefix>>azsax001.blob.core.windows.net/scripts/scriptExtensionMasterInstaller.ps1'
          storageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
        }
      ]
    }
    extensionCustomScriptProtectedSetting: {
      commandToExecute: 'sudo apt-get update'
    }
  }
}
```

</details>
<p>

<h3>Example 4</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-vm-win-03"
        },
        "imageReference": {
            "value": {
                "publisher": "MicrosoftWindowsServer",
                "offer": "WindowsServer",
                "sku": "2019-Datacenter",
                "version": "latest"
            }
        },
        "osType": {
            "value": "Windows"
        },
        "vmSize": {
            "value": "Standard_B12ms"
        },
        "osDisk": {
            "value": {
                "diskSizeGB": "128",
                "managedDisk": {
                    "storageAccountType": "Premium_LRS"
                }
            }
        },
        "adminUsername": {
            "value": "localAdminUser"
        },
        "adminPassword": {
            "reference": {
                "keyVault": {
                    "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
                },
                "secretName": "adminPassword"
            }
        },
        "nicConfigurations": {
            "value": [
                {
                    "nicSuffix": "-nic-01",
                    "ipConfigurations": [
                        {
                            "name": "ipconfig01",
                            "subnetId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001"
                        }
                    ]
                }
            ]
        },
        "configurationProfile": {
            "value": "/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
resource kv1 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'adp-<<namePrefix>>-az-kv-x-001'
  scope: resourceGroup('<<subscriptionId>>','validation-rg')
}

module virtualMachines './Microsoft.Compute/virtualMachines/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-virtualMachines'
  params: {
    name: '<<namePrefix>>-vm-win-03'
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2019-Datacenter'
      version: 'latest'
    }
    osType: 'Windows'
    vmSize: 'Standard_B12ms'
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    adminUsername: 'localAdminUser'
    adminPassword: kv1.getSecret('adminPassword')
    nicConfigurations: [
      {
        nicSuffix: '-nic-01'
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001'
          }
        ]
      }
    ]
    configurationProfile: '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'
  }
}
```

</details>
<p>

<h3>Example 5</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-vm-win-02"
        },
        "imageReference": {
            "value": {
                "publisher": "MicrosoftWindowsServer",
                "offer": "WindowsServer",
                "sku": "2022-datacenter-azure-edition",
                "version": "latest"
            }
        },
        "osType": {
            "value": "Windows"
        },
        "vmSize": {
            "value": "Standard_B12ms"
        },
        "osDisk": {
            "value": {
                "diskSizeGB": "128",
                "managedDisk": {
                    "storageAccountType": "Premium_LRS"
                }
            }
        },
        "adminUsername": {
            "value": "localAdminUser"
        },
        "adminPassword": {
            "reference": {
                "keyVault": {
                    "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
                },
                "secretName": "adminPassword"
            }
        },
        "nicConfigurations": {
            "value": [
                {
                    "nicSuffix": "-nic-01",
                    "ipConfigurations": [
                        {
                            "name": "ipconfig01",
                            "subnetId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001"
                        }
                    ]
                }
            ]
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
resource kv1 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'adp-<<namePrefix>>-az-kv-x-001'
  scope: resourceGroup('<<subscriptionId>>','validation-rg')
}

module virtualMachines './Microsoft.Compute/virtualMachines/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-virtualMachines'
  params: {
    name: '<<namePrefix>>-vm-win-02'
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    osType: 'Windows'
    vmSize: 'Standard_B12ms'
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    adminUsername: 'localAdminUser'
    adminPassword: kv1.getSecret('adminPassword')
    nicConfigurations: [
      {
        nicSuffix: '-nic-01'
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001'
          }
        ]
      }
    ]
  }
}
```

</details>
<p>

<h3>Example 6</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-vm-win-01"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "encryptionAtHost": {
            "value": false
        },
        "imageReference": {
            "value": {
                "publisher": "MicrosoftWindowsServer",
                "offer": "WindowsServer",
                "sku": "2019-Datacenter",
                "version": "latest"
            }
        },
        "osType": {
            "value": "Windows"
        },
        "vmSize": {
            "value": "Standard_B12ms"
        },
        "osDisk": {
            "value": {
                "createOption": "fromImage",
                "deleteOption": "Delete",
                "caching": "None",
                "diskSizeGB": "128",
                "managedDisk": {
                    "storageAccountType": "Premium_LRS"
                }
            }
        },
        "dataDisks": {
            "value": [
                {
                    "createOption": "Empty",
                    "deleteOption": "Delete",
                    "caching": "None",
                    "diskSizeGB": "128",
                    "managedDisk": {
                        "storageAccountType": "Premium_LRS"
                    }
                },
                {
                    "createOption": "Empty",
                    "deleteOption": "Delete",
                    "caching": "None",
                    "diskSizeGB": "128",
                    "managedDisk": {
                        "storageAccountType": "Premium_LRS"
                    }
                }
            ]
        },
        "availabilityZone": {
            "value": 2
        },
        "adminUsername": {
            "value": "localAdminUser"
        },
        "adminPassword": {
            "reference": {
                "keyVault": {
                    "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
                },
                "secretName": "adminPassword"
            }
        },
        "nicConfigurations": {
            "value": [
                {
                    "nicSuffix": "-nic-01",
                    "deleteOption": "Delete",
                    "ipConfigurations": [
                        {
                            "name": "ipconfig01",
                            "subnetId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001",
                            "pipConfiguration": {
                                "publicIpNameSuffix": "-pip-01",
                                "roleAssignments": [
                                    {
                                        "roleDefinitionIdOrName": "Reader",
                                        "principalIds": [
                                            "<<deploymentSpId>>"
                                        ]
                                    }
                                ]
                            },
                            "loadBalancerBackendAddressPools": [
                                {
                                    "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/loadBalancers/adp-<<namePrefix>>-az-lb-internal-001/backendAddressPools/servers"
                                }
                            ],
                            "applicationSecurityGroups": [
                                {
                                    "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/applicationSecurityGroups/adp-<<namePrefix>>-az-asg-x-001"
                                }
                            ]
                        }
                    ],
                    "roleAssignments": [
                        {
                            "roleDefinitionIdOrName": "Reader",
                            "principalIds": [
                                "<<deploymentSpId>>"
                            ]
                        }
                    ]
                }
            ]
        },
        "backupVaultName": {
            "value": "adp-<<namePrefix>>-az-rsv-x-001"
        },
        "backupVaultResourceGroup": {
            "value": "validation-rg"
        },
        "backupPolicyName": {
            "value": "VMpolicy"
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        },
        "diagnosticLogsRetentionInDays": {
            "value": 7
        },
        "diagnosticStorageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "diagnosticWorkspaceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        },
        "diagnosticEventHubAuthorizationRuleId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
        },
        "diagnosticEventHubName": {
            "value": "adp-<<namePrefix>>-az-evh-x-001"
        },
        "systemAssignedIdentity": {
            "value": true
        },
        "userAssignedIdentities": {
            "value": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            }
        },
        "extensionAntiMalwareConfig": {
            "value": {
                "enabled": true,
                "settings": {
                    "AntimalwareEnabled": "true",
                    "Exclusions": {
                        "Extensions": ".ext1;.ext2",
                        "Paths": "c:\\excluded-path-1;c:\\excluded-path-2",
                        "Processes": "excludedproc1.exe;excludedproc2.exe"
                    },
                    "RealtimeProtectionEnabled": "true",
                    "ScheduledScanSettings": {
                        "isEnabled": "true",
                        "scanType": "Quick",
                        "day": "7",
                        "time": "120"
                    }
                }
            }
        },
        "extensionMonitoringAgentConfig": {
            "value": {
                "enabled": true
            }
        },
        "monitoringWorkspaceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        },
        "extensionDependencyAgentConfig": {
            "value": {
                "enabled": true
            }
        },
        "extensionNetworkWatcherAgentConfig": {
            "value": {
                "enabled": true
            }
        },
        "extensionDiskEncryptionConfig": {
            "value": {
                "enabled": true,
                "settings": {
                    "EncryptionOperation": "EnableEncryption",
                    "KeyVaultURL": "https://adp-<<namePrefix>>-az-kv-x-001.vault.azure.net/",
                    "KeyVaultResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001",
                    "KeyEncryptionKeyURL": "https://adp-<<namePrefix>>-az-kv-x-001.vault.azure.net/keys/keyEncryptionKey/bc3bb46d95c64367975d722f473eeae5", // ID must be updated for new keys
                    "KekVaultResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001",
                    "KeyEncryptionAlgorithm": "RSA-OAEP",
                    "VolumeType": "All",
                    "ResizeOSDisk": "false"
                }
            }
        },
        "extensionDSCConfig": {
            "value": {
                "enabled": true
            }
        },
        "extensionCustomScriptConfig": {
            "value": {
                "enabled": true,
                "fileData": [
                    {
                        "uri": "https://adp<<namePrefix>>azsax001.blob.core.windows.net/scripts/scriptExtensionMasterInstaller.ps1",
                        "storageAccountId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
                    }
                ]
            }
        },
        "extensionCustomScriptProtectedSetting": {
            "value": {
                "commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command \"& .\\scriptExtensionMasterInstaller.ps1\""
            }
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
resource kv1 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'adp-<<namePrefix>>-az-kv-x-001'
  scope: resourceGroup('<<subscriptionId>>','validation-rg')
}

module virtualMachines './Microsoft.Compute/virtualMachines/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-virtualMachines'
  params: {
    name: '<<namePrefix>>-vm-win-01'
    lock: 'CanNotDelete'
    encryptionAtHost: false
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2019-Datacenter'
      version: 'latest'
    }
    osType: 'Windows'
    vmSize: 'Standard_B12ms'
    osDisk: {
      createOption: 'fromImage'
      deleteOption: 'Delete'
      caching: 'None'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    dataDisks: [
      {
        createOption: 'Empty'
        deleteOption: 'Delete'
        caching: 'None'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        createOption: 'Empty'
        deleteOption: 'Delete'
        caching: 'None'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    availabilityZone: 2
    adminUsername: 'localAdminUser'
    adminPassword: kv1.getSecret('adminPassword')
    nicConfigurations: [
      {
        nicSuffix: '-nic-01'
        deleteOption: 'Delete'
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-001'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
              roleAssignments: [
                {
                  roleDefinitionIdOrName: 'Reader'
                  principalIds: [
                    '<<deploymentSpId>>'
                  ]
                }
              ]
            }
            loadBalancerBackendAddressPools: [
              {
                id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/loadBalancers/adp-<<namePrefix>>-az-lb-internal-001/backendAddressPools/servers'
              }
            ]
            applicationSecurityGroups: [
              {
                id: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/applicationSecurityGroups/adp-<<namePrefix>>-az-asg-x-001'
              }
            ]
          }
        ]
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalIds: [
              '<<deploymentSpId>>'
            ]
          }
        ]
      }
    ]
    backupVaultName: 'adp-<<namePrefix>>-az-rsv-x-001'
    backupVaultResourceGroup: 'validation-rg'
    backupPolicyName: 'VMpolicy'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
    extensionAntiMalwareConfig: {
      enabled: true
      settings: {
        AntimalwareEnabled: 'true'
        Exclusions: {
          Extensions: '.ext1;.ext2'
          Paths: 'c:\\excluded-path-1;c:\\excluded-path-2'
          Processes: 'excludedproc1.exe;excludedproc2.exe'
        }
        RealtimeProtectionEnabled: 'true'
        ScheduledScanSettings: {
          isEnabled: 'true'
          scanType: 'Quick'
          day: '7'
          time: '120'
        }
      }
    }
    extensionMonitoringAgentConfig: {
      enabled: true
    }
    monitoringWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    extensionDependencyAgentConfig: {
      enabled: true
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
    }
    extensionDiskEncryptionConfig: {
      enabled: true
      settings: {
        EncryptionOperation: 'EnableEncryption'
        KeyVaultURL: 'https://adp-<<namePrefix>>-az-kv-x-001.vault.azure.net/'
        KeyVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001'
        KeyEncryptionKeyURL: 'https://adp-<<namePrefix>>-az-kv-x-001.vault.azure.net/keys/keyEncryptionKey/bc3bb46d95c64367975d722f473eeae5'
        KekVaultResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001'
        KeyEncryptionAlgorithm: 'RSA-OAEP'
        VolumeType: 'All'
        ResizeOSDisk: 'false'
      }
    }
    extensionDSCConfig: {
      enabled: true
    }
    extensionCustomScriptConfig: {
      enabled: true
      fileData: [
        {
          uri: 'https://adp<<namePrefix>>azsax001.blob.core.windows.net/scripts/scriptExtensionMasterInstaller.ps1'
          storageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
        }
      ]
    }
    extensionCustomScriptProtectedSetting: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command \'& .\\scriptExtensionMasterInstaller.ps1\''
    }
  }
}
```

</details>
<p>
