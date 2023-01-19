<#
.SYNOPSIS
Check for failing pipelines and create issues for those, that are failing.

.DESCRIPTION
If a pipeline fails, a new issue will be created, with a link to the failed pipeline. If the issue is already existing, a comment will be added, if a new run failed (with the link for the new failed run). If a pipeline run succeeds and an issue is open for the failed run, it will be closed (and a link to the successful run is added to the issue).

.PARAMETER repo
Needs to have the structure "owner/repositioryName"

.PARAMETER limitNumberOfRuns
Optional. Number of recent runs to scan for failed runs. Default is 100.

.PARAMETER limitInDays
Optional. Only runs in the past selected days will be analyzed. Default is 2.

.PARAMETER ignorePipelines
Optional. List of pipeline names that should be ignored (even if they fail, no ticket will be created). Default is an empty array.

.EXAMPLE
New-IssuesForFailingPipelines -repo 'owner/repo01' -limitNumberOfRuns 100 -limitInDays 2 -Verbose -WhatIf

.NOTES
The function supports -WhatIf
#>
function New-IssuesForFailingPipelines {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory = $true)]
        [string] $repo,

        [Parameter(Mandatory = $false)]
        [int] $limitNumberOfRuns = 100,

        [Parameter(Mandatory = $false)]
        [int] $limitInDays = 2,

        [Parameter(Mandatory = $false)]
        [String[]] $ignorePipelines = @()
    )

    $issues = gh issue list --state open --label 'automation,bug' --json 'title,url,body,comments' --repo $repo | ConvertFrom-Json -Depth 100
    $runs = gh run list --json 'url,workflowName,headBranch,startedAt' --limit $limitNumberOfRuns --repo $repo | ConvertFrom-Json -Depth 100
    $workflowRuns = @{}
    $issuesCreated = 0
    $issuesCommented = 0
    $issuesClosed = 0

    foreach ($run in $runs) {
        $runStartTime = [Datetime]::ParseExact($run.startedAt, 'MM/dd/yyyy HH:mm:ss', $null)

        if (($run.headBranch -eq 'main') -and ($runStartTime -gt (Get-Date).AddDays(-$limitInDays)) -and ($ignorePipelines -notcontains $run.workflowName)) {
            $runId = $run.url.Split('/') | Select-Object -Last 1
            $runDetails = gh run view $runId --json 'conclusion,number' --repo $repo | ConvertFrom-Json -Depth 100

            if (!$workflowRuns.ContainsKey($run.workflowName) -or $runDetails.number -gt $workflowRuns[$run.workflowName].number) {
                $workflowRun = New-Object PSObject -Property @{
                    workflowName = $run.workflowName
                    number       = $runDetails.number
                    url          = $run.url
                    conclusion   = $runDetails.conclusion
                }

                if (!$workflowRuns.ContainsKey($run.workflowName)) {
                    $workflowRuns.Add($run.workflowName, $workflowRun)
                } else {
                    $workflowRuns[$run.workflowName] = $workflowRun
                }
            }
        }
    }

    foreach ($workflowRun in $workflowRuns.values) {
        if ($workflowRun.conclusion -eq 'failure') {
            $issueName = "[Failed pipeline] $($workflowRun.workflowName)"
            $failedrun = "failed run: $($workflowRun.url)"

            if ($issues.title -notcontains $issueName) {
                if ($PSCmdlet.ShouldProcess("$issueName", 'create')) {
                    gh issue create --title "$issueName" --body "$failedrun" --label 'automation,bug' --repo $repo
                }

                $issuesCreated++
            } else {
                $issue = ($issues | Where-Object { $_.title -eq $issueName })[0]

                if (!$issue.body.Contains($failedrun)) {
                    if ($issue.comments.length -eq 0) {
                        if ($PSCmdlet.ShouldProcess("Issue [$issueName]", 'Add comment')) {
                            gh issue comment $issue.url --body $failedrun --repo $repo
                        }

                        $issuesCommented++
                    } else {
                        if (!$issue.comments.body.Contains($failedrun)) {
                            if ($PSCmdlet.ShouldProcess("$issueName", 'close')) {
                                gh issue comment $issue.url --body $failedrun --repo $repo
                            }

                            $issuesCommented++
                        }
                    }
                }
            }
        } else {
            $issueName = "[Failed pipeline] $($workflowRun.workflowName)"

            if ($issues.title -contains $issueName) {
                $issue = ($issues | Where-Object { $_.title -eq $issueName })[0]
                $successfulrun = "successful run: $($workflowRun.url)"
                gh issue close $issue.url --comment $successfulrun --repo $repo
                $issuesClosed++
            }
        }
    }

    Write-Verbose ('[{0}] issue(s){1} created' -f $issuesCreated, $($WhatIfPreference ? ' would have been' : ''))
    Write-Verbose ('[{0}] issue(s){1} commented' -f $issuesCommented, $($WhatIfPreference ? ' would have been' : ''))
    Write-Verbose ('[{0}] issue(s){1} closed' -f $issuesClosed, $($WhatIfPreference ? ' would have been' : ''))
}
