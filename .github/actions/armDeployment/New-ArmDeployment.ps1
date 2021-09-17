Param (
    [string]
    [Parameter(Mandatory = $true)]
    $templateFile,
    
    [string[]]
    [Parameter(Mandatory = $true)]
    $templateParametersFile,

    [string]
    [Parameter(Mandatory = $true)]
    $location,

    [PSCustomObject]
    [Parameter(Mandatory = $false)]
    [Alias("metadata")]
    $tags,

    [string]
    [Parameter(Mandatory = $false)]
    $resourceGroupName,

    [string]
    [Parameter(Mandatory = $false)]
    $subscriptionId,

    [string]
    [Parameter(Mandatory = $false)]
    $managementGroupId
)   

Write-Verbose " Module:`n $templateFile `n Parameter File(s)/Directory: `n $templateParametersFile `n"

## Assess Provided Path
if (Test-Path -Path $templateParametersFile -PathType Container) {
    ## Transform Path to Files
    $templateParametersFile = Get-ChildItem $templateParametersFile -Recurse -Filter *.parameters.json | Select-Object -ExpandProperty FullName
    Write-Verbose "Parameter File(s)/Directory - Count: `n $($templateParametersFile.Count)`n"
}

## Iterate through each file
foreach ($file in $templateParametersFile) {
    $fileProperties = Get-Item -Path $file
    Write-Verbose "Deploying: $($fileProperties.Name) `n"
    [bool]$Stoploop = $false
    [int]$Retrycount = 0

    ## Construct a common parameter set
    $CommonDeployParameters = @{
        Name                  = $fileProperties.Name
        TemplateFile          = $templateFile
        TemplateParameterFile = $file
    }

    ## Append Tags to Parameters if Resource supports them
    if ($Tags) { $CommonDeployParameters += @{Tags = $Tags } }

    ## Attempt deployment
    do {
        try {    
            ## Deployment Scope Conditions
            $deploymentSchema = (ConvertFrom-Json (Get-Content -Raw -Path $templateFile)).'$schema'
 
            switch -Regex ($deploymentSchema) {
                # Resource Group Deployment
                '\/deploymentTemplate.json#$' {
                    Write-Verbose "Deployment Scope: resourceGroup `n"
                    Set-AzContext -SubscriptionId $subscriptionId | out-null
                    # Validate if Resource Group is available, if not.. create it
                    if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)) {
                        Write-Verbose "Resource Group <$resourceGroupName> does not exist.. Creating at location <$location> `n"
                        New-AzResourceGroup -Name $resourceGroupName -Location $location -ErrorAction Stop | Out-Null     
                    }
                    New-AzResourceGroupDeployment @CommonDeployParameters `
                        -ResourceGroupName $resourceGroupName `
                }
                # Subscription Deployment
                '\/subscriptionDeploymentTemplate.json#$' {
                    Write-Verbose "Deployment Scope: subscription. `n"
                    Set-AzContext -SubscriptionId $subscriptionId | out-null
                    New-AzDeployment @CommonDeployParameters `
                        -Location $location
                }
                # Management Group Deployment
                '\/managementGroupDeploymentTemplate.json#$' {
                    Write-Verbose "Deployment Scope: managementGroup. `n"
                    New-AzManagementGroupDeployment @CommonDeployParameters `
                        -Location $location `
                        -ManagementGroupId $ManagementGroupId
                }
                # Tenant Deployment
                '\/tenantDeploymentTemplate.json#$' {
                    Write-Verbose "Deployment Scope: tenant. `n"
                    New-AzTenantDeployment @CommonDeployParameters `
                        -Location $location `
                }
                Default {
                    throw "[$deploymentSchema] is a non-supported schema"
                    $Stoploop = $true
                }
            }     
            $Stoploop = $true
        }
        catch {
            if ($Retrycount -gt 1) {
                throw $PSitem.Exception.Message
                $Stoploop = $true
            }
            else {
                Write-Verbose "Resource deployment Failed.. ($Retrycount/1) Retrying in 5 Seconds.. `n"
                Start-Sleep -Seconds 5
                $Retrycount = $Retrycount + 1
            }
        }
    } #end do
    While ($Stoploop -eq $false) 
} #end for each file 
