The `'Get-CrossReferencedModuleList'` function helps you with discovering cross-modules references. It checks for any module references in a given path. This can be useful to determine which modules' folder you'd need to keep in case you'd only want to cherry-pick certain modules from the library.

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [How to use it](#how-to-use-it)
  - [Example output](#example-output)
- [Related function: _Get-CrossReferencedModuleList_](#related-function-Get-CrossReferencedModuleList)

---
# Location

You can find the script under `'utilities/tools/Get-CrossReferencedModuleList.ps1'`.

# How it works

When invoking the script:

1. The function fetches all references implemented in the modules in a given path.
1. The function groups them into the '\<ProviderNameSpace\>/\<ResourceType\>' hierarchy by type:
     - Resource (API) deployments
     - Local module (file) references
     - Remote module references (e.g., Bicep Registry / Template Specs)

> Note: The function collects the information recursively. That means, if module `A` has a dependency on module `B`, and Module B a dependency on module `C`, than A will show a dependency on both `B` & `C` (i.e., it is transitive).


> Note: If you provide the `-Verbose` switch, the function further prints all local module references to the terminal

# How to use it

> **Note:** The script must be loaded ('*dot-sourced*') before the function can be invoked.

For details on how to use the function, please refer to the script's local documentation.

## Example output

```PowerShell
VERBOSE: The modules in path [ResourceModules\modules] have the following local folder references:
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
