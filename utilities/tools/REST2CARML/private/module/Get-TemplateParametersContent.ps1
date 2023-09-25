<#
.SYNOPSIS
Get the formatted content for the template's 'parameters' section

.DESCRIPTION
Get the formatted content for the template's 'parameters' section. Template content of any pre-existing template takes precedence over new content.

.PARAMETER FullResourceType
Mandatory. The complete ResourceType identifier to update the template for (e.g., 'Microsoft.Storage/storageAccounts').

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

.PARAMETER FullModuleData
Mandatory. The full stack of module data of all modules included in the original invocation. May be used for parent-child references.

Expects an array with objects like:

Name                           Value
----                           -----
identifier                     Microsoft.AVS/privateClouds/workloadNetworks/dhcpConfigurations
data                           {parameters, outputs, additionalFiles, modules…}
metadata                       {urlPath, jsonFilePath, parentUrlPath}
identifier                     Microsoft.AVS/privateClouds/cloudLinks
data                           {parameters, outputs, additionalFiles, modules…}
metadata                       {urlPath, jsonFilePath, parentUrlPath}
identifier                     Microsoft.AVS/privateClouds/workloadNetworks/portMirroringProfiles
data                           {parameters, outputs, additionalFiles, modules…}
metadata                       {urlPath, jsonFilePath, parentUrlPath}

