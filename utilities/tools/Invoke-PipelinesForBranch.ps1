#region helper functions

<#
.SYNOPSIS
Invoke a given GitHub workflow

.DESCRIPTION
Long description

.PARAMETER PersonalAccessToken
Mandatory. The GitHub PAT to leverage when interacting with the GitHub API.

.PARAMETER GitHubRepositoryOwner
Mandatory. The repository's organization.

.PARAMETER GitHubRepositoryName
Mandatory. The name of the repository to trigger the workflows in.

.PARAMETER WorkflowFileName
Mandatory. The name of the workflow to trigger

.PARAMETER TargetBranch
Optional. The branch to trigger the pipeline for.

.PARAMETER GitHubPipelineInputs
Optional. Input parameters to pass into the pipeline. Must match the names of the runtime parameters in the yaml file(s)

.PARAMETER WorkflowFilePath
Required. The path to the workflow.

.EXAMPLE
Invoke-GitHubWorkflow -PersonalAccessToken '<Placeholder>' -GitHubRepositoryOwner 'Azure' -GitHubRepositoryName 'ResourceModules' -WorkflowFileName 'ms.analysisservices.servers.yml' -TargetBranch 'main' -GitHubPipelineInputs @{ prerelease = 'false'; staticValidation = 'true'; deploymentValidation = 'true'; removeDeployment = 'true' }

Trigger the workflow 'ms.analysisservices.servers.yml' with branch 'main' in repository 'Azure/ResourceModules'.
#>
function Invoke-GitHubWorkflow {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $GitHubRepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $GitHubRepositoryName,

        [Parameter(Mandatory = $false)]
        [hashtable] $GitHubPipelineInputs = @{},

        [Parameter(Mandatory = $true)]
        [string] $WorkflowFilePath,

        [Parameter(Mandatory = $false)]
        [string] $TargetBranch = 'main'
    )

    # Load used function
    . (Join-Path (Split-Path $PSScriptRoot -Parent) 'pipelines' 'sharedScripts' 'Get-GitHubWorkflowDefaultInput.ps1')

    $workflowFileName = Split-Path $WorkflowFilePath -Leaf

    $requestInputObject = @{
        Method  = 'POST'
        Uri     = "https://api.github.com/repos/$GitHubRepositoryOwner/$GitHubRepositoryName/actions/workflows/$workflowFileName/dispatches"
        Headers = @{
            Authorization = "Bearer $PersonalAccessToken"
        }
        Body    = @{
            ref    = $TargetBranch
            inputs = $GitHubPipelineInputs
        } | ConvertTo-Json
    }
    if ($PSCmdlet.ShouldProcess("GitHub workflow [$workflowFileName] for branch [$TargetBranch]", 'Invoke')) {
        $response = Invoke-RestMethod @requestInputObject -Verbose:$false

        if ($response) {
            Write-Error "Request failed. Reponse: [$response]"
            return $false
        }
    }

    return $true
}

<#
.SYNOPSIS
Get a list of all GitHub module workflows

.DESCRIPTION
Get a list of all GitHub module workflows. Does not return all properties but only the relevant ones.

.PARAMETER PersonalAccessToken
Mandatory. The GitHub PAT to leverage when interacting with the GitHub API.

.PARAMETER GitHubRepositoryOwner
Mandatory. The repository's organization.

.PARAMETER GitHubRepositoryName
Mandatory. The name of the repository to fetch the workflows from.

.PARAMETER Filter
Optional. A filter to apply when fetching the workflows. By default we fetch all module workflows (ms.*).

.EXAMPLE
Get-GitHubModuleWorkflowList -PersonalAccessToken '<Placeholder>' -GitHubRepositoryOwner 'Azure' -GitHubRepositoryName 'ResourceModules'

Get all module workflows from repository 'Azure/ResourceModules'
#>
function Get-GitHubModuleWorkflowList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $GitHubRepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $GitHubRepositoryName,

        [Parameter(Mandatory = $false)]
        [string] $Filter = 'ms.*'
    )

    $allWorkflows = @()
    $page = 1
    do {
        $requestInputObject = @{
            Method  = 'GET'
            Uri     = "https://api.github.com/repos/$GitHubRepositoryOwner/$GitHubRepositoryName/actions/workflows?per_page=100&page=$page"
            Headers = @{
                Authorization = "Bearer $PersonalAccessToken"
            }
        }
        $response = Invoke-RestMethod @requestInputObject

        if (-not $response.workflows) {
            Write-Error "Request failed. Reponse: [$response]"
        }

        $allWorkflows += $response.workflows | Select-Object -Property @('id', 'name', 'path', 'badge_url') | Where-Object { (Split-Path $_.path -Leaf) -like $Filter }

        $expectedPages = [math]::ceiling($response.total_count / 100)
        $page++
    } while ($page -le $expectedPages)

    return $allWorkflows
}
#endregion

<#
.SYNOPSIS
Trigger all pipelines for either Azure DevOps or GitHub

