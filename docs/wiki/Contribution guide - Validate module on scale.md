Use this script to test a branch across multiple modules using the CI environment. As the script will trigger the pipelines as you would in the CI environment, both static & deployment tests are executed.

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [How to use it](#how-to-use-it)

---
# Location

You can find the script under [`/utilities/tools/Invoke-PipelinesForBranch.ps1`](https://github.com/Azure/ResourceModules/blob/main/utilities/tools/Invoke-PipelinesForBranch.ps1)

# How it works

The most important parameter is the 'Environment' you want to run the pipelines for, that is, either GitHub or Azure DevOps. Depending on your choice you'll have to provide a Personal Access Token that grants the permissions to read & trigger pipelines in the desired environment.

Upon triggering, the utility will:
1. Fetch all pipelines in the target environment & filter them down to, by default, module pipelines.
1. Trigger these pipelines for the provided targeted branch (e.g. `main`)
1. Return the formatted status badges for the pipelines that were triggered.

# How to use it

For details on how to use the function, please refer to the script's local documentation.
> **Note:** The script must be loaded ('*dot-sourced*') before the function can be invoked.
