<#
.SYNOPSIS
Generate the status URL for GitHub module action workflows

.DESCRIPTION
Generate the status URL for GitHub module action workflows
E.g.  # [![AnalysisServices: Servers](https://github.com/Azure/ResourceModules/actions/workflows/ms.analysisservices.servers.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.analysisservices.servers.yml)

.PARAMETER PipelineFileName
Mandatory. The name of the workflow/pipeline file to create the badge for. For example 'platform.updateReadMe.yml'.
Can not be provided if 'ModuleName' & 'ProviderNamespace' are provided.

.PARAMETER CustomFolderPath
Mandatory. The path to the pipeline/workflow file
Can not be provided if 'ModuleName' & 'ProviderNamespace' are provided.

.PARAMETER ModuleName
Mandatory. The name of the module to create the url for
Can not be provided if 'PipelineFileName' & 'CustomFolderPath' are provided.

.PARAMETER ProviderNamespace
Mandatory. The ProviderNamespace of the module to create the url for
Can not be provided if 'PipelineFileName' & 'CustomFolderPath' are provided.

.PARAMETER RepositoryName
Mandatory. The repository to create the url for

.PARAMETER Organization
Mandatory. The Organization the repository is hosted in to create the url for

.EXAMPLE
Get-PipelineStatusUrl -ModuleName 'servers' -ProviderNamespace 'Microsoft.AnalysisServices' -RepositoryName 'ResourceModules' -Organization 'Azure'

Generate a status badge url for the 'service' module of the 'Microsoft.AnalysisServices' ProviderNamespace in repo 'Azure/ResourceModules'

.EXAMPLE
Get-PipelineStatusUrl -PipelineFileName 'platform.updateReadMe.yml' -CustomFolderPath '.github/workflows' -RepositoryName 'ResourceModules' -Organization 'Azure'

Generate a status badge url for the 'platform.updateReadMe.yml' pipeline in the folder path '.github/workflows' of repo 'Azure/ResourceModules'
#>
function Get-PipelineStatusUrl {

    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Custom'
        )]
        [string] $PipelineFileName,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Custom'
        )]
        [string] $CustomFolderPath,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Module'
        )]
        [string] $ModuleName,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Module'
        )]
        [string] $ProviderNamespace,

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

    if ([String]::IsNullOrEmpty($PipelineFileName)) {
        $shortProviderNamespace = $ProviderNamespace.Replace('Microsoft.', 'MS.')
        $pipelineFileName = ('{0}.{1}.yml' -f $shortProviderNamespace, $ModuleName).Replace('\', '/').Replace('/', '.').ToLower()
    }

    switch ($Environment) {
        'ADO' {
            $pipelinesFolderPath = (-not [String]::IsNullOrEmpty($CustomFolderPath)) ? $CustomFolderPath : (Join-Path '.azuredevops' 'modulePipelines')
            $pipelineFileUri = Join-Path $pipelinesFolderPath $pipelineFileName
            $pipelineName = (Get-Content -Path $pipelineFileUri)[0].TrimStart('name:').Replace('"', '').Trim()
            $pipelineFileGitUri = ('https://dev.azure.com/{0}/{1}/_apis/build/status/{2}?branchName=main' -f $Organization, $Projectname, $pipelineName.Replace("'", '')) -replace ' ', '%20'

            # Note: Badge name is automatically the pipeline name
            return ('[![{0}]({1})]({1})' -f $pipelineName, $pipelineFileGitUri).Replace('\', '/')
        }
        'GitHub' {
            $workflowsFolderPath = (-not [String]::IsNullOrEmpty($CustomFolderPath)) ? $CustomFolderPath : (Join-Path '.github' 'workflows')
            $pipelineFileUri = Join-Path $workflowsFolderPath $pipelineFileName
            $pipelineName = (Get-Content -Path $pipelineFileUri)[0].TrimStart('name:').Replace('"', '').Trim()
            $pipelineNameInUri = $pipelineName.Replace(' ', '%20').Replace("'", '')
            $pipelineStatusUri = 'https://github.com/{0}/{1}/workflows/{2}' -f $Organization, $RepositoryName, $pipelineNameInUri
            $pipelineFileGitUri = 'https://github.com/{0}/{1}/actions/workflows/{2}' -f $Organization, $RepositoryName, $pipelineFileName
            # Note: Badge name is automatically the pipeline name
            return ('[![{0}]({1}/badge.svg)]({2})' -f $pipelineName, $pipelineStatusUri, $pipelineFileGitUri).Replace('\', '/')
        }
    }
}
