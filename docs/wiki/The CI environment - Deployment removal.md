This pipeline and its scripts can be used to limit the number of deployments that are listed in Azure at any given time. This is especially useful for a scope like 'Management Group' is Azure does not provide any [automatic cleanup](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-history-deletions?tabs=azure-powershell).

The corresponding error message would look similar to `Creating the deployment '<deploymentName>' would exceed the quota of '800'. The current deployment count is '804'. Please delete some deployments before creating a new one, or see https://aka.ms/800LimitFix for information on managing deployment limits.`

The platform pipeline `platform.deployment.removal.yml` has an automatic schedule that runs every night, but can also be triggered on-demand.

By default, the pipeline will cleanup both the Subscription, as well as Management Group scope using the used script's default configuration. In addition, you can specify a pipeline variable `maxDeploymentRetentionInDays` to define beyond which time frame deployments should always be deleted. Within the timeframe, only non-failed and non-running deployments are considered.

> **NOTE**<br> In order for the pipeline to remove both Management-Group-Level as well as Subscription-Level deployments the used service principal needs the [permissions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-history-deletions?tabs=azure-powershell#required-permissions) either scope. If you use CARML to test deployments on any of these scopes your principal will already have the required permissions. <br>
> In case the principal does not have the required permissions you can either:
> - Not register the `platform.deployment.removal.yml` pipeline OR
> - Adjust the pipeline's default behavior to not remove deployments on the scope you'd like to preserve (i.e., change `default: true` to `default: false`)

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [How to use it](#how-to-use-it)

---
# Location

You can find the used scripts under
- [`/utilities/pipelines/deploymentRemoval/Clear-SubscriptionDeployment`](https://github.com/Azure/ResourceModules/blob/main/utilities/pipelines/deploymentRemoval/Clear-SubscriptionDeployment.ps1) and
- [`/utilities/pipelines/deploymentRemoval/Clear-ManagementGroupDeployment`](https://github.com/Azure/ResourceModules/blob/main/utilities/pipelines/deploymentRemoval/Clear-ManagementGroupDeployment.ps1)


# How it works

Both scripts work in the same way:

1. The script fetches all current deployments at a given scope from Azure (i.e., Management-Group-scope or Subscription-scope).
   - For example, it may find
     - 120 successful deployments
     - 10 failed deployments that are 3 weeks old
     - 10 failed deployments that are 1 week old
     - 10 running
1. By default it then filters them down to non-running & non-failing deployments (can be modified) unless they are older than a provided time limit in which case they'd always be included.
   - Following the example, and with a time limit of 2 weeks, it now only considers the
     -  120 successful deployments
     -  10 failed deployments that are 3 weeks old
1. Lastly, it removes all matching deployments in chunks of 100 deployments each.
   - In context of the example, this mean it deletes the deployments with to commands, first removing 100, and then 30 deployments.

# How to use it

For details on how to use the functions, please refer to the scripts local documentation.

> **Note:** Each script must be loaded ('*dot-sourced*') before the function can be invoked.
