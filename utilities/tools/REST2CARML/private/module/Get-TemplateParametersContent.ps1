function Get-TemplateParametersContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType,

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

        # Handle parent proxy, if any
        $hasAProxyParent = $FullModuleData.identifier -notContains ((Split-Path $FullResourceType -Parent) -replace '\\', '/')
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
        foreach ($dataBlock in ($linkedChildren | Sort-Object -Property 'identifier')) {
            $childResourceType = ($dataBlock.identifier -split '/')[-1]
            $parametersToAdd += @{
                level       = 0
                name        = $childResourceType
                type        = 'array'
                default     = @()
                description = "The $childResourceType to create as part of the $resourceTypeSingular."
                required    = $false
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
