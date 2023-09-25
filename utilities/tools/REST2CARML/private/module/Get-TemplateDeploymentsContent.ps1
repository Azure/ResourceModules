<#
.SYNOPSIS
Get the formatted content for the template's 'deployments' section

.DESCRIPTION
Get the formatted content for the template's 'deployments' section. For the primary resource, template content of any pre-existing template takes precedence over new content.

.PARAMETER FullResourceType
Mandatory. The complete ResourceType identifier to update the template for (e.g., 'Microsoft.Storage/storageAccounts').

.PARAMETER ResourceType
Mandatory. The resource type without the provider namespace (e.g., 'storageAccounts')

.PARAMETER ResourceTypeSingular
Optional. The 'singular' version of the resource type. For example 'container' instead of 'containers'.

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
    ResourceType            = 'privateClouds/clusters/datastores'
    ResourceTypeSingular    = 'datastore'
    ModuleData              = @(@{...}, (...))
    FullModuleData          = @(@{...}, (...))
    ParentResourceTypes     = @('privateClouds', 'clusters')
    ExistingTemplateContent = @(@{...}, (...))
    LinkedChildren          = @(@{...}, (...))
}
Get-TemplateDeploymentsContent @contentInputObject

Get the formatted template content for resource type 'Microsoft.AVS/privateClouds/clusters/datastores' based on the given data - including an existing template's data. The  output looks something like:

