<#
.SYNOPSIS
Run a template validation using a given parameter file

.DESCRIPTION
Run a template validation using a given parameter file
Works on a resource group, subscription, managementgroup and tenant level

.PARAMETER componentsBasePath
Mandatory. The path to the component/module root

.PARAMETER parametersBasePath
Mandatory. The path to the root of the parameters folder to test with

.PARAMETER modulePath
Mandatory. Path to the module from root.

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

.EXAMPLE
Test-TemplateWithParameterFile -componentsBasePath "$(System.DefaultWorkingDirectory)" -parametersBasePath "$(Build.Repository.LocalPath)" -modulePath 'Modules/ARM/KeyVault' -parameterFilePath 'Modules/ARM/KeyVault/Parameters/parameters.json' -location 'WestEurope' -resourceGroupName 'aLegendaryRg'

Test the deploy.json of the KeyVault module with the parameter file 'parameters.json' using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
Test-TemplateWithParameterFile -componentsBasePath "$(System.DefaultWorkingDirectory)" -parametersBasePath "$(Build.Repository.LocalPath)" -modulePath 'Modules/ARM/ResourceGroup' -parameterFilePath 'Modules/ARM/ResourceGroup/Parameters/parameters.json' -location 'WestEurope'

Test the deploy.json of the ResourceGroup module with the parameter file 'parameters.json' in location 'WestEurope'
#>
function Test-TemplateWithParameterFile {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $componentsBasePath,

        [Parameter(Mandatory)]
        [string] $parametersBasePath,

        [Parameter(Mandatory)]
        [string] $modulePath,

        [Parameter(Mandatory)]
        [string] $parameterFilePath,

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
        $templateFilePath = "$componentsBasePath/$modulePath/deploy.json"
        $DeploymentInputs = @{
            TemplateFile          = $templateFilePath
            TemplateParameterFile = "$parametersBasePath/$parameterFilePath"
            Verbose               = $true
            OutVariable           = 'ValidationErrors'
        }
        $ValidationErrors = $null

        #####################
        ## TEST DEPLOYMENT ##
        #####################
        $deploymentSchema = (ConvertFrom-Json (Get-Content -Raw -Path $templateFilePath)).'$schema'
        switch -regex ($deploymentSchema) {
            '\/deploymentTemplate.json#$' {
                if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction 'SilentlyContinue')) {
                    if ($PSCmdlet.ShouldProcess("Resource group [$resourceGroupName] in location [$location]", "Create")) {
                        New-AzResourceGroup -Name $resourceGroupName -Location $location
                    }
                }
                if ($PSCmdlet.ShouldProcess("Resource group level deployment", "Test")) {
                    Test-AzResourceGroupDeployment @DeploymentInputs -ResourceGroupName $resourceGroupName
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
                if ($PSCmdlet.ShouldProcess("Subscription level deployment", "Test")) {
                    Test-AzSubscriptionDeployment @DeploymentInputs -Location $Location
                }
                break
            }
            '\/managementGroupDeploymentTemplate.json#$' {
                if ($PSCmdlet.ShouldProcess("Management group level deployment", "Test")) {
                    Test-AzManagementGroupDeployment @DeploymentInputs -Location $Location -ManagementGroupId $ManagementGroupId
                }
                break
            }
            '\/tenantDeploymentTemplate.json#$' {
                Write-Verbose 'Handling tenant level validation'
                if ($PSCmdlet.ShouldProcess("Tenant level deployment", "Test")) {
                    Test-AzTenantDeployment @DeploymentInputs -Location $location
                }
                break
            }
            default {
                throw "[$deploymentSchema] is a non-supported ARM template schema"
            }
        }
        if ($ValidationErrors) {
            Write-Error "Template is not valid."
        }
    }

    end {
        Write-Debug ("{0} exited" -f $MyInvocation.MyCommand)
    }
}