# ComputeVirtualmachines `[Microsoft.Compute/virtualMachines]`

This module deploys one or multiple Virtual Machines.

## Resource Types

## Parameters

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

## Template references

| Output Name                   | Type   | Description                                           |
| :---------------------------- | :----- | :---------------------------------------------------- |
| `virtualMachineName`          | string | The name of the VM.                                   |
| `virtualMachineResourceGroup` | string | The name of the Resource Group the VM was created in. |
| `virtualMachineResourceId`    | string | The Resource Id of the VM.                            |
