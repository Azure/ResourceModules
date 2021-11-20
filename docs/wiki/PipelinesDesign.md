# Pipelines Design

This section gives you an overview of the design principals the pipelines follow.
---

### _Navigation_

- [Phases](#phases)
  - [Validate](#validate)
    - [Static module validation](#static-module-validation)
    - [Simulated deployment validation](#template-validation)
  - [Test deploy](#test-deploy)
  - [Removal](#removal)
  - [Publish](#Publish)
- [Shared concepts](#shared-concepts)
  - [Validation prerequisites](#validation-prerequisites)
  - [Tokens Replacement](#tokens-replacement)
- [Platform-specific considerations](#platform-specific-considerations)
  - [GitHub Workflows](#github-workflows)

---

## Phases

To "build"/"bake" the modules, a dedicated pipeline is used for each module to validate their production readiness, by:

1. **Validate**:
   1. Running a set of static Pester tests against the template
   1. Validating the template by invoking Azure’s validation API (Test-AzResourceGroupDeployment – or the same for other scopes)
1. **Test deploy**: we deploy each module by using a pre-defined set of parameters to a ‘sandbox’ subscription in Azure to see if it’s really working
   1. **Removal**: The test suite is cleaned up by removing all deployed test resources again
1. **Publish**: the proven results are copied/published to a configured location such as template specs, the bicep registry, Azure DevOps artifacts, etc.

<img src="./media/pipelinePhases.png" alt="Pipeline phases" height="150">

Using this flow, validated modules can be consumed by other any consumer / template / orchestration to deploy a service, workload, or entire environment such as a landing zone.

These 'ad-hoc' test pipelines are important since every customer environment might be different due to applied Azure Policies or security policies, modules might behave differently or naming conventions need to be tested and applied beforehand.

### Validate

The validation phase performs all test outside of a test deployment. This includes [static tests](#static-module-validation) regarding for example a proper documentation, as well as [simulated deployments](#simulated-deployment-validation).

#### Static module validation

This static validation executes the tests documented in the [testing](./Testing.md) section. Without diving into to much detail, we test aspects like a proper ReadMe documentation, a proper module folder structure, a minimum number of refresh of the leveraged of API versions and the like.

#### Simulated deployment validation

This test executes validation tests such as `Test-AzResourceGroupDeployment` using both the module's template, as well as each specified parameter file. The intention of this test is to fail fast, before we even get to the later deployment test.

However, even for such a simulated deployment we have to account for certain [prerequisites](#prerequisites) and also consider the [tokens replacement](#tokens-replacement) logic we leverage on this platform.

### Test deploy

The deployment phase uses a combination of both the module's template file as well as each specified parameter file to run a parallel deployment towards a given Azure environment.

The parameter files used in this stage should ideally cover as many scenarios as possible to ensure we can use the template for all use cases we may have when deploying to production eventually. Using the example of a CosmosDB module we may want to have one parameter file for the minimum amount of required parameters, one parameter file for each CosmosDB type to test individual configurations and at least one parameter file that tests the supported providers such as RBAC & diagnostic settings.

Note that, for the deployments we have to account for certain [prerequisites](#prerequisites) and also consider the [tokens replacement](#tokens-replacement) logic we leverage on this platform.

### Removal

The removal phase is strongly coupled with the previous deployment phase. Fundamentally, we want to remove any test-deployed resource after its test concluded. If we would not, we would generate unnecessary costs and may temper with any subsequent test.

> ***Note:*** At the time of this writing, resources to be removed are identified using Azure tags. This means, at deployment time, a specific tag is applied to the resources which is then picked up by the removal phase to remove the same. However, while this solution works for most modules, it does not for all. The main reasons why it would fail are:
> - Lack of 'Tag' support
> - Soft-delete
> - Resource removal must occur in a specific order
>
> To account for these cases, a new approach is implemented and will succeed the current solution.

### Publish

The publish phase concludes each module's pipeline. If all previous tests succeeded (i.e. no phase failed) and the pipeline was executed in the main/master branch, a new module version is published to all configured target locations. Currently we support
- _template specs_
- _private bicep registry_

By the time of this writing, the publishing experience works as follows:
1. A user can optionally specific a specific version in the module's pipeline file, or during runtime. If the user does not, a default version is used
1. No matter what publishing location we enabled, the corresponding logic will
   1. Fetch the latest version of this module in the target location (if available)
   1. Compare it with any specified custom version the user optionally provided
      - If the custom version is higher, it is used going forward
      - If it is lower, the fallback mechanism will select a new version based on some default behavior (e.g. increment to the next patch version)
   1. The identified new version is then used to publish the module to the target location in question

## Shared concepts

There are several concepts that are shared among the phases. Most notably the [simulated deployment validation](#simulated-deployment-validation) and [test deployment](#test-deploy).

### Prerequisites

For both the [simulated deployment validation](#simulated-deployment-validation) as well as the [test deployment](#test-deployment) we should account for the following prerequisites:
- A _"Sandbox"_ or _"Engineering"_ **validation subscription** (in Azure) has to be used to test if the modules (or other components) are deployable. This subscription must not have connectivity to any on-premises or other Azure networks.
- An Azure Active Directory Service Principal (AAD SPN) to authenticate to the validation subscription and run the test deployments of the modules.

### Tokens Replacement

The validation or deploy actions/templates includes a step that replaces certain strings in a parameter file with values that are provided from the module workflow. This helps achieve the following:

Dynamic parameters that do not need to be hardcoded in the parameter file, and the ability to reuse the repository as a fork, where users define the same tokens in their own "repository secrets", which are then available automatically to their parameter files.

For example, some modules require referencing Azure resources with the Resource ID. This ID typically contains the `subscriptionId` in the format of `/subscriptions/<<subscriptionId>>/...`. This task substitutes the `<<subscriptionId>>` with the correct value, based on the different token types.

Please review the Parameter File Tokens [Design](./ParameterFileTokens) for more details on the different token types and how you can use them to remove hardcoded values from your parameter files.

## Platform-specific considerations



### GitHub Workflows

#### **Component:** Variable file(s)
#### **Component:** Composite Actions
#### **Component:** Workflows
