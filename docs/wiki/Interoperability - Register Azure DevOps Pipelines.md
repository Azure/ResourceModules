Not all customers may be using GitHub repos and/or GitHub Actions. CARML can be hosted in a GitHub repo and deployed using Azure DevOps Pipelines or run entirely through Azure DevOps.

Use the script described in this article to automatically register all specified Azure DevOps pipelines in a target Azure DevOps project. This is especially useful to register the initial module pipelines as there is one for each module in the repository.

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [How to use it](#how-to-use-it)

---
# Location

You can find the script under [`/utilities/tools/AzureDevOps/Register-AzureDevOpsPipeline.ps1`](https://github.com/Azure/ResourceModules/blob/main/utilities/tools//AzureDevOps/Register-AzureDevOpsPipeline.ps1)

# How it works

1. Get all pipelines in a given target folder (for example, `.azuredevops/modulePipelines`)
1. Fetch all currently registered pipelines in the target Azure DevOps project
1. Compare the local defined and remote-registered pipelines to detect which ones need to be created and which ones skipped
1. Create all pipelines that are missing from the target environment
1. Optionally register the pipelines also for build validation (i.e., they registered to be required for Pull Requests)

# How to use it

> **Note:** You'll need the 'azure-devops' extension to run this function: `az extension add --upgrade -n azure-devops`

Perform the following steps:
1. (If pipelines are in GitHub) Create a service connection to the target GitHub repository using e.g., oAuth
1. Create a PAT token for the Azure DevOps environment in which you want to register the pipelines in
1. Run this script with the corresponding input parameters
1. Create any required element required to run the pipelines. For example:
   - Library group(s) used in the pipeline(s)
   - Service connection(s) used in the pipeline(s)
   - Agent pool(s) used in the pipeline(s) if not using the default available agents

For further details on how to use the function, please refer to the script's local documentation.
> **Note:** The script must be loaded ('*dot-sourced*') before the function can be invoked.