```bicep
// =============== //
//   Deployments   //
// =============== //

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
    name: 'pid-11111111-1111-1111-1111-111111111111-${uniqueString(deployment().name, location)}'
    properties: {
        mode: 'Incremental'
        template: {
            '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
            contentVersion: '1.0.0.0'
            resources: []
        }
    }
}
(...)
```
#>
function Get-TemplateDeploymentsContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [string] $ResourceTypeSingular = ((Get-ResourceTypeSingularName -ResourceType $ResourceType) -split '/')[-1],

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

        # Collect all parent references for 'exiting' resource references
        $fullParentResourceStack = Get-ParentResourceTypeList -ResourceType $FullResourceType

        $locationParameterExists = ($templateContent | Where-Object { $_ -like 'param location *' }).Count -gt 0

        $matchingExistingResource = $existingTemplateContent.resources | Where-Object {
            $_.type -eq $FullResourceType -and $_.name -eq $resourceTypeSingular
        }

        ########################
        ##   Create Content   ##
        ########################

        $templateContent = @(
            '// =============== //'
            '//   Deployments   //'
            '// =============== //'
            ''
        )

        # Add telemetry resource
        # ----------------------
        $telemetryTemplate = Get-Content -Path (Join-Path $Script:src 'telemetry.bicep')
        if (-not $locationParameterExists) {
            # Remove the location from the deployment name if the template has no such parameter
            $telemetryTemplate = $telemetryTemplate -replace ', location', ''
        }
        $templateContent += $telemetryTemplate

        # Add a space in between the new section and the previous one in case no space exists
        if (-not [String]::IsNullOrEmpty($templateContent[-1])) {
            $templateContent += ''
        }

        # Add 'existing' parents (if any)
        # -------------------------------
        $existingResourceIndent = 0
        $orderedParentResourceTypes = $fullParentResourceStack | Where-Object { $_ -notlike $FullResourceType } | Sort-Object
        foreach ($parentResourceType in $orderedParentResourceTypes) {
            $singularParent = ((Get-ResourceTypeSingularName -ResourceType $parentResourceType) -split '/')[-1]
            $levedParentResourceType = ($parentResourceType -ne (@() + $orderedParentResourceTypes)[0]) ? (Split-Path $parentResourceType -Leaf) : $parentResourceType
            $parentJSONPath = ($FullModuleData[$parentResourceType]).Metadata.JSONFilePath

            if ([String]::IsNullOrEmpty($parentJSONPath)) {
                # Case: A child who's parent resource does not exist (i.e., is a proxy). In this case we use the current API paths as a fallback
                # Example: 'Microsoft.AVS/privateClouds/workloadNetworks' is not actually existing as a parent for 'Microsoft.AVS/privateClouds/workloadNetworks/dhcpConfigurations'
                $parentJSONPath = $JSONFilePath
            }

            $parentResourceAPI = Split-Path (Split-Path $parentJSONPath -Parent) -Leaf
            $templateContent += @(
                "$(' ' * $existingResourceIndent)resource $($singularParent) '$($levedParentResourceType)@$($parentResourceAPI)' existing = {",
                "$(' ' * $existingResourceIndent)  name: $($singularParent)Name"
            )
            if ($parentResourceType -ne (@() + $orderedParentResourceTypes)[-1]) {
                # Only add an empty line if there is more content to add
                $templateContent += ''
            }
            $existingResourceIndent += 4
        }
        # Add closing brakets
        foreach ($parentResourceType in ($fullParentResourceStack | Where-Object { $_ -notlike $FullResourceType } | Sort-Object)) {
            $existingResourceIndent -= 4
            $templateContent += "$(' ' * $existingResourceIndent)}"
        }

        # Add a space in between the new section and the previous one in case no space exists
        if (-not [String]::IsNullOrEmpty($templateContent[-1])) {
            $templateContent += ''
        }

        # Add primary resource
        # --------------------
        # Deployment resource declaration line
        $serviceAPIVersion = Split-Path (Split-Path $JSONFilePath -Parent) -Leaf
        $templateContent += "resource $resourceTypeSingular '$FullResourceType@$serviceAPIVersion' = {"

        if (($FullResourceType -split '/').Count -ne 2) {
            # In case of children, we set the 'parent' to the next parent
            $templateContent += ('  parent: {0}' -f (($parentResourceTypes | ForEach-Object { Get-ResourceTypeSingularName -ResourceType $_ }) -join '::'))
        }

        foreach ($parameter in ($ModuleData.parameters | Where-Object { $_.level -eq 0 -and $_.name -ne 'properties' } | Sort-Object -Property 'name')) {
            if ($matchingExistingResource.topLevelElements.name -notcontains $parameter.name) {
                $templateContent += '  {0}: {0}' -f $parameter.name
            } else {
                $existingProperty = $matchingExistingResource.topLevelElements | Where-Object { $_.name -eq $parameter.name }
                $templateContent += $existingProperty.content
            }
        }

        if (($ModuleData.parameters | Where-Object { $_.level -eq 1 -and $_.Parent -eq 'properties' }).Count -gt 0) {
            $templateContent += '  properties: {'
            foreach ($parameter in ($ModuleData.parameters | Where-Object { $_.level -eq 1 -and $_.Parent -eq 'properties' } | Sort-Object -Property 'name')) {
                if ($matchingExistingResource.nestedElements.name -notcontains $parameter.name) {
                    $templateContent += '    {0}: {0}' -f $parameter.name
                } else {
                    $existingProperty = $matchingExistingResource.nestedElements | Where-Object { $_.name -eq $parameter.name }
                    $templateContent += $existingProperty.content
                }
            }
            $templateContent += '  }'
        }

        $templateContent += @(
            '}'
            ''
        )

        # If a template already exists, add 'extra' resources that are not yet part of the template content
        # -------------------------------------------------------------------------------------------------
        # Excluded are
        # - Anything we generate anew as a resource
        # - Telemetry (as it's regenerated above anyways)
        # - Existing parent resources (as they are regenerated above anyways)
        if ($existingTemplateContent.resources.count -gt 0) {
            $preExistingExtraResources = $existingTemplateContent.resources | Where-Object {
                $_.name -notIn @($ModuleData.resources.name) + @('defaultTelemetry') + @($resourceTypeSingular) -and $_.content[0] -notlike '* existing = {'
            }
            foreach ($resource in $preExistingExtraResources) {
                $templateContent += $resource.content
                $templateContent += ''
            }
        }

        # Add additional resources such as extensions (like DiagnosticSettigs)
        # --------------------------------------------------------------------
        # Other collected resources
        foreach ($additionalResource in ($ModuleData.resources | Sort-Object 'name')) {
            if ($existingTemplateContent.resources.name -notcontains $additionalResource.name) {
                $templateContent += $additionalResource.content
            } else {
                $existingResource = $existingTemplateContent.resources | Where-Object { $_.name -eq $additionalResource.name }
                $templateContent += $existingResource.content
                $templateContent += ''
            }
        }

        # Add child-module references
        # ---------------------------
        $childrenInputObject = @{
            FullResourceType        = $FullResourceType
            ResourceType            = $ResourceType
            ResourceTypeSingular    = $ResourceTypeSingular
            ModuleData              = $ModuleData
            LocationParameterExists = $LocationParameterExists
        }
        if ($LinkedChildren.Keys.Count -gt 0) {
            $childrenInputObject['LinkedChildren'] = $LinkedChildren
        }
        if ($ExistingTemplateContent.Count -gt 0) {
            $childrenInputObject['ExistingTemplateContent'] = $ExistingTemplateContent
        }
        if ($ParentResourceTypes.Count -gt 0) {
            $childrenInputObject['ParentResourceTypes'] = $ParentResourceTypes
        }
        $templateContent += Get-TemplateChildModuleContent @childrenInputObject

        # TODO : Add other module references
        # ----------------------------------
        foreach ($additionalResource in $ModuleData.modules) {
            if ($existingTemplateContent.modules.name -notcontains $additionalResource.name) {
                $templateContent += $additionalResource.content
            } else {
                $existingResource = $existingTemplateContent.modules | Where-Object { $_.name -eq $additionalResource.name }
                $templateContent += $existingResource.content
                $templateContent += ''
            }
        }

        # TODO: Extra extra modules
        # $preExistingExtraModules = $existingTemplateContent.modules | Where-Object { $_.name -notIn $ModuleData.modules.name }
        # foreach ($preExistingMdoule in $preExistingExtraModules) {
        #     # Beware: The pre-existing content also contains e.g. 'linkedChildren' we add as part of the template generation
        # }

        return $templateContent
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
