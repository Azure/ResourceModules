<#
.SYNOPSIS
Generate the status URL for GitHub module action workflows

.DESCRIPTION
Generate the status URL for GitHub module action workflows
E.g.  # [![AnalysisServices: Servers](https://github.com/Azure/ResourceModules/actions/workflows/ms.analysisservices.servers.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.analysisservices.servers.yml)

.PARAMETER name
Mandatory. The name of the module to create the url for

.PARAMETER provider
Mandatory. The provider of the module to create the url for

.PARAMETER RepositoryName
Mandatory. The repository to create the url for

.PARAMETER Organization
Mandatory. The Organization the repository is hosted in to create the url for

.EXAMPLE
Get-PipelineStatusUrl -name 'servers' -provider 'Microsoft.AnalysisServices' -RepositoryName 'ResourceModules' -Organization 'Azure'

Generate a status badge url for the 'service' module of the 'Microsoft.AnalysisServices' provider in repo 'Azure/ResourceModules'
#>
function Get-PipelineStatusUrl {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $name,

        [Parameter(Mandatory)]
        [string] $provider,

        [Parameter(Mandatory)]
        [string] $RepositoryName,

        [Parameter(Mandatory)]
        [string] $Organization,

        [Parameter(Mandatory)]
        [ValidateSet('GitHub', 'ADO')]
        [string]$Environment,

        [Parameter(Mandatory = $false)]
        [string]$ProjectName = ''
    )


    $shortProvider = $provider.Replace('Microsoft.', 'MS.')
    $pipelineFileName = ('{0}.{1}.yml' -f $shortProvider, $name).Replace('\', '/').Replace('/', '.').ToLower()
    switch ($Environment) {
        'ADO' {
            $pipelineFileUri = ".azuredevops/modulePipelines/$pipelineFileName"
            $pipelineName = (Get-Content -Path $pipelineFileUri)[0].TrimStart('name:').Replace('"', '').Trim()
            $pipelineFileGitUri = ('https://dev.azure.com/{0}/{1}/_apis/build/status/{2}?branchName=main' -f $Organization, $Projectname, $pipelineName.Replace("'", '')) -replace ' ', '%20'

            # Note: Badge name is automatically the pipeline name
            return ('[![{0}]({1})]({1})' -f $pipelineName, $pipelineFileGitUri).Replace('\', '/')
        }
        'GitHub' {
            $pipelineFileUri = ".github/workflows/$pipelineFileName"
            $pipelineName = (Get-Content -Path $pipelineFileUri)[0].TrimStart('name:').Replace('"', '').Trim()
            $pipelineNameInUri = $pipelineName.Replace(' ', '%20').Replace("'", '')
            $pipelineStatusUri = 'https://github.com/{0}/{1}/workflows/{2}' -f $Organization, $RepositoryName, $pipelineNameInUri
            $pipelineFileGitUri = 'https://github.com/{0}/{1}/actions/workflows/{2}' -f $Organization, $RepositoryName, $pipelineFileName
            # Note: Badge name is automatically the pipeline name
            return ('[![{0}]({1}/badge.svg)]({2})' -f $pipelineName, $pipelineStatusUri, $pipelineFileGitUri).Replace('\', '/')
        }
    }
}
