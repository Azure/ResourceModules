function Get-ModuleOutputContent {

    [CmdletBinding()]
    param (
        [Parameter()]
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType,

        [Parameter(Mandatory = $true)]
        [string] $UrlPath,

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

        $providerNamespace = ($FullResourceType -split '/')[0]
        $resourceType = $FullResourceType -replace "$providerNamespace/", ''

        # Get the singular version of the current resource type for proper naming
        $resourceTypeSingular = ((Get-ResourceTypeSingularName -ResourceType $resourceType) -split '/')[-1]

        $targetScope = Get-TargetScope -UrlPath $UrlPath

        ####################
        ##   Set Outputs   #
        ####################
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
        if ($ModuleData.parametersToAdd.name -contains 'location' -and $ModuleData.parametersToAdd['location'].defaultValue -ne 'global') {
            $defaultOutputs += @{
                name    = 'location'
                type    = 'string'
                content = @(
                    "@description('The location the resource was deployed into.')"
                    '{0}.location' -f $resourceTypeSingular
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

        # Output header comment
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


    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
