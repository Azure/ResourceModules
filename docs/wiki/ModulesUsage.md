This section gives you an overview of how to use the bicep modules.

---
### _Navigation_
- [Deploy local template](#Deploy-local-template)
  - [Azure CLI](#Local:-Azure-CLI)
  - [PowerShell](#Local:-PowerShell)
- [Deploy remote template](#Deploy-remote-template)
  - [Azure CLI](#Remote:-Azure-CLI)
  - [PowerShell](#Remote:-PowerShell)
---

# Deploy local template

## Local: Azure CLI

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

## Local: PowerShell

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

# Deploy remote template

## Remote: Azure CLI

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

## Remote: PowerShell

```PowerShell
New-AzResourceGroup -Name 'ExampleGroup' -Location "Central US"

$inputObject = @{
 Name              = 'ExampleDeployment'
 ResourceGroupName = 'ExampleGroup'
 TemplateUri       = 'https://raw.githubusercontent.com/MrMCake/ResourceModules/main/arm/Microsoft.KeyVault/vaults/deploy.json'
}
New-AzResourceGroupDeployment @inputObject
```

