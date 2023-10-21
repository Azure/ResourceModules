<#
.SYNOPSIS
Update the table of Platform pipelines in the given Readme.md

.DESCRIPTION
Update the table of Platform pipelines in the given Readme.md. The header must be identifyable with the `## Platform` header.

.PARAMETER FilePath
Mandatory. The path to the ReadMe file to update

.PARAMETER RepositoryName
Mandatory. The name of the repository the pipelines/workflows are in (required to generate the correct links)

.PARAMETER Organization
Mandatory. The name of the Organization the pipelines/workflows are in (required to generate the correct links)

.PARAMETER Environment
Mandatory. The environment to generate the badges for (either Azure DevOps - or GitHub)

.PARAMETER ProjectName
Mandatory. The name of the Azure DevOps project the pipelines are in (required to generate the correct links) - in case Azure DevOps is used

.EXAMPLE
Set-ReadMePlatformTable -FilePath 'C:\ResourceModules\README.md' -Environment 'GitHub' -RepositoryName 'ResourceModules' -Organization 'Azure'

Updated the 'README.md' file with the Platform badges from the 'https://github.com/Azure/ResourceModules' GitHub project.

.EXAMPLE
Set-ReadMePlatformTable -FilePath 'C:\ResourceModules\README.md' -Environment 'ADO' -RepositoryName 'ResourceModules' -Organization 'carml' -ProjectName 'carml'

Updated the 'README.md' file with the Platform badges from the 'https://dev.azure.com/carml/carml' Azure DevOps project.
#>
function Set-ReadMePlatformTable {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FilePath,

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
    $repoRoot = (Get-Item $PSScriptRoot).Parent.Parent.Parent.FullName
    . (Join-Path $repoRoot 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Merge-FileWithNewContent.ps1')
    . (Join-Path $repoRoot 'utilities' 'tools' 'helper' 'Get-PipelineStatusUrl.ps1')
    . (Join-Path $repoRoot 'utilities' 'tools' 'helper' 'Get-PipelineNameFromFile.ps1')




    # Logic
    $contentArray = Get-Content -Path $FilePath

    $pipelineTable = @(
        '| Name | Status |'
        '| - | - |'
    )

    switch ($Environment) {
        'ADO' {
            $platformPipelinePaths = (Get-ChildItem (Join-Path $repoRoot '.azuredevops' 'platformPipelines')).FullName | Sort-Object

            foreach ($platformPipelinePath in $platformPipelinePaths) {

                $pipelineFileName = Split-Path $platformPipelinePath -Leaf
                $pipelineFolderPath = (Split-Path $platformPipelinePath -Parent).Replace($repoRoot, '')

                $pipelineName = Get-PipelineNameFromFile -FilePath $platformPipelinePath
                $shortenedPipelineName = ($pipelineName -split '\.Platform: ')[1]

                $statusInputObject = @{
                    PipelineFileName   = $pipelineFileName
                    PipelineFolderPath = $pipelineFolderPath.Substring(1, ($pipelineFolderPath.Length - 1))
                    RepositoryName     = $RepositoryName
                    Organization       = $Organization
                    ProjectName        = $ProjectName
                    Environment        = $Environment
                }
                $statusBadge = Get-PipelineStatusUrl @statusInputObject
                $pipelineTable += '| {0} | {1} |' -f $shortenedPipelineName, $statusBadge
            }
        }
        'GitHub' {
            $platformWorkflowPaths = (Get-ChildItem (Join-Path $repoRoot '.github' 'workflows') -Filter 'platform.*').FullName | Sort-Object

            foreach ($platformWorkflowPath in $platformWorkflowPaths) {
                $workflowFileName = Split-Path $platformWorkflowPath -Leaf
                $workflowFolderPath = (Split-Path $platformWorkflowPath -Parent).Replace($repoRoot, '')

                $workflowName = Get-PipelineNameFromFile -FilePath $platformWorkflowPath
                $shortenedWorkflowName = ($workflowName -split '\.Platform: ')[1]

                $statusInputObject = @{
                    PipelineFileName   = $workflowFileName
                    PipelineFolderPath = $workflowFolderPath.Substring(1, ($workflowFolderPath.Length - 1))
                    RepositoryName     = $RepositoryName
                    Organization       = $Organization
                    Environment        = $Environment
                }
                $statusBadge = Get-PipelineStatusUrl @statusInputObject

                $pipelineTable += '| {0} | {1} |' -f $shortenedWorkflowName, $statusBadge
            }
        }
    }

    $mergeContentInputObject = @{
        OldContent             = $contentArray
        NewContent             = $pipelineTable
        SectionStartIdentifier = '## Platform'
        ContentType            = 'table'
    }
    $newContent = Merge-FileWithNewContent @mergeContentInputObject

    Write-Verbose 'New content:'
    Write-Verbose '============'
    Write-Verbose ($newContent | Out-String)

    if ($PSCmdlet.ShouldProcess("File in path [$FilePath]", 'Overwrite')) {
        Set-Content -Path $FilePath -Value $newContent -Force
        Write-Verbose "File [$FilePath] updated" -Verbose
    }
}