.DESCRIPTION
Trigger all pipelines for either Azure DevOps or GitHub. By default, pipelines are filtered to CARML module pipelines.
Note, for Azure DevOps you'll need the 'azure-devops' extension: `az extension add --upgrade -n azure-devops`

.PARAMETER PersonalAccessToken
Mandatory. The PAT to use to interact with either GitHub / Azure DevOps.

.PARAMETER TargetBranch
Mandatory. The branch to run the pipelines for (e.g. `main`).

.PARAMETER PipelineFilter
Optional. The pipeline files to filter down to. By default only files with a name that starts with 'ms.*' are considered. E.g. 'ms.network*'.

.PARAMETER Environment
Optional. The environment to run the pipelines for. By default it's GitHub.

.PARAMETER GeneratePipelineBadges
Optional. Generate pipeline status badges for the given pipeline configuration.

.PARAMETER RepositoryRoot
Optional. The root of the repository. Used to load related functions in their folder path.

.PARAMETER GitHubRepositoryOwner
Optional. The GitHub organization to run the workfows in. Required if the chosen environment is `GitHub`. Defaults to 'Azure'.

.PARAMETER GitHubRepositoryName
Optional. The GitHub repository to run the workfows in. Required if the chosen environment is `GitHub`. Defaults to 'ResourceModules'.

.PARAMETER AzureDevOpsOrganizationName
Optional. The Azure DevOps organization to run the pipelines in. Required if the chosen environment is `AzureDevOps`.

.PARAMETER AzureDevOpsProjectName
Optional. The Azure DevOps project to run the pipelines in. Required if the chosen environment is `AzureDevOps`.

.PARAMETER AzureDevOpsPipelineFolderPath
Optional. The folder in Azure DevOps the pipelines are registerd in. Required if the chosen environment is `AzureDevOps`. Defaults to 'CARML-Modules'.

.EXAMPLE
Invoke-PipelinesForBranch -PersonalAccessToken '<Placeholder>' -TargetBranch 'feature/branch' -Environment 'GitHub' -PipelineFilter 'ms.network.*' -GitHubPipelineInputs @{ prerelease = 'false'; staticValidation = 'true'; deploymentValidation = 'true'; removeDeployment = 'true' }

Run all GitHub workflows that start with 'ms.network.*' using branch 'feature/branch'. Also returns all GitHub status badges.

.EXAMPLE
Invoke-PipelinesForBranch -PersonalAccessToken '<Placeholder>' -TargetBranch 'feature/branch' -Environment 'AzureDevOps' -PipelineFilter 'ms.network.*' -AzureDevOpsOrganizationName 'contoso' -AzureDevOpsProjectName 'Sanchez' -AzureDevOpsPipelineFolderPath 'CARML-Modules'

