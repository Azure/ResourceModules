function Get-TargetScope {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $JSONKeyPath
    )

    switch ($JSONKeyPath) {
        { $PSItem -like '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/*' } { return 'resourceGroup' }
        { $PSItem -like '/subscriptions/{subscriptionId}/*' } { return 'subscription' }
        { $PSItem -like 'providers/Microsoft.Management/managementGroups/*' } { return 'managementGroup' }
    }
    Default {
        throw 'Unable to detect target scope'
    }
}
