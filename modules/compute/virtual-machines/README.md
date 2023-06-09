# Virtual Machines `[Microsoft.Compute/virtualMachines]`

This module deploys one Virtual Machine with one or multiple NICs and optionally one or multiple public IPs.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Considerations](#Considerations)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Automanage/configurationProfileAssignments` | [2021-04-30-preview](https://learn.microsoft.com/en-us/azure/templates) |
| `Microsoft.Compute/virtualMachines` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines) |
| `Microsoft.Compute/virtualMachines/extensions` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines/extensions) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/networkInterfaces` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/networkInterfaces) |
| `Microsoft.Network/publicIPAddresses` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/publicIPAddresses) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers/protectedItems) |

## Parameters

**Required parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `adminUsername` | securestring |  |  | Administrator username. |
| `configurationProfile` | string | `''` | `['', /providers/Microsoft.Automanage/bestPractices/AzureBestPracticesDevTest, /providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction]` | The configuration profile of automanage. |
| `imageReference` | object |  |  | OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image. |
| `nicConfigurations` | array |  |  | Configures NICs and PIPs. |
| `osDisk` | object |  |  | Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object.  Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| `osType` | string |  | `[Linux, Windows]` | The chosen OS type. |
| `vmSize` | string |  |  | Specifies the size for the VMs. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `additionalUnattendContent` | array | `[]` |  | Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. - AdditionalUnattendContent object. |
| `adminPassword` | securestring | `''` |  | When specifying a Windows Virtual Machine, this value should be passed. |
| `allowExtensionOperations` | bool | `True` |  | Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine. |
| `availabilitySetResourceId` | string | `''` |  | Resource ID of an availability set. Cannot be used in combination with availability zone nor scale set. |
| `availabilityZone` | int | `0` | `[0, 1, 2, 3]` | If set to 1, 2 or 3, the availability zone for all VMs is hardcoded to that value. If zero, then availability zones is not used. Cannot be used in combination with availability set nor scale set. |
| `backupPolicyName` | string | `'DefaultPolicy'` |  | Backup policy the VMs should be using for backup. If not provided, it will use the DefaultPolicy from the backup recovery service vault. |
| `backupVaultName` | string | `''` |  | Recovery service vault name to add VMs to backup. |
| `backupVaultResourceGroup` | string | `[resourceGroup().name]` |  | Resource group of the backup recovery service vault. If not provided the current resource group name is considered by default. |
| `bootDiagnostics` | bool | `False` |  | Whether boot diagnostics should be enabled on the Virtual Machine. Boot diagnostics will be enabled with a managed storage account if no bootDiagnosticsStorageAccountName value is provided. If bootDiagnostics and bootDiagnosticsStorageAccountName values are not provided, boot diagnostics will be disabled. |
| `bootDiagnosticStorageAccountName` | string | `''` |  | Custom storage account used to store boot diagnostic information. Boot diagnostics will be enabled with a custom storage account if a value is provided. |
| `bootDiagnosticStorageAccountUri` | string | `[format('.blob.{0}/', environment().suffixes.storage)]` |  | Storage account boot diagnostic base URI. |
| `certificatesToBeInstalled` | array | `[]` |  | Specifies set of certificates that should be installed onto the virtual machine. |
| `computerName` | string | `[parameters('name')]` |  | Can be used if the computer name needs to be different from the Azure VM resource name. If not used, the resource name will be used as computer name. |
| `customData` | string | `''` |  | Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format. |
| `dataDisks` | array | `[]` |  | Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| `dedicatedHostId` | string | `''` |  | Specifies resource ID about the dedicated host that the virtual machine resides in. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `disablePasswordAuthentication` | bool | `False` |  | Specifies whether password authentication should be disabled. |
| `enableAutomaticUpdates` | bool | `True` |  | Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. When patchMode is set to Manual, this parameter must be set to false. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableEvictionPolicy` | bool | `False` |  | Specifies the eviction policy for the low priority virtual machine. Will result in 'Deallocate' eviction policy. |
| `encryptionAtHost` | bool | `True` |  | This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| `extensionAadJoinConfig` | object | `{object}` |  | The configuration for the [AAD Join] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionAntiMalwareConfig` | object | `{object}` |  | The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionAzureDiskEncryptionConfig` | object | `{object}` |  | The configuration for the [Azure Disk Encryption] extension. Must at least contain the ["enabled": true] property to be executed. Restrictions: Cannot be enabled on disks that have encryption at host enabled. Managed disks encrypted using Azure Disk Encryption cannot be encrypted using customer-managed keys. |
| `extensionCustomScriptConfig` | object | `{object}` |  | The configuration for the [Custom Script] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionCustomScriptProtectedSetting` | secureObject | `{object}` |  | Any object that contains the extension specific protected settings. |
| `extensionDependencyAgentConfig` | object | `{object}` |  | The configuration for the [Dependency Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionDomainJoinConfig` | object | `{object}` |  | The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionDomainJoinPassword` | securestring | `''` |  | Required if name is specified. Password of the user specified in user parameter. |
| `extensionDSCConfig` | object | `{object}` |  | The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionMonitoringAgentConfig` | object | `{object}` |  | The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| `extensionNetworkWatcherAgentConfig` | object | `{object}` |  | The configuration for the [Network Watcher Agent] extension. Must at least contain the ["enabled": true] property to be executed. |
| `licenseType` | string | `''` | `['', Windows_Client, Windows_Server]` | Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `maxPriceForLowPriorityVm` | string | `''` |  | Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars. |
| `monitoringWorkspaceId` | string | `''` |  | Resource ID of the monitoring log analytics workspace. Must be set when extensionMonitoringAgentConfig is set to true. |
| `name` | string | `[take(toLower(uniqueString(resourceGroup().name)), 10)]` |  | The name of the virtual machine to be created. You should use a unique prefix to reduce name collisions in Active Directory. If no value is provided, a 10 character long unique string will be generated based on the Resource Group's name. |
| `nicdiagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `nicDiagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the NIC diagnostic setting, if deployed. |
| `patchAssessmentMode` | string | `'ImageDefault'` | `[AutomaticByPlatform, ImageDefault]` | VM guest patching assessment mode. Set it to 'AutomaticByPlatform' to enable automatically check for updates every 24 hours. |
| `patchMode` | string | `''` | `['', AutomaticByOS, AutomaticByPlatform, ImageDefault, Manual]` | VM guest patching orchestration mode. 'AutomaticByOS' & 'Manual' are for Windows only, 'ImageDefault' for Linux only. Refer to 'https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching'. |
| `pipdiagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, DDoSMitigationFlowLogs, DDoSMitigationReports, DDoSProtectionNotifications]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `pipdiagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `pipDiagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the PIP diagnostic setting, if deployed. |
| `plan` | object | `{object}` |  | Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use. |
| `priority` | string | `'Regular'` | `[Low, Regular, Spot]` | Specifies the priority for the virtual machine. |
| `provisionVMAgent` | bool | `True` |  | Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later. |
| `proximityPlacementGroupResourceId` | string | `''` |  | Resource ID of a proximity placement group. |
| `publicKeys` | array | `[]` |  | The list of SSH public keys used to authenticate with linux based VMs. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sasTokenValidityLength` | string | `'PT8H'` |  | SAS token validity length to use to download files from storage accounts. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours. |
| `secureBootEnabled` | bool | `False` |  | Specifies whether secure boot should be enabled on the virtual machine. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| `securityType` | string | `''` |  | Specifies the SecurityType of the virtual machine. It is set as TrustedLaunch to enable UefiSettings. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. The system-assigned managed identity will automatically be enabled if extensionAadJoinConfig.enabled = "True". |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `timeZone` | string | `''` |  | Specifies the time zone of the virtual machine. e.g. 'Pacific Standard Time'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`. |
| `ultraSSDEnabled` | bool | `False` |  | The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
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
                "storageAccountType": "Premium_LRS",
                "diskEncryptionSet": { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.
                    "id": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>"
                }
            }
        },
        {
            "caching": "ReadOnly",
            "createOption": "Empty",
            "diskSizeGB": "128",
            "managedDisk": {
                "storageAccountType": "Premium_LRS",
                "diskEncryptionSet": { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.
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
        deleteOption: 'Delete' // Optional. Can be 'Delete' or 'Detach'
        diskSizeGB: '256'
        managedDisk: {
            storageAccountType: 'Premium_LRS'
            diskEncryptionSet: { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.
                id: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/diskEncryptionSets/<desName>'
            }
        }
    }
    {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: '128'
        managedDisk: {
            storageAccountType: 'Premium_LRS'
            diskEncryptionSet: { // Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.
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
- The field `nicSuffix` and `subnetResourceId` are mandatory.
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
          "subnetResourceId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>",
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
          "subnetResourceId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>",
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
          "subnetResourceId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>",
          "pipConfiguration": {
            "publicIpNameSuffix": "-pip-02"
          }
        },
        {
          "name": "ipconfig2",
          "subnetResourceId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>",
          "privateIPAllocationMethod": "Static",
          "privateIPAddress": "10.0.0.9"
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
          subnetResourceId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>'
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
          subnetResourceId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>'
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
          subnetResourceId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>'
          pipConfiguration: {
            publicIpNameSuffix: '-pip-02'
          }
        }
        {
          name: 'ipconfig2'
          subnetResourceId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vNetName>/subnets/<subnetName>'
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.0.0.9'
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

## Considerations

Enabling automanage triggers the creation of additional resources outside of the specific virtual machine deployment, such as:
- an `Automanage-Automate-<timestamp>` in the same Virtual Machine Resource Group and linking to the log analytics workspace leveraged by Azure Security Center.
- a `DefaultResourceGroup-<locationId>` rg hosting a recovery services vault `DefaultBackupVault-<location>` where vm backups are stored
For further details on automanage please refer to [Automanage virtual machines](https://learn.microsoft.com/en-us/azure/automanage/automanage-virtual-machines).

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the VM. |
| `resourceGroupName` | string | The name of the resource group the VM was created in. |
| `resourceId` | string | The resource ID of the VM. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `network/network-interfaces` | Local reference |
| `network/public-ip-addresses` | Local reference |
| `recovery-services/vaults/protection-containers/protected-items` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Linux</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachines './compute/virtual-machines/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cvmlincom'
  params: {
    // Required parameters
    adminUsername: 'localAdministrator'
    imageReference: {
      offer: '0001-com-ubuntu-server-focal'
      publisher: 'Canonical'
      sku: '<sku>'
      version: 'latest'
    }
    nicConfigurations: [
      {
        deleteOption: 'Delete'
        ipConfigurations: [
          {
            applicationSecurityGroups: [
              {
                id: '<id>'
              }
            ]
            loadBalancerBackendAddressPools: [
              {
                id: '<id>'
              }
            ]
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
              roleAssignments: [
                {
                  principalIds: [
                    '<managedIdentityPrincipalId>'
                  ]
                  principalType: 'ServicePrincipal'
                  roleDefinitionIdOrName: 'Reader'
                }
              ]
            }
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        nicSuffix: '-nic-01'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
      }
    ]
    osDisk: {
      caching: 'ReadOnly'
      createOption: 'fromImage'
      deleteOption: 'Delete'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    availabilityZone: 1
    backupPolicyName: '<backupPolicyName>'
    backupVaultName: '<backupVaultName>'
    backupVaultResourceGroup: '<backupVaultResourceGroup>'
    computerName: '<<namePrefix>>linvm1'
    dataDisks: [
      {
        caching: 'ReadWrite'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        caching: 'ReadWrite'
        createOption: 'Empty'
        deleteOption: 'Delete'
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
    enableAutomaticUpdates: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    encryptionAtHost: false
    extensionAadJoinConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
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
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
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
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionCustomScriptProtectedSetting: {
      commandToExecute: '<commandToExecute>'
    }
    extensionDependencyAgentConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionDSCConfig: {
      enabled: false
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionMonitoringAgentConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    location: '<location>'
    lock: 'CanNotDelete'
    monitoringWorkspaceId: '<monitoringWorkspaceId>'
    name: '<<namePrefix>>cvmlincom'
    patchMode: 'AutomaticByPlatform'
    publicKeys: [
      {
        keyData: '<keyData>'
        path: '/home/localAdministrator/.ssh/authorized_keys'
      }
    ]
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
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
      "value": "localAdministrator"
    },
    "imageReference": {
      "value": {
        "offer": "0001-com-ubuntu-server-focal",
        "publisher": "Canonical",
        "sku": "<sku>",
        "version": "latest"
      }
    },
    "nicConfigurations": {
      "value": [
        {
          "deleteOption": "Delete",
          "ipConfigurations": [
            {
              "applicationSecurityGroups": [
                {
                  "id": "<id>"
                }
              ],
              "loadBalancerBackendAddressPools": [
                {
                  "id": "<id>"
                }
              ],
              "name": "ipconfig01",
              "pipConfiguration": {
                "publicIpNameSuffix": "-pip-01",
                "roleAssignments": [
                  {
                    "principalIds": [
                      "<managedIdentityPrincipalId>"
                    ],
                    "principalType": "ServicePrincipal",
                    "roleDefinitionIdOrName": "Reader"
                  }
                ]
              },
              "subnetResourceId": "<subnetResourceId>"
            }
          ],
          "nicSuffix": "-nic-01",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ]
        }
      ]
    },
    "osDisk": {
      "value": {
        "caching": "ReadOnly",
        "createOption": "fromImage",
        "deleteOption": "Delete",
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "availabilityZone": {
      "value": 1
    },
    "backupPolicyName": {
      "value": "<backupPolicyName>"
    },
    "backupVaultName": {
      "value": "<backupVaultName>"
    },
    "backupVaultResourceGroup": {
      "value": "<backupVaultResourceGroup>"
    },
    "computerName": {
      "value": "<<namePrefix>>linvm1"
    },
    "dataDisks": {
      "value": [
        {
          "caching": "ReadWrite",
          "createOption": "Empty",
          "deleteOption": "Delete",
          "diskSizeGB": "128",
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          }
        },
        {
          "caching": "ReadWrite",
          "createOption": "Empty",
          "deleteOption": "Delete",
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
    "enableAutomaticUpdates": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "encryptionAtHost": {
      "value": false
    },
    "extensionAadJoinConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
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
        },
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
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
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionCustomScriptProtectedSetting": {
      "value": {
        "commandToExecute": "<commandToExecute>"
      }
    },
    "extensionDependencyAgentConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionDSCConfig": {
      "value": {
        "enabled": false,
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionMonitoringAgentConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionNetworkWatcherAgentConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
        }
      }
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "monitoringWorkspaceId": {
      "value": "<monitoringWorkspaceId>"
    },
    "name": {
      "value": "<<namePrefix>>cvmlincom"
    },
    "patchMode": {
      "value": "AutomaticByPlatform"
    },
    "publicKeys": {
      "value": [
        {
          "keyData": "<keyData>",
          "path": "/home/localAdministrator/.ssh/authorized_keys"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
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
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Linux.Atmg</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachines './compute/virtual-machines/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cvmlinatmg'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'Canonical'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
              tags: {
                Environment: 'Non-Prod'
                Role: 'DeploymentValidation'
              }
            }
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        nicSuffix: '-nic-01'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    configurationProfile: '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'
    disablePasswordAuthentication: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
    name: '<<namePrefix>>cvmlinatmg'
    publicKeys: [
      {
        keyData: '<keyData>'
        path: '/home/localAdminUser/.ssh/authorized_keys'
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
      "value": "localAdminUser"
    },
    "imageReference": {
      "value": {
        "offer": "0001-com-ubuntu-server-jammy",
        "publisher": "Canonical",
        "sku": "22_04-lts-gen2",
        "version": "latest"
      }
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig01",
              "pipConfiguration": {
                "publicIpNameSuffix": "-pip-01",
                "tags": {
                  "Environment": "Non-Prod",
                  "Role": "DeploymentValidation"
                }
              },
              "subnetResourceId": "<subnetResourceId>"
            }
          ],
          "nicSuffix": "-nic-01",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "osDisk": {
      "value": {
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "configurationProfile": {
      "value": "/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction"
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
    "name": {
      "value": "<<namePrefix>>cvmlinatmg"
    },
    "publicKeys": {
      "value": [
        {
          "keyData": "<keyData>",
          "path": "/home/localAdminUser/.ssh/authorized_keys"
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

<h3>Example 3: Linux.Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachines './compute/virtual-machines/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cvmlinmin'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'Canonical'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
            }
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    disablePasswordAuthentication: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
    name: '<<namePrefix>>cvmlinmin'
    publicKeys: [
      {
        keyData: '<keyData>'
        path: '/home/localAdminUser/.ssh/authorized_keys'
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
        "offer": "0001-com-ubuntu-server-jammy",
        "publisher": "Canonical",
        "sku": "22_04-lts-gen2",
        "version": "latest"
      }
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig01",
              "pipConfiguration": {
                "publicIpNameSuffix": "-pip-01"
              },
              "subnetResourceId": "<subnetResourceId>"
            }
          ],
          "nicSuffix": "-nic-01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Linux"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "disablePasswordAuthentication": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "<<namePrefix>>cvmlinmin"
    },
    "publicKeys": {
      "value": [
        {
          "keyData": "<keyData>",
          "path": "/home/localAdminUser/.ssh/authorized_keys"
        }
      ]
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
module virtualMachines './compute/virtual-machines/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cvmwincom'
  params: {
    // Required parameters
    adminUsername: 'VMAdmin'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2019-datacenter'
      version: 'latest'
    }
    nicConfigurations: [
      {
        deleteOption: 'Delete'
        ipConfigurations: [
          {
            applicationSecurityGroups: [
              {
                id: '<id>'
              }
            ]
            loadBalancerBackendAddressPools: [
              {
                id: '<id>'
              }
            ]
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
              roleAssignments: [
                {
                  principalIds: [
                    '<managedIdentityPrincipalId>'
                  ]
                  principalType: 'ServicePrincipal'
                  roleDefinitionIdOrName: 'Reader'
                }
              ]
            }
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        nicSuffix: '-nic-01'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
      }
    ]
    osDisk: {
      caching: 'None'
      createOption: 'fromImage'
      deleteOption: 'Delete'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    availabilityZone: 2
    backupPolicyName: '<backupPolicyName>'
    backupVaultName: '<backupVaultName>'
    backupVaultResourceGroup: '<backupVaultResourceGroup>'
    computerName: '<<namePrefix>>winvm1'
    dataDisks: [
      {
        caching: 'None'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        caching: 'None'
        createOption: 'Empty'
        deleteOption: 'Delete'
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
    enableAutomaticUpdates: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    encryptionAtHost: false
    extensionAadJoinConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
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
          day: '7'
          isEnabled: 'true'
          scanType: 'Quick'
          time: '120'
        }
      }
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
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
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
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
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionCustomScriptProtectedSetting: {
      commandToExecute: '<commandToExecute>'
    }
    extensionDependencyAgentConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionDSCConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionMonitoringAgentConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    location: '<location>'
    lock: 'CanNotDelete'
    monitoringWorkspaceId: '<monitoringWorkspaceId>'
    name: '<<namePrefix>>cvmwincom'
    patchMode: 'AutomaticByPlatform'
    proximityPlacementGroupResourceId: '<proximityPlacementGroupResourceId>'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
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
      "value": "VMAdmin"
    },
    "imageReference": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "MicrosoftWindowsServer",
        "sku": "2019-datacenter",
        "version": "latest"
      }
    },
    "nicConfigurations": {
      "value": [
        {
          "deleteOption": "Delete",
          "ipConfigurations": [
            {
              "applicationSecurityGroups": [
                {
                  "id": "<id>"
                }
              ],
              "loadBalancerBackendAddressPools": [
                {
                  "id": "<id>"
                }
              ],
              "name": "ipconfig01",
              "pipConfiguration": {
                "publicIpNameSuffix": "-pip-01",
                "roleAssignments": [
                  {
                    "principalIds": [
                      "<managedIdentityPrincipalId>"
                    ],
                    "principalType": "ServicePrincipal",
                    "roleDefinitionIdOrName": "Reader"
                  }
                ]
              },
              "subnetResourceId": "<subnetResourceId>"
            }
          ],
          "nicSuffix": "-nic-01",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ]
        }
      ]
    },
    "osDisk": {
      "value": {
        "caching": "None",
        "createOption": "fromImage",
        "deleteOption": "Delete",
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "availabilityZone": {
      "value": 2
    },
    "backupPolicyName": {
      "value": "<backupPolicyName>"
    },
    "backupVaultName": {
      "value": "<backupVaultName>"
    },
    "backupVaultResourceGroup": {
      "value": "<backupVaultResourceGroup>"
    },
    "computerName": {
      "value": "<<namePrefix>>winvm1"
    },
    "dataDisks": {
      "value": [
        {
          "caching": "None",
          "createOption": "Empty",
          "deleteOption": "Delete",
          "diskSizeGB": "128",
          "managedDisk": {
            "storageAccountType": "Premium_LRS"
          }
        },
        {
          "caching": "None",
          "createOption": "Empty",
          "deleteOption": "Delete",
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
    "enableAutomaticUpdates": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "encryptionAtHost": {
      "value": false
    },
    "extensionAadJoinConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
        }
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
            "day": "7",
            "isEnabled": "true",
            "scanType": "Quick",
            "time": "120"
          }
        },
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
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
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          },
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
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionCustomScriptProtectedSetting": {
      "value": {
        "commandToExecute": "<commandToExecute>"
      }
    },
    "extensionDependencyAgentConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionDSCConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionMonitoringAgentConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
        }
      }
    },
    "extensionNetworkWatcherAgentConfig": {
      "value": {
        "enabled": true,
        "tags": {
          "Environment": "Non-Prod",
          "Role": "DeploymentValidation"
        }
      }
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "monitoringWorkspaceId": {
      "value": "<monitoringWorkspaceId>"
    },
    "name": {
      "value": "<<namePrefix>>cvmwincom"
    },
    "patchMode": {
      "value": "AutomaticByPlatform"
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
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
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
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

<h3>Example 5: Windows.Atmg</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachines './compute/virtual-machines/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cvmwinatmg'
  params: {
    // Required parameters
    adminUsername: 'localAdministrator'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    configurationProfile: '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
    name: '<<namePrefix>>cvmwinatmg'
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
      "value": "localAdministrator"
    },
    "imageReference": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "MicrosoftWindowsServer",
        "sku": "2022-datacenter-azure-edition",
        "version": "latest"
      }
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig01",
              "subnetResourceId": "<subnetResourceId>"
            }
          ],
          "nicSuffix": "-nic-01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "configurationProfile": {
      "value": "/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "<<namePrefix>>cvmwinatmg"
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

<h3>Example 6: Windows.Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachines './compute/virtual-machines/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cvmwinmin'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
    name: '<<namePrefix>>cvmwinmin'
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
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig01",
              "subnetResourceId": "<subnetResourceId>"
            }
          ],
          "nicSuffix": "-nic-01"
        }
      ]
    },
    "osDisk": {
      "value": {
        "diskSizeGB": "128",
        "managedDisk": {
          "storageAccountType": "Premium_LRS"
        }
      }
    },
    "osType": {
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "<<namePrefix>>cvmwinmin"
    }
  }
}
```

