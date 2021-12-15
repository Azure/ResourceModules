<#
.SYNOPSIS
Get the scope of the given template file

.DESCRIPTION
Get the scope of the given template file (supports ARM & Bicep)
Will return either
- resourcegroup
- subscription
- managementgroup
- tenant

.PARAMETER TemplateFilePath
Mandatory. The path of the template file

.EXAMPLE
Get-ScopeOfTemplateFile -TemplateFilePath 'C:/deploy.json'

Get the scope of the given deploy.json template.
#>
function Get-ScopeOfTemplateFile {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('Path')]
        [string] $TemplateFilePath
    )

    if ((Split-Path $templateFilePath -Extension) -eq '.bicep') {
        # Bicep
        $bicepContent = Get-Content $templateFilePath
        $bicepScope = $bicepContent | Where-Object { $_ -like '*targetscope =*' }
        if (-not $bicepScope) {
            $deploymentScope = 'resourcegroup'
        } else {
            $deploymentScope = $bicepScope.ToLower().Split('=')[-1].Replace("'", '').Trim()
        }
    } else {
        # ARM
        $armSchema = (ConvertFrom-Json (Get-Content -Raw -Path $templateFilePath)).'$schema'
        switch -regex ($armSchema) {
            '\/deploymentTemplate.json#$' { $deploymentScope = 'resourcegroup' }
            '\/subscriptionDeploymentTemplate.json#$' { $deploymentScope = 'subscription' }
            '\/managementGroupDeploymentTemplate.json#$' { $deploymentScope = 'managementgroup' }
            '\/tenantDeploymentTemplate.json#$' { $deploymentScope = 'tenant' }
            Default { throw "[$armSchema] is a non-supported ARM template schema" }
        }
    }
    Write-Verbose "Determined deployment scope [$deploymentScope]" -Verbose

    return $deploymentScope
}
