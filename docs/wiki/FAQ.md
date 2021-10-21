## FAQ

### What is a Resource Module?
A Resource Module is a reusable building block. A Module encapsulates one or more Azure resources and their respective configurations for reuse in your Azure environment.

## Getting Started

### Prerequisites

To be able to deploy [ARM][AzureResourceManager] templates you should have latest version [PowerShell 7][PowerShellDocs] + [Azure Az Module][InstallAzPs] or [Azure CLI](<https://docs.microsoft.com/en-us/cli/azure/>)as well as [Bicep][Bicep] installed.



### Installation

#### One-liner to install or update Azure CLI

```PowerShell
# Windows 10
iwr https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; start msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi

# Linux
curl -L https://aka.ms/InstallAzureCli | bash
```

#### One-liner to install or update PowerShell 7 on Windows 10

```PowerShell
iex "&amp; { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
```

Make sure to install Azure Az Module as well.

```PowerShell
iex "&amp; { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
```

### Usage

#### Deploy local template (Azure CLI)

```bash
az group create --name ExampleGroup --location "Central US"
az deployment group create \
  --name ExampleDeployment \
  --resource-group ExampleGroup \
  --template-file <path-to-template> \
  --parameters storageAccountType=Standard_GRS
```

#### Deploy local template (PowerShell)

```PowerShell
New-AzResourceGroup -Name ExampleGroup -Location "Central US"
New-AzResourceGroupDeployment `
  -Name ExampleDeployment `
  -ResourceGroupName ExampleGroup `
  -TemplateFile <path-to-template>
```

#### Deploy remote template (Azure CLI)

```bash
az group create --name ExampleGroup --location "Central US"
az deployment group create \
  --name ExampleDeployment \
  --resource-group ExampleGroup \
  --template-uri "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.storage/storage-account-create/azuredeploy.json" \
  --parameters storageAccountType=Standard_GRS
```

#### Deploy remote template (PowerShell)

```PowerShell
New-AzResourceGroup -Name ExampleGroup -Location "Central US"
New-AzResourceGroupDeployment `
  -Name remoteTemplateDeployment `
  -ResourceGroupName ExampleGroup `
  -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.storage/storage-account-create/azuredeploy.json
```

## Module Dependencies
In order to successfully deploy and test all Modules in your desired environment some Modules have to have resources deployed beforehand.

Of course it is obvious and by default one should know which Azure Service needs specific resources to be deployed beforehand but here is the full list of Modules which have dependencies on other Services.

> **Note**<br>
If we speak from **Modules** in this context we mean the **Services** which get created from these Modules.

### Services (in order)
1. VirtualNetwork
1. StorageAccounts
1. KeyVault
1. LogAnalytics
1. PublicIPPrefix
1. PublicIPAddresses
1. EventHubNamespaces
1. EventHubs (only needed if EventHubs are used for Monitoring in addition to LAs)
1. ActionGroup
1. AzureSqlServer
1. AppServicePlan
1. SharedImageGallery
1. ApplicationSecurityGroups
1. NetworkSecurityGroups
1. WvdHostPool
1. WvdAppliccationGroups
1. Managed Service Identity
1. Deployment Scripts

## Modules with Dependencies

- ActivityLog
  - ActionGroup
- ActivityLogAlert
  - ActionGroup
- AzureBastion
  - VirtualNetwork / AzureBastionSubnet
- AzureFirewall
  - VirtualNetwork / AzureFirewallSubnet
- AzureNetAppFiles
  - VirtualNetwork / NetApp enabled subnet
- AzureSecurityCenter
  - LogAnalyticsWorkspace
- AzureSqlDatabase
  - AzureSqlServer
- DiskEncryptionSet
  - KeyVault / Key (encryptionKey)
- Deployment Scripts
  - Managed Service Identity
- EventHubs
  - EventHubNamespaces
- FunctionApp
  - AppServicePlan
- ImageTemplates
  - SharedImageGallery
- LoadBalancer
  - PublicIPAddresses
- MetricAlert
  - ActionGroup
  - VirtualMachines
- NetworkSecurityGroups
  - ApplicationSecurityGroups
- NSGFlowLogs
  - NetworkWatcher (needs to reside in same RG)
  - NetworkSecurityGroups
  - StorageAccount (Diagnostics)
- SQLManagedInstances
  - VirtualNetwork / Subnet
  - KeyVault / Key
  - StorageAccount / vulnerabilityAssessmentsStorageAccountId
- SQLManagedInstancesDatabases
  - SQLManagedInstances
- VirtualMachines
  - VirtualNetwork / Subnet
  - KeyVault / Secrets (admiUsername, adminPassword)
- VirtualMachineScaleSet
  - VirtualNetwork / Subnet
  - KeyVault / Secrets (admiUsername, adminPassword)
- VirtualNetworkGateway
  - PublicIPPrefix
  - VirtualNetwork (in the same rg, like AFW)
- VirtualNetworkGatewayConnection
  - KeyVault / Secret (vpnSharedKey)
- WebApp
  - AppServicePlan
- WvdApplicationGroups
  - WvdHostPool
- WvdApplications
  - WvdAppliccationGroups

## Secrets and Keys

1. KeyVault needs secrets to be created
   - administratorLogin for AzureSQLServer
   - administratorLoginPassword for AzureSQLServer
   - encryptionKey for DiskEncryptionSet
   - adminUserName for VirtualMachine
   - adminPassword for VirtualMachine
1. DiskEncryptionSet needs key pre-created (encryptionKey)
1. SQLManagedInstance needs key pre-created (encryptionKeySqlMi)
   - administratorLogin
   - administratorLoginPassword

## Reporting Issues and Feedback

### Issues and Bugs

If you find any bugs, please file an issue in the [GitHub Issues][GitHubIssues] page. Please fill out the provided template with the appropriate information.
> Please search the existing issues before filing new issues to avoid duplicates.

If you are taking the time to mention a problem, even a seemingly minor one, it is greatly appreciated, and a totally valid contribution to this project. **Thank you!**

### Feedback

If there is a feature you would like to see in here, please file an issue or feature request in the [GitHub Issues][GitHubIssues] page to provide direct feedback.

## Contribution

### Setting up yopur environment for contribution

1. Fork and clone the repo.
  * Set up a upstream, to pull from the Azure/ResourceModule repo (integration check before PR).
   ```
     git remote add upstream https://github.com/Azure/ResourceModules
     git fetch upstream
   ```

2. Set up a secret in your repo for `AZURE_CREDENTIALS` for testing changes with workflows in your own environment. The permissions that the SPN needs differ between modules. Required permissions are in some cases documented in the modules readme. See [Azure/login](https://github.com/Azure/login) for more info about the secret creation.

3. Create a branch in your own repo and do the changes. The PR will be between your working fork/branch and <upstream>/main. For the PR, follow the PR template.

4. Follow the guidelines below for the changes you do when converting/creating a module.
  * To convert a json template to bicep use `bicep decompile deploy.json --outfile deploy.bicep`
  * To convert from bicep to json use `bicep build deploy.bicep --outfile deploy.json`

### How to contribute a module?

Modules in the repository are structured via the module's main resource provider (e.g. `Microsoft.Web/serverfarms`) where each section corresponds to its place in the hierarchy. However, for cases that do not fit into this schema we provide the following guidance:
- **Sub-Resources**<p>
  Resources like `Microsoft.Sql/servers` may have dedicated modules for sub-resources such as `Microsoft.Sql/servers/databases`. In these cases we recommend to create a subfolder with the 'parent folder name and suffix `"Resources"`' on the same level as the parent (e.g. `serversResources`) and place the sub-resource module inside this folder. In the given example we would have the following folder structure:
  ```
  Microsoft.Sql
  ├─ servers [module]
  └─ serversResources
     └─ databases [module]
  ```
- **Overlapping/Ambigious providers**<p>
  There may be cases where a folder is already leveraged by a different module with the same provider (e.g. `Microsoft.Web/sites`). In these cases we recommend to add an additional layer into the hierarchy by moving the module that originally populated the conflicting folder into a sub-folder of the same using a meaningful name. The new module can then be positioned on the same level, again with a meaningful name. For example:
  ```
  Microsoft.Web
  ├─ serverfarms [module]
  └─ sites [the conflicting name - now shared as a parent folder]
     ├─ webApp [module]
     └─ functionApp [module]
  ```
### Bicep module authoring guidelines

Files and folders within the module folder are all in lower case.

``` txt
    Microsoft.Web
    └─ sites
       ├─ .bicep
       |  ├─ nested_resourceName1.bicep
       |  └─ nested_resourceName2.bicep
       ├─parameters
       |  └─ parameters.json
       ├─ deploy.bicep
       └─ readme.md
```

Within a bicep file, follow the following conventions:

- Parameters:
  - camelCase, i.e `resourceGroupName`
  - Descriptions contain type of requirement:
    - `Optional` - Is not needed at any point. Module contains default values.
    - `Required` - Is required to be provided. Module does not have a default value and will expect input.
    - `Generated` - Should not be used to provide a parameter. Used to generate data used in the deployment that cannot be generated other places in the template. i.e. the `utcNow()` function.
    - `Conditional` - Optional or required parameter depending on other inputs.

- Variables:
  - camelCase, i.e `builtInRoleNames`
  - For modules that manage roleAssignments, update the list of roles to only be the applicable roles. One way of doing this:
    - Deploy an instance of the resource you are working on, go to IAM page and copy the list from Roles.
    - Use the following script to generate and output the applicable roles needed in the bicep/ARM module:
``` pwsh
$rawRoles = @"
<paste the table here>
"@
$resourceRoles = @()
$rawRolesArray = $rawRoles -split "`n"
for ($i = 0; $i -lt $rawRolesArray.Count; $i++) {
  if($i % 5 -eq 0) {
    $resourceRoles += $rawRolesArray[$i].Trim()
  }
}
$allRoles = az role definition list --custom-role-only false --query '[].{roleName:roleName, id:id, roleType:roleType}' | ConvertFrom-Json
$resBicep = [System.Collections.ArrayList]@()
$resArm = [System.Collections.ArrayList]@()
foreach ($resourceRole in $resourceRoles) {
  $matchingRole = $allRoles | Where-Object { $_.roleName -eq $resourceRole }
  $resBicep += "'{0}': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','{1}')" -f $resourceRole, ($matchingRole.id.split('/')[-1])
  $resArm += "`"{0}`": `"[subscriptionResourceId('Microsoft.Authorization/roleDefinitions','{1}')]`"," -f $resourceRole, ($matchingRole.id.split('/')[-1])
}
Write-Host "Bicep"
Write-Host "-----"
$resBicep
Write-Host "ARM"
Write-Host "---"
$resArm
```

- Resource:
  - camelCase, i.e `resourceGroup`
  - The name used as a reference is the singular name of the resource that it deploys, i.e:
    - `resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01'`
    - `resource virtualMachine 'Microsoft.Compute/virtualMachines@2020-06-01'`
  - For child resources, use a shorthand of the resource type declaration, i.e:
    - `resource serviceBusNamespace_authorizationRules 'AuthorizationRules@2020-06-01'`

- Modules:
  - camel_Snake_Case, i.e `resourceGroup_rbac` ?
  - All module references go into a child folder on the module called `.bicep`
  - File name for nested module is structured as follows: `nested_<resourceName>.bicep` i.e:
    - `nested_rbac.bicep`

- Outputs:
  - camelCase, i.e `resourceGroupResourceId`
  - At a minimum, reference the following:
    - `<resourceReference>Name`, i.e. `resourceGroupName`
    - `<resourceReference>ResourceId`, i.e. `resourceGroupResourceId`

#### Testing your Bicep module

When you have done your changes and want to validate, run the following:

```pwsh
Invoke-Pester -Configuration @{
    Run        = @{
        Container = New-PesterContainer -Path 'arm/.global/global.module.tests.ps1' -Data @{
            moduleFolderPaths = "C:\dev\ip\Azure-ResourceModules\ResourceModules\arm\Microsoft.EventGrid/topics"
        }
    }
    Filter     = @{
        #ExcludeTag = 'ApiCheck'
        #Tag = 'ApiCheck'
    }
    TestResult = @{
        TestSuiteName = 'Global Module Tests'
        Enabled       = $false
    }
    Output     = @{
        Verbosity = 'Detailed'
    }
}
```

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.

## Learn More

* [PowerShell Documentation][PowerShellDocs]
* [Microsoft Azure Documentation][MicrosoftAzureDocs]
* [Azure Resource Manager][AzureResourceManager]
* [Bicep][Bicep]
* [GitHubDocs][GitHubDocs]

<!-- References -->

<!-- Local -->
[ProjectSetup]: <https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions>
[GitHubDocs]: <https://docs.github.com/>
[AzureDevOpsDocs]: <https://docs.microsoft.com/en-us/azure/devops/?view=azure-devops>
[GitHubIssues]: <https://github.com/Azure/Modules/issues>
[Contributing]: CONTRIBUTING.md
[AzureIcon]: docs/media/MicrosoftAzure-32px.png
[PowershellIcon]: docs/media/MicrosoftPowerShellCore-32px.png
[BashIcon]: docs/media/Bash_Logo_black_and_white_icon_only-32px.svg.png

<!-- External -->
[Bicep]: <https://github.com/Azure/bicep>
[Az]: <https://img.shields.io/powershellgallery/v/Az.svg?style=flat-square&label=Az>
[AzGallery]: <https://www.powershellgallery.com/packages/Az/>
[PowerShellCore]: <https://github.com/PowerShell/PowerShell/releases/latest>
[InstallAzPs]: <https://docs.microsoft.com/en-us/powershell/azure/install-az-ps>
[AzureResourceManager]: <https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview>

<!-- Docs -->
[MicrosoftAzureDocs]: <https://docs.microsoft.com/en-us/azure/>
[PowerShellDocs]: <https://docs.microsoft.com/en-us/powershell/>
