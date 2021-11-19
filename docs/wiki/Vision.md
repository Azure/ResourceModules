# Vision

This section will give on an overview of the idea and approach of this platform.
Note, it will not elaborate every aspect of the subject but is intended to help you understand the design on a fundamental level.

---

### _Navigation_

- [What is Infrastructure as Code?](#...)
- [How do we define a module?](#...)
- [How does the platform fit in?](#...)
  - [Deployment model](#...)
  - [Deployment flow](#...)

---


## What is Infrastructure as Code?

_'Infrastructure as Code (IaC)'_ describes a declarative approach towards resource deployment & management. Using configuration & template files that represent the deployed infrastructure has several benefits:
- You have a local representation of your deployed infrastructure
- The configuration applied is version controlled and hence enabled roll-backs & analysis
- You can deploy you infrastructure in a repeatable fashion - hence minimizing the possibility of manual errors
- You can use automation to deploy your infrastructure and establish for example a multi-stage deployment (i.e. continuous deployment) from a Sandbox environment, via integration to production using the same files

In context of bicep or ARM templates we usually leverage a combination of flexible templates that are deployed using different parameter files for different scenarios.

## How do we define a module?

In the context of _CARML_ we define a module as a reusable, template-based building block to deploy Azure resources. As such it is the foundation to apply _Infrastructure as Code_.

By default each module can deploy one instance of a resource and n-amount of its child-resources (for example `1` storage account and `n`-amount of containers). In some instances a module may also deploy strongly coupled resources (for example `1` virtual machine and `n`-amount of data discs).

Each module is generalized for maximum flexibility and optimized for easy usability. The idea is that the template should be able to cover as many resource-specific scenarios as possible and not restrict the user by making assumptions on the users behalf. Eventually the injected parameters should decide what the template does.

Furthermore, each module comes with meaningful default values for it's optional parameters, a detailed documentation for its usage and one or multiple parameter files to proof is correctness.

## How does the platform fit in?

The _CARML_ platform hosts a collection of resource modules with the intend to cover as many Azure resources and their child-resources as possible.

As such, users can re-use the modules as-is, built on top of them to orchestrate their deployments and in turn their infrastructure (for example workloads, construction sets or landing zones).

To ensure the modules are valid and can perform the intended deployments, the repository also comes with several pipelines and perform various tests on the modules, and if successful publish them in one or multiple target locations.

Why this is useful we will explain in the next few sections.

### Deployment model

<img src="media/deploymentModel.png" alt="Deployment model components" height="200" width="300">

When working with IaC we use 3 different components:
- The deployed **environments** that can be individual services, compositions such as workloads, or entire landing zones and the like
- The **orchestration** deploying the modules in the form of template/pipeline orchestration using for example GitHub actions or Azure DevOps pipelines
  - No matter the platform we can differentiate two different deployment approaches:
    - **_Template Orchestration_**: These types of deployments reference individual modules from a 'main/environment' bicep/ARM template and use its capabilities to pass parameters & orchestrate the deployments. By default, deployments are deployed in parallel by the Azure Resource Manager while accounting for all dependencies defined. Furthermore, the deploying pipeline only needs one deployment job that triggers the template's deployment.
    - **_Pipeline Orchestration_**: This approach uses the platform specific pipeline capabilities (for example pipeline jobs) to trigger the deployment of individual modules, where each job deploys one module. By defining dependencies in between jobs you can make sure your resources are deployed in order. Parallelization is achieved by using a pool of pipeline agents that execute the jobs, while accounting for all dependencies defined.
- The fundamental **modules** that each deploy a service, i.e. are the building blocks to deploy environments

To make each component a bit more tangible, let's take a look at the following example:

- Target Environment
  - A virtual machine connected to a storage account
- Orchestration
  - Template-orchestration using GitHub actions
- Modules
  - Resource Group
  - Virtual Network
  - Virtual Machine
  - Storage Account

For this example we could create a GitHub workflow that signs into Azure and run's a single deployment using for example the PowerShell command `New-AzResourceGroupDeployment`.
Furthermore we'd then create an orchestration-template the deploys the above resources in the following parallel groups (using dependencies)
1. The resource group
1. The virtual network & storage account
1. The virtual Machine

Then we'd only need to create a parameter file for the orchestration-template and have the workflow deploy both in combination.

### Deployment flow

In this section we'll take a deeper look into the fundamental flow of the platform.

First things first, we would work towards the deployment of our environments in 3 phases:

<img src="media/deploymentFlow.png" alt="Deployment flow" height="150" width="750">

The **Produce components** phase is the phase where you're supposed to set up your modules and validate that they work. In case of _CARML_ this means we have a pipeline for each module that, with one or multiple test-parameter files, runs static as well as validation & deployment tests on its template. Once if all tests pass we can be certain no bugs were introduced (in case the template was altered) and all features work as intended.

The next phase, **Publish artifacts**, will take the tested and approved modules and publish them to a target location of your choice (for example _template specs_ or the _bicep registry_). The publishing should publish at least the tested module template itself.
The target location should support versioning so that you only always publish new versions.
This may bring up the question _Why_ you should publish your templates before you use them. Afterall, you could just reference the modules in the source repository as is to deploy you environments. This however has one major drawback: If your deployments rely on what you have in your source repository then they 'by definition' always use the latest code. This means, as soon as somebody introduces a breaking change to one of these templates, all your orchestrated and referencing deployments will be blocked until you updated them to the latest version too.
By introducing versions to you modules, the referencing templates can and should specify a specific module versions they want to use and deploy their environment with those. If we now have the case that a breaking change is introduced, a new version is published, but no deployment is affected because they still reference the original. Instead they have to make the deliberate decision to upgrade the module references to newer versions.

The last phase then is the **artifact consumption**. As mentioned previously, this is the phase where we orchestrate the deployment of for example services, workloads or entire landing zones. Up to this point, all deployments were only done for test reasons and should be deleted after a successful run. The deployments we perform now are instead 'sticky' deployments to for example a integration or production environment. By referencing and orchestrating the templates published in the previous step we can be sure that all templates work and we only need to provide them with the correctly configured parameters and orchestrate their deployment in the correct order.

The following image shows a more detailed version of the end-2-end approach:

<img src="media/completeFlow.png" alt="Complete deployment flow" height="700" width="4400">

The top row represents your orchestration environment (for example GitHub), the bottom row the Azure environment.
