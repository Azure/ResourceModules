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

The modules in path [ResourceModules\modules] have the following local folder references:

```PowerShell
VERBOSE: Resource: app-configuration/configuration-store
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: automation/automation-account
VERBOSE: - operational-insights/workspace/linked-service
VERBOSE: - operations-management/solution
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: batch/batch-account
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: cache/redis
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: cognitive-services/account
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: compute/virtual-machine
VERBOSE: - recovery-services/vault/protection-container/protected-item
VERBOSE:
VERBOSE: Resource: container-registry/registry
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: container-service/managed-cluster
VERBOSE: - kubernetes-configuration/extension
VERBOSE: - kubernetes-configuration/flux-configuration
VERBOSE:
VERBOSE: Resource: data-factory/factory
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: digital-twins/digital-twins-instance
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: event-grid/domain
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: event-grid/topic
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: event-hub/namespace
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: insights/private-link-scope
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: key-vault/vault
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: kubernetes-configuration/extension
VERBOSE: - kubernetes-configuration/flux-configuration
VERBOSE:
VERBOSE: Resource: machine-learning-services/workspace
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: network/azure-firewall
VERBOSE: - network/public-ip-address
VERBOSE:
VERBOSE: Resource: network/bastion-host
VERBOSE: - network/public-ip-address
VERBOSE:
VERBOSE: Resource: network/nat-gateway
VERBOSE: - network/public-ip-address
VERBOSE:
VERBOSE: Resource: network/virtual-network-gateway
VERBOSE: - network/public-ip-address
VERBOSE:
VERBOSE: Resource: operational-insights/workspace
VERBOSE: - operations-management/solution
VERBOSE:
VERBOSE: Resource: purview/account
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: recovery-services/vault
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: relay/namespace
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: resources/resource-group
VERBOSE: - authorization/locks/resource-group
VERBOSE:
VERBOSE: Resource: service-bus/namespace
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: signal-r-service/signal-r
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: signal-r-service/web-pub-sub
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: sql/server
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: storage/storage-account
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: synapse/private-link-hub
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: synapse/workspace
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: web/site
VERBOSE: - network/private-endpoint
VERBOSE:
VERBOSE: Resource: web/static-site
VERBOSE: - network/private-endpoint
```
