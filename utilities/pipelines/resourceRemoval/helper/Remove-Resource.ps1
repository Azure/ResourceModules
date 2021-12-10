function Remove-Resource {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $resourceId,

        [Parameter()]
        [string] $name,

        [Parameter()]
        [string] $type
    )

    switch ($type) {
        'Microsoft.Insights/diagnosticSettings' {
            $parentResourceId = $resourceId.Split('/providers/{0}' -f $type)[0]
            $null = Remove-AzDiagnosticSetting -ResourceId $parentResourceId -Name $name
            break
        }
        Default {
            $null = Remove-AzResource -ResourceId $resourceId -Force -ErrorAction 'Stop'
        }
    }
}
