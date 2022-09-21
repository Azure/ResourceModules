function Get-ModuleLockDetail {

    [CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory = $true)]
        [string] $SpecificationUrl
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        $arrItem = [pscustomobject] @{}

        $arrItem = $SpecificationUrl -split '\\'
    }

    process {


        if ($arrItem -and $arrItem.Count -le 9) {
            Write-Host 'apply lock'
        } else {
            Write-Host"Can't apply lock"
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }

}

Get-ModuleLockDetail '\subscriptions\{subscriptionId}\resourceGroups\{resourceGroupName}\providers\Microsoft.Storage\storageAccounts\{accountName}'
