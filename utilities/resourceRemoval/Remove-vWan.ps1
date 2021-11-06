function Remove-Resource {
    param(
        $resourcesToRemove
    )
    $resourcesToRetry = @()
    Write-Verbose "----------------------------------" -Verbose
    foreach ($resource in $resourcesToRemove) {
        Write-Verbose ("Trying to remove resource [{0}] of type [{1}] from resource group [{2}]" -f $resource.Name, $resource.ResourceType, $resource.ResourceGroupName) -Verbose
        try {
            $null = Remove-AzResource -ResourceId $resource.ResourceId -Force -ErrorAction Stop
        }
        catch {
            Write-Warning ("Removal moved back for re-try. Reason: [{0}]" -f $_.Exception.Message)
            $resourcesToRetry += $resource
        }
    }
    Write-Verbose "----------------------------------" -Verbose
    return $resourcesToRetry
}
    
#Identifying resources
$virtualWAN = Get-AzResource -Tag @{ RemoveModule = "virtualWans"; } -ResourceGroupName "validation-rg"
if ($virtualWAN) {
    $vWANResourceId = $virtualWAN.ResourceId

    $virtualHub = Get-AzVirtualHub -ResourceGroupName validation-rg | Where-Object { $_.VirtualWan.Id -eq $vWANResourceId }
    if ($virtualHub) {
        $virtualHubResourceId = $virtualHub.Id

        $vpnGateway = Get-AzVpnGateway -ResourceGroupName validation-rg | Where-Object { $_.VirtualHub.Id -eq $virtualHubResourceId }
        if ($vpnGateway) {
            $vpnGatewayResourceId = $vpnGateway.Id
        }
    }

    $vpnSite = Get-AzVpnSite -ResourceGroupName validation-rg | Where-Object { $_.VirtualWan.Id -eq $vWANResourceId }
    if ($vpnSite) {
        $vpnSiteResourceId = $vpnSite.Id
    }
}

#Building array of resources to remove (in the required order)
$resourcesToRemove = @()
if ($vpnGatewayResourceId) { $resourcesToRemove += Get-AzResource -ResourceId $vpnGatewayResourceId }
if ($virtualHubResourceId) { $resourcesToRemove += Get-AzResource -ResourceId $virtualHubResourceId }
if ($vpnSiteResourceId) { $resourcesToRemove += Get-AzResource -ResourceId $vpnSiteResourceId }
if ($vWANResourceId) { $resourcesToRemove += Get-AzResource -ResourceId $vWANResourceId }

if ($resourcesToRemove) {
    $maximumRetries = '${{ parameters.maximumRemovalRetries }}' -as [int]
    $currentRety = 0
    $resourcesToRetry = @() 
    Write-Verbose ("Init removal of [{0}] resources" -f $resourcesToRemove.Count) -Verbose
    while (($resourcesToRetry = Remove-Resource -resourcesToRemove $resourcesToRemove).Count -gt 0 -and $currentRety -le $maximumRetries) {
        Write-Verbose ("Re-try removal of remaining [{0}] resources. Round [{1}|{2}]" -f $resourcesToRetry.Count, $currentRety, $maximumRetries) -Verbose
        $currentRety++
    }

    if ($resourcesToRetry.Count -gt 0) {
        throw ("The removal failed for resources [{0}]" -f ($resourcesToRetry.Name -join ', '))
    }
}
else {
}