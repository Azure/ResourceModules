# Getting started

This section will give on an overview on how to get started using this repository.

---

### _Navigation_

- [General prerequisites](#general-prerequisites)
- [Where to start](#where-to-start)
  - [**Option 1**: Use it as a basis to set up your own inner-source project](#option-1-use-it-as-a-basis-to-set-up-your-own-inner-source-project)
    - [Fork the repository](#fork-the-repository)
    - [Service Names](#service-names)
    - [Dependencies](#dependencies)
    - [GitHub-specific prerequisites](#github-specific-prerequisites)
  - [**Option 2**: Use it as a local reference to build bicep templates](#option-2-use-it-as-a-local-reference-to-build-bicep-templates)
    - [Clone / download the repository](#clone--download-the-repository)
  - [**Option 3**: Use it as remote reference to reference the bicep templates](#option-3-use-it-as-remote-reference-to-reference-the-bicep-templates)

---

Let us first answer the question what a Resource Module is:
> A Resource Module is a reusable, template-based building block to deploy Azure resources. It encapsulates one or more Azure resources and their respective configurations for use in your Azure environment.

## General prerequisites

No matter from where you start you have to account for some general prerequisites when it comes to bicep and this repository.
To ensure you can use all the content in this repostiroy you'd want to install

- The latest PowerShell version [PowerShell 7][PowerShellDocs]

  ```PowerShell
  # Windows one-liner
  winget install --name PowerShell --exact --source winget

  # Linux one-liner
  wget https://aka.ms/install-powershell.sh; sudo bash install-powershell.sh; rm install-powershell.sh
  ```

> Source: [Install PowerShell on Windows, Linux, and macOS][InstallPS]

- The [Azure Az Module][InstallAzPs] / or at least modules such as `Az.Accounts` & `Az.Resources`

  ```PowerShell
  # One-liner
  Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
  ```

- The [Azure CLI][AzCLI]

  ```PowerShell
  # Windows one-liner
  winget install --id Microsoft.AzureCLI --exact

  # Linux one-liner
  curl -L https://aka.ms/InstallAzureCli | bash
  ```

> Source: [How to install the Azure CLI][InstallAzCLI]

- And of course [Bicep][Bicep]

```PowerShell
# Windows one-liner
winget install --id Microsoft.Bicep --exact

# Linux
# Fetch the latest Bicep CLI binary
curl -Lo bicep https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64
# Mark it as executable
chmod +x ./bicep
# Add bicep to your PATH (requires admin)
sudo mv ./bicep /usr/local/bin/bicep
# Verify you can now access the 'bicep' command
bicep --help
# Done!
```

> Source: [Install Bicep tools][InstallBicep]
> ***Note***: This only affects the machine that would deploy or interact with the bicep templates (for example your local machine or a pipeline agent).

## Where to start

Depending on how you want to use this repositories content you may go down different paths to get started.

### **Option 1**: Use it as a basis to set up your own inner-source project

The repository is set up in a way that you can essentially create your own private 1:1 copy and would be able to re-use the same concepts and functionality in your own environment like GitHub. This set up is a 2-step process. First, you have to either 'Form' the repository to you own GitHub account, or move it to your desired location manually. And second you have to configure the environment, that is, you have to update all references to the original source respository to your own and also set up several secrets to point to the Azure environment of your choice.

Depending on the pipelines you use (e.g. GitHub workflows vs. Azure DevOps pipelines) make sure you also account for the specific requirements outlined below.

#### Fork the repository

If you want to have a linked clone of the source repository in your own GitHub account, you can fork the repository instead. Still is also the preferred method to contribute back to this repository.

To fork the repostory you can simply click on the `Fork` button on the top right of the repository website. You can then select the Account you want to fork the repository to and are good to go.

> ***Note***: To ensure your fork stays up to date you can select the 'Fetch upstream' button on your repository root page. This will trigger a process that fetches the latest changes from the source repository back to your fork.
>
> ***Note***: To also re-use the pipelines you may need to account for additional requirements as described below.

Once forked, make sure you update all references to the original repository like for example any link that points to the original location.

#### Service Names

On of the most important actions you should take from the beginning is to update the parameter files in your module. Though you may not want to use all modules that are available, even the subset you use may currently be configured with resource names that must be globally unique and are already taken. For those it is recommended that you define your own unique naming schema (for example a special prefix) and update the resource names accordingly.

Please refer to [this list][AzureNames] to check which services have a global scope and must be updated.

#### Dependencies

As the modules we test often times have dependencies to other servies, we created a pipeline to deploys several standard services like VirtualNetworks and KeyVaults (alongside dummy secrets) for the modules to use. This _dependency_ pipeline should be prepared and executed before you start running any pipelines on your own. In case you need to rename any services there (for example because a certain globally unique resource name was already taken) make sure to update any references to this name in the module parameter files. You can find further details about this pipeline [here](.\TestingDesign.md#Module-Dependencies).

#### GitHub-specific prerequisites

In case you want to not only leverage the module templates but actually re-use the implemented pipelines & testing framework as well, you need to set up a few additional secrets in your GitHub environment:

| Secret Name | Example | Description |
| - | - | - |
| `ARM_MGMTGROUP_ID` | `de33a0e7-64d9-4a94-8fe9-b018cedf1e05` | The ID of the management group to test deploy modules of that level in. |
| `ARM_SUBSCRIPTION_ID` | `d0312b25-9160-4550-914f-8738d9b5caf5` | The ID of the subscription to test deploy modules of that level in. |
| `ARM_TENANT_ID` | `9734cec9-4384-445b-bbb6-767e7be6e5ec` | The ID of the tenant to test deploy modules of that level in. |
| `AZURE_CREDENTIALS` |  `{"clientId": "4ce8ce4c-cac0-48eb-b815-65e5763e2929", "clientSecret": "<placeholder>", "subscriptionId": "d0312b25-9160-4550-914f-8738d9b5caf5", "tenantId": "9734cec9-4384-445b-bbb6-767e7be6e5ec" }` | The login credentials to use to log into the target Azure environment to test in. |
| `PLATFORM_REPO_UPDATE_PAT` | `<placeholder>` | A PAT with enough permissions assigned to it to push into the main branch. This PAT is leveraged by pipelines that automatically generate ReadMe files to keep them up to date |

The permissions that the principal needs differ between modules. Required permissions are in some cases documented in the modules readme. See [Azure/login](https://github.com/Azure/login) for more info about the secret creation.

### **Option 2**: Use it as a local reference to build bicep templates

Instead of re-using the repository as-is you may opt to just save yourself a copy of the code. This may make sense if you want to havest the code for a larger setup that you assemble locally, or you may just want to keep it for reference. To do so, you essentially just have to download the repository like presented in the following:

#### Clone / download the repository

To save a local copy of the repository you can either clone the repository or download it as a `.zip` file.
A clone is a direct reference the the source repository which enables you to pull updates as they happen in the source repostory. To achive this you have to have `Git` installed and run the command

```PowerShell
  git clone 'https://github.com/Azure/ResourceModules.git'`
```

from the command line of your choice.

If you instead just want to have a copy of the repository's content you can instead download it in the `.zip` format. You can do this by navigating to the repository folder of your choice (for example root), then select the `<> Code` button on the top left and click on `Download ZIP` on the opening blade.

 <img src="./media/cloneDownloadRepo.JPG" alt="How to download repository" height="266" width="295">

### **Option 3**: Use it as remote reference to reference the bicep templates

Last but not least, instead of fetching your own copy of the repository you can also choose to reference the content of the repository directly. This works as the repository is public and hence all file urls are available without any sort of authentication.

> ***Note***: In cases where you want to assemble your own template that references other modules you should not rely on direct links as they referencing files may receive breaking changes. Instead you should rely on published versions instead.

<!-- References -->

<!-- External -->
[Bicep]: <https://github.com/Azure/bicep/blob/main/docs/installing.md>
[Az]: <https://img.shields.io/powershellgallery/v/Az.svg?style=flat-square&label=Az>
[AzGallery]: <https://www.powershellgallery.com/packages/Az/>
[AzCLI]: <https://docs.microsoft.com/en-us/cli/azure/>
[PowerShellCore]: <https://github.com/PowerShell/PowerShell/releases/latest>
[InstallAzPs]: <https://docs.microsoft.com/en-us/powershell/azure/install-az-ps>
[InstallAzCLI]: <https://docs.microsoft.com/en-us/cli/azure/install-azure-cli>
[InstallPS]: <https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1>
[InstallBicep]: <https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually>
[AzureResourceManager]: <https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview>

<!-- Docs -->
[PowerShellDocs]: <https://docs.microsoft.com/en-us/powershell/>
[AzureNames]: <https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules>
