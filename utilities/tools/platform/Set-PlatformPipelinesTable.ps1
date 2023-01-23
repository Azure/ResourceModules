function Set-PlatformPipelinesTable {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FilePath,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $true)]
        [string] $Organization,

        [Parameter(Mandatory = $false)]
        [ValidateSet('GitHub', 'ADO')]
        [string]$Environment,

        [Parameter(Mandatory = $false)]
        [string] $ProjectName = ''
    )

    # Load external functions
    $repoRoot = (Get-Item $PSScriptRoot).Parent.Parent.Parent.FullName
    . (Join-Path $repoRoot 'utilities' 'tools' 'helper' 'Merge-FileWithNewContent.ps1')
    . (Join-Path $repoRoot 'utilities' 'tools' 'helper' 'Get-PipelineStatusUrl.ps1')

    # Logic
    $contentArray = Get-Content -Path $FilePath

    $pipelineTable = @(
        '| Name | Status |'
        '| - | - |'
    )

    switch ($Environment) {
        'ADO' {

            $statusInputObject = @{
                PipelineFileName = $workflowFileName
                CustomFolderPath = $workflowFolderPath
                RepositoryName   = $RepositoryName
                Organization     = $Organization
                ProjectName      = $ProjectName
                Environment      = $Environment
            }
            $statusBadge = Get-PipelineStatusUrl @statusInputObject
        }
        'GitHub' {
            $platformWorkflowPaths = (Get-ChildItem (Join-Path $repoRoot '.github' 'workflows') -Filter 'platform.*').FullName

            foreach ($platformWorkflowPath in $platformWorkflowPaths) {
                $workflowContent = Get-Content -Path $platformWorkflowPath
                $workflowFileName = Split-Path $platformWorkflowPath -Leaf
                $workflowFolderPath = (Split-Path $platformWorkflowPath -Parent).Replace($repoRoot, '')

                $lineIndex = 0
                while ($workflowContent[$lineIndex] -notlike 'name: *') {
                    $lineIndex++
                }

                if ($workflowContent[$lineIndex] -match "name: ['|`"]\.Platform: (.+)['|`"]") {
                    $shortenedWorkflowName = $Matches[1].Trim()
                } else {
                    throw "Unable to determine name of workflow in path [$platformWorkflowPath]. The name should start with [.Platform: ]"
                }

                $statusInputObject = @{
                    PipelineFileName = $workflowFileName
                    CustomFolderPath = $workflowFolderPath.Substring(1, ($workflowFolderPath.Length - 1))
                    RepositoryName   = $RepositoryName
                    Organization     = $Organization
                    Environment      = $Environment
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
