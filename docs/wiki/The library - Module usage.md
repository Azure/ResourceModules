This section provides a guideline on how to use the CARML Bicep modules.

---

### _Navigation_

- [Deploy template](#deploy-template)
  - [PowerShell](#powershell)
  - [Azure CLI](#azure-cli)
  - [As nested deployment](#as-nested-deployment)
- [Orchestrate deployment](#orchestrate-deployment)
---

# Deploy template

This section shows you how to deploy a Bicep template.

## PowerShell

This sub-section gives you an example on how to deploy a template from your local drive (file) or a publicly available remote location (URI).

<details>
<summary><i>Resource Group</i> scope</summary>

To be used if the targeted scope in the first line of the template is:
- **Bicep:** `targetScope = 'resourceGroup'` or empty (as default)
- **ARM:** `"$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"`

Using parameter file
```PowerShell
New-AzResourceGroup -Name 'ExampleGroup' -Location "Central US"

$inputObject = @{
  DeploymentName        = 'ExampleDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ResourceGroupName     = 'ExampleGroup'
  TemplateParameterFile = 'parameters.json'
  # Using a local reference
  TemplateFile          = "$home\ResourceModules\modules\key-vault\vault\main.bicep"
  # Using a remote reference
  # TemplateUri         = 'https://raw.githubusercontent.com/Azure/ResourceModules/main/modules/key-vault/vault/main.bicep'
}
New-AzResourceGroupDeployment @inputObject
```

For more information, please refer to the official [Microsoft docs](https://learn.microsoft.com/en-us/powershell/module/az.resources/new-azresourcegroupdeployment).

</details>

<details>
<summary><i>Subscription</i> scope</summary>

To be used if the targeted scope in the first line of the template is:
- **Bicep:** `targetScope = 'subscription'`
- **ARM:** `"$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#"`

```PowerShell
$inputObject = @{
  DeploymentName        = 'ExampleDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  TemplateParameterFile = 'parameters.json'
  Location              = 'EastUS2'
  # Using a local reference
  TemplateFile          = "$home\ResourceModules\modules\resources\resource-group\main.bicep"
  # Using a remote reference
  # TemplateUri         = 'https://raw.githubusercontent.com/Azure/ResourceModules/main/modules/resources/resource-group/main.bicep'
}
New-AzDeployment @inputObject
```

For more information, please refer to the official [Microsoft docs](https://learn.microsoft.com/en-us/powershell/module/az.resources/new-azdeployment).

</details>

<details>
<summary><i>Management group</i> scope</summary>

To be used if the targeted scope in the first line of the template is:
- **Bicep:** `targetScope = 'managementGroup'`
- **ARM:** `"$schema": "https://schema.management.azure.com/schemas/2018-05-01/managementGroupDeploymentTemplate.json#"`

```PowerShell
$inputObject = @{
  DeploymentName        = 'ExampleDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ManagementGroupId     = 'myManagementGroup'
  Location              = 'EastUS2'
  TemplateParameterFile = 'parameters.json'
  # Using a local reference
  TemplateFile          = "$home\ResourceModules\modules\authorization\policy-assignment\management-group\main.bicep"
  # Using a remote reference
  # TemplateUri         = 'https://raw.githubusercontent.com/Azure/ResourceModules/main/modules/authorization/policy-assignments/management-group/main.bicep'
}
New-AzManagementGroupDeployment @inputObject
```

For more information, please refer to the official [Microsoft docs](https://learn.microsoft.com/en-us/powershell/module/az.resources/new-azmanagementgroupdeployment).

</details>

<details>
<summary><i>Tenant</i> scope</summary>

To be used if the targeted scope in the first line of the template is:
- **Bicep:** `targetScope = 'tenant'`
- **ARM:** `"$schema": "https://schema.management.azure.com/schemas/2019-08-01/tenantDeploymentTemplate.json#",     `

```PowerShell
$inputObject = @{
  DeploymentName        = 'ExampleDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  TemplateParameterFile = 'parameters.json'
  Location              = 'EastUS2'
  # Using a local reference
  TemplateFile          = "$home\ResourceModules\modules\subscription\alias\main.bicep"
  # Using a remote reference
  # TemplateUri         = 'https://raw.githubusercontent.com/Azure/ResourceModules/main/modules/subscription/alias/main.bicep'
}
New-AzTenantDeployment @inputObject
```

For more information, please refer to the official [Microsoft docs](https://learn.microsoft.com/en-us/powershell/module/az.resources/new-aztenantdeployment).

</details>

## Azure CLI

<details>
<summary><i>Resource Group</i> scope</summary>

To be used if the targeted scope in the first line of the template is:
- **Bicep:** `targetScope = 'resourceGroup'` or empty (as default)
- **ARM:** `"$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"`

```bash
az group create --name 'ExampleGroup' --location "Central US"
$inputObject = @(
  '--name',           ('ExampleDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])),
  '--resource-group', 'ExampleGroup',
  '--parameters',     '@parameters.json',
  # Using a local reference
  '--template-file',  "$home\ResourceModules\modules\storage\storage-account\main.bicep",
  # Using a remote reference
  # '--template-uri',   'https://raw.githubusercontent.com/Azure/ResourceModules/main/modules/storage/storage-account/main.bicep'
)
az deployment group create @inputObject
```

For more information, please refer to the official [Microsoft docs](https://learn.microsoft.com/en-us/cli/azure/deployment/group?view=azure-cli-latest#az-deployment-group-create).

</details>

<details>
<summary><i>Subscription</i> scope</summary>

To be used if the targeted scope in the first line of the template is:
- **Bicep:** `targetScope = 'subscription'`
- **ARM:** `"$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#"`

```bash
$inputObject = @(
  '--name',           ('ExampleDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])),
  '--parameters',     '@parameters.json',
  '--location',       'EastUS2',
  # Using a local reference
  '--template-file',  "$home\ResourceModules\modules\resources\resource-group\main.bicep"
  # Using a remote reference
  # '--template-uri',  'https://raw.githubusercontent.com/Azure/ResourceModules/main/modules/resources/resource-group/main.bicep'
)
az deployment sub create @inputObject
```

For more information, please refer to the official [Microsoft docs](https://learn.microsoft.com/en-us/cli/azure/deployment/sub?view=azure-cli-latest#az-deployment-sub-create).

</details>

<details>
<summary><i>Management group</i> scope</summary>

To be used if the targeted scope in the first line of the template is:
- **Bicep:** `targetScope = 'managementGroup'`
- **ARM:** `"$schema": "https://schema.management.azure.com/schemas/2018-05-01/managementGroupDeploymentTemplate.json#"`

```bash
$inputObject = @(
  '--name',                ('ExampleDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])),
  '--parameters',          '@parameters.json',
  '--location',            'EastUS2',
  '--management-group-id', 'myManagementGroup',
  # Using a local reference
  '--template-file',       "$home\ResourceModules\modules\authorization\policy-assignment\management-group\main.bicep"
  # Using a remote reference
  # '--template-uri',      'https://raw.githubusercontent.com/Azure/ResourceModules/main/modules/authorization/policy-assignment/management-group/main.bicep'
)
az deployment mg create @inputObject
```

For more information, please refer to the official [Microsoft docs](https://learn.microsoft.com/en-us/cli/azure/deployment/mg?view=azure-cli-latest#az-deployment-mg-create).

</details>

<details>
<summary><i>Tenant</i> scope</summary>

To be used if the targeted scope in the first line of the template is:
- **Bicep:** `targetScope = 'tenant'`
- **ARM:** `"$schema": "https://schema.management.azure.com/schemas/2019-08-01/tenantDeploymentTemplate.json#",     `

```bash
$inputObject = @(
  '--name',           ('ExampleDeployment-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])),
  '--parameters',     '@parameters.json',
  '--location',       'EastUS2',
  # Using a local reference
  '--template-file',  "$home\ResourceModules\modules\subscription\alias\main.bicep"
  # Using a remote reference
  # '--template-uri',  'https://raw.githubusercontent.com/Azure/ResourceModules/main/modules/subscription/alias/main.bicep'
)
az deployment tenant create @inputObject
```

For more information, please refer to the official [Microsoft docs](https://learn.microsoft.com/en-us/cli/azure/deployment/tenant?view=azure-cli-latest#az-deployment-tenant-create).

</details>

# As nested deployment

You can also reference modules in another template using the below syntax. To deploy this 'orchestration template' you can again use the commands described [above](#deploy-template). You can also find further information in the 'Template Orchestration' section of [Solution Creation](./Solution%20creation) site.

```bicep
// Using local reference
module testDeployment 'ResourceModules/modules/key-vault/vault/main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-example'
  params: { ... }
}

// Using Template-Specs reference (with configuration file)
module testDeployment 'ts/modules:key-vault.vault:1.0.0' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-example'
  params: { ... }
}

// Using Bicep reference
module testDeployment 'br:<registry-name>.azurecr.io/bicep/modules/key-vault.vault:1.0.0' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-example'
  params: { ... }
}
```

---

# Orchestrate deployment

If you're interested on how to build a solution from the modules, please refer to the corresponding ['Solution creation'](./Solution%20creation) section.
