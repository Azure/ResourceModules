
<#
.SYNOPSIS
Bulk delete all deployments on the given management group scope

.DESCRIPTION
Bulk delete all deployments on the given management group scope

.PARAMETER ManagementGroupId
Mandatory. The Resource ID of the Management Group to remove the deployments for.

.PARAMETER DeploymentStatusToExclude
Optional. The status to exlude from removals. Can be multiple. By default, we exclude any deployment that is in state 'running' or 'failed'.

.EXAMPLE
Clear-ManagementGroupDeployment -ManagementGroupId 'MyManagementGroupId'

Bulk remove all 'non-running' & 'non-failed' deployments from the Management Group with ID 'MyManagementGroupId'

.EXAMPLE
Clear-ManagementGroupDeployment -ManagementGroupId 'MyManagementGroupId' -DeploymentStatusToExclude @('running')

Bulk remove all 'non-running' deployments from the Management Group with ID 'MyManagementGroupId'
#>
function Clear-ManagementGroupDeployment {


    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory = $false)]
        [string[]] $DeploymentStatusToExclude = @('running', 'failed')
    )

    # Load used functions
    . (Join-Path $PSScriptRoot 'helper' 'Split-Array.ps1')

    $getInputObject = @{
        Method  = 'GET'
        Uri     = "https://management.azure.com/providers/Microsoft.Management/managementGroups/$ManagementGroupId/providers/Microsoft.Resources/deployments/?api-version=2021-04-01"
        Headers = @{
            Authorization = 'Bearer {0}' -f (Get-AzAccessToken).Token
        }
    }
    $response = Invoke-RestMethod @getInputObject

    if (($response | Get-Member -MemberType 'NoteProperty').Name -notcontains 'value') {
        throw ('Fetching deployments failed with error [{0}]' -f ($reponse | Out-String))
    }

    $relevantDeployments = $response.value | Where-Object { $_.properties.provisioningState -notin $DeploymentStatusToExclude }

    if (-not $relevantDeployments) {
        Write-Verbose 'No deployments found' -Verbose
        return
    }

    $relevantDeploymentChunks = , (Split-Array -InputArray $relevantDeployments -SplitSize 100)

    Write-Verbose ('Triggering the removal of [{0}] deployments of management group [{1}]' -f $relevantDeployments.Count, $ManagementGroupId)

    $failedRemovals = 0
    $successfulRemovals = 0
    foreach ($deployments in $relevantDeploymentChunks) {

        $requests = $deployments | ForEach-Object {
            @{ httpMethod            = 'DELETE'
                name                 = (New-Guid).Guid
                requestHeaderDetails = @{
                    commandName = 'HubsExtension.Microsoft.Resources/deployments.BulkDelete.execute'
                }
                url                  = '/providers/Microsoft.Management/managementGroups/{0}/providers/Microsoft.Resources/deployments/{1}?api-version=2019-08-01' -f $ManagementGroupId, $_.name
            }
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
            } | ConvertTo-Json -Depth 4
        }
        if ($PSCmdlet.ShouldProcess(('Removal of [{0}] deployments' -f $requests.Count), 'Request')) {
            $response = Invoke-RestMethod @removeInputObject

            $failedRemovals += ($response.responses | Where-Object { $_.httpStatusCode -notlike '20*' }  ).Count
            $successfulRemovals += ($response.responses | Where-Object { $_.httpStatusCode -like '20*' }  ).Count
        }
    }

    Write-Verbose 'Outcome' -Verbose
    Write-Verbose '=======' -Verbose
    Write-Verbose "Successful removals:`t`t$successfulRemovals" -Verbose
    Write-Verbose "Un-successful removals:`t$failedRemovals" -Verbose
}
