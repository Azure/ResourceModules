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
Mandatory. Path to the parameter file from root. Can be a single file, multiple files, or directory that conains (.json) files.

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

.PARAMETER additionalTags
Optional. Provde a Key Value Pair (Object) that will be appended to the Parameter file tags. Example: @{myKey = 'myValue',myKey2 = 'myValue2'}.

.PARAMETER retryLimit
Optional. Maximum retry limit if the deployment fails. Default is 3.

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
        [string[]] $parameterFilePath,

        [Parameter(Mandatory)]
        [string] $location,

        [Parameter(Mandatory = $false)]
        [string] $resourceGroupName,

        [Parameter(Mandatory = $false)]       
        [string] $subscriptionId,

        [Parameter(Mandatory = $false)]       
        [string] $managementGroupId,

        [Parameter(Mandatory = $false)]       
        [bool] $removeDeployment,

        [Parameter(Mandatory = $false)]       
        [PSCustomObject]$additionalTags,

        [Parameter(Mandatory = $false)]       
        [int]$retryLimit = 3
    )
    
    begin {
        Write-Debug ("{0} entered" -f $MyInvocation.MyCommand) 
    }
    
    process {

        ## Assess Provided Parameter Path 
        if ((Test-Path -Path $parameterFilePath -PathType Container) -and $parameterFilePath.Length -eq 1) {
            ## Transform Path to Files
            $parameterFilePath = Get-ChildItem $parameterFilePath -Recurse -Filter *.json | Select-Object -ExpandProperty FullName
            Write-Verbose "Detected Parameter File(s)/Directory - Count: `n $($parameterFilePath.Count)"
        }

        ## Iterate through each file
        foreach ($parameterFile in $parameterFilePath) {
            $fileProperties = Get-Item -Path $parameterFile
            Write-Verbose "Deploying: $($fileProperties.Name)"
            [bool]$Stoploop = $false
            [int]$retryCount = 1

            $DeploymentInputs = @{
                Name                  = "$moduleName-$(-join (Get-Date -Format yyyyMMddTHHMMssffffZ)[0..63])"
                TemplateFile          = $templateFilePath
                TemplateParameterFile = $parameterFile
                Verbose               = $true
                ErrorAction           = 'Stop'
            }

            ## Append Tags to Parameters if Resource supports them
            $parameterFileTags = (ConvertFrom-Json (Get-Content -Raw -Path $parameterFile) -AsHashtable).parameters.tags.value            
            if (-not $parameterFileTags) { $parameterFileTags = @{} }
            if ($additionalTags) { $parameterFileTags += $additionalTags } # If additionalTags object is provided, append tag to the resource
            if ($removeDeployment) { $parameterFileTags += @{removeModule = $moduleName } } # If removeDeployment is set to true, append removeMoule tag to the resource
            if ($removeDeployment -or $additionalTags) { 
                # Overwrites parameter file tags parameter
                Write-Verbose ("removeDeployment for $moduleName= $removeDeployment `nadditionalTags:`n $($additionalTags | ConvertTo-Json)")
                $DeploymentInputs += @{Tags = $parameterFileTags } 
            }

            #######################
            ## INVOKE DEPLOYMENT ##
            #######################
            do {
                try {
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
                            $Stoploop = $true
                        }
                    }
                    $Stoploop = $true
                } #end try
                catch {
                    if ($retryCount -gt $retryLimit) {
                        throw $PSitem.Exception.Message
                        $Stoploop = $true
                    }
                    else {
                        Write-Verbose "Resource deployment Failed.. ($retryCount/$retryLimit) Retrying in 5 Seconds.. `n"
                        Start-Sleep -Seconds 5
                        $retryCount++
                    }
                } #end catch
            } #end do
            while ($Stoploop -eq $false -or $retryCount -eq $retryLimit) { 
            } #end while
        } #end foreach parameter file
    } #end process

    end {
        Write-Debug ("{0} exited" -f $MyInvocation.MyCommand)  
    }
}