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

### Removal

The removal phase is strongly coupled with the previous deployment phase. Fundamentally, we want to remove any test-deployed resource after the test concluded. If they are not, they result in unnecessary costs and may temper with any subsequent test.

### Publish

## Shared concepts

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
