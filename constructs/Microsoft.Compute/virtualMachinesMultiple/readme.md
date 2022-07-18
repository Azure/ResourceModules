# Multiple Virtual Machines `[Microsoft.Compute/virtualMachines]`

This module deploys one or multiple Virtual Machines.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

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
| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `adminUsername` | secureString |  | Administrator username |
| `imageReference` | object |  | OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image. |
| `nicConfigurations` | array |  | Configures NICs and PIPs. |
| `osDisk` | object |  | Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object.  Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| `osType` | string | `[Windows, Linux]` | The chosen OS type |
| `vmSize` | string |  | Specifies the size for the VMs |

**Conditional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `vmInitialNumber` | int | `1` | If no explicit values were provided in the vmNames parameter, this parameter will be used to generate VM names, using the vmNamePrefix and the vmNumberOfInstances values. |
| `vmNamePrefix` | string | `[take(toLower(uniqueString(resourceGroup().name)), 10)]` | If no explicit values were provided in the vmNames parameter, this prefix will be used in combination with the vmNumberOfInstances and the vmInitialNumber parameters to create unique VM names. You should use a unique prefix to reduce name collisions in Active Directory. If no value is provided, a 10 character long unique string will be generated based on the Resource Group's name. |
| `vmNames` | array | `[]` | Name(s) of the virtual machine(s). If no explicit names are provided, VM name(s) will be generated based on the vmNamePrefix, vmNumberOfInstances and vmInitialNumber parameters. |
| `vmNumberOfInstances` | int | `1` | If no explicit values were provided in the vmNames parameter, this parameter will be used to generate VM names, using the vmNamePrefix and the vmInitialNumber values. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `additionalUnattendContent` | array | `[]` |  | Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. - AdditionalUnattendContent object |
| `adminPassword` | secureString | `''` |  | When specifying a Windows Virtual Machine, this value should be passed |
| `allowExtensionOperations` | bool | `True` |  | Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine. |
| `availabilitySetName` | string | `''` |  | Resource name of an availability set. Cannot be used in combination with availability zone nor scale set. |
| `availabilityZone` | int | `0` | `[0, 1, 2, 3]` | If set to 1, 2 or 3, the availability zone for all VMs is hardcoded to that value. If zero, then availability zones is not used. Cannot be used in combination with availability set nor scale set. |
| `backupPolicyName` | string | `'DefaultPolicy'` |  | Backup policy the VMs should be using for backup. If not provided, it will use the DefaultPolicy from the backup recovery service vault. |
| `backupVaultName` | string | `''` |  | Recovery service vault name to add VMs to backup. |
| `backupVaultResourceGroup` | string | `[resourceGroup().name]` |  | Resource group of the backup recovery service vault. If not provided the current resource group name is considered by default. |
| `bootDiagnosticStorageAccountName` | string | `''` |  | Storage account used to store boot diagnostic information. Boot diagnostics will be disabled if no value is provided. |
| `bootDiagnosticStorageAccountUri` | string | `[format('.blob.{0}/', environment().suffixes.storage)]` |  | Storage account boot diagnostic base URI. |
| `certificatesToBeInstalled` | array | `[]` |  | Specifies set of certificates that should be installed onto the virtual machine. |
| `configurationProfileAssignments` | array | `[]` |  | Any VM configuration profile assignments |
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
| `extensionAntiMalwareConfig` | object | `{object}` |  | The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionCustomScriptConfig` | object | `{object}` |  | The configuration for the [Custom Script] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionCustomScriptProtectedSetting` | secureObject | `{object}` |  | Any object that contains the extension specific protected settings |
| `extensionDependencyAgentConfig` | object | `{object}` |  | The configuration for the [Dependency Agent] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionDiskEncryptionConfig` | object | `{object}` |  | The configuration for the [Disk Encryption] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionDomainJoinConfig` | object | `{object}` |  | The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionDomainJoinPassword` | secureString | `''` |  | Required if domainName is specified. Password of the user specified in domainJoinUser parameter |
| `extensionDSCConfig` | object | `{object}` |  | The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionMonitoringAgentConfig` | object | `{object}` |  | The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed |
| `extensionNetworkWatcherAgentConfig` | object | `{object}` |  | The configuration for the [Network Watcher Agent] extension. Must at least contain the ["enabled": true] property to be executed |
| `licenseType` | string | `''` | `[Windows_Client, Windows_Server, ]` | Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `maxPriceForLowPriorityVm` | string | `''` |  | Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars. |
| `monitoringWorkspaceId` | string | `''` |  | Resource ID of the monitoring log analytics workspace. Must be set when extensionMonitoringAgentConfig is set to true. |
| `nicdiagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `nicDiagnosticSettingsName` | string | `''` |  | The name of the NIC diagnostic setting, if deployed. |
| `pipdiagnosticLogCategoriesToEnable` | array | `[DDoSProtectionNotifications, DDoSMitigationFlowLogs, DDoSMitigationReports]` | `[DDoSProtectionNotifications, DDoSMitigationFlowLogs, DDoSMitigationReports]` | The name of logs that will be streamed. |
| `pipdiagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `pipDiagnosticSettingsName` | string | `''` |  | The name of the PIP diagnostic setting, if deployed. |
| `plan` | object | `{object}` |  | Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use. |
| `provisionVMAgent` | bool | `True` |  | Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later. |
| `proximityPlacementGroupName` | string | `''` |  | Resource name of a proximity placement group. |
| `publicKeys` | array | `[]` |  | The list of SSH public keys used to authenticate with linux based VMs |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sasTokenValidityLength` | string | `'PT8H'` |  | SAS token validity length to use to download files from storage accounts. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours. |
| `secureBootEnabled` | bool | `False` |  | Specifies whether secure boot should be enabled on the virtual machine. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| `securityType` | string | `''` |  | Specifies the SecurityType of the virtual machine. It is set as TrustedLaunch to enable UefiSettings. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `timeZone` | string | `''` |  | Specifies the time zone of the virtual machine. e.g. 'Pacific Standard Time'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`. |
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


### Parameter Usage: `vmNames`

Name(s) of the virtual machine(s). If no explicit names are provided, VM name(s) will be generated based on the `vmNamePrefix`, `vmNumberOfInstances` and `vmInitialNumber` parameters.

```json
"vmNames": {
    "value": [
        "<<namePrefix>>-vm-linux-vmnames-01",
        "<<namePrefix>>-vm-linux-vmnames-02",
        "<<namePrefix>>-vm-linux-vmnames-03"
    ]
}
```

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

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
| `virtualMachinesName` | array | The names of the VMs. |
| `virtualMachinesResourceGroup` | string | The name of the resource group the VM(s) was/were created in. |
| `virtualMachinesResourceId` | array | The resource ID(s) of the VM(s). |
