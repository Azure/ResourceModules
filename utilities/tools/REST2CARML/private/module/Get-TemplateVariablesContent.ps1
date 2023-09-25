<#
.SYNOPSIS
Get the formatted content for the template's 'variables' section

.DESCRIPTION
Get the formatted content for the template's 'variables' section. Template content of any pre-existing template takes precedence over new content.

.PARAMETER ModuleData
Mandatory. The module data to fetch the data for this section from & then format it propertly for the template.

Expects an array with objects like:
Name                           Value
----                           -----
parameters                     {name, identity, type, properties…}
outputs                        {}
additionalFiles                {}
modules                        {}
variables                      {diagnosticsMetrics, diagnosticsLogs}
resources                      {privateCloud_diagnosticSettings, privateCloud_lock}
isSingleton                    False
additionalParameters           {diagnosticLogsRetentionInDays, diagnosticStorageAccountId, diagnosticWorkspaceId, diagnosticEventHubAuthorizationRuleId…}

.PARAMETER ExistingTemplateContent
Optional. The prepared content of an existing template, if any.

Expects an array with objects like:

Name                           Value
----                           -----
modules                        {privateCloud_cloudLinks, privateCloud_hcxEnterpriseSites, privateCloud_authorizations, privateCloud_scriptExecutions…}
variables                      {diagnosticsMetrics, diagnosticsLogs, enableReferencedModulesTelemetry}
parameters                     {name, sku, addons, authorizations…}
outputs                        {name, resourceId, resourceGroupName}
resources                      {defaultTelemetry, privateCloud, privateCloud_diagnosticSettings, privateCloud_lock}

.EXAMPLE
Get-TemplateVariablesContent -ModuleData @(@{ variables = @(@{ name = 'abc'; content = @( var abc = (...)) }; (...))}, (...)) -ExistingTemplateContent @(@{ variables = @(@{ name = 'abc'; content = @( var abc = (...))}, (...))}, (...))

Generate the variables content for the above example containing at least the 'abc' variable. Would result in an output like

```bicep
// ============= //
//   Variables   //
// ============= //

var abc = (...)
(...)
```
#>
function Get-TemplateVariablesContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array] $ModuleData,

        [Parameter(Mandatory = $false)]
        [array] $ExistingTemplateContent = @()
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {

        ########################
        ##   Create Content   ##
        ########################

        $templateContent = @(
            '// ============= //'
            '//   Variables   //'
            '// ============= //'
            ''
        )

        foreach ($variable in $ModuleData.variables) {
            if ($existingTemplateContent.variables.name -notcontains $variable.name) {
                $templateContent += $variable.content
            } else {
                $matchingExistingVar = $existingTemplateContent.variables | Where-Object { $_.name -eq $variable.name }
                $templateContent += $matchingExistingVar.content
            }
            $templateContent += ''
        }

        # Add telemetry variable
        if ($linkedChildren.Keys.Count -gt 0) {
            if ($existingTemplateContent.variables.name -notcontains 'enableReferencedModulesTelemetry') {
                $templateContent += @(
                    'var enableReferencedModulesTelemetry = false'
                )
            } else {
                $matchingExistingVar = $existingTemplateContent.variables | Where-Object { $_.name -eq 'enableReferencedModulesTelemetry' }
                $templateContent += $matchingExistingVar.content
            }
            $templateContent += ''
        }

        # Add additional parameters to only exist in a pre-existing template at the end
        foreach ($extraVariable in ($existingTemplateContent.variables | Where-Object { $ModuleData.variables.name -notcontains $_.name -and $_.name -ne 'enableReferencedModulesTelemetry' })) {
            $templateContent += $extraVariable.content
            $templateContent += ''
        }

        # Only add the section if any content was added
        if ($templateContent.count -eq 4) {
            return @()
        } else {
            return $templateContent
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
