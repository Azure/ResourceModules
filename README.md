# ![AzureIcon] Common Azure Resource Modules Library

## Description

This repository includes a library of mature and curated [Bicep][Bicep] modules as well as a Continuous Integration (CI) environment leveraged for modules' validation and versioned publishing.

The CI environment supports both ARM and Bicep and can be leveraged using GitHub actions as well as Azure DevOps pipelines.

<h1 style="color: steelblue;">Upcoming breaking changes</h1>

In between now and the release of version `0.11.0`, the `main` branch is subject to several upcoming breaking changes that will affect all modules (e.g., the renaming of folders and files).

The rationale is an ongoing effort to prepare our modules for a release in the official [Public Bicep Registry](https://github.com/Azure/bicep-registry-modules), forcing us to align the structural requirements.

For more details, please refer to the issue #3131.

## Get started

* For introduction guidance visit the [Wiki](https://github.com/azure/ResourceModules/wiki)
* For guidance on which version of the code to leverage, see [Disclaimer](https://github.com/azure/resourcemodules#Disclaimer)
* For information on contributing, see [Contribution](<https://github.com/Azure/ResourceModules/wiki/Contribution%20guide>)
* File an issue via [GitHub Issues](https://github.com/azure/ResourceModules/issues/new/choose)
* For reference documentation, visit [Enterprise-Scale](https://github.com/azure/enterprise-scale)
* For an outline of the module features, visit [Module overview](https://github.com/Azure/ResourceModules/wiki/The%20library%20-%20Module%20overview)

> **Note:** To ensure the modules and environment work as expected, please ensure you are using the latest version of the used tools such as PowerShell and Bicep. Especially in case of the later, note, that you need to manually update the Bicep CLI. For further information, see our [troubleshooting guide](./The%20CI%20environment%20-%20Troubleshooting).

## Available Resource Modules

| Name | Status |
| - | - |

## Platform

| Name | Status |
| - | - |
| Update API Specs file | [![.Platform: Update API Specs file](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Update%20API%20Specs%20file/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.apiSpecs.yml) |
| Assign Pull Request to Author | [![.Platform: Assign Pull Request to Author](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Assign%20Pull%20Request%20to%20Author/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.assignPrToAuthor.yml) |
| Test - ConvertTo-ARMTemplate.ps1 | [![.Platform: Test - ConvertTo-ARMTemplate.ps1](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Test%20-%20ConvertTo-ARMTemplate.ps1/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.convertToArmTemplate.tests.yml) |
| Clean up deployment history | [![.Platform: Clean up deployment history](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Clean%20up%20deployment%20history/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.deployment.history.cleanup.yml) |
| Library PSRule pre-flight validation | [![.Platform: Library PSRule pre-flight validation](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Library%20PSRule%20pre-flight%20validation/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.librarycheck.psrule.yml) |
| Broken Links Check | [![.Platform: Broken Links Check](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Broken%20Links%20Check/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.linkcheck.yml) |
| Linter (audit) | [![.Platform: Linter (audit)](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Linter%20(audit)/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.linter.yml) |
| Manage issues for failing pipelines | [![.Platform: Manage issues for failing pipelines](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Manage%20issues%20for%20failing%20pipelines/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.ManageIssueForFailingPipelines.yml) |
| Update ReadMe status Tables | [![.Platform: Update ReadMe status Tables](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Update%20ReadMe%20status%20Tables/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.updateReadMe.yml) |
| Update Static Test Documentation | [![.Platform: Update Static Test Documentation](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Update%20Static%20Test%20Documentation/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.updateStaticTestDocs.yml) |
| Sync Docs/Wiki | [![.Platform: Sync Docs/Wiki](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Sync%20Docs/Wiki/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.wiki-sync.yml) |

## Disclaimer

Please note that CARML is constantly evolving and introducing new features. The `main` branch of this repository changes frequently and thus, it always contains the latest available version of the code. Some of the updates may introduce breaking changes as well.
- **Default path**: To avoid disruptions, use distinct versions available through [releases](https://github.com/Azure/ResourceModules/releases).
- **Early adopter path**: If the risk of breaking changes is understood and accepted, you can use the code in the `main` branch directly. However, the CARML team recommends against automatically pulling code from `main`. It is always recommended to review changes before you pull them into your own repository.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

For specific guidelines on how to contribute to this repository please refer to the [Contribution guide](https://github.com/Azure/ResourceModules/wiki/Contribution%20guide) Wiki section.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.

## Learn More

* [PowerShell Documentation][PowerShellDocs]
* [Microsoft Azure Documentation][MicrosoftAzureDocs]
* [GitHubDocs][GitHubDocs]
* [Azure Resource Manager][AzureResourceManager]
* [Bicep][Bicep]

## Telemetry

Modules provided in this library have telemetry enabled by default. To learn more about this feature, please refer to the [Telemetry article](https://github.com/Azure/ResourceModules/wiki/The%20library%20-%20Module%20design#telemetry) in the wiki.

<!-- References -->

<!-- Local -->
[Wiki]: <https://github.com/Azure/Modules/wiki>
[ProjectSetup]: <https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions>
[GitHubDocs]: <https://docs.github.com/>
[AzureDevOpsDocs]: <https://learn.microsoft.com/en-us/azure/devops/?view=azure-devops>
[GitHubIssues]: <https://github.com/Azure/Modules/issues>
[Contributing]: CONTRIBUTING.md
[AzureIcon]: docs/media/MicrosoftAzure-32px.png
[PowershellIcon]: docs/media/MicrosoftPowerShellCore-32px.png

<!-- External -->
[Bicep]: <https://github.com/Azure/bicep>
[Az]: <https://img.shields.io/powershellgallery/v/Az.svg?style=flat-square&label=Az>
[AzGallery]: <https://www.powershellgallery.com/packages/Az/>
[PowerShellCore]: <https://github.com/PowerShell/PowerShell/releases/latest>
[InstallAzPs]: <https://learn.microsoft.com/en-us/powershell/azure/install-az-ps>
[AzureResourceManager]: <https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview>
[TemplateSpecs]: <https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs>

[ESLZ]: <https://github.com/Azure/Enterprise-Scale>
[AzureSecurityBenchmark]: <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/security-governance-and-compliance#azure-security-benchmark>
[ESLZWorkloadTemplatesLibrary]: <https://github.com/Azure/Enterprise-Scale/tree/main/workloads>

<!-- Docs -->
[MicrosoftAzureDocs]: <https://learn.microsoft.com/en-us/azure/>
[PowerShellDocs]: <https://learn.microsoft.com/en-us/powershell/>
