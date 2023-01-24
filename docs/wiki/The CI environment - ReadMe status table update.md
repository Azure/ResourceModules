Use these scripts to update the diverse module and pipeline status tables (such as 'Available Resource Modules').
In the platform's pipeline `platform.updateReadMe.yml`, these scripts are invoked each time anything in the `modules` path changes to keep the table in sync. It updates
- the root ReadMe ([`/readme.md`](https://github.com/Azure/ResourceModules/blob/main/README.md))
- the `modules` folder ReadMe ([`/modules/readme.md`](https://github.com/Azure/ResourceModules/blob/main/modules/README.md))
- the module overview table ([`/docs/wiki/The library - Module overview.md`](https://github.com/Azure/ResourceModules/wiki/The%20library%20-%20Module%20overview))

with the latest available data.

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [How to use it](#how-to-use-it)

---
# Location

You can find the used scripts under
- [`/utilities/tools/platform/Set-ReadMeModuleTable.ps1`](https://github.com/Azure/ResourceModules/blob/main/utilities/tools/platform/Set-ReadMeModuleTable.ps1)
- [`/utilities/tools/platform/Set-ModuleOverviewTable.ps1`](https://github.com/Azure/ResourceModules/blob/main/utilities/tools/platform/Set-ModuleOverviewTable.ps1)
- [`/utilities/tools/platform/Set-ReadMePlatformTable.ps1`](https://github.com/Azure/ResourceModules/blob/main/utilities/tools/platform/Set-ReadMePlatformTable.ps1)

# How it works

How it works depends on the script that is used to update the corresponding section.

For the module overview the steps are:
1. The script loads the current content of the given readMe file (the one provided via the parameter `FilePath`)
1. It then generates a new table based on an either specified or default set of intended columns (for example, a `name` column, and or `status` column)
1. It replaces the original content in section `Available Resource Modules` with the new table
1. If not invoked with a `-WhatIf` the script will eventually overwrite the original file with the new content

For the module feature overview table the steps are:
1. The scripts searches all available module `deploy.bicep` templates in the provided `ModuleFolderPath`
1. It then iterates over all templates and analyzes their content. Doing so, it determines how big they are, if they support RBAC, if they have child modules, etc.
1. Once done, it uses all the gathered data to generate a markdown table with the results
1. It replaces the original content in the [`The library - Module overview`](https://github.com/Azure/ResourceModules/wiki/The%20library%20-%20Module%20overview) table with the new content
1. If not invoked with a `-WhatIf` the script will eventually overwrite the original file with the new content

For the Platform pipeline status overview, the steps are
1. The script loads the current content of the given readMe file (the one provided via the parameter `FilePath`)
1. It then fetches all Platform pipelines from either the GitHub or the corresponding Azure DevOps folder
1. It extracts each pipeline's name from the corresponding pipeline
1. It generates a status badge for the target environment (GitHub or ADO)
1. It replaces the original content in section `Platform` with the new table
1. If not invoked with a `-WhatIf` the script will eventually overwrite the original file with the new content


# How to use it

For details on how to use these functions, please refer to the scripts local documentation.

> **Note:** Each script must be loaded ('*dot-sourced*') before its function can be invoked.
