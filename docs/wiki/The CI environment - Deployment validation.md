This section provides an overview of the principles the deployment validation is built upon, how it is set up, and how you can interact with it.

- [Deployment validation phases](#deployment-validation-phases)
    - [Template validation](#template-validation)
    - [Azure deployment validation](#azure-deployment-validation)
        - [Output example]
    - [Resource removal](#removal)
        - [How it works](#how-it-works)
        - [Create a specialized removal procedure](#create-a-specialized-removal-procedure)
- [Verify the deployment validation of your module locally](#verify-the-deployment-validation-of-your-module-locally)


# Deployment validation phases

<img src=".\media\CIEnvironment\deploymentValidationStep.png" alt="Deployment Validation Step" height="500">

# Template validation

The template validation tests execute a dry-run with each parameter file provided & configured for a module. For example, if you have two parameter files for a module, one with the minimum set of parameters, one with the maximum, the tests will run an `Test-AzDeployment` (_- the command may vary based on the template schema_) with each of the two parameter files to see if the template would be able to be deployed with them. This test could fail either because the template is invalid, or because any of the parameter files is configured incorrectly.

This test executes validation tests such as `Test-AzResourceGroupDeployment` using both the module's template, as well as each specified parameter file. The intention of this test is to fail fast, before we even get to the later deployment test.

However, even for such a simulated deployment we have to account for certain [prerequisites](#prerequisites) and also consider the [tokens replacement](#tokens-replacement) logic we leverage on this platform.

# Azure deployment validation

If all other tests passed, the deployment tests are the ultimate module validation. Using the available & configured parameter files for a module, each is deployed to Azure (in parallel) and verifies if the deployment works end-to-end.

Most of the resources are deleted by default after their deployment, to keep costs down and to be able to retest resource modules from scratch in the next run. However, the removal step can be skipped in case further investigation on the deployed resource is needed. For further details, please refer to the (./PipelinesUsage) section.

This happens using the `utilities/pipelines/resourceDeployment/Test-TemplateWithParameterFile.ps1` script.

> **Note**<br>
Currently the list of the parameter file used to test the module is hardcoded in the module specific workflow, as the **parameterFilePaths** in the _job_deploy_module_ and _job_tests_module_deploy_validate_ jobs.

The deployment phase uses a combination of both the module's template file as well as each specified parameter file to run a parallel deployment towards a given Azure environment.

The parameter files used in this stage should ideally cover as many scenarios as possible to ensure we can use the template for all use cases we may have when deploying to production eventually. Using the example of a CosmosDB module we may want to have one parameter file for the minimum amount of required parameters, one parameter file for each CosmosDB type to test individual configurations and at least one parameter file that tests the supported providers such as RBAC & diagnostic settings.

Note that, for the deployments we have to account for certain [prerequisites](#prerequisites) and also consider the [tokens replacement](#tokens-replacement) logic we leverage on this platform.


**importance of running in sandbox subscription**
> **Note**: Since every customer environment might be different due to applied Azure Policies or security policies, modules might behave differently or naming conventions need to be tested and applied beforehand.

### Output example

<img src=".\media\CIEnvironment\deploymentValidationOutput.png" alt="Deployment Validation Output" height="400">

## Resource removal

This paragraph describes how the removal of resources deployed by a module is performed and how to modify the default behavior if a specific module or resource type needs it.

The removal phase is triggered after the deployment completes. It takes care of removing all resources deployed as part of the previous deployment phase. The reason is twofold:
- Make sure to keep the validation subscription cost as low as possible.
- Allow test deployments from scratch at every run.

### How it works

The removal process will remove all resources created during deployment. The list is identified by:

1. Recursively fetching the list of resource IDs created through your deployment (resources created by deployments created by the parent one will be fetched too).
1. Ordering the list based on resource IDs segment count (ensures child resources are removed first. E.g. `storageAccount/blobServices` comes before `storageAccount` as it has one more segments delimited by `/`).
1. Filtering out from the list any resource used as dependencies for different modules (e.g. the commonly used Log Analytics workspace).
1. Moving specific resource types to the top of the list (if a certain order is required). For example `vWAN` requires its `Virtual Hubs` to be removed first, even though they are no child-resources.

After a resource is removed (this happens after each resource in the list), the script will execute, if defined, a **post removal operation**. This can be used for those resource types that requires a post processing, like purging a soft-deleted key vault.

The procedure is initiated by the script `/utilities/pipelines/resourceRemoval/Initialize-DeploymentRemoval.ps1`, run during deployment by:
- (Azure DevOps) `/.azuredevops/pipelineTemplates/jobs.validateModuleDeployment.yml`
- (GitHub) `/.github/actions/templates/validateModuleDeployment/action.yml`

It uses several helper scripts that can be found in the `/utilities/pipelines/resourceRemoval/helper` folder

### Create a specialized removal procedure

This paragraph is intended for CARML contributors who are willing to add a new module to the library. It contains instructions on how to operate with the removal scripts in case a customized removal is needed for any specific resource.

The default removal procedure works fine for most of the modules created so far, so it's likely you won't have to change anything to make the module you're editing to be removed correctly after deployment.

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

To define a **custom removal** action:
1. Open the `/utilities/pipelines/resourceRemoval/helper/Invoke-ResourceRemoval.ps1` file.
1. Look for the following comment: `### CODE LOCATION: Add custom removal action here`
1. Add a case value that matches the resource type you want to modify the removal action for
1. In the case block, define the resource-type-specific removal action

To add a **post-removal** step:
1. Open the `/utilities/pipelines/resourceRemoval/helper/Invoke-ResourcePostRemoval.ps1` file.
1. Look for the following comment: `### CODE LOCATION: Add custom post-removal operation here`
1. Add a case value that matches the resource type you want to add a post-removal operation for
1. In the case block, define the resource-type-specific post removal action


# Verify the deployment validation of your module locally

This paragraph is intended for CARML contributors or more generally for those leveraging the CARML CI environment and having the need to update or add a new module to the library.

Refer to the below snippet to optionally leverage the 'Test-ModuleLocally.ps1' script and verify if your module will comply with the deployment validation step before pushing to source control.

```powershell
#########[ Function Test-ModulesLocally.ps1 ]#############
$pathToRepository = '<pathToClonedRepo>'
. "$pathToRepository\utilities\tools\Test-ModuleLocally.ps1"

# REQUIRED INPUT FOR TESTING
$TestModuleLocallyInput = @{
    templateFilePath              = "$pathToRepository\arm\Microsoft.Authorization\roleDefinitions\deploy.bicep"
    PesterTest                    = $false
    DeploymentTest                = $true
    ValidationTest                = $true
    ValidateOrDeployParameters    = @{
        Location          = '<ReplaceWith-TargetLocation>'
        ResourceGroupName = 'validation-rg'
        SubscriptionId    = '<ReplaceWith-TargetSubscriptionId>'
        ManagementGroupId = '<ReplaceWith-TargetManagementGroupName>'
    }
    AdditionalTokens              = @{
        'deploymentSpId' = '<ReplaceWith-SPNObjectId>'
        'tenantId'       = '<ReplaceWith-TargetTenantId>'
    }
}

Test-ModuleLocally @TestModuleLocallyInput -Verbose
```

> You can use the `Get-Help` cmdlet to show more options on how you can use this script.