.PARAMETER ParentResourceTypes
Optional. The name of any parent resource type. (e.g., @('privateClouds', 'clusters')

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

.PARAMETER LinkedChildren
Optional. Information about any child-module of the current resource type. Used to generate proper module references.

Expects an array with objects like:

Name                           Value
----                           -----
identifier                     Microsoft.AVS/privateClouds/cloudLinks
data                           {parameters, outputs, additionalFiles, modules…}
metadata                       {urlPath, jsonFilePath, parentUrlPath}
identifier                     Microsoft.AVS/privateClouds/hcxEnterpriseSites
data                           {parameters, outputs, additionalFiles, modules…}
metadata                       {urlPath, jsonFilePath, parentUrlPath}
identifier                     Microsoft.AVS/privateClouds/authorizations
data                           {parameters, outputs, additionalFiles, modules…}
metadata                       {urlPath, jsonFilePath, parentUrlPath}

.EXAMPLE
$contentInputObject = @{
    FullResourceType        = 'Microsoft.AVS/privateClouds/clusters/datastores'
    ModuleData              = @(@{...}, (...))
    FullModuleData          = @(@{...}, (...))
    ParentResourceTypes     = @('privateClouds', 'clusters')
    ExistingTemplateContent = @(@{...}, (...))
    LinkedChildren          = @(@{...}, (...))
}
Get-TemplateParametersContent @contentInputObject

Get the formatted template content for resource type 'Microsoft.AVS/privateClouds/clusters/datastores' based on the given data - including an existing template's data. The  output looks something like:

```bicep
// ============== //
//   Parameters   //
// ============== //

@description('Required. Name of the private cloud')
param name string

@description('Required. The resource model definition representing SKU')
param sku object

@description('Optional. The addons to create as part of the privateCloud.')
param addons array = []
(...)
```
#>
function Get-TemplateParametersContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType,

        [Parameter(Mandatory = $true)]
        [array] $ModuleData,

        [Parameter(Mandatory = $true)]
        [hashtable] $FullModuleData,

        [Parameter(Mandatory = $false)]
        [array] $ParentResourceTypes = @(),

        [Parameter(Mandatory = $false)]
        [array] $ExistingTemplateContent = @(),

        [Parameter(Mandatory = $false)]
        [hashtable] $LinkedChildren = @{}
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        #####################
        ##   Collect Data   #
        #####################

        # Handle parent proxy, if any
        $hasAProxyParent = $FullModuleData.Keys -notContains ((Split-Path $FullResourceType -Parent) -replace '\\', '/')
        $parentProxyName = $hasAProxyParent ? ($UrlPath -split '\/')[-3] : ''
        $proxyParentType = Split-Path (Split-Path $FullResourceType -Parent) -Leaf

        # Collect parameters to create
        # ----------------------------
        $parametersToAdd = @()

        # Add parent parameters
        foreach ($parentResourceType in ($parentResourceTypes | Sort-Object)) {
            $thisParentIsProxy = $hasAProxyParent -and $parentResourceType -eq $proxyParentType

            $parentParamData = @{
                level       = 0
                name        = '{0}Name' -f (Get-ResourceTypeSingularName -ResourceType $parentResourceType)
                type        = 'string'
                description = '{0}. The name of the parent {1}. Required if the template is used in a standalone deployment.' -f ($thisParentIsProxy ? 'Optional' : 'Conditional'), $parentResourceType
                required    = $false
            }

            if ($thisParentIsProxy) {
                # Handle proxy parents (i.e., empty containers with only a default value name)
                $parentParamData['default'] = $parentProxyName
            }

            $parametersToAdd += $parentParamData
        }

        # Add primary (service) parameters (i.e. top-level and those in the properties)
        $parametersToAdd += @() + ($ModuleData.parameters | Where-Object { $_.Level -in @(0, 1) -and $_.name -ne 'properties' -and ([String]::IsNullOrEmpty($_.Parent) -or $_.Parent -eq 'properties') })

        # Add additional (extension) parameters
        $parametersToAdd += $ModuleData.additionalParameters

        # Add child module references
        foreach ($childIdentifier in ($linkedChildren.Keys | Sort-Object)) {
            $childResourceType = ($childIdentifier -split '/')[-1]
            # Add only if not already exists in the primary parameters
            if (($parametersToAdd | Where-Object { $_.name -eq $childResourceType }).Count -eq 0) {
                $parametersToAdd += @{
                    level       = 0
                    name        = $childResourceType
                    type        = 'array'
                    default     = @()
                    description = "The $childResourceType to create as part of the $resourceTypeSingular."
                    required    = $false
                }
            }
        }

        # Add telemetry parameter
        $parametersToAdd += @{
            level       = 0
            name        = 'enableDefaultTelemetry'
            type        = 'boolean'
            default     = $true
            description = 'Enable telemetry via the Customer Usage Attribution ID (GUID).'
            required    = $false
        }

        ########################
        ##   Create Content   ##
        ########################

        $templateContent = @(
            '// ============== //'
            '//   Parameters   //'
            '// ============== //'
            ''
        )

        # Note: If there already is a template and a given parameter was already specified, we use the existing declaration instead of generating a new one
        # as it may have custom logic / default values, etc.

        # First the required
        foreach ($parameter in ($parametersToAdd | Where-Object { $_.required } | Sort-Object -Property 'Name')) {
            if ($existingTemplateContent.parameters.name -notcontains $parameter.name) {
                $templateContent += Get-FormattedModuleParameter -ParameterData $parameter
            } else {
                $templateContent += ($existingTemplateContent.parameters | Where-Object { $_.name -eq $parameter.name }).content
                $templateContent += ''
            }
        }
        # Then the conditional
        foreach ($parameter in ($parametersToAdd | Where-Object { -not $_.required -and $_.description -like 'Conditional. *' } | Sort-Object -Property 'Name')) {
            if ($existingTemplateContent.parameters.name -notcontains $parameter.name) {
                $templateContent += Get-FormattedModuleParameter -ParameterData $parameter
            } else {
                $templateContent += ($existingTemplateContent.parameters | Where-Object { $_.name -eq $parameter.name }).content
                $templateContent += ''
            }
        }
        # Then the rest
        foreach ($parameter in ($parametersToAdd | Where-Object { -not $_.required -and $_.description -notlike 'Conditional. *' } | Sort-Object -Property 'Name')) {
            if ($existingTemplateContent.parameters.name -notcontains $parameter.name) {
                $templateContent += Get-FormattedModuleParameter -ParameterData $parameter
            } else {
                $templateContent += ($existingTemplateContent.parameters | Where-Object { $_.name -eq $parameter.name }).content
                $templateContent += ''
            }
        }

        # Add additional parameters to only exist in a pre-existing template at the end
        foreach ($extraParameter in ($existingTemplateContent.parameters | Where-Object { $parametersToAdd.name -notcontains $_.name })) {
            $templateContent += $extraParameter.content
            $templateContent += ''
        }

        return $templateContent
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
