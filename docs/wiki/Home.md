# Common Azure Resource Modules Library

The objective of this repository is to provide a template library that can accelerate deployments in Infrastructure as Code scenarios, such as Azure landing zones, landing zone accelerators and aspiring landing zone accelerators (workloads/applications/multi-module solutions) or individual service deployments.

This wiki describes the content of this repository, its modules, pipelines, and possible options on how to use them and how to contribute to this project.

If you're unfamiliar with Infrastructure as Code or wonder how you can use the content of this repository in your deployments, check out [The context](./The%20context) section of this wiki.

### _Navigation_

- [The context](./The%20context)
  - [CARML overview](./The%20context%20-%20CARML%20overview)
    - [The library](./The%20context%20-%20CARML%20library)
    - [The CI environment](./The%20context%20-%20CARML%20CI%20environment)
  - [Logical layers and personas](./The%20context%20-%20Logical%20layers%20and%20personas)
- [Getting started](./Getting%20started)
  - [**Scenario 1:** Consume module library only](./Getting%20started%20-%20Scenario%201%20Consume%20library)
  - [**Scenario 2:** Onboard module library and CI environment](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment)
    - [Check namePrefix availability](./Getting%20started%20-%20Check%20NamePrefix%20availability)
  - [**Scenario 3:** Contribute](./Getting%20started%20-%20Scenario%203%20Contribute)
- [The library](./The%20library)
  - [Module overview](./The%20library%20-%20Module%20overview)
  - [Module design](./The%20library%20-%20Module%20design)
  - [Module usage](./The%20library%20-%20Module%20usage)
- [The CI environment](./The%20CI%20environment)
  - [Pipeline design](./The%20CI%20environment%20-%20Pipeline%20design)
    - [Static validation](./The%20CI%20environment%20-%20Static%20validation)
    - [Deployment validation](./The%20CI%20environment%20-%20Deployment%20validation)
    - [Publishing](./The%20CI%20environment%20-%20Publishing)
    - [Token replacement](./The%20CI%20environment%20-%20Token%20replacement)
    - [GitHub ReadMe module table update](./The%20CI%20environment%20-%20GitHub%20ReadMe%20module%20table%20update)
  - [Pipeline usage](./The%20CI%20environment%20-%20Pipeline%20usage)
- [Interoperability](./Interoperability)
  - [Bicep to ARM/JSON conversion](./Interoperability%20-%20Bicep%20to%20ARM%20conversion)
  - [Register Azure DevOps pipelines](./Interoperability%20-%20Register%20Azure%20DevOps%20pipelines)
- [Contribution guide](./Contribution%20guide)
  - [Contribution flow](./Contribution%20guide%20-%20Contribution%20flow)
  - [Generate module Readme](./Contribution%20guide%20-%20Generate%20module%20Readme)
  - [Get formatted RBAC roles](./Contribution%20guide%20-%20Get%20formatted%20RBAC%20roles)
  - [Validate module locally](./Contribution%20guide%20-%20Validate%20module%20locally)
  - [Validate modules on scale](./Contribution%20guide%20-%20Validate%20module%20on%20scale)
- [Solution creation](./Solution%20creation)
- Upgrade guideline
  - [Upgrade from 0.3.1 to 0.4.0](./Upgrade%20from%200.3.1%20to%200.4.0)
- [Known issues](./Known%20issues)

---

# Scope

Following, you can find an abstract overview of everything in- and out-of-scope of this repository.

## In Scope

- **Module library:** A collection of comprehensive, reusable, Bicep-based building blocks to deploy Azure resources, that can be combined to create & orchestrate more complex, multi-module Azure solutions.
- **CI environment:** Pipelines to validate modules & publish the successfully validated ones to a target location, using semantic versioning. Available with both GitHub Workflows and Azure DevOps pipelines.
- **Documentation:** Including design principles and usage of [The library](./The%20library) and [The CI environment](./The%20CI%20environment) as well as step-by-step guidelines on how to start leveraging them - see in the [Getting started](./Getting%20started) section.

## Out of Scope

- **Orchestration:** Orchestrated, multi-module solutions such as workloads or applications intended for production environments.
- **Real-time Updates:** Modules are updated on a best effort basis by a group of committed contributors.
- **Languages:** Other domain-specific languages (DSL), like _Terraform_.

# Reporting Issues

## Bugs

If you find any bugs, please file an issue on the [GitHub Issues][GitHubIssues] page by filling out the provided template with the appropriate information.

> Please search the existing issues before filing new issues to avoid duplicates.

If you are taking the time to mention a problem, even a seemingly minor one, it is greatly appreciated, and a totally valid contribution to this project. **Thank you!**

## Feature requests

If there is a feature you would like to see in here, please file an issue or feature request on the [GitHub Issues][GitHubIssues] page to provide direct feedback.

---

# Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.

---

# Learn More

- [PowerShell Documentation][PowerShellDocs]
- [Microsoft Azure Documentation][MicrosoftAzureDocs]
- [Azure Resource Manager][AzureResourceManager]
- [Bicep][Bicep]
- [GitHubDocs][GitHubDocs]

<!-- References -->

<!-- Local -->
[GitHubDocs]: <https://docs.github.com/>
[GitHubIssues]: <https://github.com/Azure/Modules/issues>
[AzureResourceManager]: <https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview>
[Bicep]: <https://github.com/Azure/bicep>

<!-- Docs -->
[MicrosoftAzureDocs]: <https://docs.microsoft.com/en-us/azure/>
[PowerShellDocs]: <https://docs.microsoft.com/en-us/powershell/>
