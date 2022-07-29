<#
.SYNOPSIS
Register or update all specified DevOps pipelines in a target DevOps Project

.DESCRIPTION
Register or update all specified DevOps pipelines in a target DevOps Project
If this scripts is run within an Azure pipeline the environment variable AZURE_DEVOPS_EXT_PAT needs to be set with $(System.AccessToken) within your pipeline.
Since tty is not supported within a pipelune run, az devops login is using the token which is set via AZURE_DEVOPS_EXT_PAT.

.REQUIREMENTS
- Azure CLI 2.13.0
- Azure CLI extension devops 0.18.0
- Repository for which the pipeline needs to be configured.
- The '<ProjectName>' Build Service needs 'Edit build pipeline' permissions
Reference: https://docs.microsoft.com/en-us/azure/devops/pipelines/policies/permissions?view=azure-devops#pipeline-permissions

The script can be run as often as you want without breaking anything. Pipelines that already exist will be skipped.

.PARAMETER OrganizationName
Required. The name of the Azure DevOps organization.

.PARAMETER ProjectName
Required. The name of the Azure DevOps project.

.PARAMETER SourceRepository
Optional. The name of the source repository.
Defaults to 'Azure/ResourceModules'

.PARAMETER SourceRepositoryType
Optional. The type of source repository. Either 'GitHub' or 'tfsgit' (for Azure DevOps).
Defaults to 'GitHub'.

.PARAMETER GitHubServiceConnectionName
Optional. The pre-created service connection to the GitHub source repository if the pipeline files are in GitHub.
It is recommended to create the service connection using oAuth.

.PARAMETER AzureDevOpsPAT
Required. The access token with appropriate permissions to create Azure Pipelines.
Usually the System.AccessToken from an Azure Pipeline instance run has sufficient permissions as well.
Reference: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/access-tokens?view=azure-devops&tabs=yaml#how-do-i-determine-the-job-authorization-scope-of-my-yaml-pipeline
Needs at least the permissions:
- Agent Pool:           Read
- Build:                Read & execute
- Service Connections:  Read & query

.PARAMETER BranchName
Optional. Branch name for which the pipelines will be configured.
Default to 'main'.

.PARAMETER PipelineTargetPath
Optional. Folder path in which the pipelines are created.
Defaults to 'Modules'

.PARAMETER RelativePipelinePath
Optional. The relative local path to the folder with the pipeline YAML files. Make sure your workspace is opened in the repository root.
Defaults to '.azuredevops/modulePipelines'.

.PARAMETER CreateBuildValidation
Optional. Create an additional pull request build validation rule for the pipelines.

.EXAMPLE
$inputObject = @{
    OrganizationName      = 'Contoso'
    ProjectName           = 'CICD'
    SourceRepository      = 'Azure/ResourceModules'
    AzureDevOpsPAT        = '<Placeholder>'
}
Register-AzureDevOpsPipeline @inputObject

Registers all pipelines in the default path in the DevOps project [Contoso/CICD] by leveraging the given AzureDevOpsPAT and using a pre-created service connection to GitHub

.EXAMPLE
$inputObject = @{
    OrganizationName      = 'Contoso'
    ProjectName           = 'CICD'
    SourceRepositoryType  = 'tfsgit'
    SourceRepository      = 'Azure/ResourceModules'
    AzureDevOpsPAT        = '<Placeholder>'
}
Register-AzureDevOpsPipeline @inputObject

Register all pipelines in a DevOps repository with default values in a the target project

.NOTES
You'll need the 'azure-devops' extension to run this function: `az extension add --upgrade -n azure-devops`

The steps you'd want to follow are
- (if pipelines are in GitHub) Create a service connection to the target GitHub repository using e.g. oAuth
- Create a PAT token for the Azure DevOps environment in which you want to register the pipelines in
- Run this script with the corresponding input parameters
- Create any required element required to execute the pipelines. For example:
  - Library group(s) used in the pipeline(s)
  - Service connection(s) used in the pipeline(s)
  - Agent pool(s) used in the pipeline(s) if not using the default available agents
