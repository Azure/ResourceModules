The repository is built so that you can create your own private 1:1 clone and be able to reuse the same concepts and features in your own environment such as GitHub.

This requires several steps:

1. [Configure your Azure environment](#1-configure-your-azure-environment)
1. [Fork/clone the repository into your DevOps environment](#2-forkclone-the-repository-into-your-devops-environment)
1. [Configure the CI environment](#3-configure-the-ci-environment)
1. [Deploy dependencies](#4-deploy-dependencies)
1. [Update module parameter files](#5-update-module-parameter-files)

Depending on the DevOps environment you choose (GitHub or Azure DevOps) make sure you also account for the specific requirements outlined below.

# 1. Configure your Azure environment

CARML tests the deployments and stores the module artifacts in an Azure subscription. To do so, it requires a service principal with access to it.

In this first step make sure you
- Have/create an Azure Active Directory Service Principal with at least `Contributor` & `User Access Administrator` permissions on the Management-Group/Subscription you want to test the modules in
- Note down the following pieces of information
  - Application (Client) ID
  - Service Principal Object ID (**not** the object ID of the application)
  - Service Principal Secret (password)
  - Tenant ID
  - Subscription ID
  - Parent Management Group ID

# 2. Fork/clone the repository into your DevOps environment

Next you'll want to create your own copy of the code. Depending on the repository environment you want to use (GitHub or Azure DevOps), the set up will be slightly different.

> **Note:** Whether you chose GitHub or Azure DevOps as your repository's location does not affect your options when registering the pipelines.

<details>
<summary>GitHub Repository</summary>

For GitHub, you have two choices depending on your planned repository visibility:
- If the repository may be **public**, we recommend to create a simple fork into the target organization. As the CARML source repository is public, a fork must be public too.
- If you need a **private** version instead, we recommend you create your target repository, download/clone the CARML repository (ref. 'how to' below) and upload the content to the created target repository
  > **Note:** This disables the feature to 'fetch' from the upstream (CARML) repository. As a result, you have to port updates manually.

</details>

<details>
<summary>Azure DevOps Repository</summary>

For a **private** Azure DevOps git, we recommend you create your target repository, download/clone the CARML repository (ref. 'how to' below) and upload the content to the created target repository
> **Note:** This disables the feature to 'fetch' from the upstream (CARML) repository. As a result, you have to port updates manually.

</details>

<p><p>

<details>
<summary><b>How to:</b> Clone/download the repository</summary>
To save a local copy of the repository you can either clone the repository or download it as a `.zip` file.
A clone is a direct reference the the source repository which enables you to pull updates as they happen in the source repository. To achieve this you have to have `Git` installed and run the command

```PowerShell
  git clone 'https://github.com/Azure/ResourceModules.git'
```

from the command-line of your choice.

If you instead just want to have a copy of the repository's content you can instead download it in the `.zip` format. You can do this by navigating to the repository folder of your choice (for example root), then select the `<> Code` button on the top left and click on `Download ZIP` on the opening blade.

 <img src="./media/cloneDownloadRepo.JPG" alt="How to download repository" height="266">

</details>

<p>

# 3. Configure the CI environment

To configure the CI environment you have to perform several tasks:
- [3.1 Update default `namePrefix`](#31-update-default-nameprefix)
- [3.2 Setup CI-environment-specific configuration](#32-setup-ci-environment-specific-configuration)

> **Note:** While you can use the browser, we recommend that you clone all files from your local machine and update them using, for example, Visual Studio Code.

## 3.1 Update default `namePrefix`

To lower the barrier to entry and allow users to easily define their own naming conventions, we introduced a default `'name prefix'` for all deployed resources.

Each pipeline in CARML that deploys resources uses a logic that automatically replaces "tokens" (i.e. placeholders) in any parameter file. Tokens are stored in only a few central locations to facilitate maintenance.

To update the `namePrefix`, perform the following steps:

1. Open the `settings.json` file in the repository root directory.

1. Replace the `"value": "<...>"` of token `namePrefix` with a different value:

    ```json
    {
        "name": "namePrefix",
        "value": "<...>"
    }
    ```
    > **Note:** The value should be a 3-5 character long string like `cntso`. Longer strings are not recommended as they may conflict with Azure resource name length restrictions.

## 3.2 Setup CI-environment-specific configuration

While the concepts are the same, the configuration of the CI environment can differ drastically depending on the DevOps environment in which you want to register and run your pipelines. Following you can find instructions on how to perform the remaining configuration in the corresponding DevOps environment:

<details>
<summary>GitHub</summary>

### 3.2.1 Setup secrets

### Pipeline secrets

To use the environment's pipelines you should use the information you gathered during the [Azure setup](#1-configure-your-azure-environment) to set the following repository secrets set up:

| Secret Name | Example | Description |
| - | - | - |
| `ARM_MGMTGROUP_ID` | `de33a0e7-64d9-4a94-8fe9-b018cedf1e05` | The group ID of the management group to test deploy modules of that level in. |
| `ARM_SUBSCRIPTION_ID` | `d0312b25-9160-4550-914f-8738d9b5caf5` | The subscription ID of the subscription to test deploy modules of that level in. |
| `ARM_TENANT_ID` | `9734cec9-4384-445b-bbb6-767e7be6e5ec` | The tenant ID of the tenant to test deploy modules of that level in. |
| `DEPLOYMENT_SP_ID` | `de33a0e7-64d9-4a94-8fe9-b018cedf1e05` | This is the Principal (Object ID) for the Service Principal used as the Azure service connection. It is used for Default Role Assignments when Modules are being deployed into Azure |
| `AZURE_CREDENTIALS` | `{"clientId": "4ce8ce4c-cac0-48eb-b815-65e5763e2929", "clientSecret": "<placeholder>", "subscriptionId": "d0312b25-9160-4550-914f-8738d9b5caf5", "tenantId": "9734cec9-4384-445b-bbb6-767e7be6e5ec" }` | The login credentials of the deployment principal to use to log into the target Azure environment to test in. The format is described [here](https://github.com/Azure/login#configure-deployment-credentials). |
| `PLATFORM_REPO_UPDATE_PAT` | `<placeholder>` | A PAT with enough permissions assigned to it to push into the main branch. This PAT is leveraged by pipelines that automatically generate ReadMe files to keep them up to date |

<p>

<details>
<summary><b>How to:</b> Add a repository secret to GitHub</summary>

1. Navigate to the repository's `Settings`.

    <img src="./media/SetupEnvironment/forkSettings.png" alt="Navigate to settings" height="100">

1. In the list of settings, expand `Secrets` and select `Actions`. You can create a new repository secret by selecting `New repository secret` on the top right.

    <img src="./media/SetupEnvironment/forkSettingsSecrets.png" alt="Navigate to secrets" height="600">

1. In the opening view, you can create a secret by providing a secret `Name`, a secret `Value`, followed by a click on the `Add secret` button.

    <img src="./media/SetupEnvironment/forkSettingsSecretAdd.png" alt="Add secret" height="600">

</details>

<p>

> Special case: `AZURE_CREDENTIALS`,
> This secret represents our service connection to Azure and its value is a compressed JSON object that must match the following format:
>
> ```JSON
> {"clientId": "<client_id>", "clientSecret": "<client_secret>", "subscriptionId": "<subscriptionId>", "tenantId": "<tenant_id>" }
> ```
>
> **Make sure you create this object as one continuous string as shown above** - using the information you collected during [Step 1](#1-configure-your-azure-environment). Failing to format the secret as above, results in masked strings (`***`) in place of `{` and `}` in the workflow logs as it is considering each line of the json object as a separate secret string. If you're interested, you can find more information about this object [here](https://github.com/Azure/login#configure-deployment-credentials).

### 3.2.2 Setup variables file

The primary pipeline variable file `.github/variables/global.variables.json` hosts the fundamental pipeline configuration. In the file you will find and can configure settings such as:

<details>
<summary>General</summary>

| Variable Name | Example Value | Description |
| - | - | - |
| `defaultLocation` | `"WestEurope"` | The default location to deploy resources to. If no location is specified in the deploying parameter file, this location is used |
| `resourceGroupName` | `"validation-rg"` | The resource group to deploy all resources for validation to |

</details>

<details>
<summary>Template-specs specific (publishing)</summary>

| Variable Name | Example Value | Description |
| - | - | - |
| `templateSpecsRGName` | `"artifacts-rg"` | The resource group to host the created template-specs |
| `templateSpecsRGLocation` | `"WestEurope"` | The location of the resource group to host the template-specs. Is used to create a new resource group if not yet existing |
| `templateSpecsDescription` | `"This is a module from the [Common Azure Resource Modules Library]"` | A description to add to the published template specs |
| `templateSpecsDoPublish` | `"true"` | A central switch to enable/disable publishing to template-specs |

</details>

<details>
<summary>Private bicep registry specific (publishing)</summary>

| Variable Name | Example Value | Description |
| - | - | - |
| `bicepRegistryName` | `"adpsxxazacrx001"` | The container registry to publish bicep templates to. <p> **NOTE:** Must be globally unique |
| `bicepRegistryRGName` | `"artifacts-rg"` | The resource group of the container registry to publish bicep templates to. Is used to create a new container registry if not yet existing |
| `bicepRegistryRGName` | `"artifacts-rg"` | The location of the resource group of the container registry to publish bicep templates to. Is used to create a new resource group if not yet existing |
| `bicepRegistryDoPublish` | `"true"` | A central switch to enable/disable publishing to the private bicep registry |

</details>

<p>

> **NOTE:** If you plan to use the private container registry for Bicep, make sure to update its value `bicepRegistryName` as it must be globally unique

### 3.2.3 Enable actions


Finally, the 'GitHub Actions' are disabled by default. Hence, in order to continue with the rest of the lab and execute any pipelines you have to enable them first.

To do so, perform the following steps:

1. Navigate to the `Actions` tab on the top of the repository page.

1. Next, select '`I understand my workflows, go ahead and enable them`'.

    <img src="./media/SetupEnvironment/actionsEnable.png" alt="Enable Actions" height="380">

</details>

<p>

<details>
<summary>Azure DevOps</summary>

### 3.2.1 Setup service connection

The service connection must be set up in the project's settings under _Pipelines: Service connections_ (a step by step guide can be found [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml)).

It's name must match the one configured as `serviceConnection` in the [variable file](#323-setup-variables-file)'s 'Global' section.

### 3.2.2 Setup secrets in variable group

The variable group must set up in Azure DevOps as described [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=classic#create-a-variable-group).

Based on the information you gather in the [Azure setup](#1-configure-your-azure-environment), you must configure the following secrets in the variable group:

| Secret Name | Example | Description |
| - | - | - |
| `ARM_MGMTGROUP_ID` | `de33a0e7-64d9-4a94-8fe9-b018cedf1e05` | The group ID of the management group to test deploy modules of that level in. |
| `ARM_SUBSCRIPTION_ID` | `d0312b25-9160-4550-914f-8738d9b5caf5` | The subscription ID of the subscription to test deploy modules of that level in. |
| `ARM_TENANT_ID` | `9734cec9-4384-445b-bbb6-767e7be6e5ec` | The tenant ID of the tenant to test deploy modules of that level in. |
| `DEPLOYMENT_SP_ID` | `de33a0e7-64d9-4a94-8fe9-b018cedf1e05` | This is the Principal (Object ID) for the Service Principal used as the Azure service connection. It is used for Default Role Assignments when Modules are being deployed into Azure |

Make sure its name matches the `group` reference used in the module pipelines. For example

```yaml
variables:
  - group: 'PLATFORM_VARIABLES'
```

### 3.2.3 Setup variables file

The primary pipeline variable file `.azuredevops/pipelineVariables/global.variables.yml` hosts the fundamental pipeline configuration. In the file you will find and can configure information such as:

<details>
<summary>General</summary>

| Variable Name | Example Value | Description |
| - | - | - |
| `defaultLocation` | `'WestEurope'` | The default location to deploy resources to. If no location is specified in the deploying parameter file, this location is used |
| `defaultResourceGroupName` | `'validation-rg'` | The resource group to deploy all resources for validation to |
| `serviceConnection` | `'Contoso-Connection'` | The service connection that points to the subscription to test in and publish to |

</details>

<details>
<summary>Template-specs specific (publishing)</summary>

| Variable Name | Example Value | Description |
| - | - | - |
| `templateSpecsRGName` | `'artifacts-rg'` | The resource group to host the created template-specs |
| `templateSpecsRGLocation` | `'WestEurope'` | The location of the resource group to host the template-specs. Is used to create a new resource group if not yet existing |
| `templateSpecsDescription` | `'This is a module from the [Common Azure Resource Modules Library]'` | A description to add to the published template specs |
| `templateSpecsDoPublish` | `'true'` | A central switch to enable/disable publishing to template-specs |

</details>

<details>
<summary>Private bicep registry specific (publishing)</summary>

| Variable Name | Example Value | Description |
| - | - | - |
| `bicepRegistryName` | `'adpsxxazacrx001'` | The container registry to publish bicep templates to. <p> **NOTE:** Must be globally unique |
| `bicepRegistryRGName` | `'artifacts-rg'` | The resource group of the container registry to publish bicep templates to. Is used to create a new container registry if not yet existing |
| `bicepRegistryRGName` | `'artifacts-rg'` | The location of the resource group of the container registry to publish bicep templates to. Is used to create a new resource group if not yet existing |
| `bicepRegistryDoPublish` | `'true'` | A central switch to enable/disable publishing to the private bicep registry |

</details>

<details>
<summary>Universal packages specific (publishing)</summary>

| Variable Name | Example Value | Description |
| - | - | - |
| `vstsFeedName` | `'ResourceModules'` | The name of the Azure DevOps universal packages feed to publish to |
| `vstsFeedProject` | `'$(System.TeamProject)'` | The project that hosts the feed. The feed must be created in Azure DevOps ahead of time. |
| `vstsFeedToken` | `'$(System.AccessToken)'` | The token used to publish universal packages into the feed above |
| `artifactsFeedDoPublish` | `'true'` | A central switch to enable/disable publishing to Universal packages |

</details>

<p>

> **NOTE:** If you plan to use the private container registry for Bicep, make sure to update its value `bicepRegistryName` as it must be globally unique

### 3.2.4 Register pipelines

To use the pipelines that come with the environment in Azure DevOps, you need to register them first. You can either do this manually, or, execute the utility `Register-AzureDevOpsPipeline` we provide in path `utilities/tools/AzureDevOps`. For further information, please refer to the corresponding [documentation](./Getting%20started%20-%20Register-AzureDevOpsPipeline).

</details>

<p>

# 4. Deploy dependencies

At this stage you can execute your first pipeline, that is, the dependency pipeline.

As the modules we test oftentimes have dependencies to other services, we created a pipeline to deploys several standard services like Virtual Networks and Key Vaults (alongside dummy secrets) for the modules to use. This _dependency_ pipeline should be prepared and executed before you start running any module pipelines.

> **Note:** If you want to rename any services there make sure to update any references to this name in the module parameter files. You can find further details about this pipeline [here](./Getting%20started%20-%20Dependency%20pipeline).

# 5. Update module parameter files

Once the required dependencies are deployed, there is one more step left to get as many module pipelines running as possible.

Essentially, several modules reference values who's references are will be different for every first deployment of a resource. For example, if a module references a Key Vault key, its version identifier will only be available once the dependency pipeline executed once.

For this reason, make sure to update the references in the following modules once the dependency pipeline concluded:

| File | Parameter |
| - | - |
| `arm\Microsoft.Compute\diskEncryptionSets\.parameters\parameters.json` |`keyUrl.value` |
| `arm\Microsoft.Compute\virtualMachines\.parameters\linux.parameters.json` | `extensionDiskEncryptionConfig.value.settings.KeyEncryptionKeyURL` |
| `arm\Microsoft.Compute\virtualMachines\.parameters\windows.parameters.json` | `extensionDiskEncryptionConfig.value.settings.KeyEncryptionKeyURL` |
| `arm\Microsoft.Compute\virtualMachineScaleSets\.parameters\linux.parameters.json` | `extensionDiskEncryptionConfig.value.settings.KeyEncryptionKeyURL` |
| `arm\Microsoft.Compute\virtualMachineScaleSets\.parameters\windows.parameters.json` | `extensionDiskEncryptionConfig.value.settings.KeyEncryptionKeyURL` |
| `arm\Microsoft.Sql\managedInstances\.parameters\parameters.json` | `keys.value.uri` |

</details>


<!-- TODO: Reference interoperability (ConvertTo-ARM) for scenario 1 & 2 -->
