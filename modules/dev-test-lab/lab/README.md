# DevTest Labs `[Microsoft.DevTestLab/labs]`

This module deploys a DevTest Lab.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DevTestLab/labs` | [2018-10-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/labs) |
| `Microsoft.DevTestLab/labs/artifactsources` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/artifactsources) |
| `Microsoft.DevTestLab/labs/costs` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/costs) |
| `Microsoft.DevTestLab/labs/notificationchannels` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/notificationchannels) |
| `Microsoft.DevTestLab/labs/policysets/policies` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/policysets/policies) |
| `Microsoft.DevTestLab/labs/schedules` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/schedules) |
| `Microsoft.DevTestLab/labs/virtualnetworks` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/virtualnetworks) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the lab. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `encryptionDiskEncryptionSetId` | string | `''` | The Disk Encryption Set Resource ID used to encrypt OS and data disks created as part of the the lab. Required if encryptionType is set to "EncryptionAtRestWithCustomerKey". |
| `notificationchannels` | array | `[]` | Notification Channels to create for the lab. Required if the schedules property "notificationSettingsStatus" is set to "Enabled. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `announcement` | object | `{object}` |  | The properties of any lab announcement associated with this lab. |
| `artifactsources` | array | `[]` |  | Artifact sources to create for the lab. |
| `artifactsStorageAccount` | string | `''` |  | The resource ID of the storage account used to store artifacts and images by the lab. Also used for defaultStorageAccount, defaultPremiumStorageAccount and premiumDataDiskStorageAccount properties. If left empty, a default storage account will be created by the lab and used. |
| `browserConnect` | string | `'Disabled'` | `[Disabled, Enabled]` | Enable browser connect on virtual machines if the lab's VNETs have configured Azure Bastion. |
| `costs` | object | `{object}` |  | Costs to create for the lab. |
| `disableAutoUpgradeCseMinorVersion` | bool | `False` |  | Disable auto upgrade custom script extension minor version. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `encryptionType` | string | `'EncryptionAtRestWithPlatformKey'` | `[EncryptionAtRestWithCustomerKey, EncryptionAtRestWithPlatformKey]` | Specify how OS and data disks created as part of the lab are encrypted. |
| `environmentPermission` | string | `'Reader'` | `[Contributor, Reader]` | The access rights to be granted to the user when provisioning an environment. |
| `extendedProperties` | object | `{object}` |  | Extended properties of the lab used for experimental features. |
| `isolateLabResources` | string | `'Enabled'` | `[Disabled, Enabled]` | Enable lab resources isolation from the public internet. |
| `labStorageType` | string | `'Premium'` | `[Premium, Standard, StandardSSD]` | Type of storage used by the lab. It can be either Premium or Standard. |
| `location` | string | `[resourceGroup().location]` |  | Location for all Resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `managementIdentities` | object | `{object}` |  | The ID(s) to assign to the virtual machines associated with this lab. |
| `mandatoryArtifactsResourceIdsLinux` | array | `[]` |  | The ordered list of artifact resource IDs that should be applied on all Linux VM creations by default, prior to the artifacts specified by the user. |
| `mandatoryArtifactsResourceIdsWindows` | array | `[]` |  | The ordered list of artifact resource IDs that should be applied on all Windows VM creations by default, prior to the artifacts specified by the user. |
| `policies` | array | `[]` |  | Policies to create for the lab. |
| `premiumDataDisks` | string | `'Disabled'` | `[Disabled, Enabled]` | The setting to enable usage of premium data disks. When its value is "Enabled", creation of standard or premium data disks is allowed. When its value is "Disabled", only creation of standard data disks is allowed. Default is "Disabled". |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `schedules` | array | `[]` |  | Schedules to create for the lab. |
| `support` | object | `{object}` |  | The properties of any lab support message associated with this lab. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `virtualnetworks` | array | `[]` |  | Virtual networks to create for the lab. |
| `vmCreationResourceGroupId` | string | `[resourceGroup().id]` |  | Resource Group allocation for virtual machines. If left empty, virtual machines will be deployed in their own Resource Groups. Default is the same Resource Group for DevTest Lab. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the lab. |
| `resourceGroupName` | string | The resource group the lab was deployed into. |
| `resourceId` | string | The resource ID of the lab. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |
| `uniqueIdentifier` | string | The unique identifier for the lab. Used to track tags that the lab applies to each resource that it creates. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module lab './dev-test-lab/lab/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dtllcom'
  params: {
    // Required parameters
    name: 'dtllcom001'
    // Non-required parameters
    announcement: {
      enabled: 'Enabled'
      expirationDate: '2025-12-30T13:00:00Z'
      markdown: 'DevTest Lab announcement text. <br> New line. It also supports Markdown'
      title: 'DevTest announcement title'
    }
    artifactsources: [
      {
        branchRef: 'master'
        displayName: 'Public Artifact Repo'
        folderPath: '/Artifacts'
        name: 'Public Repo'
        sourceType: 'GitHub'
        status: 'Disabled'
        uri: 'https://github.com/Azure/azure-devtestlab.git'
      }
      {
        armTemplateFolderPath: '/Environments'
        branchRef: 'master'
        displayName: 'Public Environment Repo'
        name: 'Public Environment Repo'
        sourceType: 'GitHub'
        status: 'Disabled'
        uri: 'https://github.com/Azure/azure-devtestlab.git'
      }
    ]
    artifactsStorageAccount: '<artifactsStorageAccount>'
    browserConnect: 'Enabled'
    costs: {
      cycleType: 'CalendarMonth'
      status: 'Enabled'
      target: 450
      thresholdValue100DisplayOnChart: 'Enabled'
      thresholdValue100SendNotificationWhenExceeded: 'Enabled'
    }
    disableAutoUpgradeCseMinorVersion: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    encryptionDiskEncryptionSetId: '<encryptionDiskEncryptionSetId>'
    encryptionType: 'EncryptionAtRestWithCustomerKey'
    environmentPermission: 'Contributor'
    extendedProperties: {
      RdpConnectionType: '7'
    }
    isolateLabResources: 'Enabled'
    labStorageType: 'Premium'
    location: '<location>'
    lock: 'CanNotDelete'
    managementIdentities: {
      '<managedIdentityResourceId>': {}
    }
    notificationchannels: [
      {
        description: 'Integration configured for auto-shutdown'
        emailRecipient: 'mail@contosodtlmail.com'
        events: [
          {
            eventName: 'AutoShutdown'
          }
        ]
        name: 'autoShutdown'
        notificationLocale: 'en'
        webHookUrl: 'https://webhook.contosotest.com'
      }
      {
        events: [
          {
            eventName: 'Cost'
          }
        ]
        name: 'costThreshold'
        webHookUrl: 'https://webhook.contosotest.com'
      }
    ]
    policies: [
      {
        evaluatorType: 'MaxValuePolicy'
        factData: '<factData>'
        factName: 'UserOwnedLabVmCountInSubnet'
        name: '<name>'
        threshold: '1'
      }
      {
        evaluatorType: 'MaxValuePolicy'
        factName: 'UserOwnedLabVmCount'
        name: 'MaxVmsAllowedPerUser'
        threshold: '2'
      }
      {
        evaluatorType: 'MaxValuePolicy'
        factName: 'UserOwnedLabPremiumVmCount'
        name: 'MaxPremiumVmsAllowedPerUser'
        status: 'Disabled'
        threshold: '1'
      }
      {
        evaluatorType: 'MaxValuePolicy'
        factName: 'LabVmCount'
        name: 'MaxVmsAllowedPerLab'
        threshold: '3'
      }
      {
        evaluatorType: 'MaxValuePolicy'
        factName: 'LabPremiumVmCount'
        name: 'MaxPremiumVmsAllowedPerLab'
        threshold: '2'
      }
      {
        evaluatorType: 'AllowedValuesPolicy'
        factData: ''
        factName: 'LabVmSize'
        name: 'AllowedVmSizesInLab'
        status: 'Enabled'
        threshold: '<threshold>'
      }
      {
        evaluatorType: 'AllowedValuesPolicy'
        factName: 'ScheduleEditPermission'
        name: 'ScheduleEditPermission'
        threshold: '<threshold>'
      }
      {
        evaluatorType: 'AllowedValuesPolicy'
        factName: 'GalleryImage'
        name: 'GalleryImage'
        threshold: '<threshold>'
      }
      {
        description: 'Public Environment Policy'
        evaluatorType: 'AllowedValuesPolicy'
        factName: 'EnvironmentTemplate'
        name: 'EnvironmentTemplate'
        threshold: '<threshold>'
      }
    ]
    premiumDataDisks: 'Enabled'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    schedules: [
      {
        dailyRecurrence: {
          time: '0000'
        }
        name: 'LabVmsShutdown'
        notificationSettingsStatus: 'Enabled'
        notificationSettingsTimeInMinutes: 30
        status: 'Enabled'
        taskType: 'LabVmsShutdownTask'
        timeZoneId: 'AUS Eastern Standard Time'
      }
      {
        name: 'LabVmAutoStart'
        status: 'Enabled'
        taskType: 'LabVmsStartupTask'
        timeZoneId: 'AUS Eastern Standard Time'
        weeklyRecurrence: {
          time: '0700'
          weekdays: [
            'Friday'
            'Monday'
            'Thursday'
            'Tuesday'
            'Wednesday'
          ]
        }
      }
    ]
    support: {
      enabled: 'Enabled'
      markdown: 'DevTest Lab support text. <br> New line. It also supports Markdown'
    }
    tags: {
      'hidden-title': 'This is visible in the resource name'
      labName: 'dtllcom001'
      resourceType: 'DevTest Lab'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
    virtualnetworks: [
      {
        allowedSubnets: [
          {
            allowPublicIp: 'Allow'
            labSubnetName: '<labSubnetName>'
            resourceId: '<resourceId>'
          }
        ]
        description: 'lab virtual network description'
        externalProviderResourceId: '<externalProviderResourceId>'
        name: '<name>'
        subnetOverrides: [
          {
            labSubnetName: '<labSubnetName>'
            resourceId: '<resourceId>'
            sharedPublicIpAddressConfiguration: {
              allowedPorts: [
                {
                  backendPort: 3389
                  transportProtocol: 'Tcp'
                }
                {
                  backendPort: 22
                  transportProtocol: 'Tcp'
                }
              ]
            }
            useInVmCreationPermission: 'Allow'
            usePublicIpAddressPermission: 'Allow'
          }
        ]
      }
    ]
    vmCreationResourceGroupId: '<vmCreationResourceGroupId>'
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
    "name": {
      "value": "dtllcom001"
    },
    // Non-required parameters
    "announcement": {
      "value": {
        "enabled": "Enabled",
        "expirationDate": "2025-12-30T13:00:00Z",
        "markdown": "DevTest Lab announcement text. <br> New line. It also supports Markdown",
        "title": "DevTest announcement title"
      }
    },
    "artifactsources": {
      "value": [
        {
          "branchRef": "master",
          "displayName": "Public Artifact Repo",
          "folderPath": "/Artifacts",
          "name": "Public Repo",
          "sourceType": "GitHub",
          "status": "Disabled",
          "uri": "https://github.com/Azure/azure-devtestlab.git"
        },
        {
          "armTemplateFolderPath": "/Environments",
          "branchRef": "master",
          "displayName": "Public Environment Repo",
          "name": "Public Environment Repo",
          "sourceType": "GitHub",
          "status": "Disabled",
          "uri": "https://github.com/Azure/azure-devtestlab.git"
        }
      ]
    },
    "artifactsStorageAccount": {
      "value": "<artifactsStorageAccount>"
    },
    "browserConnect": {
      "value": "Enabled"
    },
    "costs": {
      "value": {
        "cycleType": "CalendarMonth",
        "status": "Enabled",
        "target": 450,
        "thresholdValue100DisplayOnChart": "Enabled",
        "thresholdValue100SendNotificationWhenExceeded": "Enabled"
      }
    },
    "disableAutoUpgradeCseMinorVersion": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "encryptionDiskEncryptionSetId": {
      "value": "<encryptionDiskEncryptionSetId>"
    },
    "encryptionType": {
      "value": "EncryptionAtRestWithCustomerKey"
    },
    "environmentPermission": {
      "value": "Contributor"
    },
    "extendedProperties": {
      "value": {
        "RdpConnectionType": "7"
      }
    },
    "isolateLabResources": {
      "value": "Enabled"
    },
    "labStorageType": {
      "value": "Premium"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "managementIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    },
    "notificationchannels": {
      "value": [
        {
          "description": "Integration configured for auto-shutdown",
          "emailRecipient": "mail@contosodtlmail.com",
          "events": [
            {
              "eventName": "AutoShutdown"
            }
          ],
          "name": "autoShutdown",
          "notificationLocale": "en",
          "webHookUrl": "https://webhook.contosotest.com"
        },
        {
          "events": [
            {
              "eventName": "Cost"
            }
          ],
          "name": "costThreshold",
          "webHookUrl": "https://webhook.contosotest.com"
        }
      ]
    },
    "policies": {
      "value": [
        {
          "evaluatorType": "MaxValuePolicy",
          "factData": "<factData>",
          "factName": "UserOwnedLabVmCountInSubnet",
          "name": "<name>",
          "threshold": "1"
        },
        {
          "evaluatorType": "MaxValuePolicy",
          "factName": "UserOwnedLabVmCount",
          "name": "MaxVmsAllowedPerUser",
          "threshold": "2"
        },
        {
          "evaluatorType": "MaxValuePolicy",
          "factName": "UserOwnedLabPremiumVmCount",
          "name": "MaxPremiumVmsAllowedPerUser",
          "status": "Disabled",
          "threshold": "1"
        },
        {
          "evaluatorType": "MaxValuePolicy",
          "factName": "LabVmCount",
          "name": "MaxVmsAllowedPerLab",
          "threshold": "3"
        },
        {
          "evaluatorType": "MaxValuePolicy",
          "factName": "LabPremiumVmCount",
          "name": "MaxPremiumVmsAllowedPerLab",
          "threshold": "2"
        },
        {
          "evaluatorType": "AllowedValuesPolicy",
          "factData": "",
          "factName": "LabVmSize",
          "name": "AllowedVmSizesInLab",
          "status": "Enabled",
          "threshold": "<threshold>"
        },
        {
          "evaluatorType": "AllowedValuesPolicy",
          "factName": "ScheduleEditPermission",
          "name": "ScheduleEditPermission",
          "threshold": "<threshold>"
        },
        {
          "evaluatorType": "AllowedValuesPolicy",
          "factName": "GalleryImage",
          "name": "GalleryImage",
          "threshold": "<threshold>"
        },
        {
          "description": "Public Environment Policy",
          "evaluatorType": "AllowedValuesPolicy",
          "factName": "EnvironmentTemplate",
          "name": "EnvironmentTemplate",
          "threshold": "<threshold>"
        }
      ]
    },
    "premiumDataDisks": {
      "value": "Enabled"
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
    "schedules": {
      "value": [
        {
          "dailyRecurrence": {
            "time": "0000"
          },
          "name": "LabVmsShutdown",
          "notificationSettingsStatus": "Enabled",
          "notificationSettingsTimeInMinutes": 30,
          "status": "Enabled",
          "taskType": "LabVmsShutdownTask",
          "timeZoneId": "AUS Eastern Standard Time"
        },
        {
          "name": "LabVmAutoStart",
          "status": "Enabled",
          "taskType": "LabVmsStartupTask",
          "timeZoneId": "AUS Eastern Standard Time",
          "weeklyRecurrence": {
            "time": "0700",
            "weekdays": [
              "Friday",
              "Monday",
              "Thursday",
              "Tuesday",
              "Wednesday"
            ]
          }
        }
      ]
    },
    "support": {
      "value": {
        "enabled": "Enabled",
        "markdown": "DevTest Lab support text. <br> New line. It also supports Markdown"
      }
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "labName": "dtllcom001",
        "resourceType": "DevTest Lab"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    },
    "virtualnetworks": {
      "value": [
        {
          "allowedSubnets": [
            {
              "allowPublicIp": "Allow",
              "labSubnetName": "<labSubnetName>",
              "resourceId": "<resourceId>"
            }
          ],
          "description": "lab virtual network description",
          "externalProviderResourceId": "<externalProviderResourceId>",
          "name": "<name>",
          "subnetOverrides": [
            {
              "labSubnetName": "<labSubnetName>",
              "resourceId": "<resourceId>",
              "sharedPublicIpAddressConfiguration": {
                "allowedPorts": [
                  {
                    "backendPort": 3389,
                    "transportProtocol": "Tcp"
                  },
                  {
                    "backendPort": 22,
                    "transportProtocol": "Tcp"
                  }
                ]
              },
              "useInVmCreationPermission": "Allow",
              "usePublicIpAddressPermission": "Allow"
            }
          ]
        }
      ]
    },
    "vmCreationResourceGroupId": {
      "value": "<vmCreationResourceGroupId>"
    }
  }
}
```

</details>
<p>

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module lab './dev-test-lab/lab/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dtllmin'
  params: {
    // Required parameters
    name: 'dtllmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "name": {
      "value": "dtllmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>
