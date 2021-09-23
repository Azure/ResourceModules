<#
.SYNOPSIS
Run a template validation using a given parameter file

.DESCRIPTION
Run a template validation using a given parameter file
Works on a resource group, subscription, managementgroup and tenant level

.PARAMETER parametersBasePath
Mandatory. The path to the root of the parameters folder to test with

.PARAMETER templateFilePath
Mandatory. Path to the template file from root.

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
Test-TemplateWithParameterFile templateFilePath 'ARM/KeyVault/deploy.json' -parameterFilePath 'ARM/KeyVault/Parameters/parameters.json' -location 'WestEurope' -resourceGroupName 'aLegendaryRg'

Test the deploy.json of the KeyVault module with the parameter file 'parameters.json' using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
Test-TemplateWithParameterFile templateFilePath 'ARM/ResourceGroup/deploy.json' -parameterFilePath 'ARM/ResourceGroup/Parameters/parameters.json' -location 'WestEurope'

Test the deploy.json of the ResourceGroup module with the parameter file 'parameters.json' in location 'WestEurope'
#>
function Test-TemplateWithParameterFile {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $templateFilePath,

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
        # Can be removed once bicep supports a test deployment
        if ((Split-Path $templateFilePath -Extension) -eq '.bicep') {
            az bicep build -f $templateFilePath
            $templateFilePath = Join-Path (Split-Path $templateFilePath -Parent) 'deploy.json'
        }

        $DeploymentInputs = @{
            TemplateFile          = $templateFilePath
            TemplateParameterFile = $parameterFilePath
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