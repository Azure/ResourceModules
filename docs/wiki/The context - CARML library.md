This page provides an overview of the CARML library. For further details refer to the dedicated Wiki section [The library](./The%20library)

---

### _Navigation_

- [What is IaC?](#what-is-iac)
- [How do we define a module?](#how-do-we-define-a-module)

---

# What is IaC?

_'Infrastructure as Code (IaC)'_ describes a declarative approach towards resource deployment & management.
Using configuration & template files that represent the deployed infrastructure has several benefits:
- You have a local representation of your deployed infrastructure is mapped to a local
- Version control: The applied configuration is version controlled and hence enabled roll-backs & analysis
- Repeatability: You can deploy you infrastructure in a repeatable fashion - hence minimizing the possibility of manual errors
- Reusability: You can use automation to deploy your infrastructure and establish for example a multi-stage deployment (i.e. continuous deployment) from a Sandbox environment, via integration to production using the same files

In the context of Bicep or ARM/JSON templates we usually leverage a combination of flexible templates that are deployed using different parameter files for different scenarios.

# How do we define a module?

In the context of _CARML_ we define a module as a reusable, template-based building block to deploy Azure resources. As such it is the foundation to apply _Infrastructure as Code_.

By default each module can deploy one instance of a resource and n-amount of its child-resources (for example `1` storage account and `n`-amount of containers). In some instances a module may also deploy strongly coupled resources (for example `1` virtual machine and `n`-amount of data discs).

Each module is generalized for maximum flexibility and optimized for easy usability. The idea is that the template should be able to cover as many resource-specific scenarios as possible and not restrict the user by making assumptions on the users behalf. Eventually the injected parameters should decide what the template does.

Furthermore, each module comes with meaningful default values for it's optional parameters, a detailed documentation for its usage and one or multiple parameter files to proof is correctness.