#>
function Register-AzureDevOpsPipeline {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $OrganizationName,

        [Parameter(Mandatory = $true)]
        [string] $ProjectName,

        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsPAT,

        [Parameter(Mandatory = $false)]
        [string] $SourceRepository = 'Azure/ResourceModules',

        [Parameter(Mandatory = $false)]
        [ValidateSet('gitHub', 'tfsgit')]
        [string] $SourceRepositoryType = 'gitHub',

        [Parameter(Mandatory = $false)]
        [string] $GitHubServiceConnectionName = $SourceRepository,

        [Parameter(Mandatory = $false)]
        [string] $BranchName = 'main',

        [Parameter(Mandatory = $false)]
        [string] $PipelineTargetPath = 'Modules',

        [Parameter(Mandatory = $false)]
        [string] $RelativePipelinePath = '.azuredevops/modulePipelines',

        [Parameter(Mandatory = $false)]
        [bool] $CreateBuildValidation = $false
    )

    Write-Verbose '##############'
    Write-Verbose '# Local Data #'
    Write-Verbose '##############'
    Write-Verbose 'Identify relevant Azure Pipelines to be updated'

    $localPipelinePaths = (Get-ChildItem -Path $RelativePipelinePath -Recurse -Filter '*.yml').FullName
    Write-Verbose ('Found [{0}] local Pipeline(s) in folder path [{1}]' -f $localPipelinePaths.Count, $RelativePipelinePath)

    $pipelinesArray = @()
    foreach ($localPipelinePath in $localPipelinePaths) {
        $line = (Get-Content -Path $localPipelinePath)[0]
        $pipelineName = ($line -split 'name:')[1].Replace("'", '').Trim()
        $pipelinesArray += @{
            ProjectName      = $ProjectName
            SourceRepository = $SourceRepository
            BranchName       = $BranchName
            FolderPath       = $PipelineTargetPath
            ymlPath          = Join-Path $relativePipelinePath (Split-Path $localPipelinePath -Leaf)
            pipelineName     = $pipelineName
        }
    }

    Write-Verbose '###############'
    Write-Verbose '# Remote Data #'
    Write-Verbose '###############'
    Write-Verbose "Trying to login to Azure DevOps project $OrganizationName/$ProjectName with a PAT"
    $orgUrl = "https://dev.azure.com/$OrganizationName/"
    $AzureDevOpsPAT | az devops login

    Write-Verbose "Set default Azure DevOps configuration to $OrganizationName and $ProjectName"
    az devops configure --defaults organization=$orgUrl project=$ProjectName --use-git-aliases $true

    Write-Verbose "Get and list all Azure Pipelines in $PipelineTargetPath"
    $azurePipelines = az pipelines list --organization $orgUrl --project $ProjectName --folder-path $PipelineTargetPath | ConvertFrom-Json | Sort-Object name
    Write-Verbose ('Found [{0}] Azure Pipeline(s) in project [{1}]' -f $azurePipelines.Count, $ProjectName)

    Write-Verbose '############'
    Write-Verbose '# Evaluate #'
    Write-Verbose '############'
    [array] $pipelinesToBeSkipped = $pipelinesArray | Where-Object { $_.pipelineName -in $azurePipelines.name }
    Write-Verbose ('[{0}] Pipeline(s) will be skipped' -f $pipelinesToBeSkipped.Count)

    [array] $pipelinesToBeUpdated = $pipelinesArray | Where-Object { $_.pipelineName -notin $azurePipelines.name }
    Write-Verbose ('[{0}] Pipeline(s) have been identified to be updated' -f $pipelinesToBeUpdated.Count)

    Write-Verbose '##############'
    Write-Verbose '# Processing #'
    Write-Verbose '##############'
    if ($SourceRepositoryType -eq 'GitHub') {
        $azureDevOpsToGitHubConnection = az devops service-endpoint list -o 'Json' | ConvertFrom-Json | Where-Object { $_.Name -eq $GitHubServiceConnectionName }
    }

    Write-Verbose '----------------------------------'
    foreach ($pipeline in $pipelinesToBeUpdated) {
        Write-Verbose ('Create Azure pipeline [{0}]' -f $pipeline.pipelineName)

        $inputObject = @(
            '--repository', $pipeline.SourceRepository,
            '--repository-type', $SourceRepositoryType,
            '--branch', $pipeline.BranchName,
            '--folder-path', $pipeline.FolderPath,
            '--name', $pipeline.pipelineName,
            '--yml-path', $pipeline.ymlPath.Replace('\', '/'),
            '--skip-run'
        )
        if ($SourceRepositoryType -eq 'GitHub') {
            $inputObject += @('--service-connection', $azureDevOpsToGitHubConnection.id)
        }

        if ($PSCmdlet.ShouldProcess(('Azure DevOps pipeline [{0}]' -f $pipeline.pipelineName), 'Create')) {
            $pipelineresult = az pipelines create @inputObject
            $pipelineobject = $pipelineresult | ConvertFrom-Json
        }

        if ($createBuildValidation) {
            $AzureDevOpsPAThFilter = $pipeline.ymlpath -replace 'pipeline.yml', '*'
            Write-Verbose ('Configuring build validation rule for pipeline [{0}]' -f $pipeline.pipelineName)
            $inputObject = @(
                '--blocking', $true,
                '--branch', $BranchName,
                '--build-definition-id', $pipelineobject.id,
                '--display-name', 'Check {0}' -f $pipeline.pipelineName,
                '--manual-queue-only', $true,
                '--queue-on-source-update-only', $true,
                '--valid-duration', 1440,
                '--path-filter', $AzureDevOpsPAThFilter,
                '--repository-id', $pipelineobject.repository.id,
                '--enabled', $true
            )
            if ($PSCmdlet.ShouldProcess(('Mandatory repository build policy [Check {0}] for pipeline [{0}]' -f $pipeline.pipelineName), 'Create')) {
                az repos policy build create @inputObject
            }
        }
    }
}
