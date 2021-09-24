<#
.SYNOPSIS
Run a template deployment using a given parameter file

.DESCRIPTION
Run a template deployment using a given parameter file.
Works on a resource group, subscription, managementgroup and tenant level

.PARAMETER moduleName
Mandatory. The name of the module to deploy

.PARAMETER templateFilePath
Mandatory. The path to the deployment file

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
Optional. Set to 'true' to add the tag 'removeModule = <ModuleName>' to the deployment. Is picked up by the removal stage to remove the resource again.

.EXAMPLE
New-ModuleDeployment -ModuleName 'KeyVault' -templateFilePath 'C:/KeyVault/deploy.json' -parameterFilePath 'C:/KeyVault/Parameters/parameters.json' -location 'WestEurope' -resourceGroupName 'aLegendaryRg'

Deploy the deploy.json of the KeyVault module with the parameter file 'parameters.json' using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
New-ModuleDeployment -ModuleName 'KeyVault' -templateFilePath 'C:/ResourceGroup/deploy.json' -parameterFilePath 'C:/ResourceGroup/Parameters/parameters.json' -location 'WestEurope'

Deploy the deploy.json of the ResourceGroup module with the parameter file 'parameters.json' in location 'WestEurope'
#>
function New-ModuleDeployment {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $moduleName,

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
        [string] $managementGroupId,

        [Parameter(Mandatory = $false)]       
        [bool] $removeDeployment
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
        if ($removeDeployment) {
            # Fetch tags of parameter file if any (- required for the remove process. Tags may need to be compliant with potential customer requirements)
            $parameterFileTags = (ConvertFrom-Json (Get-Content -Raw -Path $parameterFilePath) -AsHashtable).parameters.tags.value
            if (-not $parameterFileTags) {
                $parameterFileTags = @{}
            }
            $parameterFileTags['removeModule'] = $moduleName
        }

        # Determine deployment scope
        # ==========================
        if ((Split-Path $templateFilePath -Extension) -eq '.bicep') {
            # Bicep
            $bicepContent = Get-Content $templateFilePath
            $bicepScope = $bicepContent | Where-Object { $_ -like "*targetscope =" } 
            if (-not $bicepScope) {
                $deploymentScope = "resourceGroup" 
            }
            else {
                $deploymentScope = $bicepScope.Replace('targetscope = ', '').Trim()
            } 
        }
        else {
            # ARM
            $armSchema = (ConvertFrom-Json (Get-Content -Raw -Path $templateFilePath)).'$schema'
            switch -regex ($armSchema) {
                '\/deploymentTemplate.json#$' { $deploymentScope = "resourceGroup" }
                '\/subscriptionDeploymentTemplate.json#$'  { $deploymentScope = "subscription" }
                '\/managementGroupDeploymentTemplate.json#$'  { $deploymentScope = "managementGroup" }
                '\/tenantDeploymentTemplate.json#$'  { $deploymentScope = "tenant" }
                Default { throw "[$armSchema] is a non-supported ARM template schema" }
            }
        }

        #######################
        ## INVOKE DEPLOYMENT ##
        #######################
        switch ($deploymentScope) {
            'resourceGroup' {
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
                if ($removeDeployment) {
                    Write-Verbose "Because the subsequent removal is enabled after the Module $moduleName has been deployed, the following tags (removeModule: $moduleName) are now set on the resource."
                    Write-Verbose "This is necessary so that the later running Removal Stage can remove the corresponding Module from the Resource Group again."
                    # Overwrites parameter file tags parameter  
                    $DeploymentInputs += @{ 
                        Tags = $parameterFileTags
                    }
                }
                if ($PSCmdlet.ShouldProcess("Resource group level deployment", "Create")) {
                    New-AzResourceGroupDeployment @DeploymentInputs -ResourceGroupName $resourceGroupName
                }
                break
            }
            'subscription' {
                if ($subscriptionId) {
                    $Context = Get-AzContext -ListAvailable | Where-Object Subscription -Match $subscriptionId
                    if ($Context) {
                        $Context | Set-AzContext
                    }
                }
                if ($removeDeployment) {
                    Write-Verbose "Because the subsequent removal is enabled after the Module $moduleName has been deployed, the following tags (removeModule: $moduleName) are now set on the resource."
                    Write-Verbose "This is necessary so that the later running Removal Stage can remove the corresponding Module from the Resource Group again."
                    # Overwrites parameter file tags parameter  
                    $DeploymentInputs += @{ 
                        Tags = $parameterFileTags
                    }
                }
                if ($PSCmdlet.ShouldProcess("Subscription level deployment", "Create")) {
                    New-AzSubscriptionDeployment @DeploymentInputs -location $location
                }
                break
            }
            'managementGroup' {
                if ($PSCmdlet.ShouldProcess("Management group level deployment", "Create")) {
                    New-AzManagementGroupDeployment @DeploymentInputs -location $location -managementGroupId $managementGroupId
                }
                break
            }
            'tenant' {
                if ($PSCmdlet.ShouldProcess("Tenant level deployment", "Create")) {
                    New-AzTenantDeployment @DeploymentInputs -location $location
                }
                break
            }
            default {
                throw "[$deploymentScope] is a non-supported template scope"
            }
        }
    }
    
    end {
        Write-Debug ("{0} exited" -f $MyInvocation.MyCommand)  
    }
}