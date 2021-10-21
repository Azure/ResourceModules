
### What is a Resource Module?
A Resource Module is a reusable building block. A Module encapsulates one or more Azure resources and their respective configurations for reuse in your Azure environment.

## Getting Started

### Prerequisites

To be able to deploy [ARM][AzureResourceManager] templates you should have latest version [PowerShell 7][PowerShellDocs] + [Azure Az Module][InstallAzPs] or [Azure CLI](<https://docs.microsoft.com/en-us/cli/azure/>)as well as [Bicep][Bicep] installed.



### Installation

#### One-liner to install or update Azure CLI

```PowerShell
# Windows 10
iwr https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; start msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi

# Linux
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
