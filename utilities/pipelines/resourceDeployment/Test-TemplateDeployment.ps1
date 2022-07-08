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
Optional. Path to the parameter file from root.

.PARAMETER location
Mandatory. Location to test in. E.g. WestEurope

.PARAMETER resourceGroupName
Optional. Name of the resource group to deploy into. Mandatory if deploying into a resource group (resource group level)

.PARAMETER subscriptionId
Optional. ID of the subscription to deploy into. Mandatory if deploying into a subscription (subscription level) using a Management groups service connection

.PARAMETER managementGroupId
Optional. Name of the management group to deploy into. Mandatory if deploying into a management group (management group level)

.PARAMETER additionalParameters
Optional. Additional parameters you can provide with the deployment. E.g. @{ resourceGroupName = 'myResourceGroup' }

.EXAMPLE
Test-TemplateDeployment -templateFilePath 'C:/KeyVault/deploy.bicep' -parameterFilePath 'C:/KeyVault/.test/parameters.json' -location 'WestEurope' -resourceGroupName 'aLegendaryRg'

Test the deploy.bicep of the KeyVault module with the parameter file 'parameters.json' using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
Test-TemplateDeployment -templateFilePath 'C:/KeyVault/deploy.bicep' -location 'WestEurope' -resourceGroupName 'aLegendaryRg'

Test the deploy.bicep of the KeyVault module using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
Test-TemplateDeployment -templateFilePath 'C:/ResourceGroup/deploy.json' -parameterFilePath 'C:/ResourceGroup/.test/parameters.json' -location 'WestEurope'

Test the deploy.json of the ResourceGroup module with the parameter file 'parameters.json' in location 'WestEurope'
#>
function Test-TemplateDeployment {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $templateFilePath,

        [Parameter(Mandatory)]
        [string] $location,

        [Parameter(Mandatory = $false)]
        [string] $parameterFilePath,

        [Parameter(Mandatory = $false)]
        [string] $resourceGroupName,

        [Parameter(Mandatory = $false)]
        [string] $subscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $managementGroupId,

        [Parameter(Mandatory = $false)]
        [Hashtable] $additionalParameters
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path (Get-Item -Path $PSScriptRoot).parent.FullName 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')
    }

    process {
        $DeploymentInputs = @{
            TemplateFile = $templateFilePath
            Verbose      = $true
            OutVariable  = 'ValidationErrors'
        }
        if (-not [String]::IsNullOrEmpty($parameterFilePath)) {
            $DeploymentInputs['TemplateParameterFile'] = $parameterFilePath
        }
        $ValidationErrors = $null

        # Additional parameter object provided yes/no
        if ($additionalParameters) {
            $DeploymentInputs += $additionalParameters
        }

        $deploymentScope = Get-ScopeOfTemplateFile -TemplateFilePath $templateFilePath -Verbose

        if ($deploymentScope -ne 'resourceGroup') {
            $deploymentNamePrefix = Split-Path -Path (Split-Path $templateFilePath -Parent) -LeafBase
            if ([String]::IsNullOrEmpty($deploymentNamePrefix)) {
                $deploymentNamePrefix = 'templateDeployment-{0}' -f (Split-Path $templateFilePath -LeafBase)
            }
            # Generate a valid deployment name. Must match ^[-\w\._\(\)]+$
            do {
                $deploymentName = "$deploymentNamePrefix-$(-join (Get-Date -Format yyyyMMddTHHMMssffffZ)[0..63])"
            } while ($deploymentName -notmatch '^[-\w\._\(\)]+$')

            Write-Verbose "Testing with deployment name [$deploymentName]" -Verbose
            $DeploymentInputs['DeploymentName'] = $deploymentName
        }

        #######################
        ## INVOKE DEPLOYMENT ##
        #######################
        switch ($deploymentScope) {
            'resourceGroup' {
                if (-not [String]::IsNullOrEmpty($subscriptionId)) {
                    Write-Verbose ('Setting context to subscription [{0}]' -f $subscriptionId)
                    $null = Set-AzContext -Subscription $subscriptionId
                }
                if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction 'SilentlyContinue')) {
                    if ($PSCmdlet.ShouldProcess("Resource group [$resourceGroupName] in location [$location]", 'Create')) {
                        New-AzResourceGroup -Name $resourceGroupName -Location $location
                    }
                }
                if ($PSCmdlet.ShouldProcess('Resource group level deployment', 'Test')) {
                    $res = Test-AzResourceGroupDeployment @DeploymentInputs -ResourceGroupName $resourceGroupName
                }
                break
            }
            'subscription' {
                if (-not [String]::IsNullOrEmpty($subscriptionId)) {
                    Write-Verbose ('Setting context to subscription [{0}]' -f $subscriptionId)
                    $null = Set-AzContext -Subscription $subscriptionId
                }
                if ($PSCmdlet.ShouldProcess('Subscription level deployment', 'Test')) {
                    $res = Test-AzSubscriptionDeployment @DeploymentInputs -Location $Location
                }
                break
            }
            'managementGroup' {
                if ($PSCmdlet.ShouldProcess('Management group level deployment', 'Test')) {
                    $res = Test-AzManagementGroupDeployment @DeploymentInputs -Location $Location -ManagementGroupId $ManagementGroupId
                }
                break
            }
            'tenant' {
                Write-Verbose 'Handling tenant level validation'
                if ($PSCmdlet.ShouldProcess('Tenant level deployment', 'Test')) {
                    $res = Test-AzTenantDeployment @DeploymentInputs -Location $location
                }
                break
            }
            default {
                throw "[$deploymentScope] is a non-supported template scope"
            }
        }
        if ($ValidationErrors) {
            if ($res.Details) { Write-Warning ($res.Details | ConvertTo-Json -Depth 10 | Out-String) }
            if ($res.Message) { Write-Warning $res.Message }
            Write-Error 'Template is not valid.'
        } else {
            Write-Verbose 'Template is valid' -Verbose
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
