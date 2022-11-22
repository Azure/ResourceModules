<#
.SYNOPSIS
Generate the child-module's template content based on the given module data.

.DESCRIPTION
Generate the child-module's template content based on the given module data.

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

.PARAMETER LocationParameterExists
Mandatory. An indicator whether the template will contain a 'location' parameter. Only then we can reference it in e.g., deployment names.

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

.PARAMETER ParentResourceTypes
Optional. The name of any parent resource type. (e.g., @('privateClouds', 'clusters')

.EXAMPLE
$contentInputObject = @{
    FullResourceType        = 'Microsoft.AVS/privateClouds/clusters/datastores'
    ResourceType            = 'privateClouds/clusters/datastores'
    ResourceTypeSingular    = 'datastore'
    LinkedChildren          = @(@{...}, (...))
    ModuleData              = @(@{...}, (...))
    LocationParameterExists = $true
    ExistingTemplateContent = @(@{...}, (...))
    ParentResourceTypes     = @('privateClouds', 'clusters')
}
Get-TemplateChildModuleContent  @contentInputObject

Get the formatted template content for resource type 'Microsoft.AVS/privateClouds/clusters/datastores' based on the given data - including an existing template's data. The  output looks something like:

```bicep

(...)
```
#>
function Get-TemplateChildModuleContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [string] $ResourceTypeSingular = ((Get-ResourceTypeSingularName -ResourceType $ResourceType) -split '/')[-1],

        [Parameter(Mandatory = $false)]
        [hashtable] $LinkedChildren = @{},

        [Parameter(Mandatory = $true)]
        [array] $ModuleData,

        [Parameter(Mandatory = $true)]
        [bool] $LocationParameterExists,

        [Parameter(Mandatory = $false)]
        [array] $ExistingTemplateContent = @(),

        [Parameter(Mandatory = $false)]
        [array] $ParentResourceTypes = @()
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {

        #####################################
        ##   Add child-module references   ##
        #####################################
        $templateContent = @()

        foreach ($childIdentifier in ($linkedChildren.Keys | Sort-Object)) {
            $dataBlock = $LinkedChildren[$childIdentifier]
            $childResourceType = ($childIdentifier -split '/')[-1]

            $hasProxyParent = [String]::IsNullOrEmpty($dataBlock.metadata.parentUrlPath)
            if ($hasProxyParent) {
                $proxyParentName = Split-Path (Split-Path $childIdentifier -Parent) -Leaf
            }

            $moduleName = '{0}{1}_{2}' -f ($hasProxyParent ? "$($proxyParentName)_" : ''), $resourceTypeSingular, $childResourceType
            $modulePath = '{0}{1}/deploy.bicep' -f ($hasProxyParent ? "$proxyParentName/" : ''), $childResourceType

            $existingModuleData = $ExistingTemplateContent.modules | Where-Object { $_.name -eq $moduleName -and $_.path -eq $modulePath }

            # Differentiate 'singular' children (like 'blobservices') vs. 'multiple' chilren (like 'containers')
            if ($ModuleData.isSingleton) {
                $templateContent += @(
                    "module $moduleName '$modulePath' = {"
                )

                if ($existingModuleData.topLevelElements.name -notcontains 'name') {
                    $templateContent += "  name: '`${uniqueString(deployment().name$($LocationParameterExists ? ', location' : ''))}-$($resourceTypeSingular)-$($childResourceType)'"
                } else {
                    $existingParam = $existingModuleData.topLevelElements | Where-Object { $_.name -eq 'name' }
                    $templateContent += $existingParam.content
                }

                $templateContent += '  params: {'
                $templateContent += @()

                $alreadyAddedParams = @()

                # All param names of parents
                foreach ($parentResourceType in $parentResourceTypes) {
                    $parentParamName = ((Get-ResourceTypeSingularName -ResourceType $parentResourceType) -split '/')[-1]
                    $templateContent += '    {0}Name: {0}Name' -f $parentParamName
                    $alreadyAddedParams += $parentParamName
                }
                # Itself
                $selfParamName = ((Get-ResourceTypeSingularName -ResourceType ($FullResourceType -split '/')[-1]) -split '/')[-1]
                $templateContent += '    {0}Name: name' -f $selfParamName
                $alreadyAddedParams += $selfParamName

                # Any proxy default if any
                if ($hasProxyParent) {
                    $proxyDefaultValue = ($dataBlock.metadata.urlPath -split '\/')[-3]
                    $proxyParamName = Get-ResourceTypeSingularName -ResourceType ($proxyParentName -split '/')[-1]
                    $templateContent += "    {0}Name: '{1}'" -f $proxyParamName, $proxyDefaultValue
                    $alreadyAddedParams += $proxyParamName
                }

                # Add primary child parameters
                $allParam = $dataBlock.data.parameters + $dataBlock.data.additionalParameters
                foreach ($parameter in (($allParam | Where-Object { $_.Level -in @(0, 1) -and $_.name -ne 'properties' -and ([String]::IsNullOrEmpty($_.Parent) -or $_.Parent -eq 'properties') }) | Sort-Object -Property 'Name')) {
                    $wouldBeParameter = Get-FormattedModuleParameter -ParameterData $parameter | Where-Object { $_ -like 'param *' } | ForEach-Object { $_ -replace 'param ', '' }
                    $wouldBeParamElem = $wouldBeParameter -split ' = '
                    $parameter.name = ($wouldBeParamElem -split ' ')[0]

                    if ($existingModuleData.nestedElements.name -notcontains $parameter.name) {
                        $existingParam = $existingModuleData.nestedElements | Where-Object { $_.name -eq $parameter.name }
                        if ($alreadyAddedParams -notcontains $existingParam.name) {
                            $templateContent += $existingParam.content
                        }
                        continue
                    }

                    if ($wouldBeParamElem.count -gt 1) {
                        # With default

                        if ($parameter.name -eq 'lock') {
                            # Special handling as we pass the parameter down to the child
                            $templateContent += "    $($parameter.name): contains($($childResourceType), 'lock') ? $($childResourceType).lock : lock"
                            $alreadyAddedParams += $parameter.name
                            continue
                        }

                        $wouldBeParamValue = $wouldBeParamElem[1]

                        # Special case, location function - should reference a location parameter instead
                        if ($wouldBeParamValue -like '*().location') {
                            $wouldBeParamValue = 'location'
                        }

                        $templateContent += "    $($parameter.name): contains($($childResourceType), '$($parameter.name)') ? $($childResourceType).$($parameter.name) : $($wouldBeParamValue)"
                        $alreadyAddedParams += $parameter.name
                    } else {
                        # No default
                        $templateContent += "    $($parameter.name): $($childResourceType).$($parameter.name)"
                        $alreadyAddedParams += $parameter.name
                    }
                }

                $templateContent += @(
                    # Special handling as we pass the variable down to the child
                    '    enableDefaultTelemetry: enableReferencedModulesTelemetry'
                    '  }'
                    '}'
                    ''
                )
            } else {

                $childResourceTypeSingular = Get-ResourceTypeSingularName -ResourceType $childResourceType

                $templateContent += @(
                    "module $moduleName '$modulePath' = [for ($($childResourceTypeSingular), index) in $($childResourceType): {"
                )

                if ($existingModuleData.topLevelElements.name -notcontains 'name') {
                    $templateContent += "  name: '`${uniqueString(deployment().name$($LocationParameterExists ? ', location' : ''))}-$($resourceTypeSingular)-$($childResourceTypeSingular)-`${index}'"
                } else {
                    $existingParam = $existingModuleData.topLevelElements | Where-Object { $_.name -eq 'name' }
                    $templateContent += $existingParam.content
                }

                $templateContent += '  params: {'
                $templateContent += @()

                $alreadyAddedParams = @()

                # All param names of parents
                foreach ($parentResourceType in $parentResourceTypes) {
                    $parentParamName = ((Get-ResourceTypeSingularName -ResourceType $parentResourceType) -split '/')[-1]
                    $templateContent += '    {0}Name: {0}Name' -f $parentParamName
                    $alreadyAddedParams += $parentParamName
                }
                # Itself
                $selfParamName = ((Get-ResourceTypeSingularName -ResourceType ($FullResourceType -split '/')[-1]) -split '/')[-1]
                $templateContent += '    {0}Name: name' -f $selfParamName
                $alreadyAddedParams += $selfParamName

                # Any proxy default if any
                if ($hasProxyParent) {
                    $proxyDefaultValue = ($dataBlock.metadata.urlPath -split '\/')[-3]
                    $proxyParamName = Get-ResourceTypeSingularName -ResourceType ($proxyParentName -split '/')[-1]
                    $templateContent += "    {0}Name: '{1}'" -f $proxyParamName, $proxyDefaultValue
                    $alreadyAddedParams += $proxyParamName
                }

                # Add primary child parameters
                $allParam = $dataBlock.data.parameters + $dataBlock.data.additionalParameters
                foreach ($parameter in (($allParam | Where-Object { $_.Level -in @(0, 1) -and $_.name -ne 'properties' -and ([String]::IsNullOrEmpty($_.Parent) -or $_.Parent -eq 'properties') }) | Sort-Object -Property 'Name')) {
                    $wouldBeParameter = Get-FormattedModuleParameter -ParameterData $parameter | Where-Object { $_ -like 'param *' } | ForEach-Object { $_ -replace 'param ', '' }
                    $wouldBeParamElem = $wouldBeParameter -split ' = '
                    $parameterName = ($wouldBeParamElem -split ' ')[0]

                    # If the existing content already specifies the parameter, let's use that one instead of generating a new
                    if ($existingModuleData.nestedElements.name -contains $parameterName) {
                        $existingParam = $existingModuleData.nestedElements | Where-Object { $_.name -eq $parameterName }
                        if ($alreadyAddedParams -notcontains $existingParam.name) {
                            $templateContent += $existingParam.content
                        }
                        continue
                    }

                    if ($wouldBeParamElem.count -gt 1) {
                        # With default

                        if ($parameterName -eq 'lock') {
                            # Special handling as we pass the parameter down to the child
                            $templateContent += "    $($parameterName): contains($($childResourceTypeSingular), 'lock') ? $($childResourceTypeSingular).lock : lock"
                            $alreadyAddedParams += $parameterName
                            continue
                        }

                        $wouldBeParamValue = $wouldBeParamElem[1]

                        # Special case, location function - should reference a location parameter instead
                        if ($wouldBeParamValue -like '*().location') {
                            $wouldBeParamValue = 'location'
                        }

                        $templateContent += "    $($parameterName): contains($($childResourceTypeSingular), '$($parameterName)') ? $($childResourceTypeSingular).$($parameterName) : $($wouldBeParamValue)"
                        $alreadyAddedParams += $parameterName
                    } else {
                        # No default
                        $templateContent += "    $($parameterName): $($childResourceTypeSingular).$($parameterName)"
                        $alreadyAddedParams += $parameterName
                    }
                }

                $templateContent += @(
                    # Special handling as we pass the variable down to the child
                    '    enableDefaultTelemetry: enableReferencedModulesTelemetry'
                    '  }'
                    '}]'
                    ''
                )
            }
        }

        return $templateContent
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
