This section will give on an overview on how to get started using this repository.

# What is a Resource Module?
A Resource Module is a reusable building block. A Module encapsulates one or more Azure resources and their respective configurations for reuse in your Azure environment.

# Prerequisites

To be able to deploy [ARM][AzureResourceManager] templates you should have the latest version [PowerShell 7][PowerShellDocs] + [Azure Az Module][InstallAzPs] or [Azure CLI](<https://docs.microsoft.com/en-us/cli/azure/>) as well as [Bicep][Bicep] installed.

# Installation

## One-liner to install or update Azure CLI

```PowerShell
# Windows
iwr https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; start msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi

# Linux
curl -L https://aka.ms/InstallAzureCli | bash
```

## One-liner to install or update PowerShell 7 on Windows 10

```PowerShell
iex "&amp; { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
```

Make sure to install Azure Az Module as well.

```PowerShell
iex "&amp; { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
```

# Use the repository

You have several options to leverage the content of this repository:

## Clone / download the repository
To save a local copy of the repository you can either clone the repository or download it as a `.zip` file.
A clone is a direct reference the the source repository which enables you to pull updates as they happen in the source repostory. To achive this you have to have `Git` installed and run the command

```PowerShell
    git clone 'https://github.com/Azure/ResourceModules.git'`
```

from the command line of your choice.

If you instead just want to have a copy of the repository's content you can instead download it in the `.zip` format. You can do this by navigating to the repository folder of your choice (for example root), then select the `<> Code` button on the top left and click on `Download ZIP` on the opening blade.

 <img src="./media/cloneDownloadRepo.JPG" alt="How to download repository" height="266" width="295">

## Fork the repository

Alternativly, if you want to have a linked clone of the source repository in your own GitHub account, you can fork the repository instead. Still is also the preferred method to contribute back to this repository.

To fork the repostory you can simply click on the `Fork` button on the top right of the repository website. You can then select the Account you want to fork the repository to and are good to go.

*Note*: To ensure your fork stays up to date you can select the 'Fetch upstream' button on your repository root page. This will trigger a process that fetches the latest changes from the source repository back to your fork.

## Reference the content directly

Last but not least, instead of fetching your own copy of the repository you can also choose to just reference the content of the repository directly. This works as the repository is public and hence all file Urls are available without any sort of authentication.

*Note*: In cases where you want to assemble your own template that references other modules you should not rely on direct links as they referencing files may receive breaking changes. Instead you should rely on published versions instead.

<!-- References -->

<!-- External -->
[Bicep]: <https://github.com/Azure/bicep>
[Az]: <https://img.shields.io/powershellgallery/v/Az.svg?style=flat-square&label=Az>
[AzGallery]: <https://www.powershellgallery.com/packages/Az/>
[PowerShellCore]: <https://github.com/PowerShell/PowerShell/releases/latest>
[InstallAzPs]: <https://docs.microsoft.com/en-us/powershell/azure/install-az-ps>
[AzureResourceManager]: <https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview>

<!-- Docs -->
[PowerShellDocs]: <https://docs.microsoft.com/en-us/powershell/>
