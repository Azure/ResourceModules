function Get-ModuleLockDetail {

    [CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory = $true)]
        [string] $SpecificationUrl,
        [string] $PolicyAssignmentString = 'Microsoft.Authorization/policyAssignments'
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        $arrItem = [pscustomobject] @{}

        if ($SpecificationUrl.Contains($PolicyAssignmentString)) {
            Write-Verbose 'Lock not required' -Verbose
            Exit
        }

        $arrItem = $SpecificationUrl -split '\/'
    }

    process {


        if ($arrItem -and $arrItem.Count -le 9) {
            Write-Host 'Apply lock'
        } else {
            Write-Host "Can't apply lock"
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }

}

Get-ModuleLockDetail '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}'
