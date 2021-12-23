# Removal action

This section describes how the removal of resources deployed by a module is performed and how to modify the default behaviour if a specific module or resource type needs it.

---

### _Navigation_

- [Overview](#Overview)
- [How it works](#how-it-works)
- [Create a specialized removal procedure](#create-a-specialized-removal-procedure)

---

# Overview

The Removal action is triggered after the deployment completes. This is used for several reasons:
- Make sure to keep the validation subscription cost as low as possible.
- Enable testing of the full module deployment at every run.

The default removal procedure works fine for most of the modules created so far, so it's likely you won't have to change anything to make the module you're editing to be removed correctly after deployment.

# How it works

The removal process will remove all resources created during deployment. The list is identified by:

1. Recursively fetching the list of resource IDs created through your deployment (resources created by deployments created by the parent one will be fetched too)
1. Ordering the list based on resource IDs segment count (ensures child resources are removed first. E.g. `storageAccount/blobServices` comes before `storageAccount` as it has one more segments delimited by `/`)
1. Filtering out from the list any resource used as dependencies for different modules (e.g. the commonly used Log Analytics workspace)
1. Moving specific resource types to the top of the list (if a certain order is required). For example `vWAN` requires its `Virtual Hubs` to be removed first, even though they are no child-resources.

After a resource is removed (this happens after each resource in the list), the script will execute, if defined, a **post removal operation**. This can be used for those resource types that requires a post processing, like purging a soft-deleted key vault.

The procedure is initiated by the script `/utilities/pipelines/resourceRemoval/Initialize-DeploymentRemoval.ps1`, run during deployment by:
- (Azure DevOps) `/.azuredevops/pipelineTemplates/module.jobs.deploy.yml`
- (GitHub) `/.github/actions/templates/validateModuleDeployment/action.yml`

It uses several helper scripts that can be found in the `/utilities/pipelines/resourceRemoval/helper` folder
# Create a specialized removal procedure

You can define a custom removal procedure by:
1. influencing the **order** in which resources are removed by prioritizing specific resource types 
    > **Example** Removing a _Virtual WAN_ resource requires related resources to be deleted in a specific order
1. defining a **custom removal action** to remove a resource of a _specific resource type_ 
    > **Example** A _Recovery Services Vault_ resource requires some protected items to be identified and removed beforehand
1. defining a custom **post-removal action** to be run after removing a resource of a _specific resource type_
    > **Example** A _Key Vault_ resource needs to be purged when soft deletion is enforced

Those methods can be combined independently.

> **Important**: _custom_ and _post-removal_ actions will be executed when a resource of the type you specify is removed **regardless** of which deployment triggered the deployment. Make sure you do not assume the resource is in a particular state defined by your module.

To modify the resource types removal **order**:
1. Open the `/utilities/pipelines/resourceRemoval/Initialize-DeploymentRemoval.ps1` file.
1. Look for the following comment: `### CODE LOCATION: Add custom removal sequence here`
1. Add a case value that matches your module name
1. In the case block, update the `$removalSequence` variable value to accommodate your module requirements
1. Remember to add the `break` statement.

To defina a **custom removal** action:
1. Open the `/utilities/pipelines/resourceRemoval/helper/Invoke-ResourceRemoval.ps1` file.
1. Look for the following comment: `### CODE LOCATION: Add custom removal action here`
1. Add a case value that matches the resource type you want to modify the removal action for
1. In the case block, define the resource-type-specific removal action

To add a **post-removal** step:
1. Open the `/utilities/pipelines/resourceRemoval/helper/Invoke-ResourcePostRemoval.ps1` file.
1. Look for the following comment: `### CODE LOCATION: Add custom post-removal operation here`
1. Add a case value that matches the resource type you want to add a post-removal operation for
1. In the case block, define the resource-type-specific post removal action
