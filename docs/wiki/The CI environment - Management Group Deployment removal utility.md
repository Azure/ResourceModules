Use this script to remove Management-Group-Level Azure deployments on scale. This may be necessary in cases where you run many (test) deployments in this scope as Azure currently only auto-removes deployments from an [Resource-Group & Subscription](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-history-deletions?tabs=azure-powershell) scope. The resulting error message may look similar to `Creating the deployment '<deploymentName>' would exceed the quota of '800'. The current deployment count is '804'. Please delete some deployments before creating a new one, or see https://aka.ms/800LimitFix for information on managing deployment limits.`

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [How to use it](#how-to-use-it)

---
# Location

You can find the script under [`/utilities/tools/Clear-ManagementGroupDeployment`](https://github.com/Azure/ResourceModules/blob/main/utilities/tools/Clear-ManagementGroupDeployment.ps1)

# How it works

1. The script fetches all current deployments from Azure.
1. By default it then filters them down to non-running & non-failing deployments (can be modified).
1. Lastly, it removes all matching deployments in chunks of 100 deployments each.

# How to use it

For details on how to use the function, please refer to the script's local documentation.

> **Note:** The script must be loaded ('*dot-sourced*') before the function can be invoked.
