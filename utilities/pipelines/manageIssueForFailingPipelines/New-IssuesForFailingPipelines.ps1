﻿<#
.SYNOPSIS
Check for failing pipelines and create issues for those, that are failing.

.DESCRIPTION
If a pipeline fails, a new issue will be created, with a link to the failed pipeline. If the issue is already existing, a comment will be added, if a new run failed (with the link for the new failed run). If a pipeline run succeeds and an issue is open for the failed run, it will be closed (and a link to the successful run is added to the issue).

.PARAMETER Repo
Mandatory. The name of the respository to scan. Needs to have the structure "<owner>/<repositioryName>"

.PARAMETER LimitNumberOfRuns
Optional. Number of recent runs to scan for failed runs. Default is 100.

.PARAMETER LimitInDays
Optional. Only runs in the past selected days will be analyzed. Default is 2.

.PARAMETER IgnoreWorkflows
Optional. List of workflow names that should be ignored (even if they fail, no ticket will be created). Default is an empty array.

.EXAMPLE
New-IssuesForFailingPipelines -Repo 'owner/repo01' -LimitNumberOfRuns 100 -LimitInDays 2 -IgnoreWorkflows @('Pipeline 01')

.NOTES
The function requires GitHub CLI to be installed.
#>
function New-IssuesForFailingPipelines {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Repo,

        [Parameter(Mandatory = $false)]
        [int] $LimitNumberOfRuns = 100,

        [Parameter(Mandatory = $false)]
        [int] $LimitInDays = 2,

        [Parameter(Mandatory = $false)]
        [String[]] $IgnoreWorkflows = @()
    )

    $issues = gh issue list --state open --label 'automation,bug' --json 'title,url,body,comments' --repo $Repo | ConvertFrom-Json -Depth 100
    $runs = gh run list --json 'url,workflowName,headBranch,startedAt' --limit $LimitNumberOfRuns --repo $Repo | ConvertFrom-Json -Depth 100
    $workflowRuns = @{}
    $issuesCreated = 0
    $issuesCommented = 0
    $issuesClosed = 0

    foreach ($run in $runs) {
        $runStartTime = [Datetime]::ParseExact($run.startedAt, 'MM/dd/yyyy HH:mm:ss', $null)

        if (($run.headBranch -eq 'main') -and ($runStartTime -gt (Get-Date).AddDays(-$LimitInDays)) -and ($IgnoreWorkflows -notcontains $run.workflowName)) {
            $runId = $run.url.Split('/') | Select-Object -Last 1
            $runDetails = gh run view $runId --json 'conclusion,number' --repo $Repo | ConvertFrom-Json -Depth 100

            if (-not $workflowRuns.ContainsKey($run.workflowName) -or $runDetails.number -gt $workflowRuns[$run.workflowName].number) {
                $workflowRun = New-Object PSObject -Property @{
                    workflowName = $run.workflowName
                    number       = $runDetails.number
                    url          = $run.url
                    conclusion   = $runDetails.conclusion
                }

                if (-not $workflowRuns.ContainsKey($run.workflowName)) {
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
                if ($PSCmdlet.ShouldProcess("Issue [$issueName]", 'Create')) {
                    gh issue create --title "$issueName" --body "$failedrun" --label 'automation,bug' --repo $Repo
                }

                $issuesCreated++
            } else {
                $issue = ($issues | Where-Object { $_.title -eq $issueName })[0]

                if (!$issue.body.Contains($failedrun)) {
                    if ($issue.comments.length -eq 0) {
                        if ($PSCmdlet.ShouldProcess("Issue [$issueName]", 'Add comment')) {
                            gh issue comment $issue.url --body $failedrun --repo $Repo
                        }

                        $issuesCommented++
                    } else {
                        if (!$issue.comments.body.Contains($failedrun)) {
                            if ($PSCmdlet.ShouldProcess("Issue [$issueName]", 'Close')) {
                                gh issue comment $issue.url --body $failedrun --repo $Repo
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
                gh issue close $issue.url --comment $successfulrun --repo $Repo
                $issuesClosed++
            }
        }
    }

    Write-Verbose ('[{0}] issue(s){1} created' -f $issuesCreated, $($WhatIfPreference ? ' would have been' : ''))
    Write-Verbose ('[{0}] issue(s){1} commented' -f $issuesCommented, $($WhatIfPreference ? ' would have been' : ''))
    Write-Verbose ('[{0}] issue(s){1} closed' -f $issuesClosed, $($WhatIfPreference ? ' would have been' : ''))
}