Run all Azure DevOps pipelines that start with 'ms.network.*' using branch 'feature/branch'. Also returns all Azure DevOps pipeline status badges.
#>
function Invoke-PipelinesForBranch {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $TargetBranch,

        [Parameter(Mandatory = $false)]
        [string] $PipelineFilter = 'ms.*',

        [Parameter(Mandatory = $false)]
        [ValidateSet('GitHub', 'AzureDevOps')]
        [string] $Environment = 'GitHub',

        [Parameter(Mandatory = $false)]
        [bool] $GeneratePipelineBadges = $true,

        [Parameter(Mandatory = $false)]
        [string] $RepositoryRoot = (Split-Path (Split-Path $PSScriptRoot -Parent)),

        [Parameter(Mandatory = $false, ParameterSetName = 'GitHub')]
        [string] $GitHubRepositoryOwner = 'Azure',

        [Parameter(Mandatory = $false, ParameterSetName = 'GitHub')]
        [string] $GitHubRepositoryName = 'ResourceModules',

        [Parameter(Mandatory = $false, ParameterSetName = 'GitHub')]
        [hashtable] $GitHubPipelineInputs = @{
            prerelease           = 'false'
            deploymentValidation = 'false'
            removeDeployment     = 'true'
        },

        [Parameter(Mandatory = $false, ParameterSetName = 'AzureDevOps')]
        [string] $AzureDevOpsOrganizationName = '',

        [Parameter(Mandatory = $false, ParameterSetName = 'AzureDevOps')]
        [string] $AzureDevOpsProjectName,

        [Parameter(Mandatory = $false, ParameterSetName = 'AzureDevOps')]
        [string] $AzureDevOpsPipelineFolderPath = 'CARML-Modules'
    )

    if ($Environment -eq 'GitHub') {

        $baseInputObject = @{
            PersonalAccessToken   = $PersonalAccessToken
            GitHubRepositoryOwner = $GitHubRepositoryOwner
            GitHubRepositoryName  = $GitHubRepositoryName
        }

        Write-Verbose 'Fetching current GitHub workflows' -Verbose
        $workflows = Get-GitHubModuleWorkflowList @baseInputObject -Filter $PipelineFilter

        $gitHubWorkflowBadges = [System.Collections.ArrayList]@()

        Write-Verbose "Triggering GitHub workflows for branch [$TargetBranch]" -Verbose
        foreach ($workflow in $workflows) {

            $workflowName = $workflow.name
            $workflowFilePath = $workflow.path
            $WorkflowFileName = Split-Path $Workflow.path -Leaf

            if (Test-Path (Join-Path $RepositoryRoot $workflowFilePath)) {
                if ($PSCmdlet.ShouldProcess("GitHub workflow [$WorkflowFileName] for branch [$TargetBranch]", 'Invoke')) {
                    $null = Invoke-GitHubWorkflow @baseInputObject -TargetBranch $TargetBranch -WorkflowFilePath (Join-Path $RepositoryRoot $workflowFilePath) -GitHubPipelineInputs $GitHubPipelineInputs
                }
            } else {
                Write-Warning ('Warning: Workflow [{0}] is registered, but no workflow file in the target branch [{1}] available' -f (Join-Path $RepositoryRoot $workflowFilePath), $TargetBranch) -Verbose
            }

            # Generate pipeline badges
            if ($GeneratePipelineBadges) {
                $encodedBranch = [uri]::EscapeDataString($TargetBranch)
                $workflowUrl = "https://github.com/$GitHubRepositoryOwner/$GitHubRepositoryName/actions/workflows/$workflowFileName"

                $gitHubWorkflowBadges += "[![$workflowName]($workflowUrl/badge.svg?branch=$encodedBranch)]($workflowUrl)"
            }

        }

        if ($gitHubWorkflowBadges.Count -gt 0) {
            Write-Verbose 'GitHub Workflow Badges' -Verbose
            Write-Verbose '======================' -Verbose
            Write-Verbose ($gitHubWorkflowBadges | Sort-Object | Out-String) -Verbose
        }
    }

    if ($Environment -eq 'AzureDevOps') {

        $azureDevOpsOrgUrl = "https://dev.azure.com/$AzureDevOpsOrganizationName/"

        # Login into Azure DevOps project with a PAT
        $PersonalAccessToken | az devops login

        # Set default Azure DevOps configuration (to not continously specify it on every command)
        az devops configure --defaults organization=$azureDevOpsOrgUrl project=$AzureDevOpsProjectName --use-git-aliases $true

        Write-Verbose "Get and list all [$AzureDevOpsOrganizationName/$AzureDevOpsProjectName] Azure DevOps pipelines in folder [$AzureDevOpsPipelineFolderPath]"
        $azurePipelines = az pipelines list --folder-path $AzureDevOpsPipelineFolderPath | ConvertFrom-Json

        Write-Verbose 'Fetching details' # Required as we need the original file path for filtering (which is only available when fetching the pipeline directly)
        $detailedAzurePipelines = $azurePipelines | ForEach-Object -ThrottleLimit 10 -Parallel {
            Write-Verbose ('Fetching detailed information for pipeline [{0}]' -f $PSItem.name)
            az pipelines show --organization $USING:azureDevOpsOrgUrl --project $USING:AzureDevOpsProjectName --id $PSItem.id | ConvertFrom-Json
        }

        $modulePipelines = $detailedAzurePipelines | Where-Object { (Split-Path $_.process.yamlFileName -Leaf) -like $PipelineFilter } | Sort-Object -Property 'Name'

        Write-Verbose "Triggering Azure DevOps pipelines for branch [$TargetBranch]" -Verbose
        $modulePipelines | ForEach-Object -ThrottleLimit 10 -Parallel {
            if ($Using:WhatIfPreference) {
                Write-Verbose ("Would performing the operation `"Invoke`" on target `"GitHub workflow [{0}] for branch [{1}]`"." -f $PSItem.Name, $USING:TargetBranch) -Verbose
            } else {
                $null = az pipelines run --branch $USING:TargetBranch --id $PSItem.id --organization $USING:azureDevOpsOrgUrl --project $USING:AzureDevOpsProjectName
            }
        }

        if ($GeneratePipelineBadges) {
            foreach ($modulePipeline in $modulePipelines) {

                # Generate pipeline badges
                $pipelineDefinitionId = $modulePipeline.id
                $encodedPipelineName = [uri]::EscapeDataString($modulePipeline.Name)
                $encodedBranch = [uri]::EscapeDataString($TargetBranch)
                $primaryUrl = 'https://dev.azure.com/{0}/{1}/_apis/build/status/{2}/{3}?branchName={4}' -f $AzureDevOpsOrganizationName, $AzureDevOpsProjectName, $AzureDevOpsPipelineFolderPath, $encodedPipelineName, $encodedBranch
                $secondaryUrl = 'https://dev.azure.com/{0}/{1}/_build/latest?definitionId={2}&branchName={3}' -f $AzureDevOpsOrganizationName, $AzureDevOpsProjectName, $pipelineDefinitionId, $encodedBranch

                Write-Verbose "[![Build Status]($primaryUrl)]($secondaryUrl)" -Verbose
            }
        }
    }
}
