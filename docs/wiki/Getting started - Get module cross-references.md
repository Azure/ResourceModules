The `'Get-LinkedLocalModuleList'` function provides you with the capability to check for any local module references in a given path. This can be useful to determine which modules folder you'd need if you don't want to keep the entire library.

---

### _Navigation_

- [Location](#location)
- [How it works](#what-it-does)
- [How to use it](#how-to-use-it)
- [Related function: _Get-LinkedModuleList_](#related-function-get-linkedmodulelist)

---
# Location

You can find the script under `'utilities/tools/Get-LinkedLocalModuleList.ps1'`

# How it works

When invoking the script:

1. The function leverages the utility [Get-LinkedModuleList](#related-function-get-linkedmodulelist) to fetch all references implemented in the modules in a given path
1. The function filters these references down to only local references (i.e. cross-module references) and formats them to show a consistent '\<ProviderNameSpace\>/\<ResourceType\>' format.
1. Finally, it prints the references to the invoking terminal, group by ResourceType.

# How to use it

> **Note:** The script must be loaded before the function can be invoked

For details on how to use the function please refer to the script's local documentation.

## Example output

```PowerShell
VERBOSE: The modules in path [ResourceModules\arm] have the following local folder dependencies:
VERBOSE:
VERBOSE: Resource: Microsoft.ApiManagement/service
VERBOSE: - Microsoft.ApiManagement/authorizationServers
VERBOSE:
VERBOSE: Resource: Microsoft.ContainerRegistry/registries
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.Web/sites
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.EventHub/namespaces
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.MachineLearningServices/workspaces
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.Network/bastionHosts
VERBOSE: - Microsoft.Network/publicIPAddresses
VERBOSE:
VERBOSE: Resource: Microsoft.Sql/servers
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.Insights/privateLinkScopes
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.Web/staticSites
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.Storage/storageAccounts
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.Automation/automationAccounts
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.ServiceBus/namespaces
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.Compute/virtualMachines
VERBOSE: - Microsoft.RecoveryServices/vaults/protectionContainers/protectedItems
VERBOSE: - Microsoft.Network/publicIPAddresses
VERBOSE: - Microsoft.Network/networkInterfaces
VERBOSE:
VERBOSE: Resource: Microsoft.CognitiveServices/accounts
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.Synapse/privateLinkHubs
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.AppConfiguration/configurationStores
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.EventGrid/topics
VERBOSE: - Microsoft.Network/privateEndpoints
VERBOSE:
VERBOSE: Resource: Microsoft.KeyVault/vaults
VERBOSE: - Microsoft.Network/privateEndpoints
```

# Related function: _Get-LinkedModuleList_

The function `'Get-LinkedModuleList'` (also in path `'utilities/tools'`) is leveraged by the `'Get-LinkedLocalModuleList'` function, but can also be invoked on its own. You can use it to get an overview of all references implemented in any module in a given path. This includes:
- Resource deployments
- Cross-Module references
- Remove-Module references (e.g., Bicep Registry)

> **Note:** The script must be loaded before the function can be invoked

For details on how to use the function please refer to the script's local documentation.
