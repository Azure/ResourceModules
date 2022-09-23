<#
.SYNOPSIS
Get the singular version of the given resource type

.DESCRIPTION
Get the singular version of the given resource type

.PARAMETER ResourceType
The resource type to convert to singular (if applicable)

.EXAMPLE
Get-ResourceTypeSingularName -ResourceType 'vaults'

Returns 'vault'
#>
function Get-ResourceTypeSingularName {

    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceType
    )

    if ($ResourceType -like '*ii') { return $ResourceType -replace 'ii$', 'us' }
    if ($ResourceType -like '*ies') { return $ResourceType -replace 'ies$', 'y' }
    if ($ResourceType -like '*s') { return $ResourceType -replace 's$', '' }

    return $ResourceType
}
