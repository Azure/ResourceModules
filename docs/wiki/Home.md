# Common Azure Resource Modules Library

The objective of this repository is to provide a template library that can be reused in Infrastructure as Code scenarios, such as landing zone, workloads or individual service deployments.

This wiki describes the content of this repository, the modules, pipelines, possible options on how to use them and how to contribute to this project.

If you're unfamiliar with Infrastructure as Code, or wonder how you can use the contents of this repository in your deployments please check out the [context](./Context) section of this wiki.

### _Navigation_

- [Context](./Context)
  - [Infrastructure as Code](./Context#infrastructure-as-code-iac)
  - [Where does this platform fit in?](./Context#where-does-this-platform-fit-in)
- [Getting Started](./GettingStarted)
  - [General prerequisites](./GettingStarted#General-prerequisites)
  - [Where to start](./GettingStarted#Where-to-start)
- [Modules](./Modules)
  - [Design](./ModulesDesign)
  - [Usage](./ModulesUsage)
- [Testing](./Testing)
  - [Design](./TestingDesign)
  - [Usage](./TestingUsage)
- [Utilities](./Utilities)
  - [Bicep to ARM conversion script](./UtilitiesConvertToARMTemplate)
  - [Register Azure DevOps pipelines script](./UtilitiesRegisterAzureDevOpsPipeline)
  - [Set Module ReadMe script](./UtilitiesSetModuleReadMe)
  - [Get formatted RBAC roles script](./UtilitiesGetFormattedRBACRoleList)
  - [GitHub readMe module table update script](./UtilitiesSetGitHubReadMeModuleTable.md)
- [Pipelines](./Pipelines)
  - [Design](./PipelinesDesign)
    - [Parameter File Tokens](./ParameterFileTokens)
    - [Removal action](./PipelineRemovalAction)
  - [Usage](./PipelinesUsage)
- [Contribution Guide](./ContributionGuide)
- [Known Issues](./KnownIssues)

---

> **Note**: the following table of contents is still a work in progress and intended to replace the above going forward.

### _Updated Navigation_

- [The context](./The%20context)
  - [Infrastructure as Code](./The%20context%20-%20IaC)
  - [CARML overview](./The%20context%20-%20CARML%20overview)
- [Getting started](./Getting%20started)
  - [Prerequisites](./Getting%20started%20-%20Prerequisites)
  - [Setup environment](./Getting%20started%20-%20Setup%20environment)
  - [Token replacement](./Getting%20started%20-%20Token%20replacement)
  - [Dependency pipeline](./Getting%20started%20-%20Dependency%20pipeline)
- [The library](./The%20library)
  - [Module design](./The%20library%20-%20Module%20design)
  - [Module usage](./The%20library%20-%20Module%20usage)
- [The CI environment](./The%20CI%20environment)
  - [Pipeline design](./The%20CI%20environment%20-%20Pipeline%20design)
    - [Static validation](./The%20CI%20environment%20-%20Static%20validation)
    - [Deployment validation](./The%20CI%20environment%20-%20Deployment%20validation)
    - [Publishing](./The%20CI%20environment%20-%20Publishing)
  - [Pipeline usage](./The%20CI%20environment%20-%20Pipeline%20usage)
- [Interoperability](./Interoperability)
  - [Bicep to ARM/JSON conversion](./Interoperability%20-%20Bicep%20to%20ARM%20conversion)
  - [Register ADO pipelines](./Interoperability%20-%20Register%20ADO%20pipelines)
- [Contribution guide](./Contribution%20guide)
  - [Generate module Readme](./Contribution%20guide%20-%20Generate%20module%20Readme)
  - [Get formatted RBAC roles](./Contribution%20guide%20-%20Get%20formatted%20RBAC%20roles)
- [Known Issues](./Known%20issues)

---

# Scope

Following you can find an abstract overview of everything in- and out-of-scope of this repository.

## In Scope
- **Modules:** Rich library of resource modules - the foundation for workload or entire environments deployments
- **Platform:** Pipelines to validate modules & publish to those that pass to a location of your choice. Available with GitHub Workflows.
- **Documentation:** A rich documentation of best practices on [module](./Modules) design, the [platforms](./Context) and its [context](./Context), [testing](./Testing) and [pipelines](./Pipelines)

## Out of Scope
- **Orchestration:** Orchestrated solutions such as workloads or entire environments intended for production environments
- **Real-time Updates:** Modules are updated on a best effort basis by a group of dedicated contributors
- **Languages:** Other design languages like _Terraform_

# Reporting Issues and Feedback

## Issues and Bugs

If you find any bugs, please file an issue in the [GitHub Issues][GitHubIssues] page. Please fill out the provided template with the appropriate information.
> Please search the existing issues before filing new issues to avoid duplicates.

If you are taking the time to mention a problem, even a seemingly minor one, it is greatly appreciated, and a totally valid contribution to this project. **Thank you!**

## Feedback

If there is a feature you would like to see in here, please file an issue or feature request in the [GitHub Issues][GitHubIssues] page to provide direct feedback.

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
