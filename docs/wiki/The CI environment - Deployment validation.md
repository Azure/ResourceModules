
<img src=".\media\CIEnvironment\deploymentValidationStep.png" alt="Deployment Validation Step" height="500">

<img src=".\media\CIEnvironment\deploymentValidationOutput.png" alt="Deployment Validation Output" height="400">

# Template validation

The template validation tests execute a dry-run with each parameter file provided & configured for a module. For example, if you have two parameter files for a module, one with the minimum set of parameters, one with the maximum, the tests will run an `Test-AzDeployment` (_- the command may vary based on the template schema_) with each of the two parameter files to see if the template would be able to be deployed with them. This test could fail either because the template is invalid, or because any of the parameter files is configured incorrectly.

---

# Deployment validation

If all other tests passed, the deployment tests are the ultimate module validation. Using the available & configured parameter files for a module, each is deployed to Azure (in parallel) and verifies if the deployment works end-to-end.

Most of the resources are deleted by default after their deployment, to keep costs down and to be able to retest resource modules from scratch in the next run. However, the removal step can be skipped in case further investigation on the deployed resource is needed. For further details, please refer to the (./PipelinesUsage) section.

This happens using the `utilities/pipelines/resourceDeployment/Test-TemplateWithParameterFile.ps1` script.

> **Note**<br>
Currently the list of the parameter file used to test the module is hardcoded in the module specific workflow, as the **parameterFilePaths** in the _job_deploy_module_ and _job_tests_module_deploy_validate_ jobs.

#### Simulated deployment validation

This test executes validation tests such as `Test-AzResourceGroupDeployment` using both the module's template, as well as each specified parameter file. The intention of this test is to fail fast, before we even get to the later deployment test.

However, even for such a simulated deployment we have to account for certain [prerequisites](#prerequisites) and also consider the [tokens replacement](#tokens-replacement) logic we leverage on this platform.

### Test deploy

The deployment phase uses a combination of both the module's template file as well as each specified parameter file to run a parallel deployment towards a given Azure environment.

The parameter files used in this stage should ideally cover as many scenarios as possible to ensure we can use the template for all use cases we may have when deploying to production eventually. Using the example of a CosmosDB module we may want to have one parameter file for the minimum amount of required parameters, one parameter file for each CosmosDB type to test individual configurations and at least one parameter file that tests the supported providers such as RBAC & diagnostic settings.

Note that, for the deployments we have to account for certain [prerequisites](#prerequisites) and also consider the [tokens replacement](#tokens-replacement) logic we leverage on this platform.

**importance of running in sandbox subscription**
> **Note**: Since every customer environment might be different due to applied Azure Policies or security policies, modules might behave differently or naming conventions need to be tested and applied beforehand.

#### Removal

The removal phase takes care of removing all resources deployed as part of the previous deployment phase. The reason is twofold: keeping validation subscriptions costs down and allow deployments from scratch at every run.

For additional details on how removal works please refer to the dedicated [Removal action](PipelineRemovalAction) page.

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
