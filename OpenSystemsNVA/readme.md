# Opensystems NVA

This module deploys an OpenSystems NVA from an Azure Image into an availability set.


## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Compute/availabilitySets`|2017-12-01|
|`Microsoft.Network/publicIPAddresses`|2020-08-01|
|`Microsoft.Network/networkInterfaces`|2020-08-01|
|`Microsoft.Compute/virtualMachines`|2017-12-01|
|`Microsoft.Resources/deployments`|2020-06-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `availabilitySetName` | string | Required. Availability Set Name. | AS-wind-sg000 |  |
| `eth0SubnetName` | string | Required. External Subnet for interface eth0 | sxx-az-subnet-weu-x-001 |  |
| `eth1SubnetName` | string | Required. Internal Subnet for interface eth1 | sxx-az-subnet-weu-x-002 |  |
| `eth2SubnetName` | string | Required. External Subnet for interface eth2 | sxx-az-subnet-weu-x-003 |  |
| `eth3SubnetName` | string | Required. External Subnet for interface eth3 | sxx-az-subnet-weu-x-004 |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `osImage` | string | Required. OS Image for VM. | /subscriptions/<subscriptionId>/resourceGroups/dependencies-rg/providers/Microsoft.Compute/images/sxx-az-img-weu-x-002 |  |
| `vm1Eth0PrivateAddress` | string | Required. VM1 private address. | 10.0.0.6 |  |
| `vm1Eth1PrivateAddress` | string | Required. VM1 private address. | 10.0.1.6 |  |
| `vm1Eth2PrivateAddress` | string | Required. VM1 private address. | 10.0.2.6 |  |
| `vm1Eth3PrivateAddress` | string | Required. VM1 private address. | 10.0.3.6 |  |
| `vm1Name` | string | Required. VM1 Name. | wind-sg000-azu-euw-1 |  |
| `vm2Eth0PrivateAddress` | string | Required. VM2 private address. | 10.0.0.7 |  |
| `vm2Eth1PrivateAddress` | string | Required. VM2 private address. | 10.0.1.7 |  |
| `vm2Eth2PrivateAddress` | string | Required. VM2 private address. | 10.0.2.7 |  |
| `vm2Eth3PrivateAddress` | string | Required. VM2 private address. | 10.0.3.7 |  |
| `vm2Name` | string | Required. VM2 Name. | wind-sg000-azu-euw-2 |  |
| `vmSize` | string | Required. Size of VM. | Standard_D8s_v3 |  |
| `vnetId` | string | Required. Virtual Network resource ID. | /subscriptions/<subscriptionId>/resourceGroups/dependencies-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-002 |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |

### Resource Details

| Resource Type | Resource Name |  Resource Comment |
| --- | --- | --- |
| Microsoft.Compute/availabilitySets| [parameters('availabilitySetName')] |  |
| Microsoft.Network/publicIPAddresses| [variables('vm1PublicIPAddressName')] |  |
| Microsoft.Network/publicIPAddresses| [variables('vm1PublicIPAddressName2')] |  |
| Microsoft.Network/publicIPAddresses| [variables('vm1PublicIPAddressName3')] |  |
| Microsoft.Network/publicIPAddresses| [variables('vm2PublicIPAddressName')] |  |
| Microsoft.Network/publicIPAddresses| [variables('vm2PublicIPAddressName2')] |  |
| Microsoft.Network/publicIPAddresses| [variables('vm2PublicIPAddressName3')] |  |
| Microsoft.Network/networkInterfaces| [variables('vm1Nic0Name')] |  |
| Microsoft.Network/networkInterfaces| [variables('vm1Nic1Name')] |  |
| Microsoft.Network/networkInterfaces| [variables('vm1Nic2Name')] |  |
| Microsoft.Network/networkInterfaces| [variables('vm1Nic3Name')] |  |
| Microsoft.Compute/virtualMachines| [parameters('vm1Name')] |  |
| Microsoft.Network/networkInterfaces| [variables('vm2Nic0Name')] |  |
| Microsoft.Network/networkInterfaces| [variables('vm2Nic1Name')] |  |
| Microsoft.Network/networkInterfaces| [variables('vm2Nic2Name')] |  |
| Microsoft.Network/networkInterfaces| [variables('vm2Nic3Name')] |  |
| Microsoft.Compute/virtualMachines| [parameters('vm2Name')] |  |

### Parameter Usage: `vNetId`

```json
"vNetId": {
    "value": "/subscriptions/00000000/resourceGroups/resourceGroup"
}
```


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `vm1Name` | string | The name of the VM. |
| `vm1NameResourceGroup` | string | The Resource Group in which the resource is created. |
| `vm1NameResourceId` | string | The VM Resource ID. |

## Considerations

*N/A*

## Additional resources

- [AvAilAbilitySets](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2017-12-01/availabilitySets)
- [PublicIPAddresses](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/publicIPAddresses)
- [PublicIPAddresses](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/publicIPAddresses)
- [PublicIPAddresses](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/publicIPAddresses)
- [PublicIPAddresses](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/publicIPAddresses)
- [PublicIPAddresses](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/publicIPAddresses)
- [PublicIPAddresses](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/publicIPAddresses)
- [NetworkINterfaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/networkInterfaces)
- [NetworkINterfaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/networkInterfaces)
- [NetworkINterfaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/networkInterfaces)
- [NetworkINterfaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/networkInterfaces)
- [VirtualMachines](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2017-12-01/virtualMachines)
- [NetworkINterfaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/networkInterfaces)
- [NetworkINterfaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/networkInterfaces)
- [NetworkINterfaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/networkInterfaces)
- [NetworkINterfaces](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2018-02-01/networkInterfaces)
- [VirtualMachines](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Compute/2017-12-01/virtualMachines)