<#
.SYNOPSIS
Generate the status URL for the given pipeline/workflow file

.DESCRIPTION
Generate the status URL for the given pipeline/workflow file
E.g.  # [![AnalysisServices: Servers](https://github.com/Azure/ResourceModules/actions/workflows/ms.analysisservices.servers.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.analysisservices.servers.yml)

.PARAMETER PipelineFileName
Mandatory. The name of the workflow/pipeline file to create the badge for. For example 'platform.updateReadMe.yml'.

.PARAMETER PipelineFolderPath
Mandatory. The path to the pipeline/workflow file

.PARAMETER RepositoryName
Mandatory. The repository to create the url for

.PARAMETER Organization
Mandatory. The Organization the repository is hosted in to create the url for

.PARAMETER Environment
Mandatory. The DevOps environment to generate the status badges for

.PARAMETER ProjectName
Optional. The project the repository is hosted in. Required if the 'environment' is 'ADO'

.EXAMPLE
Get-PipelineStatusUrl -PipelineFileName 'platform.updateReadMe.yml' -PipelineFolderPath '.github/workflows' -RepositoryName 'ResourceModules' -Organization 'Azure'

Generate a status badge url for the 'platform.updateReadMe.yml' pipeline in the folder path '.github/workflows' of repo 'Azure/ResourceModules'
#>
function Get-PipelineStatusUrl {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $PipelineFileName,

        [Parameter(Mandatory = $true)]
        [string] $PipelineFolderPath,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $true)]
        [string] $Organization,

        [Parameter(Mandatory = $true)]
        [ValidateSet('GitHub', 'ADO')]
        [string] $Environment,

        [Parameter(Mandatory = $false)]
        [string] $ProjectName = ''
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'Get-PipelineNameFromFile.ps1')

    switch ($Environment) {
        'ADO' {
            $pipelineFileUri = Join-Path $PipelineFolderPath $PipelineFileName
            $pipelineName = Get-PipelineNameFromFile -FilePath $pipelineFileUri
            $pipelineFrontUri = ('https://dev.azure.com/{0}/{1}/_apis/build/status/Modules/{2}?branchName=main' -f $Organization, $Projectname, $pipelineName.Replace("'", '')) -replace ' ', '%20'
            $pipelineBackUri = ('https://dev.azure.com/{0}/{1}/_build/latest/{2}?branchName=main' -f $Organization, $Projectname, $pipelineName.Replace("'", '')) -replace ' ', '%20'

            # Note: Badge name is automatically the pipeline name
            return ('[![{0}]({1})]({2})' -f $pipelineName, $pipelineFrontUri, $pipelineBackUri).Replace('\', '/')
        }
        'GitHub' {
            $workflowFileUri = Join-Path $PipelineFolderPath $PipelineFileName
            $workflowName = Get-PipelineNameFromFile -FilePath $workflowFileUri
            $workflowNameInUri = $workflowName.Replace(' ', '%20').Replace("'", '')
            $workflowStatusUri = 'https://github.com/{0}/{1}/workflows/{2}' -f $Organization, $RepositoryName, $workflowNameInUri
            $workflowFileGitUri = 'https://github.com/{0}/{1}/actions/workflows/{2}' -f $Organization, $RepositoryName, $PipelineFileName
            # Note: Badge name is automatically the pipeline name
            return ('[![{0}]({1}/badge.svg)]({2})' -f $workflowName, $workflowStatusUri, $workflowFileGitUri).Replace('\', '/')
        }
    }
}
