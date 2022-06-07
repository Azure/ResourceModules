Use this script to test a module locally. You can use it to run only the static validation (pester tests), a deployment validation (dryRun) or an actual deployment to Azure. In the latter cases the script also takes care to replace placeholder tokens in the used parameter file for you.

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [How to use it](#how-to-use-it)

---
# Location

You can find the script under `/utilities/tools/Test-ModuleLocally.ps1`

# How it works

If the switch for pester tests (`-PesterTest`) is provided the script will
1. Invoke the global module test for the provided template file path and run all tests for it

If the switch for either the validation test (`-ValidationTest`) or deployment test (`-DeploymentTest`) is provided alongside a HashTable for the token replacement (`-ValidateOrDeployParameters`), the script will
1. Either fetch all parameter files of the module's parameter folder (default) or you can specify a single parameter file by leveraging the `parameterFilePath` parameter instead.
1. Create a dictionary to replace all tokens in these parameter files with actual values. This dictionary will consist
   - of the subscriptionID & managementGroupID of the provided `ValidateOrDeployParameters` object,
   - add all key-value pairs of the `-AdditionalTokens` object to it,
   - and optionally also add all key-value pairs specified in the `settings.json`'s `parameterFileTokens` object
1. If the `-ValidationTest` parameter was set, it runs a deployment validation using the `Test-TemplateDeployment` script
1. If the `-DeploymentTest` parameter was set, it runs a deployment using the `New-TemplateDeployment` script (with no retries).
1. As a final step it rolls the parameter files back to their original state if either the `-ValidationTest` or `-DeploymentTest` parameters were provided.

# How to use it

For details on how to use the function, please refer to the script's local documentation.
> **Note:** The script must be loaded ('*dot-sourced*') before the function can be invoked.
