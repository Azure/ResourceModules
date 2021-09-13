<#
.SYNOPSIS
Run a template deployment using a given parameter file

.DESCRIPTION
Run a template deployment using a given parameter file.
Works on a resource group, subscription, managementgroup and tenant level

.PARAMETER parametersBasePath
Mandatory. The path to the root of the parameters folder to test with

.PARAMETER templateFilePath
Mandatory. Path to the template from root.

.PARAMETER parameterFilePath
Mandatory. Path to the parameter file from root.

.PARAMETER location
Mandatory. Location to test in. E.g. WestEurope

.PARAMETER resourceGroupName
Optional. Name of the resource group to deploy into. Mandatory if deploying into a resource group (resource group level)

.PARAMETER subscriptionId
Optional. Id of the subscription to deploy into. Mandatory if deploying into a subscription (subscription level) using a Management groups service connection

.PARAMETER managementGroupId
Optional. Name of the management group to deploy into. Mandatory if deploying into a management group (management group level)

.PARAMETER removeDeployment
Optional. Set to 'true' to add the tag 'RemoveModule = <ModuleName>' to the deployment. Is picked up by the removal stage to remove the resource again.

.EXAMPLE
New-ALZDeployment -templateFilePath 'C:\deploy.json' -parameterFilePath 'C:\parameters.json' -location 'WestEurope' -resourceGroupName 'aLegendaryRg'

Deploy the template in path 'C:\deploy.json' with the parameter file 'parameters.json' using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
New-ALZDeployment -templateFilePath 'C:\deploy.json' -parameterFilePath 'C:\parameters.json' -location 'WestEurope'

Deploy the template in path 'C:\deploy.json' with the parameter file 'parameters.json' in location 'WestEurope'
#>
function New-ALZDeployment {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $templateFilePath,

        [Parameter(Mandatory)]
        [string] $parameterFilePath,

        [Parameter(Mandatory = $false)]
        [hashtable] $optionalParameters,

        [Parameter(Mandatory)]
        [string] $location,

        [Parameter(Mandatory = $false)]
        [string] $resourceGroupName,

        [Parameter(Mandatory = $false)]
        [string] $subscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $managementGroupId
    )

    begin {
        Write-Debug ("{0} entered" -f $MyInvocation.MyCommand)
    }

    process {
        $DeploymentInputs = @{
            Name                  = "$moduleName-$(-join (Get-Date -Format yyyyMMddTHHMMssffffZ)[0..63])"
            TemplateFile          = $templateFilePath
            TemplateParameterFile = $parameterFilePath
            Verbose               = $true
            ErrorAction           = 'Stop'
        }

        foreach ($key in $optionalParameters.Keys) {
            $DeploymentInputs += @{
                $key = $optionalParameters.Item($key)
            }
        }

        #######################
        ## INVOKE DEPLOYMENT ##
        #######################
        $deploymentSchema = (ConvertFrom-Json (Get-Content -Raw -Path $templateFilePath)).'$schema'
        switch -regex ($deploymentSchema) {
            '\/deploymentTemplate.json#$' {
                if ($subscriptionId) {
                    $Context = Get-AzContext -ListAvailable | Where-Object Subscription -Match $subscriptionId
                    if ($Context) {
                        $Context | Set-AzContext
                    }
                }
                if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction 'SilentlyContinue')) {
                    if ($PSCmdlet.ShouldProcess("Resource group [$resourceGroupName] in location [$location]", "Create")) {
                        New-AzResourceGroup -Name $resourceGroupName -Location $location
                    }
                }
                if ($PSCmdlet.ShouldProcess("Resource group level deployment", "Create")) {
                    New-AzResourceGroupDeployment @DeploymentInputs -ResourceGroupName $resourceGroupName
                }
                break
            }
            '\/subscriptionDeploymentTemplate.json#$' {
                if ($subscriptionId) {
                    $Context = Get-AzContext -ListAvailable | Where-Object Subscription -Match $subscriptionId
                    if ($Context) {
                        $Context | Set-AzContext
                    }
                }
                if ($PSCmdlet.ShouldProcess("Subscription level deployment", "Create")) {
                    New-AzSubscriptionDeployment @DeploymentInputs -location $location
                }
                break
            }
            '\/managementGroupDeploymentTemplate.json#$' {
                if ($PSCmdlet.ShouldProcess("Management group level deployment", "Create")) {
                    New-AzManagementGroupDeployment @DeploymentInputs -location $location -managementGroupId $managementGroupId
                }
                break
            }
            '\/tenantDeploymentTemplate.json#$' {
                if ($PSCmdlet.ShouldProcess("Tenant level deployment", "Create")) {
                    New-AzTenantDeployment @DeploymentInputs -location $location
                }
                break
            }
            default {
                throw "[$deploymentSchema] is a non-supported ARM template schema"
            }
        }
    }

    end {
        Write-Debug ("{0} exited" -f $MyInvocation.MyCommand)
    }
}