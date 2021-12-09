<#
.SYNOPSIS
Remove any artifacts that remain of the given resource

.DESCRIPTION
Remove any artifacts that remain of the given resource. For example, some resources such as key vaults usually go into a soft-delete state from which we want to purge them from.

.PARAMETER resourceToRemove
Mandatory. The resource to remove. Should have format
@{
    name        = '...'
    resourceID = '...'
    type        = '...'
}

.EXAMPLE
Initialize-PostResourceRemoval -resourceToRemove @{ name = 'myVault'; resourceId '(..)/Microsoft.KeyVault/vaults/myVault'; type = 'Microsoft.KeyVault/vaults'}

Purge resource 'myVault' of type 'Microsoft.KeyVault/vaults' if no purge protection is enabled
#>
function Initialize-PostResourceRemoval {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [hashtable] $resourceToRemove
    )

    switch ($resourceToRemove.type) {
        'Microsoft.KeyVault/vaults' {
            $name = $resourceToRemove.resourceId.Split('/')[-1]
            $resourceGroupName = $resourceToRemove.resourceId.Split('/')[4]

            $matchingKeyVault = Get-AzKeyVault -InRemovedState | Where-Object { $_.VaultName -eq $name -and $resourceGroupName -eq $resourceGroupName }
            if ($matchingKeyVault -and -not $resource.EnablePurgeProtection) {
                Write-Verbose "Purging key vault [$name]" -Verbose
                if ($PSCmdlet.ShouldProcess(('Key Vault with ID [{0}]' -f $matchingKeyVault.Id), 'Purge')) {
                    $null = Remove-AzKeyVault -ResourceId $matchingKeyVault.Id -InRemovedState -Force -Location $matchingKeyVault.Location
                }
            }
        }
    }
}
