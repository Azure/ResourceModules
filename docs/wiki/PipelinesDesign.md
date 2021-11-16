# Pipelines Design

This section gives you an overview of the design principals the pipelines follow.

---

### _Navigation_

- [Validate](#validate)
  - [Validation prerequisites](#validation-prerequisites)
  - [Why do I have to validate deployments of modules?](#why-do-i-have-to-validate-deployments-of-modules)
  - [Tokens Replacement](#tokens-replacement)

---

To "build"/"bake" the modules, a dedicated pipeline is used for each module to validate their production readiness, by:

1. **Validate**:
   1. Running a set of static Pester tests against the template
   1. Validating the template by invoking Azure’s validation API (Test-AzResourceGroupDeployment – or the same for other scopes)
1. **Test deployment**: we deploy each module by using a pre-defined set of parameters to a ‘sandbox’ subscription in Azure to see if it’s really working
1. **Publish**: the proven results are copied/published to a configured location such as template specs, the bicep registry, Azure DevOps artifacts, etc.
1. **Removal**: The test suite is cleaned up by removing all deployed test resources again

Using this flow, validated modules can be consumed by other any consumer / template / orchestration to deploy a workload, solution, environment or landing zone.

## Validate

### Validation prerequisites

A _"Sandbox"_ or _"Engineering"_ **validation subscription** (in Azure) has to be used to test if the modules (or other components) are deployable. This subscription must not have connectivity to any on-premises or other Azure networks.
The module validation pipelines use an Azure Active Directory Service Principal (AAD SPN) to authenticate to the validation subscription and run the test deployments of the modules.

### Why do I have to validate deployments of modules?

Since every customer environment might be different due to applied Azure Policies or security policies, modules might behave differently or naming conventions need to be tested and applied beforehand.

### Tokens Replacement

The validation or deploy actions/templates includes a step that replaces certain strings in a parameter file with values that are provided from the module workflow. This helps achieve the following:

Dynamic parameters that do not need to be hardcoded in the parameter file, and the ability to reuse the repository as a fork, where users define the same tokens in their own "repository secrets", which are then available automatically to their parameter files.

> See [Parameter File Tokens](./ParameterFileTokens) for more details.

For example, some modules require referencing Azure resources with the Resource ID. This ID typically contains the `subscriptionId` in the format of `/subscriptions/<<subscriptionId>>/...`. This task substitutes the `<<subscriptionId>>` with the correct value, which is available to the task via environment variables that are defined in the original module workflow. This is known as 'Default Tokens' replacement. See example below:

```yaml
env:
   ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
```

Here are the Default Tokens used in parameter files:

- **subscriptionId**: Defined as `<<subscriptionId>>` in the parameter file and references the _sandbox_ Azure subscription.
- **managementGroupId**: Defined as `<<managementGroupId>>` in the parameter file and references an **existing** Management Group used for Management Group Deployment Scopes.
- **tenantId**: Defined as `<<tenantId>>` in the parameter file and references the Azure Active Directory Tenant that is trusted by the _sandbox_ subscription.
- **deploymentSpId**: Defined as `<<deploymentSpId>>` in the parameter file and references the Service Principal for the Repository deployments. It is used to assign role permissions when modules are being deployed.

---
**Note**: Pester Tests evaluate the use of tokens during the workflow run to look for keywords that require the use of tokens.

---

Please review the Parameter File Tokens [Design](./ParameterFileTokens) for more details on the different token types and how you can use them to remove hardcoded values from your parameter files.

Below is an example of a tokenized parameter file that references an Azure Key Vault for a Virtual Machine Password:

  ```json
  "adminPassword": {
    "reference": {
        "keyVault": {
            "id": "/subscriptions/<<subscriptionId>>/resourceGroups/platform-core-rg/providers/Microsoft.KeyVault/vaults/<<platformKeyVault>>" // Default Tokens
        },
        "secretName": "<<adminPasswordToken>>" // Custom Token
    }
  }
  ```
