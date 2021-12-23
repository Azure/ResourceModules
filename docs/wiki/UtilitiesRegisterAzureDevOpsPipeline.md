# Register Azure DevOps Pipelines

Use this script to automatically register all specified Azure DevOps pipelines in a target Azure DevOps project. This is especially useful to register the initial module pipelines as there is one for each module in the repository.

---

### _Navigation_

- [Location](#location)
- [How it works](#what-it-does)
- [How to use it](#how-to-use-it)
  - [Examples](#examples)

---
# Location

You can find the script under `/utilities/tools/Register-AzureDevOpsPipeline.ps1`

# How it works

1. Get all pipelines in a given target folder (for example `.azuredevops/modulePipelines`)
1. Fetch all currently registered pipelines in the target Azure DevOps project
1. Compare the local defined and remote-registered pipelines to detect which need to be created and which skipped
1. Create all pipelines that are missing
1. Optionally register the pipelines also for build validation (i.e. they registered to be required for Pull Requests)

# How to use it

> **Note:** You'll need the 'azure-devops' extension to run this function: `az extension add --upgrade -n azure-devops`

The steps you'd want to follow are
1. (if pipelines are in GitHub) Create a service connection to the target GitHub repository using e.g. oAuth
1. Create a PAT token for the Azure DevOps environment in which you want to register the pipelines in
1. Run this script with the corresponding input parameters
1. Create any required element required to execute the pipelines. For example:
   - Library group(s) used in the pipeline(s)
   - Service connection(s) used in the pipeline(s)
   - Agent pool(s) used in the pipeline(s) if not using the default available agents

For further details please refer to the script's local documentation.

## Example 1: Register all pipelines in a GitHub repository with default values in a the target project using a pre-created GitHub service connection
```powershell
. './utilities/tools/Register-AzureDevOpsPipeline.ps1'
$inputObject = @{
    OrganizationName      = 'Contoso'
    ProjectName           = 'CICD'
    SourceRepository      = 'Azure/ResourceModules'
    AzureDevOpsPAT        = '<Placeholder>'
}
Register-AzureDevOpsPipeline @inputObject
```

## Example 2: Register all pipelines in a DevOps repository with default values in a the target project
```powershell
. './utilities/tools/Register-AzureDevOpsPipeline.ps1'
$inputObject = @{
    OrganizationName      = 'Contoso'
    ProjectName           = 'CICD'
    SourceRepositoryType  = 'tfsgit'
    SourceRepository      = 'Azure/ResourceModules'
    AzureDevOpsPAT        = '<Placeholder>'
}
Register-AzureDevOpsPipeline @inputObject
```
