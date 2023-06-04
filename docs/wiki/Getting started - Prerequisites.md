This section provides an overview of the prerequisites that you will need if working with CARML on your local machine and, for example, run the [utilities/tools/Test-ModuleLocally.ps1](https://github.com/Azure/ResourceModules/blob/main/utilities/tools/Test-ModuleLocally.ps1) script.

---

### _Navigation_

- [Prerequisites](#prerequisites)
- [Helper scripts](#helper-scripts)

---

# Prerequisites

These are
- A GitHub Account
- An active Azure subscription
- `Owner` (or `Contributor` + `User Access Administrator`) permissions on set subscription
- Access to the subscriptions tenant with permissions to create applications
- Installed
  - [Visual Studio Code](https://code.visualstudio.com/Download)
    - \+ Extension: [Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)
  - [Bicep CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#manual-with-powershell)
    > **Note:** Must be kept updated manually (i.e., is not updated via the Az-CLI Bicep extension)
  - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
    - \+ Extension: [Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-cli)
  - [Git](https://git-scm.com/downloads)
    - [Git Guide](https://rogerdudler.github.io/git-guide/)
    > ***Note:*** If just installed, don't forget to set both your git username & password
    > ```PowerShell
    > git config --global user.name "John Doe"
    > git config --global user.email "johndoe@example.com"
    > ```
  - [Windows Terminal](https://www.microsoft.com/en-US/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab)
  - [PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.2)
    - \+ Module: `Az.Accounts`
    - \+ Module: `Az.Resources`
    - \+ Module: `Pester` with minimum version `5.3.1`
    - \+ Module: `powershell-yaml` with minimum version `0.4.2`

# Helper scripts

This sub-section provides you with several helper scripts that can help you set your environment up.

<details>
<summary>Check versions script</summary>

```PowerShell
az --version
az bicep --version
bicep --version
git --version
code --version
pwsh --version

Get-Module -ListAvailable | Where-Object {
  $_.Name -in @(
    'Az.Accounts',
    'Az.Resources',
    'Pester',
    'powershell-yaml'
  )
}
```

</details>

<details>
<summary>Install prerequisites script (Windows 10+)</summary>

```PowerShell
# WinGet software
winget install --id 'Git.Git'
winget install --id 'Microsoft.PowerShell'
winget install --id 'Microsoft.AzureCLI'
winget install --id 'Microsoft.Bicep'
winget install --id 'Microsoft.VisualStudioCode'
winget install --id 'GitHub.GitHubDesktop'
winget install --id 'Microsoft.WindowsTerminal'

# VS Code Extensions
code --install-extension 'ms-azuretools.vscode-bicep'
code --install-extension 'ms-vscode.PowerShell'
code --install-extension 'msazurermtools.azurerm-vscode-tools'
code --install-extension 'ms-vscode.azurecli'

# Installing or updating PowerShell modules may require elevated permissions.
Install-Module -Name 'Az.Accounts' -Scope 'CurrentUser' -Force
Install-Module -Name 'Az.Resources' -Scope 'CurrentUser' -Force
Install-Module -Name 'Pester' -Scope 'CurrentUser' -Force
Install-Module -Name 'powershell-yaml' -Scope 'CurrentUser' -Force
```

</details>
