<#
.SYNOPSIS
Fetch all available diagnostic metrics and logs for the given Resource Type

.DESCRIPTION
Fetch all available diagnostic metrics and logs for the given Resource Type
Leverges Microsoft Docs's [https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/azure-monitor] to fetch the data

.PARAMETER ProviderNamespace
Mandatory. The Provider Namespace to fetch the data for

.PARAMETER ResourceType
Mandatory. The Resource Type to fetch the data for

.EXAMPLE
Get-DiagnosticOption -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'

Fetch the diagnostic options (logs & metrics) for Resource Type [Microsoft.KeyVault/vaults]
#>
function Get-DiagnosticOption {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory)]
        [string] $ResourceType
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
        $urlRoot = 'https://raw.githubusercontent.com/MicrosoftDocs/azure-docs/main/articles/azure-monitor/essentials'
    }

    process {

        #################
        ##   METRICS   ##
        #################
        $foundMetrics = @()
        $metricsMarkdown = (Invoke-WebRequest -Uri "$urlRoot/metrics-supported.md").Content -split '\n'

        # Find provider in file
        $matchingMetricResourceTypeLine = $metricsMarkdown.IndexOf(($metricsMarkdown -like "## $ProviderNamespace/$ResourceType")[-1])

        if ($matchingMetricResourceTypeLine -gt -1) {

            # Find table
            $tableStartIndex = $matchingMetricResourceTypeLine
            while ($metricsMarkdown[$tableStartIndex] -notlike '|*' -and $tableStartIndex -lt $metricsMarkdown.Count) {
                $tableStartIndex++
            }
            $tableStartIndex = $tableStartIndex + 2 # Skipping table header

            $tableEndIndex = $tableStartIndex
            while ($metricsMarkdown[$tableEndIndex] -like '|*' -and $tableEndIndex -lt $metricsMarkdown.Count) {
                $tableEndIndex++
            }

            # Build result
            for ($index = $tableStartIndex; $index -lt $tableEndIndex; $index++) {
                if (($metricsMarkdown[$index] -split '\|')[2] -eq 'Yes') {
                    # If the 'Exportable' column equals 'Yes', we consider the metric
                    $foundMetrics += ($metricsMarkdown[$index] -split '\|')[1]
                }
            }
        }

        ##############
        ##   LOGS   ##
        ##############
        $foundLogs = @()
        $logsMarkdown = (Invoke-WebRequest -Uri "$urlRoot/resource-logs-categories.md").Content -split '\n'

        # Find provider in file
        $matchingLogResourceTypeLine = $logsMarkdown.IndexOf(($logsMarkdown -like "## $ProviderNamespace/$ResourceType")[-1])
        if ($matchingLogResourceTypeLine -gt -1) {

            # Find table
            $tableStartIndex = $matchingLogResourceTypeLine
            while ($logsMarkdown[$tableStartIndex] -notlike '|*' -and $tableStartIndex -lt $logsMarkdown.Count) {
                $tableStartIndex++
            }
            $tableStartIndex = $tableStartIndex + 2 # Skipping table header

            $tableEndIndex = $tableStartIndex
            while ($logsMarkdown[$tableEndIndex] -like '|*' -and $tableEndIndex -lt $logsMarkdown.Count) {
                $tableEndIndex++
            }

            # Build result
            for ($index = $tableStartIndex; $index -lt $tableEndIndex; $index++) {
                $foundLogs += ($logsMarkdown[$index] -split '\|')[1]
            }
        }

        return [PSCustomObject]@{
            Metrics = $foundMetrics
            Logs    = $foundLogs
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
