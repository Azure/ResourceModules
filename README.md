# ![AzureIcon] Common Azure Resource Modules Library

## Description

This repository includes a library of mature and curated [Bicep][Bicep] modules as well as a Continuous Integration (CI) environment leveraged for modules' validation and versioned publishing.

The CI environment supports both ARM and Bicep and can be leveraged using GitHub actions as well as Azure DevOps pipelines.

## Status

[![.Platform: Linter](https://github.com/Azure/ResourceModules/actions/workflows/platform.linter.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.linter.yml)

[![.Platform: Broken Links Check](https://github.com/Azure/ResourceModules/actions/workflows/platform.linkcheck.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.linkcheck.yml)

## Get started

* For introduction guidance visit the [Wiki](https://github.com/azure/ResourceModules/wiki)
* For information on contributing, see [Contribution](<https://github.com/Azure/ResourceModules/wiki/Contribution%20guide>)
* File an issue via [GitHub Issues](https://github.com/azure/ResourceModules/issues/new/choose)
* For reference documentation, visit [Enterprise-Scale](https://github.com/azure/enterprise-scale)
* For an outline of the module features, visit [Module overview](https://github.com/Azure/ResourceModules/wiki/The%20library%20-%20Module%20overview)

## Available Resource Modules

| Name | Status |
| - | - |


## Tooling

| Name | Status | Docs |
| - | - | - |
| [ConvertTo-ARMTemplate](https://github.com/Azure/ResourceModules/blob/main/utilities/tools/ConvertTo-ARMTemplate.ps1) | [![.Platform: Test - ConvertTo-ARMTemplate.ps1](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Test%20-%20ConvertTo-ARMTemplate.ps1/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.convertToArmTemplate.tests.yml) | [link](https://github.com/Azure/ResourceModules/wiki/Interoperability%20-%20Bicep%20to%20ARM%20conversion) |

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

<!-- References -->

<!-- Local -->
[Wiki]: <https://github.com/Azure/Modules/wiki>
[ProjectSetup]: <https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions>
[GitHubDocs]: <https://docs.github.com/>
[AzureDevOpsDocs]: <https://docs.microsoft.com/en-us/azure/devops/?view=azure-devops>
[GitHubIssues]: <https://github.com/Azure/Modules/issues>
[Contributing]: CONTRIBUTING.md
[AzureIcon]: docs/media/MicrosoftAzure-32px.png
[PowershellIcon]: docs/media/MicrosoftPowerShellCore-32px.png
[BashIcon]: docs/media/Bash_Logo_black_and_white_icon_only-32px.svg.png

<!-- External -->
[Bicep]: <https://github.com/Azure/bicep>
[Az]: <https://img.shields.io/powershellgallery/v/Az.svg?style=flat-square&label=Az>
[AzGallery]: <https://www.powershellgallery.com/packages/Az/>
[PowerShellCore]: <https://github.com/PowerShell/PowerShell/releases/latest>
[InstallAzPs]: <https://docs.microsoft.com/en-us/powershell/azure/install-az-ps>
[AzureResourceManager]: <https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview>
[TemplateSpecs]: <https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs>

[ESLZ]: <https://github.com/Azure/Enterprise-Scale>
[AzureSecurityBenchmark]: <https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/security-governance-and-compliance#azure-security-benchmark>
[ESLZWorkloadTemplatesLibrary]: <https://github.com/Azure/Enterprise-Scale/tree/main/workloads>

<!-- Docs -->
[MicrosoftAzureDocs]: <https://docs.microsoft.com/en-us/azure/>
[PowerShellDocs]: <https://docs.microsoft.com/en-us/powershell/>
