<#
.SYNOPSIS
Collect all children which are linked to the provided resource type (direct, or indirect with a proxy)

.DESCRIPTION
Collect all children which are linked to the provided resource type (direct, or indirect with a proxy)

.PARAMETER FullResourceType
Mandatory. The Resource Type to search the linked child-modules for

.PARAMETER FullModuleData
Mandatory. The Module Data to search for child-modules in

.EXAMPLE
Get-LinkedChildModuleList -FullResourceType 'Microsoft.Storage/storageAccounts/blobServices' -FullModuleData @(@{ parameters = @(...); resource = @(...); (...) }, @{...})

Get all children for resource type 'Microsoft.Storage/storageAccounts/blobServices'
#>
function Get-LinkedChildModuleList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType,

        [Parameter(Mandatory = $true)]
        [hashtable] $FullModuleData
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        $linkedChildren = @{}

        # Collect child-resource information
        $fullmoduleData.Keys | Where-Object {
            # Is nested
            $_ -like "$FullResourceType/*" -and
            # Is direct child
            (($_ -split '/').Count -eq (($FullResourceType -split '/').Count + 1)
            )
        } | ForEach-Object { $linkedChildren[$_] = $fullmoduleData[$_] }

        ##  Add indirect child (via proxy resource) (i.e. it's a nested-nested resources who's parent has no individual specification/JSONFilePath).
        # TODO: Is that always true? What if the data is specified in one file?
        $FullModuleData.Keys | Where-Object {
            # Is nested
            $_ -like "$FullResourceType/*" -and
            # Is indirect child
            (($_ -split '/').Count -eq (($FullResourceType -split '/').Count + 2))
        } | Where-Object {
            # If the child's parent's parentUrlPath is empty, this parent has no PUT rest command which indicates it cannot be created independently
            [String]::IsNullOrEmpty($fullModuleData[$_].metadata.parentUrlPath)
        } | ForEach-Object { $linkedChildren[$_] = $fullmoduleData[$_] }

        return $linkedChildren
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
