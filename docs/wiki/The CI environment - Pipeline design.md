This section provides an overview of the design principles followed by the CARML CI environment pipelines.

---

### _Navigation_

- [Module Pipelines](#module-pipelines)
  - [Pipeline phases](#pipeline-phases)
    - [DevOps-Tool-specific design](#devops-tool-specific-design)
  - [Module pipeline inputs](#module-pipeline-inputs)
- [Platform pipelines](#platform-pipelines)
  - [Dependencies pipeline](#dependencies-pipeline)
    -[Dependenciespipeline inputs](#dependencies-pipeline-inputs)
  - [ReadMe pipeline](#readme-pipeline)
  - [Wiki pipeline](#wiki-pipeline)

---

# Module Pipelines

The repository hosts one pipeline for each module in the CARML library.

The purpose of each module pipeline is twofold:

1. **Validation**: To ensure the modules hosted by the CARML library are valid and can perform the intended deployments.
1. **Publishing**: To publish _versioned_ and already validated modules to one or multiple target locations, from where they can be referenced by solutions consuming them.

As such each pipeline can be mapped to `Phases 1 and 2` described in the [Deployment flow](./The%20context%20-%20CARML%20CI%20environment#deployment-flow) section.

<img src=".\media\CIEnvironment\pipelineDesign.png" alt="Pipeline phases" height="500">

The following paragraphs provide an overview of the different phases and shared logic the module pipelines use.

- [Pipeline phases](#pipeline-phases)
- [Module pipeline inputs](#module-pipeline-inputs)

## Pipeline phases

This paragraph provides an overview of the three phases executed by each module pipeline. Further details about the implementation and design of each phase are provided in the dedicated pages linked below.

1. **Static Validation**: Executes a set of static Pester tests against the module template, to ensure they comply with the intended module design principles.

1. **Deployment Validation**: we deploy each module by using a predefined set of parameters to a 'sandbox' subscription in Azure to see if it's really working
   1. **Removal**: The test suite is cleaned up by removing all deployed test resources again
1. **Publishing**: the proven results are published to a configured location such as template specs, the bicep registry, Azure DevOps artifacts.

   <img src=".\media\CIEnvironment\pipelineDesignPhases.png" alt="Pipeline phases" height="200">

### DevOps-Tool-specific design

<details>
<summary>GitHub</summary>

<img src=".\media\CIEnvironment\pipelinePhasesGH.png" alt="Pipeline phases GH" height="150">

GitHub workflows map each pipeline phase to a dedicated composite action, to maximize code reusability.
The mapping to the specific composite action is provided below:

| Composite Action | Pipeline phase |
| - | - |
| **validateModulePester** | Static validation |
| **validateModuleDeployment** | Deployment validation |
| **publishModule** | Publishing |

In addition, workflows leverage the following composite actions:

| Composite Action | Description |
| - | - |
| **getWorkflowInput** | This action allows fetching workflow input values from the module's workflow file, even if the pipeline was not triggered via a `workflow_dispatch` action. Without it we would not be able to process the contained information and would need to duplicate the configuration as workflow variables. Such input values are for example the removal switch `removeDeployment`. |
| **setEnvironmentVariables** | This action parses the variables file `global.variables.yml` and sets the key-value pairs in the `variables` list as environment variables. |

Technical documentation for each composite action, such as required input and output variables, is included in each `action.yml` file located in path `.github/actions/templates`.

</details>

<details>
<summary>Azure DevOps</summary>

<img src=".\media\CIEnvironment\pipelinePhasesADO.png" alt="Pipeline phases ADO" height="300">

Azure DevOps pipelines map each pipeline phase to a dedicated pipeline template, to maximize code reusability.
The mapping to the specific yaml template file is provided below:

| Template Name | Pipeline phase |
| - | - |
| **jobs.validateModulePester.yml** | Static validation |
| **jobs.validateModuleDeployment.yml** | Deployment validation |
| **jobs.publishModule.yml** | Publishing |

Technical documentation for each template, such as required input and output variables, is included in each `.yml` file located in path `.azuredevops/pipelineTemplates`.

</details>

## Module pipeline inputs

Each module pipeline comes with the following runtime parameters:

- `'Branch' dropdown`: A dropdown to select the branch to run the pipeline from.
- `'Remove deployed module' switch`: Can be enabled or disabled and controls whether the test-deployed resources are removed after testing. It is enabled by default.
- `'Publish prerelease module' switch`: Can be enabled or disabled and allows you to publish a prerelease version for the corresponding module when running the pipeline from a branch different than [main|master]. It is disabled by default. For further information of how the input is processed refer to the [Publishing](./The%20CI%20environment%20-%20Publishing) dedicated page.

  <img src=".\media\CIEnvironment\modulePipelineInput.png" alt="Module Pipeline Input" height="300">

<!-- ## Shared concepts

There are several concepts that are shared among the phases. Most notably

- [Prerequisites](#prerequisites)
- [Pipeline secrets](#pipeline-serets)
- [Pipeline variables](#pipeline-variables)
- [Tokens Replacement](#tokens-replacement) -->

<!-- ### Prerequisites

For both the [simulated deployment validation](#simulated-deployment-validation) as well as the [test deployment](#test-deployment) we should account for the following prerequisites:

- A _"Sandbox"_ or _"Engineering"_ **validation subscription** (in Azure) has to be used to test if the modules (or other components) are deployable. This subscription must not have connectivity to any on-premises or other Azure networks.
- An Azure Active Directory [service principal](https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals#service-principal-object) (AAD SPN) to authenticate to the validation subscription and run the test deployments of the modules. -->

<!-- ### Pipeline secrets

To use the platform pipelines you need several secrets set up in your DevOps platform. Contrary to the pipeline variables we describe in the [subsequent section](#pipeline-variables) these following variables are considered sensitive.

| Secret Name | Example | Description |
| - | - | - |
| `ARM_MGMTGROUP_ID` | `de33a0e7-64d9-4a94-8fe9-b018cedf1e05` | The group ID of the management group to test deploy modules of that level in. |
| `ARM_SUBSCRIPTION_ID` | `d0312b25-9160-4550-914f-8738d9b5caf5` | The subscription ID of the subscription to test deploy modules of that level in. |
| `ARM_TENANT_ID` | `9734cec9-4384-445b-bbb6-767e7be6e5ec` | The tenant ID of the tenant to test deploy modules of that level in. |
| `DEPLOYMENT_SP_ID` | `de33a0e7-64d9-4a94-8fe9-b018cedf1e05` | This is the Principal (Object ID) for the Service Principal used as the Azure service connection. It is used for Default Role Assignments when Modules are being deployed into Azure |

The location where to set these secrets up depends on the DevOps platform you use. Also, there may be additional platform-specific secrets to set up. For further information please refer to [this section](#devops-tool-specific-considerations). -->

### Check pipeline variables covered by setup env

<!-- ### Pipeline variables

The primary pipeline variable file hosts the fundamental pipeline configuration and is stored in a different location, based on the [DevOps platform](#devops-tool-specific-considerations). In here you will find and can configure information such as:

#### **_General_**

| Variable Name | Example Value | Description |
| - | - | - |
| `location` | "WestEurope" | The default location to deploy resources to. If no location is specified in the deploying parameter file, this location is used |
| `resourceGroupName` | "validation-rg" | The resource group to deploy all resources for validation to |

#### **_Template-specs specific (publishing)_**

| Variable Name | Example Value | Description |
| - | - | - |
| `templateSpecsRGName` | "artifacts-rg" | The resource group to host the created template-specs |
| `templateSpecsRGLocation` | "WestEurope" | The location of the resource group to host the template-specs. Is used to create a new resource group if not yet existing |
| `templateSpecsDescription` | "This is a module from the [Common Azure Resource Modules Library]" | A description to add to the published template specs |
| `templateSpecsDoPublish` | "true" | A central switch to enable/disable publishing to template-specs |

#### **_Private bicep registry specific (publishing)_**

| Variable Name | Example Value | Description |
| - | - | - |
| `bicepRegistryName` | "adpsxxazacrx001" | The container registry to publish bicep templates to |
| `bicepRegistryRGName` | "artifacts-rg" | The resource group of the container registry to publish bicep templates to. Is used to create a new container registry if not yet existing |
| `bicepRegistryRGName` | "artifacts-rg" | The location of the resource group of the container registry to publish bicep templates to. Is used to create a new resource group if not yet existing |
| `bicepRegistryDoPublish` | "true" | A central switch to enable/disable publishing to the private bicep registry | -->

### Check all token replacement covered by the dedicated page

<!-- ### Tokens Replacement

The validation or deploy actions/templates includes a step that replaces certain strings in a parameter file with values that are provided from the module workflow. This helps achieve the following:

Dynamic parameters that do not need to be hardcoded in the parameter file, and the ability to reuse the repository as a fork, where users define the same tokens in their own "repository secrets", which are then available automatically to their parameter files.

For example, some modules require referencing Azure resources with the Resource ID. This ID typically contains the `subscriptionId` in the format of `/subscriptions/<<subscriptionId>>/...`. This task substitutes the `<<subscriptionId>>` with the correct value, based on the different token types.

Please review the Parameter File Tokens [Design](./ParameterFileTokens) for more details on the different token types and how you can use them to remove hardcoded values from your parameter files. -->

---

# Platform pipelines

In addition to module pipelines, the repository includes several platform pipelines covering further tasks as described below.

- [Dependencies pipeline](#dependencies-pipeline)
- [ReadMe pipeline](#readme-pipeline)
- [Wiki pipeline](#wiki-pipeline)

## Dependencies pipeline

In order to successfully run module pipelines to validate and publish CARML modules to the target environment, certain Azure resources need to be deployed beforehand.

For example a Virtual Machine needs an existing virtual network to be connected to and a key vault hosting its required local admin credentials to be referenced.

The dependencies pipeline covers this requirement and is intended to be run before executing module pipelines successfully.

You can find further details about the dependencies pipeline in the  [Getting started - Dependency pipeline](./Getting%20started%20-%20Dependency%20pipeline) section.

### Dependencies pipeline inputs

The dependencies pipeline comes with the following runtime parameters:

- `'Branch' dropdown`: A dropdown to select the branch to run the pipeline from.
- `'Enable SqlMI dependency deployment' switch`: Can be enabled or disabled and controls whether the dependencies for the [SQL managed instance] module are deployed during execution. It is disabled by default.
- `'Enable deployment of a vhd stored in a blob container' switch`: Can be enabled or disabled and controls whether including the baking of a VHD and subsequent backup to a target storage blob container during the execution. This is a dependency for the [Compute Images] and [Compute Disks] modules. This task requires up to two hours completion and is disabled by default.

  <img src=".\media\CIEnvironment\dependencyPipelineInput.png" alt="Dependency Pipeline Input" height="300">

## ReadMe pipeline

The repository includes two major ReadMe files that require to stay in sync with the provided modules.

The first can be found in root (`README.md`) and the second in the modules folder (`arm/README.md`).

The ReadMe pipeline is triggered each time changes are pushed to the `main` branch and only if a template in the `arm` folder is being altered.

Once triggered, the pipeline crawls through the library and updates the tables in each corresponding ReadMe file, creating links to the corresponding pipeline runs and updating the list of entries.

## Wiki pipeline

The purpose of the Wiki pipeline is to sync any files from the `docs/wiki` folder to the GitHub wiki repository. It is triggered each time changes are pushed to the `main` branch and only if files in the `docs/wiki` folder are altered.

> **Note:** Any changes performed directly on the Wiki via the UI will be overwritten by this pipeline.

---

# check DevOps-Tool-specific considerations already covered

<!-- # DevOps-Tool-specific considerations

Depending on what DevOps tool you want to use to host the platform you will find the corresponding code in different locations. This section will give you an overview of these locations and what they are used for.

- [GitHub Workflows](#github-workflows)
- [Azure DevOps Pipelines](#azure-devops-pipelines)

## GitHub Workflows

[GitHub actions & workflows](https://docs.github.com/en/actions) are the CI/CD solution provided by GitHub. To get the platform going, we use the following elements:

- **[GitHub secrets:](#github-component-github-secrets)** We leverage GitHub repository secrets to store central and potentially sensitive information we need to perform deployments and other platform specific actions
- **[Variable file:](#github-component-variable-file)** This file contains the configuration for all module pipelines in this repository.
- **[Composite actions:](#github-component-composite-actions)** Composite actions bundle a set of actions for a specific purpose together. They are referenced by module pipelines.
- **[Workflows:](#github-component-workflows)** GitHub workflows make up all our pipelines and leverage the _composite actions_. We have one workflow per module, plus several platform pipelines.

In the following sub-sections we will take a deeper look into each element.

### **GitHub Component:** GitHub secrets

The GitHub repository secrets can be set up in the repositories _'Settings'_ as described [here](https://docs.github.com/en/actions/security-guides/encrypted-secrets).

For _GitHub_ in particular we need the following secrets in addition to those described in the shared [pipeline secrets](#pipeline-secrets) section:

| Secret Name | Example | Description |
| - | - | - |
| `AZURE_CREDENTIALS` | `{"clientId": "4ce8ce4c-cac0-48eb-b815-65e5763e2929", "clientSecret": "<placeholder>", "subscriptionId": "d0312b25-9160-4550-914f-8738d9b5caf5", "tenantId": "9734cec9-4384-445b-bbb6-767e7be6e5ec" }` | The login credentials of the [deployment principal](./GettingStarted#platform-principal) to use to log into the target Azure environment to test in. The format is described [here](https://github.com/Azure/login#configure-deployment-credentials). |
| `PLATFORM_REPO_UPDATE_PAT` | `<placeholder>` | A PAT with enough permissions assigned to it to push into the main branch. This PAT is leveraged by pipelines that automatically generate ReadMe files to keep them up to date |

### **GitHub Component:** Variable file

The [pipeline configuration file](#pipeline-variables) can be found at `global.variables.yml`.

### **GitHub Component:** Composite Actions

We use several composite actions to perform various tasks shared by our module workflows:

| Composite Action | Description |
| - | - |
| **validateModulePester** | This action performs [static tests](#static-module-validation) for a module using Pester, including API versions focused tests to avoid those become stale overtime. |
| **validateModuleDeployment:** | This action performs the following tasks: <li> A [simulated deployment](#simulated-deployment-validation) using a provided parameter file. <li>An [actual deployment](#test-deploy) to Azure using a provided parameter file. <li>The [removal](#removal) of the test-deployed resources |
| **publishModule:** | This action is capable of [publishing](#publish) the given template to a location specified in the pipeline [variable file](#github-component-variable-file). |
| **getWorkflowInput:** | This action allows us to fetch workflow input values from the module's workflow file, even if the pipeline was not triggered via a `workflow_dispatch` action. Without it we would not be able to process the contained information and would need to duplicate the configuration as workflow variables. Such input values are for example the removal switch `removeDeployment`. |
| **setEnvironmentVariables:** | This action read the variables file `global.variables.yml` and sets the key-value pairs in the `variables` list as environment variables |

### **GitHub Component:** Workflows

These are the individual end-to-end workflows we have for each module. Leveraging the [composite actions](#github-component-composite-actions) described before, they orchestrate the testing & publishing of their module.

Comparing multiple workflows you'll notice they are almost identical, yet differ in a few important areas:

- The **_[path filters](https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions)_** of the workflow trigger:
  | Purpose | Example |
  | - | - |
  | Include the composite actions | `- '.github/actions/templates/**'` |
  | Include the relative path to the workflow itself | `- '.github/workflows/ms.network.virtualwans.yml'` |
  | Include the relative path to the module folder | `- 'arm/Microsoft.Network/virtualWans/**'` |
  | Exclude any ReadMe | `- '!*/**/readme.md'` |

  Full example

  ```yaml
  push:
    branches:
      - main
    paths:
      - '.github/actions/templates/**'
      - '.github/workflows/ms.network.virtualwans.yml'
      - 'arm/Microsoft.Network/virtualWans/**'
      - '!arm/Microsoft.Network/virtualWans/readme.md'
  ```

- The **_environment variables_**
  The environment variables are leveraged by the workflow to fundamentally process the module. We need:
  | Variable | Description | Example |
  | - | - | - |
  | `modulePath` | Relative path to the module folder | `modulePath: 'arm/Microsoft.Network/virtualWans'` |
  | `workflowPath` | Relative path to the workflow itself | `workflowPath: '.github/workflows/ms.network.virtualwans.yml'` |

  Full example

  ```yaml
  env:
    modulePath: 'arm/Microsoft.Network/virtualWans'
    workflowPath: '.github/workflows/ms.network.virtualwans.yml'
  ```

## Azure DevOps Pipelines

[Azure DevOps pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops) are the CI/CD solution provided by Azure DevOps. To enable the CARML platform to function, we use the following components in Azure DevOps:

- **[Service connection:](#azure-devops-component-service-connection)** The [service connection](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) is a wrapper for the [deployment principal](./GettingStarted#platform-principal) that performs all actions in the target SBX/DEV/TEST subscription
- **[Variable group:](#azure-devops-component-variable-group)** [Variable groups](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=yaml) allow us to store both sensitive as well configuration data securely in Azure DevOps.
- **[Variable file:](#azure-devops-component-variable-file)** The [variable file](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema?view=azure-devops&tabs=example%2Cparameter-schema#variable-templates) is a version controlled variable file that hosts pipeline configuration data such as the agent pool to use.
- **[Pipeline templates:](#azure-devops-component-pipeline-templates)** [Pipeline templates](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/templates?view=azure-devops) allow us to re-use pipeline logic across multiple referencing pipelines
- **[Pipelines:](#azure-devops-component-pipelines)** The [pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/?view=azure-devops) contain all logic we execute as part of our platform and leverage the _pipeline templates_.

### **Azure DevOps Component:** Service Connection

The service connection must be set up in the project's settings under _Pipelines: Service connections_ (a step by step guide can be found [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml)).

It's name must match the one configured as `serviceConnection` in the [variable file](#azure-devops-component-variable-file).

### **Azure DevOps Component:** Variable group

The variable group can be set up under _Pipelines: Library_ as described [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=classic#create-a-variable-group). Make sure you set up all secrets described [here](#pipeline-secrets) and that its name matches the `group` reference used in the [module pipelines](#azure-devops-component-pipelines). For example

```yaml
variables:
  - group: 'PLATFORM_VARIABLES'
```

### **Azure DevOps Component:** Variable file

The variable file is a source controlled configuration file to control the behaviour of the pipeline. The file is stored in path `global.variables.yml`.

This file is divided into multiple categories of variables used in the pipelines:

| Section | Description |
| - | - |
| **Agent settings** | Contains information of the agent and service connection to use |
| **Source** | Contains information about the Azure DevOps instance itself, including some important folder paths |
| **Validation deployment settings** | Contains the default deployment information to use in the pipeline. For example, the default location to deploy resources to |
| **Publish: Template-Spec settings** | Contains the required information to publish to template-specs, including a switch to toggle the publishing to template specs on or off |
| **Publish: Universal packages settings** | Contains the required information to publish to universal packages, including a switch to toggle the publishing to universal packages on or off |
| **Publish: Private Bicep Registry settings** | Contains the required information to publish to the private bicep registry, including a switch to toggle the publishing to the private bicep registry on or off |
| **Azure PowerShell Version** | Contains information about the default PowerShell version to use in the pipeline |

More information about the contained variables can be found in the linked file itself.

### **Azure DevOps Component:** Pipeline templates

To keep the amount of pipeline code at a minimum we make heavy use of pipeline templates. Following you can find an overview of the ones we use and what they are used for:

| Template Name | Description |
| - | - |
| **jobs.validateModulePester.yml** | This template perform all [static tests](#static-module-validation) for a module using Pester. |
| **jobs.validateModuleDeployment.yml** | This template performs a [test deployment](#simulated-deployment-validation) followed by an [actual deployment](#test-deploy) to Azure using a provided parameter file. Once a deployment completed it [removes](#removal) the resource |
| **jobs.publishModule.yml** | This template is capable of [publishing](#publish) the given template to a location specified in the pipeline [variable file](#azure-devops-component-variable-file) |

Each file can be found in path `.azuredevops/pipelineTemplates`.

### **Azure DevOps Component:** Pipelines

These are the individual end-to-end pipelines we have for each module. Leveraging the [templates](#azure-devops-component-pipeline-templates) described before, they orchestrate the testing & publishing of their module.

While they look very similar they have specific areas in which they differ:

- The **_path filters_** of the pipeline trigger:
  | Purpose | Example |
  | - | - |
  | Include the templates | `- '/.azuredevops/pipelineTemplates/module.*.yml'` |
  | Include the relative path to the pipeline itself | `- '/.azuredevops/modulePipelines/ms.analysisservices.servers.yml' ` |
  | Include the relative path to the module folder | `- '/arm/Microsoft.AnalysisServices/servers/*'` |
  | Exclude any readme | `- '/**/*.md'` |

  Full example:

  ```yaml
  trigger:
    batch: true
    branches:
      include:
        - main
    paths:
      include:
        - '/.azuredevops/modulePipelines/ms.analysisservices.servers.yml'
        - '/.azuredevops/pipelineTemplates/module.*.yml'
        - '/arm/Microsoft.AnalysisServices/servers/*'
      exclude:
        - '/**/*.md'
  ```

  > **_Note:_** By the time of this writing, wildcards are temporarily not supported by Azure DevOps

- The **_variables_**
  The variables are leveraged by the pipelines to fundamentally process the module. We need:
  | Variable | Description | Example |
  | - | - | - |
  | `template: (...)` | Reference to the [shared variable file](#azure-devops-component-variable-file) | `- template: '../../global.variables.yml'` |
  | `group: (...)` | Reference to the [variable group](#azure-devops-component-variable-group) with the platform secrets | `- group: PLATFORM_VARIABLES` |
  | `modulePath` | Relative path to the module folder | <code>- name: modulePath<p>&nbsp;&nbsp;value: '/arm/Microsoft.AnalysisServices/servers'</code> |

  Full example:

  ```yaml
  variables:
    - template: '../../global.variables.yml'
    - group: 'PLATFORM_VARIABLES'
    - name: modulePath
      value: '/arm/Microsoft.AnalysisServices/servers'
  ```

#### Azure DevOps Artifacts

For _Azure DevOps_ we offer also the option to publish to _Azure DevOps_ universal packages. As the code is already available in the pipeline's publish template (`.azuredevops/pipelineTemplates/jobs.publishModule.yml`) you only have to specify the required information in the shared global variables file (`global.variables.yml`) to enable the feature. For detailed information please refer to the variable file's `Publish: Universal packages settings` section. -->