</details>
<p>

<h3>Example 7: Windows.Ssecmk</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachines './compute/virtual-machines/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-cvmwincmk'
  params: {
    // Required parameters
    adminUsername: 'VMAdministrator'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2019-datacenter'
      version: 'latest'
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        diskEncryptionSet: {
          id: '<id>'
        }
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_DS2_v2'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    dataDisks: [
      {
        diskSizeGB: '128'
        managedDisk: {
          diskEncryptionSet: {
            id: '<id>'
          }
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
    name: '<<namePrefix>>cvmwincmk'
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
      "value": "VMAdministrator"
    },
    "imageReference": {
      "value": {
        "offer": "WindowsServer",
        "publisher": "MicrosoftWindowsServer",
        "sku": "2019-datacenter",
        "version": "latest"
      }
    },
    "nicConfigurations": {
      "value": [
        {
          "ipConfigurations": [
            {
              "name": "ipconfig01",
              "subnetResourceId": "<subnetResourceId>"
            }
          ],
          "nicSuffix": "-nic-01"
        }
      ]
    },
    "osDisk": {
      "value": {
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
      "value": "Windows"
    },
    "vmSize": {
      "value": "Standard_DS2_v2"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "dataDisks": {
      "value": [
        {
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "<<namePrefix>>cvmwincmk"
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
