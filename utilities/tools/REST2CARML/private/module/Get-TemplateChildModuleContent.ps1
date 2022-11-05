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
        [array] $LinkedChildren = @(),

        [Parameter(Mandatory = $true)]
        [array] $ModuleData,

        [Parameter(Mandatory = $true)]
        [string] $LocationParameterExists,

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

        foreach ($dataBlock in $linkedChildren) {
            $childResourceType = ($dataBlock.identifier -split '/')[-1]

            $hasProxyParent = [String]::IsNullOrEmpty($dataBlock.metadata.parentUrlPath)
            if ($hasProxyParent) {
                $proxyParentName = Split-Path (Split-Path $dataBlock.identifier -Parent) -Leaf
            }

            $moduleName = '{0}{1}_{2}' -f ($hasProxyParent ? "$($proxyParentName)_" : ''), $resourceTypeSingular, $childResourceType
            $modulePath = '{0}{1}/deploy.bicep' -f ($hasProxyParent ? "$proxyParentName/" : ''), $childResourceType

            $matchingModule = $ExistingTemplateContent.modules | Where-Object { $_.name -eq $moduleName -and $_.path -eq $modulePath }

            # Differentiate 'singular' children (like 'blobservices') vs. 'multiple' chilren (like 'containers')
            if ($ModuleData.isSingleton) {
                $templateContent += @(
                    "module $moduleName '$modulePath' = {"
                )

                if ($matchingModule.topLevelElements.name -notcontains 'name') {
                    $templateContent += "  name: '`${uniqueString(deployment().name$($LocationParameterExists ? ', location' : ''))}-$($resourceTypeSingular)-$($childResourceType)'"
                } else {
                    $existingParam = $matchingModule.topLevelElements | Where-Object { $_.name -eq 'name' }
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

                    if ($matchingModule.nestedElements.name -notcontains $parameter.name) {
                        $existingParam = $matchingModule.nestedElements | Where-Object { $_.name -eq $parameter.name }
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

                if ($matchingModule.topLevelElements.name -notcontains 'name') {
                    $templateContent += "  name: '`${uniqueString(deployment().name$($LocationParameterExists ? ', location' : ''))}-$($resourceTypeSingular)-$($childResourceTypeSingular)-`${index}'"
                } else {
                    $existingParam = $matchingModule.topLevelElements | Where-Object { $_.name -eq 'name' }
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

                    if ($matchingModule.nestedElements.name -notcontains $parameter.name) {
                        $existingParam = $matchingModule.nestedElements | Where-Object { $_.name -eq $parameter.name }
                        if ($alreadyAddedParams -notcontains $existingParam.name) {
                            $templateContent += $existingParam.content
                        }
                        continue
                    }

                    if ($wouldBeParamElem.count -gt 1) {
                        # With default

                        if ($parameter.name -eq 'lock') {
                            # Special handling as we pass the parameter down to the child
                            $templateContent += "    $($parameter.name): contains($($childResourceTypeSingular), 'lock') ? $($childResourceTypeSingular).lock : lock"
                            $alreadyAddedParams += $parameter.name
                            continue
                        }

                        $wouldBeParamValue = $wouldBeParamElem[1]

                        # Special case, location function - should reference a location parameter instead
                        if ($wouldBeParamValue -like '*().location') {
                            $wouldBeParamValue = 'location'
                        }

                        $templateContent += "    $($parameter.name): contains($($childResourceTypeSingular), '$($parameter.name)') ? $($childResourceTypeSingular).$($parameter.name) : $($wouldBeParamValue)"
                        $alreadyAddedParams += $parameter.name
                    } else {
                        # No default
                        $templateContent += "    $($parameter.name): $($childResourceTypeSingular).$($parameter.name)"
                        $alreadyAddedParams += $parameter.name
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
