# Getting started

This section will give on an overview on how to get started using this repository.

---

### _Navigation_

- [General prerequisites](#general-prerequisites)
- [Where to start](#where-to-start)
  - [**Option 1:** Use it as a basis to set up your own inner-source project](#option-1-use-it-as-a-basis-to-set-up-your-own-inner-source-project)
    - [Fork the repository](#fork-the-repository)
    - [Service Names](#service-names)
    - [Dependencies](#dependencies)
    - [Platform variables & secrets](#platform-variables--secrets)
  - [**Option 2:** Use it as a local reference to build bicep templates](#option-2-use-it-as-a-local-reference-to-build-bicep-templates)
    - [Clone / download the repository](#clone--download-the-repository)
  - [**Option 3:** Use it as remote reference to reference the bicep templates](#option-3-use-it-as-remote-reference-to-reference-the-bicep-templates)
  - [**Option 4:** Simple contribution](#option-4-simple-contribution)
  - [Parameter File Tokens](#parameter-file-tokens)

---

# General prerequisites

No matter from where you start you have to account for some general prerequisites when it comes to bicep and this repository.
To ensure you can use all the content in this repository you'd want to install

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

---

# Where to start

Depending on how you want to use this repositories content you may go down different paths to get started.

- [**Option 1**: Use it as a basis to set up your own inner-source project](#option-1-use-it-as-a-basis-to-set-up-your-own-inner-source-project)
- [**Option 2**: Use it as a local reference to build bicep templates](#option-2-use-it-as-a-local-reference-to-build-bicep-templates)
- [**Option 3**: Use it as remote reference to reference the bicep templates](#option-3-use-it-as-remote-reference-to-reference-the-bicep-templates)
- [**Option 4:** Simple contribution](#option-4-simple-contribution)

Also there are some general aspects to take note of
- [Parameter File Tokens](#parameter-file-tokens)

## **Option 1:** Use it as a basis to set up your own inner-source project

The repository is set up in a way that you can essentially create your own private 1:1 copy and would be able to re-use the same concepts and functionality in your own environment like GitHub. This set up is a 2-step process. First, you have to either 'Form' the repository to you own GitHub account, or move it to your desired location manually. And second you have to configure the environment, that is, you have to update all references to the original source repository to your own and also set up several secrets to point to the Azure environment of your choice.

Depending on the pipelines you use (e.g. GitHub workflows vs. Azure DevOps pipelines) make sure you also account for the specific requirements outlined below.

- [Fork the repository](#fork-the-repository)
- [Service Names](#service-names)
- [Platform principal](#platform-principal)
- [Dependencies](#dependencies)
- [Platform variables & secrets](#platform-variables--secrets)

### Fork the repository

If you want to have a linked clone of the source repository in your own GitHub account, you can fork the repository instead. This is also the preferred method if the intent is to contribute back to the CARML repository.

To fork the repository you can simply click on the `Fork` button on the top right of the repository site. You can then select the Account you want to fork the repository to and are good to go.

> ***Note***: To ensure your fork stays up to date you can select the 'Fetch upstream' button on your repository root page. This will trigger a process that fetches the latest changes from the source repository back to your fork.
>
> ***Note***: To also re-use the pipelines you may need to account for additional requirements as described below.

Once forked, make sure you update all references to the original repository like for example any link that points to the original location.

### Service Names

On of the most important actions you should take from the beginning is to update the parameter files in your module. Though you may not want to use all modules that are available, even the subset you use may currently be configured with resource names that must be globally unique and are already taken. For those it is recommended that you define your own unique naming schema (for example a special prefix) and update the resource names accordingly.

Please refer to [this list][AzureNames] to check which services have a global scope and must be updated.

### Platform principal

The platform [service principal](https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals#service-principal-object) is used to perform actions in Azure using a service principal. Depending on what you want to want to execute, different permissions will be required. For example:
- To test the **Management Group** module, your principal needs at least Contributor permissions on a management group
- To test **RBAC** with any of the modules you need at least _User Access Administrator_ permissions on the target scope
- To test **subscription-level deployments** you need at least _Contributor_ permissions on the target scope

If you want to be on the safe side you can assign _Owner_ permissions to your principal on the management group scope.

> ***Note:*** By default, we're using this service principal's object ID (i.e. principal ID) as the value of the `deploymentSpId` [token](./ParameterFileTokens) to be used to test e.g. RBAC assignments.

### Dependencies

As the modules we test often times have dependencies to other services, we created a pipeline to deploys several standard services like VirtualNetworks and KeyVaults (alongside dummy secrets) for the modules to use. This _dependency_ pipeline should be prepared and executed before you start running any pipelines on your own. In case you need to rename any services there (for example because a certain globally unique resource name was already taken) make sure to update any references to this name in the module parameter files. You can find further details about this pipeline [here](./TestingDesign#Module-Dependencies).

### Platform variables & secrets

Several fundamental variables are shared among all pipelines and are stored in a pipeline variable file. In case you want to not only leverage the module templates but actually re-use the implemented pipelines & testing framework as well, you need to set up several [variables](./PipelinesDesign#pipeline-variables) & [secrets](./PipelinesDesign#pipeline-secrets) in your environment.

## **Option 2:** Use it as a local reference to build bicep templates

Instead of re-using the repository as-is you may opt to just save yourself a copy of the code. This may make sense if you want to have the code for a larger setup that you assemble locally, or you may just want to keep it for reference. To do so, you essentially just have to download the repository like presented in the following:

### Clone / download the repository

To save a local copy of the repository you can either clone the repository or download it as a `.zip` file.
A clone is a direct reference the the source repository which enables you to pull updates as they happen in the source repository. To achieve this you have to have `Git` installed and run the command

```PowerShell
  git clone 'https://github.com/Azure/ResourceModules.git'`
```

from the command-line of your choice.

If you instead just want to have a copy of the repository's content you can instead download it in the `.zip` format. You can do this by navigating to the repository folder of your choice (for example root), then select the `<> Code` button on the top left and click on `Download ZIP` on the opening blade.

 <img src="./media/cloneDownloadRepo.JPG" alt="How to download repository" height="266">

## **Option 3:** Use it as remote reference to reference the bicep templates

Last but not least, instead of fetching your own copy of the repository you can also choose to reference the content of the repository directly. This works as the repository is public and hence all file URLs are available without any sort of authentication.

> ***Note***: In cases where you want to assemble your own template that references other modules you should not rely on direct links as they referencing files may receive breaking changes. Instead you should rely on published versions instead.


## **Option 4:** Simple contribution

In case you would like to simply contribute because you, for example, want to add/update a module or would like to add some notes to the Wiki, you can do this in just a few simple steps:
1. First check if there is already an issue that matches your initiative. If so, feel free to assign yourself, or, create a new issue if does not exist yet
1. Fork the repository to the GitHub organization of your choice
1. (optional but recommended) Create a branch in your fork where you'd like to implement the contribution
1. Implement your proposed changes
   1. In case you change module-related code (anything aside the readMe.md, like the template), we'd ask you do perform a test-run in your environment. For more details, please refer to the [setup fork](#fork-the-repository) section.
1. Open a Pull-Request to the upstream (source) repository with a meaningful description and link the corresponding issue to it
   1. If you ran a pipeline to validate your changes, please make sure to attach a reference (e.g. as a status badge) to the PR

## Parameter File Tokens

If you are forking or cloning the repository, you can use 'tokens' inside your parameter files. Tokens allow you to test deploying modules in your own environment (i.e. using tokens for your naming conventions), or apply other customizations to your resources (i.e. using your own subscription ID inside a Resource ID string). See details in the [Parameter File Tokens Design](./ParameterFileTokens).

The repository contains a [Settings.json](https://github.com/Azure/ResourceModules/blob/main/settings.json) that enables you to define local tokens and store them in source control. The token format is a `name` and `value` pair as shown in the following example:

```json
"localTokens": {
  "tokens": [
    {
      "name": "tokenName",
            "value": "tokenValue"
        }
    ]
},
```

Let us say you'd want to use this token inside a Key Vault parameter file, to deploy the key vault with a name that contains this token:

```json
"parameters": {
    "name": {
        "value": "<<tokenName>>-keyVault"
    }
}
```

Once the Key Vault is deployed, you'll notice that the Key Vault name in Azure will be `tokenValue-keyVault`

> The token prefix `<<` and suffix `>>` in the above example are also configurable in the [Settings.json](https://github.com/Azure/ResourceModules/blob/main/settings.json) file. They are however the default used in the CARML main repository.

---
Note: There are default tokens that can be enabled on any resource that leverages the [GitHub specific prerequisites](GettingStarted#github-specific-prerequisites) secrets.

- `<<subscriptionId>>`: Will point to the Azure subscription.
- `<<managementGroupId>>`: Will point to the Azure an Azure Management Group.
- `<<tenantId>>`: Will point to the Azure Tenant ID.
- `<<deploymentSpId>>`: Will point to the Service Principal ID used for deployments.
- `<<resourceGroupName>>`: Will point to the Azure Resource Group where the resources are being deployed to. (This isn't defined in the secrets section but is injected at runtime)

Review [Parameter File Tokens Design](./ParameterFileTokens) for more details.

---

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
