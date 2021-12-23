# Register Azure DevOps Pipelines

Use this script to automatically register all specified Azure DevOps pipelines in a target Azure DevOps project. This is especially useful to register the initial module pipelines as there is one for each module in the repository.

---

### _Navigation_

- [Location](#location)
- [What it does](#what-it-does)
- [How to use it](#how-to-use-it)
  - [Examples](#examples)

---
# Location

You can find the script under `/utilities/tools/Register-AzureDevOpsPipeline.ps1`

# What it does

1. Get all pipelines in a given target folder (for example `.azuredevops/modulePipelines`)
1. Fetch all currently registered pipelines in the target Azure DevOps project
1. Compare the local defined and remote-registered pipelines to detect which need to be created and which skipped
1. Create all pipelines that are missing
1. Optionally register the pipelines also for build validation (i.e. they registered to be required for Pull Requests)

# How to use it

The script can be called with the following parameters:

| Name | Description |
|-|-|
| `OrganizationName` | Required. The name of the Azure DevOps organization. |
| `ProjectName` | Required. The name of the Azure DevOps project. |
| `AzureDevOpsPAT` | Required. The access token with appropriate permissions to create Azure Pipelines. <p> Usually the System.AccessToken from an Azure Pipeline instance run has sufficient permissions as well ([reference](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/access-tokens?view=azure-devops&tabs=yaml#how-do-i-determine-the-job-authorization-scope-of-my-yaml-pipeline)). <p> Needs at least the permissions: `Release`: `Read`, `write`, `execute & manage` |
| `SourceRepository` | Optional. The name of the source repository. <p> Defaults to 'Azure/ResourceModules' |
| `SourceRepositoryType` | Optional. The type of source repository. Either 'GitHub' or 'tfsgit' (for Azure DevOps). <p> Defaults to 'GitHub'. |
| `GitHubPAT` | Optional. A personal access token for the GitHub repository with the source code. |
| `GitHubServiceConnectionName` | Optional. The pre-created service connection to the GitHub source repository if the pipeline files are in GitHub. <p> It is recommended to create the service connection using oAuth. |
| `BranchName` | Optional. Branch name for which the pipelines will be configured. <p> Default to 'main'. |
| `PipelineTargetPath` | Optional. Folder path in which the pipelines are created. <p> Defaults to 'Modules' |
| `RelativePipelinePath` | Optional. The relative local path to the folder with the pipeline YAML files. Make sure your workspace is opened in the repository root. <p> Defaults to '.azuredevops/modulePipelines'. |
| `CreateBuildValidation` | Optional. Create an additional pull request build validation rule for the pipelines. |

> **Note:** You'll need the 'azure-devops' extension to run this function: `az extension add --upgrade -n azure-devops`

The steps you'd want to follow are
1. (if pipelines are in GitHub) Create a service connection to the target GitHub repository using e.g. oAuth
1. Create a PAT token for the Azure DevOps environment in which you want to register the pipelines in
1. Run this script with the corresponding input parameters
1. Create any required element required to execute the pipelines. For example:
   - Library group(s) used in the pipeline(s)
   - Service connection(s) used in the pipeline(s)
   - Agent pool(s) used in the pipeline(s) if not using the default available agents

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
