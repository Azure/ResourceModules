This page provides an overview of the CARML CI environment. For further details refer to the dedicated Wiki section [The CI environment](./The%20CI%20environment)

To ensure the modules are valid and can perform the intended deployments, the repository comes with a continuous integration (CI) environment for each module.

---

### _Navigation_

- [What is the intended deployment model?](#what-is-the-intended-the-deployment-model)
- [What is the intended deployment flow?](#what-is-the-intended-deployment-flow)
- [Why use versioned modules?](#why-use-versioned-modules)
- [Where does this platform fit in?](#where-does-this-platform-fit-in)
---

# What is the intended the deployment model?

<img src="media/deploymentModel.png" alt="Deployment model components" height="200">

When working with IaC you use 3 different components:
- The deployed **environments** that can be individual services, compositions such as workloads, or entire landing zones and the like
- The **orchestration** deploying the modules in the form of template/pipeline orchestration using for example GitHub actions or Azure DevOps pipelines
- The fundamental **modules** that each deploy a service, i.e. are the building blocks to deploy environments

To make each component a bit more tangible, let's take a look at the following example:

- Target Environment
  - A Virtual Machine connected to a Storage account
- Orchestration
  - Template-orchestration using GitHub actions
- Modules
  - Resource Group
  - Virtual Network
  - Virtual Machine
  - Storage Account

For this example we could create a GitHub workflow that signs into Azure and run's a single deployment using for example the PowerShell command `New-AzResourceGroupDeployment`.
Furthermore we'd then create an orchestration-template the deploys the above resources in the following parallel groups (using dependencies)
1. The Resource Group
1. The Virtual Network & Storage Account
1. The Virtual Machine

Then we'd only need to create a parameter file for the orchestration-template and have the workflow deploy both in combination.

# What is the intended deployment flow?

In this section we'll take a deeper look into the fundamental flow from source modules to target environments.

First things first, we would work towards the deployment of our environments in 3 phases:

<img src="media/deploymentFlow.png" alt="Deployment flow" height="150">

In the **Develop modules** phase you add/implement/update your modules and validate them using one or multiple test-parameter files, run static, validation & deployment tests on the templates and ultimately prove their correctness.

The next phase, **Publish modules**, will take the tested and approved modules and publish them to a target location of your choice (for example _[template specs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs?tabs=azure-powershell)_ or the _[bicep registry](https://docs.microsoft.com/en-gb/azure/azure-resource-manager/bicep/private-module-registry)_). The publishing should publish at least the tested module template itself.
The target location should support versioning so that you only always publish new versions.

> Note: These first two phases are covered by the [CARML](#where-does-this-platform-fit-in) platform.

In the final phase we **Consume modules** and orchestrate them to deploy services, workloads or entire landing zones. Note that all deployments up to this phase only identified as test deployments and should be deleted after their deployment concluded. In contrast, the deployments we perform now are supposed to be 'sticky' and occur on an integration/production environment. We now reference the validated & published modules and only need to provide them with the correctly configured parameters and orchestrate their deployment in the correct order.

The diagram provides a high level view on how the different phases are interconnected:

<img src="media/completeFlow.png" alt="Complete deployment flow" height="500">

The top row represents your orchestration environment (for example GitHub), the bottom row the _Azure_ environment.

From left to right you will find the phases we introduced before, _Develop modules_, _Publish modules_ & _consume modules_. However, in this illustration you can see how each interacts with the Azure environment.

Starting with _develop modules_, the top left box shows the test pipelines we have for each module, each validating, test-deploying and (if successful) publishing the module. The subscription on the bottom is intended to be a test/sandbox subscription without any link to production. Instead resources deployed here should be considered temporary and be removed after testing.

As described earlier, if all tests for a module succeed, the pipeline will _publish the modules_ to a given target location. In the center box you can see examples for _[template specs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs?tabs=azure-powershell)_, the _[bicep registry](https://docs.microsoft.com/en-gb/azure/azure-resource-manager/bicep/private-module-registry)_ as well as _[Azure DevOps artifacts](https://docs.microsoft.com/en-us/azure/devops/artifacts/concepts/feeds?view=azure-devops)_.

> Note: These first two phases are covered by the [CARML](#where-does-this-platform-fit-in) platform.

# Why use versioned modules?
Deploying resources by referencing their corresponding modules from source control has one major drawback: If your deployments rely on what you have in your source repository then they will 'by definition' use the **latest** code. Applying software development lifecycle concepts like 'publishing build artifacts and versioning' enables you to have a point in time version of an Azure Resource Module. By introducing versions to your modules, the consuming orchestration can and should specify a module version it wants to use and deploy the Azure environment using them. If we now have the case that a breaking change is introduced and an updated version is published, no deployments are affected because they still reference the previously published version. Instead, they must make the deliberate decision to upgrade the module to reference newer versions.


# Where does this platform fit in?

The _CARML_ platform hosts a collection of [resource modules](./Modules) with the intend to cover as many Azure resources and their child-resources as possible.

As such, users can use the modules as they are, alter them and or use them to deploy their environments.

To ensure the modules are valid and can perform the intended deployments, the repository comes with a [validation & test](./Testing) [pipeline](./Pipelines) for each module. If successful it will also publish them in one or multiple target locations.

As such, _CARML_ covers the `bottom box` of the [deployment model](#what-is-the-intended-the-deployment-model) section and `Phase #1` & `Phase #2` of the [deployment flow](#what-is-the-intended-deployment-flow) section.

<img src="media/completeFlowTransp.png" alt="Complete deployment flow filtered" height="500">

As we want to enable any user of this repository's content to not only leverage its modules but actually also re-use the platform, the platform itself is set up so that you can plug it into your own environment with just a few basic steps described in the [Getting Started](./GettingStarted) section. You may choose to add or remove modules, define your own locations you want to publish to and as such create your own open- or inner-source library.
