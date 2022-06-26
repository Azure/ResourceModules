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

.EXAMPLE
Invoke-GitHubWorkflow -PersonalAccessToken '<Placeholder>' -GitHubRepositoryOwner 'Azure' -GitHubRepositoryName 'ResourceModules' -WorkflowFileName 'ms.analysisservices.servers.yml' -TargetBranch 'main'

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

        [Parameter(Mandatory = $true)]
        [string] $WorkflowFilePath,

        [Parameter(Mandatory = $false)]
        [string] $TargetBranch = 'main'
    )

    # Load used function
    . (Join-Path (Split-Path $PSScriptRoot -Parent) 'pipelines' 'sharedScripts' 'Get-GitHubWorkflowDefaultInput.ps1')

    $workflowFileName = Split-Path $WorkflowFilePath -Leaf
    $workflowParameters = Get-GitHubWorkflowDefaultInput -workflowPath $WorkflowFilePath -Verbose
    $removeDeploymentFlag = $workflowParameters.removeDeployment

    $requestInputObject = @{
        Method  = 'POST'
        Uri     = "https://api.github.com/repos/$GitHubRepositoryOwner/$GitHubRepositoryName/actions/workflows/$workflowFileName/dispatches"
        Headers = @{
            Authorization = "Bearer $PersonalAccessToken"
        }
        Body    = @{
            ref    = $TargetBranch
            inputs = @{
                prerelease       = 'false'
                removeDeployment = $removeDeploymentFlag
            }
        } | ConvertTo-Json
    }
    if ($PSCmdlet.ShouldProcess("GitHub workflow [$workflowFileName] for branch [$TargetBranch]", 'Invoke')) {
        $response = Invoke-RestMethod @requestInputObject

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

        [Parameter(Mandatory = $false, ParameterSetName = 'AzureDevOps')]
        [string] $AzureDevOpsOrganizationName = 'ResourceModules',

        [Parameter(Mandatory = $false, ParameterSetName = 'AzureDevOps')]
        [string] $AzureDevOpsProjectName = 'ResourceModules',

        [Parameter(Mandatory = $false, ParameterSetName = 'AzureDevOps')]
        [string] $AzureDevOpsPipelineFolderPath = 'CARML-Modules'
    )

    if ($Environment -eq 'GitHub') {

        $baseInputObject = @{
            PersonalAccessToken   = $PersonalAccessToken
            GitHubRepositoryOwner = $GitHubRepositoryOwner
            GitHubRepositoryName  = $GitHubRepositoryName
        }

        # List all workflows
        $workflows = Get-GitHubModuleWorkflowList @baseInputObject -Filter $PipelineFilter

        $gitHubWorkflowBadges = [System.Collections.ArrayList]@()

        # Invoke workflows for target branch
        foreach ($workflow in $workflows) {

            $workflowName = $workflow.name
            $workflowFilePath = $workflow.path
            $WorkflowFileName = Split-Path $Workflow.path -Leaf

            if ($PSCmdlet.ShouldProcess("GitHub workflow [$WorkflowFileName] for branch [$TargetBranch]", 'Invoke')) {
                $null = Invoke-GitHubWorkflow @baseInputObject -TargetBranch $TargetBranch -WorkflowFilePath (Join-Path $RepositoryRoot $workflowFilePath)
            }

            # Generate pipeline badges
            if ($GeneratePipelineBadges) {
                $encodedBranch = [System.Web.HttpUtility]::UrlEncode($TargetBranch)
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

        Write-Verbose "Log into Azure DevOps project $OrganizationName/$AzureDevOpsProjectName with a PAT"
        $azureDevOpsOrgUrl = "https://dev.azure.com/$AzureDevOpsOrganizationName/"
        $PersonalAccessToken | az devops login

        Write-Verbose "Set default Azure DevOps configuration to [$AzureDevOpsOrganizationName/$AzureDevOpsProjectName]"
        az devops configure --defaults organization=$orgUazureDevOpsOrgUrlrl project=$AzureDevOpsProjectName --use-git-aliases $true

        Write-Verbose "Get and list all Azure Pipelines in $PipelineTargetPath"
        $azurePipelines = az pipelines list --organization $azureDevOpsOrgUrl --project $AzureDevOpsProjectName --folder-path $AzureDevOpsPipelineFolderPath | ConvertFrom-Json | Sort-Object name

        # List all pipelines
        # Filter to only module pipelines
        # Invoke pipelines for target branch

        # Generate pipeline badges
        if ($GeneratePipelineBadges) {

            $encodedBranch = [System.Web.HttpUtility]::UrlEncode($TargetBranch)
            $workflowUrl = "https://dev.azure.com/$AzureDevOpsOrganizationName/$AzureDevOpsProjectName/_apis/build/status/$AzureDevOpsPipelineFolderPath/{0}?branchName=$encodedBranch"

            $gitHubWorkflowBadges += "[![$workflowName]($workflowUrl/badge.svg?branch=$encodedBranch)]($workflowUrl)"


            # [![Build Status](https://dev.azure.com/servicescode/infra-as-code-source/_apis/build/status/CARML-Modules/AnalysisServices%20-%20Servers?branchName=issue%2F1127)](https://dev.azure.com/servicescode/infra-as-code-source/_build/latest?definitionId=2156&branchName=issue%2F1127)
        }
    }
}
