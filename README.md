# ![AzureIcon] Modules

This repository consists of a collection of compliant [Azure Resource Manager (ARM)][AzureResourceManager] and [Bicep][Bicep] templates as well as supporting [template specs](<https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs>).

This library of **Modules** ensures organizations can deploy compliant Azure services aligned with the proactive and preventive policies provided by [Enterprise-Scale landing zones (ESLZ)](<https://github.com/Azure/Enterprise-Scale>), aligned with [Azure Security Benchmark](<https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/security-governance-and-compliance#azure-security-benchmark>).

> This repository serves ***currently*** as a temporary extension and development site for [ESLZ Workload Templates library](<https://github.com/Azure/Enterprise-Scale/tree/main/workloads>).

## Description

## Status

[![Super Linter](<https://github.com/Azure/Modules/actions/workflows/linter.yml/badge.svg>)](<https://github.com/Azure/Modules/actions/workflows/linter.yml>)

[![Sample Workflow](<https://github.com/Azure/Modules/actions/workflows/workflow.yml/badge.svg>)](<https://github.comAzure/Modules/actions/workflows/workflow.yml>)

## Getting Started

### Prerequisites

To be able to deploy [ARM][AzureResourceManager] templates you should have latest version [PowerShell 7][PowerShellDocs] + [Azure Az Module][InstallAzPs] or [Azure CLI](<https://docs.microsoft.com/en-us/cli/azure/>)as well as [Bicep][Bicep] installed.

### Installation

#### One-liner to install or update Azure CLI on Windows 10

```PowerShell
iwr https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; start msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
```

#### One-liner to install or update Azure CLI on Linux
```bash
curl -L https://aka.ms/InstallAzureCli | bash
```

#### One-liner to install or update PowerShell 7 on Windows 10

```PowerShell
iex "&amp; { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
```

Make sure to install Azure Az Module as well.

```PowerShell
iex "&amp; { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
```

### Usage

#### Deploy local template (Azure CLI)

```bash
az group create --name ExampleGroup --location "Central US"
az deployment group create \
  --name ExampleDeployment \
  --resource-group ExampleGroup \
  --template-file <path-to-template> \
  --parameters storageAccountType=Standard_GRS
```

#### Deploy local template (PowerShell)

```PowerShell
New-AzResourceGroup -Name ExampleGroup -Location "Central US"
New-AzResourceGroupDeployment `
  -Name ExampleDeployment `
  -ResourceGroupName ExampleGroup `
  -TemplateFile <path-to-template>
```

#### Deploy remote template (Azure CLI)

```bash
az group create --name ExampleGroup --location "Central US"
az deployment group create \
  --name ExampleDeployment \
  --resource-group ExampleGroup \
  --template-uri "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.storage/storage-account-create/azuredeploy.json" \
  --parameters storageAccountType=Standard_GRS
```

#### Deploy remote template (PowerShell)

```PowerShell
New-AzResourceGroup -Name ExampleGroup -Location "Central US"
New-AzResourceGroupDeployment `
  -Name remoteTemplateDeployment `
  -ResourceGroupName ExampleGroup `
  -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.storage/storage-account-create/azuredeploy.json
```

## FAQ and Known Issues

Any advise for common problems or issues.
```bash
command to run if program contains helper info
```

## Reporting Issues and Feedback

### Issues and Bugs

If you find any bugs, please file an issue in the [GitHub Issues][GitHubIssues] page. Please fill out the provided template with the appropriate information.
> Please search the existing issues before filing new issues to avoid duplicates.

If you are taking the time to mention a problem, even a seemingly minor one, it is greatly appreciated, and a totally valid contribution to this project. **Thank you!**

### Feedback

If there is a feature you would like to see in here, please file an issue or feature request in the [GitHub Issues][GitHubIssues] page to provide direct feedback.

## Contributors

Contributors names and contact info

* [@segraef](<https://twitter.com/segraef>)

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.

## Learn More

* [PowerShell Documentation][PowerShellDocs]
* [Microsoft Azure Documentation][MicrosoftAzureDocs]
* [Azure Resource Manager][AzureResourceManager]
* [Bicep][Bicep]
* [GitHubDocs][GitHubDocs]

<!-- References -->

<!-- Local -->
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

<!-- Docs -->
[MicrosoftAzureDocs]: <https://docs.microsoft.com/en-us/azure/>
[PowerShellDocs]: <https://docs.microsoft.com/en-us/powershell/>