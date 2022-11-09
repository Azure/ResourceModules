﻿
<#
.SYNOPSIS
Bulk delete all deployments on the given subscription scope

.DESCRIPTION
Bulk delete all deployments on the given subscription scope

.PARAMETER subscriptionId
Optional. The ID of the subscription to remove the deployments from. Defaults to the current context.

.PARAMETER DeploymentStatusToExclude
Optional. The status to exlude from removals. Can be multiple. By default, we exclude any deployment that is in state 'running' or 'failed'.

.PARAMETER DaysToKeepDeploymentsFor
Optional. The time to keep deployments for beyong the deployment statuses to exclude. In other words, if a deployment is older than the threshold, they will always be deleted.

.EXAMPLE
Clear-SubscriptionDeployment -subscriptionId '11111111-1111-1111-1111-111111111111'

Bulk remove all 'non-running' & 'non-failed' deployments from the subscription with ID '11111111-1111-1111-1111-111111111111'

.EXAMPLE
Clear-SubscriptionDeployment -subscriptionId '11111111-1111-1111-1111-111111111111' -DeploymentStatusToExclude @('running')

Bulk remove all 'non-running' deployments from the subscription with ID '11111111-1111-1111-1111-111111111111'
#>
function Clear-SubscriptionDeployment {


    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $subscriptionId = (Get-AzContext).Subscription.Id,

        [Parameter(Mandatory = $false)]
        [string[]] $DeploymentStatusToExclude = @('running', 'failed'),

        [Parameter(Mandatory = $false)]
        [int] $DaysToKeepDeploymentsFor = 7
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 # Enables web reponse
    $deploymentThreshold = (Get-Date).AddDays(-1 * $DaysToKeepDeploymentsFor)

    # Load used functions
    . (Join-Path (Split-Path $PSScriptRoot -Parent) 'sharedScripts' 'Split-Array.ps1')

    # Setting context explicitely in case the principal has permissions on multiple
    Write-Verbose ('Setting context to subscription [{0}]' -f $subscriptionId)
    $null = Set-AzContext -Subscription $subscriptionId

    $getInputObject = @{
        Method  = 'GET'
        Uri     = "https://management.azure.com/subscriptions/$subscriptionId/providers/Microsoft.Resources/deployments?api-version=2020-06-01"
        Headers = @{
            Authorization = 'Bearer {0}' -f (Get-AzAccessToken).Token
        }
    }
    $response = Invoke-RestMethod @getInputObject

    if (($response | Get-Member -MemberType 'NoteProperty').Name -notcontains 'value') {
        throw ('Fetching deployments failed with error [{0}]' -f ($reponse | Out-String))
    }

    Write-Verbose ('Found [{0}] deployments in subscription [{1}]' -f $response.value.Count, $subscriptionId) -Verbose

    $relevantDeployments = $response.value | Where-Object {
        $_.properties.provisioningState -notin $DeploymentStatusToExclude -or
        ([DateTime]$_.properties.timestamp) -lt $deploymentThreshold
    }

    Write-Verbose ('Filtering [{0}] deployments out as they are in state [{1}] or newer than [{2}] days ({3})' -f ($response.value.Count - $relevantDeployments.Count), ($DeploymentStatusToExclude -join '/'), $DaysToKeepDeploymentsFor, $deploymentThreshold.ToString('yyyy-MM-dd')) -Verbose

    if (-not $relevantDeployments) {
        Write-Verbose ('No deployments for subscription [{0}] found' -f $subscriptionId) -Verbose
        return
    }

    $rawDeploymentChunks = Split-Array -InputArray $relevantDeployments -SplitSize 100
    if ($relevantDeployments.Count -le 100) {
        $relevantDeploymentChunks = , $rawDeploymentChunks
    } else {
        $relevantDeploymentChunks = $rawDeploymentChunks
    }

    Write-Verbose ('Triggering the removal of [{0}] deployments from subscription [{1}]' -f $relevantDeployments.Count, $subscriptionId) -Verbose

    foreach ($deployments in $relevantDeploymentChunks) {

        $requests = $deployments | ForEach-Object {
            @{ httpMethod            = 'DELETE'
                name                 = (New-Guid).Guid # Each batch request needs a unique ID
                requestHeaderDetails = @{
                    commandName = 'HubsExtension.Microsoft.Resources/deployments.BulkDelete.execute'
                }
                url                  = '/subscriptions/{0}/providers/Microsoft.Resources/deployments/{1}?api-version=2019-08-01' -f $subscriptionId, $_.name
            }
        }

        if ($requests -is [hashtable]) {
            $requests = , $requests
        }

        $removeInputObject = @{
            Method  = 'POST'
            Uri     = 'https://management.azure.com/batch?api-version=2020-06-01'
            Headers = @{
                Authorization  = 'Bearer {0}' -f (Get-AzAccessToken).Token
                'Content-Type' = 'application/json'
            }
            Body    = @{
                requests = $requests
            } | ConvertTo-Json -Depth 4 -EnumsAsStrings
        }
        if ($PSCmdlet.ShouldProcess(('Removal of [{0}] deployments' -f $requests.Count), 'Request')) {
            $null = Invoke-RestMethod @removeInputObject
        }
    }
    Write-Verbose 'Script execution finished. Note that the removal can take a few minutes to propagate.' -Verbose
}
