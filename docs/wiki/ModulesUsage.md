# Modules Usage

This section gives you an overview of how to use the bicep modules.

---

### _Navigation_

- [Deploy local template](#deploy-local-template)
  - [**Local:** PowerShell](#local-powershell)
  - [**Local:** Azure CLI](#local-azure-cli)
- [Deploy remote template](#deploy-remote-template)
  - [**Remote:** PowerShell](#remote-powershell)
  - [**Remote:** Azure CLI](#remote-azure-cli)

---

## Deploy local template

### **Local:** PowerShell

This example targets a resource group level template.

```PowerShell
New-AzResourceGroup -Name 'ExampleGroup' -Location "Central US"

$inputObject = @{
 DeploymentName    = 'ExampleDeployment'
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
 DeploymentName    = 'ExampleDeployment'
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
