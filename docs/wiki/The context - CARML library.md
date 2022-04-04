This page provides an overview of the CARML library. For further details refer to the dedicated Wiki section [The library](./The%20library)

---

### _Navigation_

- [Infrastructure as Code](#infrastructure-as-code)
- [A module in CARML](#a-module-in-CARML)
    - [CARML module features](#CARML-module-features)
    - [Example: multiple Storage Account variants](#example:-multiple-storage-account-variants)
---

# Infrastructure as Code

_'Infrastructure as Code (IaC)'_ describes a declarative approach towards resource deployment & management.
Using configuration & template files that represent the deployed infrastructure has several benefits:
- Local representation: Your deployed infrastructure is mapped to a local representation as code in your repository.
- Version control: The applied configuration is version controlled and hence enables roll-backs & analysis.
- Repeatability: You can deploy you infrastructure in a repeatable fashion, hence minimizing the possibility of manual errors.
- Reusability: You can reuse your automation to deploy the same infrastructure to different environments. For example leveraging a multi-stage deployment from a Sandbox environment, via integration to production using the same code.

In the context of Bicep or ARM/JSON templates we usually leverage a combination of flexible templates that are deployed using multiple parameter files mapped to different scenarios.

# A module in CARML

In the context of _CARML_ we define a module as a reusable, template-based **building block** for Infrastructure as Code deployments of Azure resources.

Each module is generalized for maximum flexibility. Each template should be able to cover as many resource-specific scenarios as possible and not restrict the user by making assumptions on the users' behalf. Eventually the injected parameters should decide what the template deploys.

Furthermore, each module comes with default values for its optional parameters, a detailed documentation for its usage and one or multiple parameter files to proof its correctness.

## CARML module features

A CARML module should comply with the following characteristics:

- **Atomic unit**: Each module is tied to a specific resource type or strongly correlated services.
  > For example a virtual machine module also deploys related OS disks and network interfaces.
- **Reusable**: Several modules can be combined together to create & orchestrate more complex Azure deployments like single services or workloads.
  > For example resource group, network security group and virtual network modules can be combined to create a resource group hosting a virtual network and multiple subnets in it associated to specific NSGs.
- **Multi-purpose**: Each module aims to cover most of the main resource's capabilities, without the need to maintain multiple module instances for different use cases. Instead, the consumption of a generalized module happens through parameter files​.
  > For example the same virtual machine module can deploy a Windows OS VM or a Linux based VM depending on input parameters.
- **Integrates child resources**: Each module can deploy one instance of a resource and, optionally, n-amount of its child-resources.
  > For example a key vault can optionally deploy n-amount of key vault access policies.
- **Integrates extension resources**: Extension resources are integrated with resource modules supporting them. Intended extension resources are diagnostic settings, role assignments, private endpoints, locks and managed identities.
  > For example an automation account can optionally deploy private endpoints and/or diagnostic settings to support monitoring.

## Example: Multiple Storage Account variants

The following aims to illustrate the previously described module features applied to the storage account module example.

Leveraging five different parameter files, the same storage account module is able to deploy five different storage account configurations.

<img src="media\Context\Library_storage-variants.png" alt="Library: storage variants">

> - **Variant 1**: A plain storage account, with no child or extension resources applied, with a defined storage account sku and kind.
> - **Variant 2**: Another plain storage account with no child or extension resources, with a different sku and kind.
> - **Variant 3**: A storage account hosting two file shares and one blob container.
> - **Variant 4**: A storage account with a specific lock applied.
> - **Variant 5**: A storage account hosting a file share with a specific role assignment applied on the file share level.
