As per the module design structure, every module in the CARML library requires a ReadMe markdown file documenting the set of deployable resource types, input and output parameters and a set of relevant template references from the official Azure Resource Reference documentation.

The `Set-Module` utility aims to simplify contributing to the AVM library, as it supports
- idempotently generating the AVM folder structure for a module (including any child resource)
- generating the module's ReadMe file from scratch or updating it
- compiling/building the module template

To ease maintenance, you can run the utility with a `Recurse` flag from the root of your folder to update all files automatically.

> **Note:** If you want to add any non-generated content to the Readme you can do so by adding it to a `## Notes` section at the bottom of the corresponding readme.

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [How to use it](#how-to-use-it)

---
# Location

You can find the script under [`/utilities/tools/Set-Module.ps1`](https://github.com/Azure/ResourceModules/blob/main/utilities/tools/Set-Module.ps1)

# How it works

Using the provided template path, the script
1. validates the module's folder structure
   - To do so, it searches for any required folder path / file missing and adds them. For several files, it will also provide some default content to get you started. The sources files for this action can be found [here](https://github.com/Azure/ResourceModules/tree/main/utilities/tools/helper/src)
1. compiles its bicep template
1. updates the readme (recursively, specified)
   1. If the intended ReadMe file does not yet exist in the expected path, it is generated with a skeleton (with e.g., a generated header name)
   1. The script then goes through all sections defined as `SectionsToRefresh` (by default all) and refreshes the sections' content (for example, for the `Parameters`) based on the values in the ARM/JSON Template. It detects sections by their header and always regenerates the full section.
   1. Once all sections are refreshed, the current ReadMe file is overwritten. **Note:** The script can be invoked combining the `WhatIf` and `Verbose` switches to just receive an console-output of the updated content.

# How to use it

For details on how to use the function, please refer to the script's local documentation.
> **Note:** The script must be loaded ('*dot-sourced*') before the function can be invoked.
