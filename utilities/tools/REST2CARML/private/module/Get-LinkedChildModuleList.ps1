function Get-LinkedChildModuleList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType,

        [Parameter(Mandatory = $true)]
        [array] $FullModuleData
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        # Collect child-resource information
        $linkedChildren = $fullmoduleData | Where-Object {
            # Is nested
            $_.identifier -like "$FullResourceType/*" -and
            # Is direct child
            (($_.identifier -split '/').Count -eq (($FullResourceType -split '/').Count + 1)
            )
        }
        ##  Add indirect child (via proxy resource) (i.e. it's a nested-nested resources who's parent has no individual specification/JSONFilePath).
        # TODO: Is that always true? What if the data is specified in one file?
        $indirectChildren = $FullModuleData | Where-Object {
            # Is nested
            $_.identifier -like "$FullResourceType/*" -and
            # Is indirect child
            (($_.identifier -split '/').Count -eq (($FullResourceType -split '/').Count + 2))
        } | Where-Object {
            # If the child's parent's parentUrlPath is empty, this parent has no PUT rest command which indicates it cannot be created independently
            [String]::IsNullOrEmpty($_.metadata.parentUrlPath)
        }

        if ($indirectChildren) {
            $linkedChildren += $indirectChildren
        }

        return $linkedChildren
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
