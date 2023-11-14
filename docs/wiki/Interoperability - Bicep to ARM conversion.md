
Bicep is [ready for production use](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/frequently-asked-questions#is-this-ready-for-production-use) starting with version 0.3. It is supported by Microsoft support plans and has parity with what can be accomplished with ARM Templates.

However, for users who still prefer using ARM templates over Bicep, the CARML library provides a script that uses the Bicep Toolkit translator/compiler to support the conversion of CARML Bicep modules to ARM/JSON Templates.

This page documents the conversion utility and how to use it.

> **NOTE:** As Bicep & ARM template files work slightly different (e.g., references as specified differently), the ReadMe we generate out of them using the [`/utilities/tools/Set-Module.ps1`](https://github.com/Azure/ResourceModules/blob/main/utilities/tools/Set-Module.ps1) utility may look differently. To this end, make sure to regenerate all ReadMEs after you converted the repository from Bicep to ARM. If you don't, the Pester tests in the pipeline may fail when reviewing the ReadMEs.

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [How to use it](#how-to-use-it)

---
# Location

You can find the script under [`/utilities/tools/ConvertTo-ARMTemplate.ps1`](https://github.com/Azure/ResourceModules/blob/main/utilities//tools/ConvertTo-ARMTemplate.ps1)

# How it works

The script finds all `main.bicep` files and converts them to json-based ARM templates by using the following steps:
1. Remove existing main.json files from folders where main.bicep files are also present.
1. Convert .bicep files to .json
1. Remove Bicep metadata from the converted .json files
1. Remove .bicep files and folders
1. Update pipeline files - Replace .bicep with .json in pipeline files

# How to use it

For details on how to use the function, please refer to the script's local documentation.
> **Note:** The script must be loaded ('*dot-sourced*') before the function can be invoked.
