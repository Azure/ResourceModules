<#
.SYNOPSIS
Get the formatted content for the template's 'outputs' section

.DESCRIPTION
Get the formatted content for the template's 'outputs' section. For the primary resource, template content of any pre-existing template takes precedence over new content.

.PARAMETER ResourceType
Mandatory. The resource type without the provider namespace (e.g., 'storageAccounts')

.PARAMETER ResourceTypeSingular
Optional. The 'singular' version of the resource type. For example 'container' instead of 'containers'.

.PARAMETER TargetScope
Mandatory. The scope of the target template (e.g., 'resourceGroup', 'subscription', etc.)

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
$contentInputObject = @{
    ResourceType            = 'privateClouds/clusters/datastores'
    ResourceTypeSingular    = 'datastore'
    TargetScope             = 'resourceGroup'
    ModuleData              = @(@{...}, (...))
    ExistingTemplateContent = @(@{...}, (...))
}
Get-TemplateOutputContent @contentInputObject

Get the formatted template content for resource type 'Microsoft.AVS/privateClouds/clusters/datastores' based on the given data - including an existing template's data. The  output looks something like:

```bicep
// =========== //
//   Outputs   //
// =========== //

@description('The name of the datastore.')
output name string = datastore.name

@description('The resource ID of the datastore.')
output resourceId string = datastore.id

@description('The name of the resource group the datastore was created in.')
output resourceGroupName string = resourceGroup().name
(...)
```
#>
function Get-TemplateOutputContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [string] $ResourceTypeSingular = ((Get-ResourceTypeSingularName -ResourceType $ResourceType) -split '/')[-1],

        [Parameter(Mandatory = $true)]
        [string] $TargetScope,

        [Parameter(Mandatory = $true)]
        [array] $ModuleData,

        [Parameter(Mandatory = $false)]
        [array] $ExistingTemplateContent = @()
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        #####################
        ##   Collect Data   #
        #####################
        $defaultOutputs = @(
            @{
                name    = 'name'
                type    = 'string'
                content = @(
                    "@description('The name of the $resourceTypeSingular.')"
                    "output name string = $resourceTypeSingular.name"
                )
            },
            @{
                name    = 'resourceId'
                type    = 'string'
                content = @(
                    "@description('The resource ID of the $resourceTypeSingular.')"
                    "output resourceId string = $resourceTypeSingular.id"
                )
            }
        )

        if ($targetScope -eq 'resourceGroup') {
            $defaultOutputs += @{
                name    = 'resourceGroupName'
                type    = 'string'
                content = @(
                    "@description('The name of the resource group the $resourceTypeSingular was created in.')"
                    'output resourceGroupName string = resourceGroup().name'
                )
            }
        }

        # If the main resource has a location property, an output should be returned too
        if ($ModuleData.parameters.name -contains 'location' -and $ModuleData.parameters['location'].defaultValue -ne 'global') {
            $defaultOutputs += @{
                name    = 'location'
                type    = 'string'
                content = @(
                    "@description('The location the resource was deployed into.')"
                    'output location string = {0}.location' -f $resourceTypeSingular
                )
            }
        }

        # Extra outputs
        $outputsToAdd = -not $ExistingTemplateContent ? @() : $ExistingTemplateContent.outputs
        foreach ($default in $defaultOutputs) {
            if ($outputsToAdd.name -notcontains $default.name) {
                $outputsToAdd += $default
            }
        }

        ########################
        ##   Create Content   ##
        ########################

        $templateContent = @(
            '// =========== //'
            '//   Outputs   //'
            '// =========== //'
            ''
        )

        foreach ($output in $outputsToAdd) {
            $templateContent += $output.content
            $templateContent += ''
        }

        return $templateContent
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
