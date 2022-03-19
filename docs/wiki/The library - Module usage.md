This section provides a guideline on how to use the CARML Bicep modules.

---

### _Navigation_

- [Deploy template](#deploy-template)
  - [PowerShell](#powershell)
  - [Azure CLI](#azure-cli)
- [Orchestrate deployment](#orchestrate-deployment)
  - [Template-orchestration](#template-orchestration)
---

# Deploy template

This section shows you how to deploy a Bicep template.

## PowerShell

This sub-section gives you an example on how to deploy a template from your local drive (file) or a publicly available remote location (URI).

<details>
<summary><i>Resource Group</i> scope</summary>

```PowerShell
New-AzResourceGroup -Name 'ExampleGroup' -Location "Central US"

$inputObject = @{
  DeploymentName    = 'ExampleDeployment'
  ResourceGroupName = 'ExampleGroup'
  # Using a local reference
  TemplateFile      = "$home\ResourceModules\arm\Microsoft.KeyVault\vault\deploy.bicep"
  # Using a remote reference
  # TemplateUri     = 'https://raw.githubusercontent.com/Azure/ResourceModules/main/arm/Microsoft.KeyVault/vaults/deploy.bicep'
}
New-AzResourceGroupDeployment @inputObject
```

For more information please refer to the official [Microsoft docs](https://docs.microsoft.com/en-us/powershell/module/az.resources/new-azresourcegroupdeployment).

</details>

<details>
<summary><i>Subscription</i> scope</summary>

```PowerShell
$inputObject = @{
  DeploymentName = 'ExampleDeployment'
  # Using a local reference
  TemplateFile   = "$home\ResourceModules\arm\Microsoft.Resources\resourceGroups\deploy.bicep"
  # Using a remote reference
  # TemplateUri  = 'https://raw.githubusercontent.com/Azure/ResourceModules/main/arm/Microsoft.Resources/resourceGroups/deploy.bicep'
}
New-AzDeployment @inputObject
```

For more information please refer to the official [Microsoft docs](https://docs.microsoft.com/en-us/powershell/module/az.resources/new-azdeployment).

</details>

<details>
<summary><i>Management group</i> scope</summary>

```PowerShell
$inputObject = @{
  DeploymentName = 'ExampleDeployment'
  # Using a local reference
  TemplateFile   = "$home\ResourceModules\arm\Microsoft.Authorization\policyAssignments\managementGroup\deploy.bicep"
  # Using a remote reference
  # TemplateUri  = 'https://raw.githubusercontent.com/Azure/ResourceModules/main/arm/Microsoft.Authorization/policyAssignments/managementGroup/deploy.bicep'
}
New-AzManagementGroupDeployment @inputObject
```

For more information please refer to the official [Microsoft docs](https://docs.microsoft.com/en-us/powershell/module/az.resources/new-azmanagementgroupdeployment).

</details>

<details>
<summary><i>Tenant</i> scope</summary>

```PowerShell
$inputObject = @{
  DeploymentName = 'ExampleDeployment'
  # Using a local reference
  TemplateFile   = "$home\ResourceModules\arm\Microsoft.Subscription\aliases\deploy.bicep"
  # Using a remote reference
  # TemplateUri  = 'https://raw.githubusercontent.com/Azure/ResourceModules/main/arm/Microsoft.Subscription/aliases/deploy.bicep'
}
New-AzTenantDeployment @inputObject
```

For more information please refer to the official [Microsoft docs](https://docs.microsoft.com/en-us/powershell/module/az.resources/new-aztenantdeployment).

</details>

## Azure CLI

<details>
<summary><i>Resource Group</i> scope</summary>

```bash
az group create --name 'ExampleGroup' --location "Central US"
$inputObject = @(
  '--name',           'ExampleDeployment',
  '--resource-group', 'ExampleGroup',
    # Using a local reference
  '--template-file',  "$home\ResourceModules\arm\Microsoft.Storage\storageAccounts\deploy.bicep",
  # Using a remote reference
  # '--template-uri',   'https://raw.githubusercontent.com/Azure/ResourceModules/main/arm/Microsoft.Storage/storageAccounts/deploy.bicep',
)
az deployment group create @inputObject
```

For more information please refer to the official [Microsoft docs](https://docs.microsoft.com/en-us/cli/azure/deployment/group?view=azure-cli-latest#az-deployment-group-create).

</details>

<details>
<summary><i>Subscription</i> scope</summary>

```bash
$inputObject = @(
  '--name',           'ExampleDeployment',
  '--resource-group', 'ExampleGroup',
    # Using a local reference
  '--template-file',  "$home\ResourceModules\arm\Microsoft.Resources\resourceGroups\deploy.bicep",
  # Using a remote reference
  # '--template-uri',  'https://raw.githubusercontent.com/Azure/ResourceModules/main/arm/Microsoft.Resources/resourceGroups/deploy.bicep',
)
az deployment sub create @inputObject
```

For more information please refer to the official [Microsoft docs](https://docs.microsoft.com/en-us/cli/azure/deployment/sub?view=azure-cli-latest#az-deployment-sub-create).

</details>

<details>
<summary><i>Management group</i> scope</summary>

```bash
$inputObject = @(
  '--name',           'ExampleDeployment',
  '--resource-group', 'ExampleGroup',
    # Using a local reference
  '--template-file',  "$home\ResourceModules\arm\Microsoft.Authorization\policyAssignments\managementGroup\deploy.bicep",
  # Using a remote reference
  # '--template-uri',  'https://raw.githubusercontent.com/Azure/ResourceModules/main/arm/Microsoft.Authorization/policyAssignments/managementGroup/deploy.bicep',
)
az deployment mg create @inputObject
```

For more information please refer to the official [Microsoft docs](https://docs.microsoft.com/en-us/cli/azure/deployment/mg?view=azure-cli-latest#az-deployment-mg-create).

</details>

<details>
<summary><i>Tenant</i> scope</summary>

```bash
$inputObject = @(
  '--name',           'ExampleDeployment',
  '--resource-group', 'ExampleGroup',
    # Using a local reference
  '--template-file',  "$home\ResourceModules\arm\Microsoft.Subscription\aliases\deploy.bicep",
  # Using a remote reference
  # '--template-uri',  'https://raw.githubusercontent.com/Azure/ResourceModules/main/arm/Microsoft.Subscription/aliases/deploy.bicep',
)
az deployment tenant create @inputObject
```

For more information please refer to the official [Microsoft docs](https://docs.microsoft.com/en-us/cli/azure/deployment/tenant?view=azure-cli-latest#az-deployment-tenant-create).

</details>

---

# Orchestrate deployment

If you're interested on how to build a solution from the modules, please refer to the corresponding ['Solution creation'](./Solution%20creation) section.
