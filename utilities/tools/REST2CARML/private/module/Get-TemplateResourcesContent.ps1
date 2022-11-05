function Get-TemplateResourcesContent {

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
        [array] $FullModuleData,

        [Parameter(Mandatory = $false)]
        [array] $ParentResourceTypes = @(),

        [Parameter(Mandatory = $false)]
        [array] $ExistingTemplateContent = @(),

        [Parameter(Mandatory = $false)]
        [array] $LinkedChildren = @()
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
            $_.resourceType -eq $FullResourceType -and $_.resourceName -eq $resourceTypeSingular
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
        $templateContent += ''

        # Add 'existing' parents (if any)
        # -------------------------------
        $existingResourceIndent = 0
        $orderedParentResourceTypes = $fullParentResourceStack | Where-Object { $_ -notlike $FullResourceType } | Sort-Object
        foreach ($parentResourceType in $orderedParentResourceTypes) {
            $singularParent = ((Get-ResourceTypeSingularName -ResourceType $parentResourceType) -split '/')[-1]
            $levedParentResourceType = ($parentResourceType -ne (@() + $orderedParentResourceTypes)[0]) ? (Split-Path $parentResourceType -Leaf) : $parentResourceType
            $parentJSONPath = ($FullModuleData | Where-Object { $_.identifier -eq $parentResourceType }).Metadata.JSONFilePath

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
        $templateContent += ''

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

        $templateContent += '  properties: {'
        foreach ($parameter in ($ModuleData.parameters | Where-Object { $_.level -eq 1 -and $_.Parent -eq 'properties' } | Sort-Object -Property 'name')) {
            if ($matchingExistingResource.nestedElements.name -notcontains $parameter.name) {
                $templateContent += '    {0}: {0}' -f $parameter.name
            } else {
                $existingProperty = $matchingExistingResource.nestedElements | Where-Object { $_.name -eq $parameter.name }
                $templateContent += $existingProperty.content
            }
        }

        $templateContent += @(
            '  }'
            '}'
            ''
        )

        # If a template already exists, add 'extra' resources that are not yet part of the template content
        # -------------------------------------------------------------------------------------------------
        $preExistingExtraResources = $existingTemplateContent.resources | Where-Object {
            $_.resourceName -notIn ($ModuleData.resources.name + 'defaultTelemetry' + $resourceTypeSingular)
        }
        foreach ($resource in $preExistingExtraResources) {
            $templateContent += $resource.content
            $templateContent += ''
        }

        # Add additional resources such as extensions (like DiagnosticSettigs)
        # --------------------------------------------------------------------
        # Other collected resources
        foreach ($additionalResource in $ModuleData.resources) {
            if ($existingTemplateContent.resources.resourceName -notcontains $additionalResource.name) {
                $templateContent += $additionalResource.content
            } else {
                $existingResource = $existingTemplateContent.resources | Where-Object { $_.resourceName -eq $additionalResource.name }
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
        if ($LinkedChildren.Count -gt 0) {
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
