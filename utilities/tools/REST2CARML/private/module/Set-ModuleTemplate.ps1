<#
.SYNOPSIS
Update the module's primary template (deploy.bicep) as per the provided module data.

.DESCRIPTION
Update the module's primary template (deploy.bicep) as per the provided module data.

.PARAMETER FullResourceType
Mandatory. The complete ResourceType identifier to update the template for (e.g. 'Microsoft.Storage/storageAccounts').

.PARAMETER ModuleData
Mandatory. The module data (e.g. parameters) to add to the template.

.PARAMETER FullModuleData
Mandatory. The full stack of module data of all modules included in the original invocation. May be used for parent-child references.

.PARAMETER JSONFilePath
Mandatory. The service specification file to process.

.PARAMETER UrlPath
Mandatory. The API Path in the JSON specification file to process

.EXAMPLE
Set-ModuleTemplate -FullResourceType 'Microsoft.KeyVault/vaults' -ModuleData @{ parameters = @(...); resource = @(...); (...) } -JSONFilePath '(...)/resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json' -UrlPath '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}' -FullModuleData @(@{ parameters = @(...); resource = @(...); (...) }, @{...})

Update the module [Microsoft.KeyVault/vaults] with the provided module data.
#>
function Set-ModuleTemplate {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType,

        [Parameter(Mandatory = $true)]
        [array] $ModuleData,

        [Parameter(Mandatory = $true)]
        [array] $FullModuleData,

        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath,

        [Parameter(Mandatory = $true)]
        [string] $UrlPath
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        $templatePath = Join-Path $script:repoRoot 'modules' $FullResourceType 'deploy.bicep'
        $providerNamespace = ($FullResourceType -split '/')[0]
        $resourceType = $FullResourceType -replace "$providerNamespace/", ''
    }

    process {
        # Collect any children of the current resource to create references
        $directChildren = $fullmoduleData | Where-Object {
            ($_.identifier -split '/').Count -gt ($FullResourceType -split '/').count
        }

        # Collect parent resources to use for parent type references
        $typeElem = $FullResourceType -split '/'
        if ($typeElem.Count -gt 2) {
            $parentResourceTypes = $typeElem[1..($typeElem.Count - 2)]
        } else {
            $parentResourceTypes = @()
        }

        # Get the singular version of the current resource type for proper naming
        $resourceTypeSingular = ((Get-ResourceTypeSingularName -ResourceType $resourceType) -split '/')[-1]

        ##################
        ##  PARAMETERS  ##
        ##################

        $targetScope = Get-TargetScope -UrlPath $UrlPath

        $templateContent = ($targetScope -ne 'resourceGroup') ? @(
            "targetScope = '{0}'" -f $targetScope,
            ''
        ) : @()

        $templateContent += @(
            '// ============== //'
            '//   Parameters   //'
            '// ============== //'
            ''
        )

        foreach ($parentResourceType in $parentResourceTypes) {
            $templateContent += Get-FormattedModuleParameter -ParameterData @{
                level       = 0
                name        = '{0}Name' -f (Get-ResourceTypeSingularName -ResourceType $parentResourceType)
                type        = 'string'
                description = 'Conditional. The name of the parent key vault. Required if the template is used in a standalone deployment.'
                required    = $false
            }
        }

        # Add primary (service) parameters (i.e. top-level and those in the properties)
        foreach ($parameter in ($ModuleData.parameters | Where-Object { $_.Level -in @(0, 1) -and $_.name -ne 'properties' -and ([String]::IsNullOrEmpty($_.Parent) -or $_.Parent -eq 'properties') })) {
            $templateContent += Get-FormattedModuleParameter -ParameterData $parameter
        }
        # Add additional (extension) parameters
        foreach ($parameter in $ModuleData.additionalParameters) {
            $templateContent += Get-FormattedModuleParameter -ParameterData $parameter
        }

        # Child module references
        foreach ($dataBlock in $directChildren) {
            $childResourceType = ($dataBlock.identifier -split '/')[-1]

            $templateContent += Get-FormattedModuleParameter -ParameterData @{
                level       = 0
                name        = $childResourceType
                type        = 'array'
                default     = @()
                description = "The $childResourceType to create as part of the $resourceTypeSingular."
                required    = $false
            }
        }

        # Add telemetry parameter
        $templateContent += Get-FormattedModuleParameter -ParameterData @{
            level       = 0
            name        = 'enableDefaultTelemetry'
            type        = 'boolean'
            default     = $true
            description = 'Enable telemetry via the Customer Usage Attribution ID (GUID).'
            required    = $false
        }

        #################
        ##  VARIABLES  ##
        #################

        foreach ($variable in $ModuleData.variables) {
            $templateContent += $variable
        }
        # Add telemetry variable
        if ($directChildren.Count -gt 0) {
            $templateContent += @(
                'var enableReferencedModulesTelemetry = false'
                ''
            )
        }

        ###################
        ##  DEPLOYMENTS  ##
        ###################

        $templateContent += @(
            ''
            '// =============== //'
            '//   Deployments   //'
            '// =============== //'
            ''
        )

        # Telemetry
        $templateContent += Get-Content -Path (Join-Path $Script:src 'telemetry.bicep')
        $templateContent += ''

        # TODO: Add recursive parent reference (if any)

        # Deployment resource declaration line
        $serviceAPIVersion = Split-Path (Split-Path $JSONFilePath -Parent) -Leaf
        $templateContent += "resource $resourceTypeSingular '$FullResourceType@$serviceAPIVersion' = {"

        foreach ($parameter in ($ModuleData.parameters | Where-Object { $_.level -eq 0 -and $_.name -ne 'properties' })) {
            $templateContent += '  {0}: {0}' -f $parameter.name
        }

        $templateContent += '  properties: {'
        foreach ($parameter in ($ModuleData.parameters | Where-Object { $_.level -eq 1 -and $_.Parent -eq 'properties' })) {
            $templateContent += '    {0}: {0}' -f $parameter.name
        }

        $templateContent += @(
            '  }'
            '}'
            ''
        )


        # Other collected resources
        $templateContent += $ModuleData.resources

        # Child-module references
        foreach ($dataBlock in $directChildren) {
            $childResourceType = ($dataBlock.identifier -split '/')[-1]
            $childResourceTypeSingular = Get-ResourceTypeSingularName -ResourceType $childResourceType
            $templateContent += @(
                "module $($resourceTypeSingular)_$($childResourceType) '$($childResourceType)/deploy.bicep' = [for ($($childResourceTypeSingular), index) in $($childResourceType): {",
                "name: '`${uniqueString(deployment().name, location)}-$($resourceTypeSingular)-$($childResourceTypeSingular)-`${index}'",
                'params: {'
            )

            foreach ($parentResourceType in $parentResourceTypes) {
                $templateContent += '    {0}Name: {0}Name' -f ((Get-ResourceTypeSingularName -ResourceType $parentResourceType) -split '/')[-1]
            }
            $templateContent += '    {0}Name: name' -f ((Get-ResourceTypeSingularName -ResourceType ($FullResourceType -split '/')[-1]) -split '/')[-1]

            # Add primary child parameters
            $allParam = $dataBlock.data.parameters + $dataBlock.data.additionalParameters
            foreach ($parameter in ($allParam | Where-Object { $_.Level -in @(0, 1) -and $_.name -ne 'properties' -and ([String]::IsNullOrEmpty($_.Parent) -or $_.Parent -eq 'properties') })) {
                $wouldBeParameter = Get-FormattedModuleParameter -ParameterData $parameter | Where-Object { $_ -like 'param *' } | ForEach-Object { $_ -replace 'param ', '' }
                $wouldBeParamElem = $wouldBeParameter -split ' = '
                $parameter.name = ($wouldBeParamElem -split ' ')[0]
                if ($wouldBeParamElem.count -gt 1) {
                    # With default

                    if ($parameter.name -eq 'lock') {
                        # Special handling as we pass the parameter down to the child
                        $templateContent += "    lock: contains($($childResourceTypeSingular), 'lock') ? $($childResourceTypeSingular).lock : lock"
                        continue
                    }

                    $wouldBeParamValue = $wouldBeParamElem[1]
                    $templateContent += "    $($parameter.name): contains($($childResourceTypeSingular), '$($parameter.name)') ? $($childResourceTypeSingular).$($parameter.name) : $($wouldBeParamValue)"
                } else {
                    # No default
                    $templateContent += "    $($parameter.name): $($childResourceTypeSingular).$($parameter.name)"
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

        #######################################
        ##  Create template outputs section  ##
        #######################################

        # Output header comment
        $templateContent += @(
            '// =========== //'
            '//   Outputs   //'
            '// =========== //'
            ''
            "@description('The name of the $resourceTypeSingular.')"
            "output name string = $resourceTypeSingular.name"
            ''
            "@description('The resource ID of the $resourceTypeSingular.')"
            "output resourceId string = $resourceTypeSingular.id"
            ''
        )

        if ($targetScope -eq 'resourceGroup') {
            $templateContent += @(
                "@description('The name of the resource group the $resourceTypeSingular was created in.')"
                'output resourceGroupName string = resourceGroup().name'
                ''
            )
        }

        # Update file
        # -----------
        Set-Content -Path $templatePath -Value ($templateContent | Out-String).TrimEnd() -Force
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
