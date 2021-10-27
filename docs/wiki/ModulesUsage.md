# Modules Usage

This section gives you an overview of how to use the bicep modules.

---
### _Navigation_
- [Deploy local template](#Deploy-local-template)
  - [PowerShell](#Local-PowerShell)
  - [Azure CLI](#Local-Azure-CLI)
- [Deploy remote template](#Deploy-remote-template)
  - [PowerShell](#Remote-PowerShell)
  - [Azure CLI](#Remote-Azure-CLI)
---

## Deploy local template

### **Local:** PowerShell

This example targets a resource group level template.

```PowerShell
New-AzResourceGroup -Name 'ExampleGroup' -Location "Central US"

$inputObject = @{
 Name              = 'ExampleDeployment'
 ResourceGroupName = 'ExampleGroup'
 TemplateFile      = "$home\Microsoft.KeyVault\vault\deploy.bicep"
}
New-AzResourceGroupDeployment @inputObject
```

### **Local:** Azure CLI

This example targets a resource group level template.

```bash
az group create --name 'ExampleGroup' --location "Central US"
$inputObject = @(
    '--name',           'ExampleDeployment',
    '--resource-group', 'ExampleGroup',
    '--template-file',  "$home\Microsoft.KeyVault\vault\deploy.bicep",
    '--parameters',     'storageAccountType=Standard_GRS',
)
az deployment group create @inputObject
```

## Deploy remote template


### **Remote:** PowerShell

```PowerShell
New-AzResourceGroup -Name 'ExampleGroup' -Location "Central US"

$inputObject = @{
 Name              = 'ExampleDeployment'
 ResourceGroupName = 'ExampleGroup'
 TemplateUri       = 'https://raw.githubusercontent.com/MrMCake/ResourceModules/main/arm/Microsoft.KeyVault/vaults/deploy.json'
}
New-AzResourceGroupDeployment @inputObject
```



### **Remote:** Azure CLI

```bash
az group create --name 'ExampleGroup' --location "Central US"

$inputObject = @(
    '--name',           'ExampleDeployment',
    '--resource-group', 'ExampleGroup',
    '--template-uri',   'https://raw.githubusercontent.com/MrMCake/ResourceModules/main/arm/Microsoft.KeyVault/vaults/deploy.json',
    '--parameters',     'storageAccountType=Standard_GRS',
)
az deployment group create @inputObject
```
