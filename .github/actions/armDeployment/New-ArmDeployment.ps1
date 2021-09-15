Param (
    [string]
    [Parameter(Mandatory = $true)]
    [ValidateSet("resourceGroup", "subscription", "managementGroup")]
    $scope,

    [string]
    [Parameter(Mandatory = $true)]
    $templateFile,
    
    [string[]]
    [Parameter(Mandatory = $true)]
    $templateParametersFile,

    [PSCustomObject]
    [Parameter(Mandatory = $false)]
    [Alias("metadata")]
    $tags,

    [string]
    [Parameter(Mandatory = $false, ParameterSetName = 'RG')]
    $resourceGroupName,

    [string]
    [Parameter(Mandatory = $false, ParameterSetName = 'SB')]
    [Parameter(ParameterSetName = 'MG')]
    $location,

    [string]
    [Parameter(Mandatory = $false, ParameterSetName = 'RG')]
    [Parameter(ParameterSetName = 'SB')]
    $subscriptionId,

    [string]
    [Parameter(Mandatory = $false, ParameterSetName = 'MG')]
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
            Write-Verbose "Deployment Scope: $Scope `n"
            switch ($scope) {
                resourceGroup {
                    Set-AzContext -SubscriptionId $subscriptionId | out-null
                    New-AzResourceGroupDeployment @CommonDeployParameters `
                        -ResourceGroupName $resourceGroupName 
                }
                subscription {
                    Set-AzContext -SubscriptionId $subscriptionId | out-null
                    New-AzDeployment @CommonDeployParameters `
                        -Location $location
                }
                managementGroup {
                    New-AzManagementGroupDeployment @CommonDeployParameters `
                        -Location $location `
                        -ManagementGroupId $ManagementGroupId
                }
                Default {
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
