<#
.SYNOPSIS
Get the resource type's parents

.DESCRIPTION
Get the resource type's parents

.PARAMETER ResourceType
Mandatory. The resource type to get all parent paths of

.EXAMPLE
Get-ParentResourceTypeList -ResourceType 'Microsoft.Storage/storageAccounts/blobServices/containers'

Get the parent resource paths for [Microsoft.Storage/storageAccounts/blobServices/containers]. Would return
- Microsoft.Storage/storageAccounts/blobServices/containers
- Microsoft.Storage/storageAccounts/blobServices
- Microsoft.Storage/storageAccounts
#>
function Get-ParentResourceTypeList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceType
    )

    $res = @(
        $ResourceType
    )
    if (($ResourceType -split '/').Count -gt 2) {
        $res += Get-ParentResourceTypeList -ResourceType ((Split-Path $ResourceType -Parent) -replace '\\', '/')
    }
    return $res
}
