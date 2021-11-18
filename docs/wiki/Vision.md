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

When working with IaC we use 3 different components
- **Deployed target environments** that can be individual services, compositions such as workloads, or entire landing zones and the like
- **The orchestration deploying the modules** in the form of template/pipeline orchestration using for example GitHub actions or Azure DevOps pipelines
- **The fundamental modules** that each deploy a service, i.e. are the building blocks to deploy environments

To elaborate a bit further, let's take a look at the following example:

Let's say we want to deploy an environment that consists of a virtual machine we want to connect to a storage account. For this setup we'd need the following modules
- Resource Group
- Virtual Network
- Virtual Machine
- Storage Account

For the orchestration we could use either a deployment orchestration...

### Deployment flow
