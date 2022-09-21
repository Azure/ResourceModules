<#
.DESCRIPTION
    This PowerShell script clones an Azure DevOps Repository, retrieves all the Markdown files, changes the references to images according to the GitHub convention
    and pushes these changes to the 'master' branch in the Github Repository.

.PARAMETER AzureDevOpsRepositoryName
    The name of the Azure DevOps Repository.

.PARAMETER AzureDevOpsRepositoryHomePageName
    The name of the home page of the Azure DevOps Repository.

.PARAMETER GitHubRepositoryURL
    The URL of the GitHub Repository.

.EXAMPLE
    $parameters = @{
        AzureDevOpsRepositoryName = "wiki"
        AzureDevOpsRepositoryHomePageName = "Welcome"
        GitHubRepositoryURL = "https://github.com/isd-product-innovation/azure-landing-zone-platform.wiki.git"
        GitHubRepositoryName = "azure-landing-zone-platform"
    }

    .\Complete-WikiMigration.ps1 @parameters
#>

#Write-Output 'Subscription + RG + DeploymentName +  Hash)'

[CmdletBinding()]
Param (
    [Parameter(Mandatory = $true)]
    [String] $resourceGroup,

    [Parameter(Mandatory = $true)]
    [String] $storageAccount,

    [Parameter(Mandatory = $true)]
    [String] $storageSubscriptionId
)

Import-Module -Name ./module-tracker.psm1

#region Create the Storage Table
Select-AzSubscription -SubscriptionId $storageSubscriptionId
$tableObject = New-StorageAccountTable -StorageAccountName $storageAccount -ResourceGroup $resourceGroup -TableName 'AzureDeployments'
#endregion

#region Getting all Tenant deployments
$StartTime = $(Get-Date)

$processedDeployments = 0
try {
    $azDeployments = Get-AzTenantDeployment

    foreach ($deployment in $azDeployments) {
        Save-AzDeploymentTemplate -DeploymentName $deployment.DeploymentName -Force | Out-Null
        $hash = Get-TemplateHash -TemplatePath "./$($deployment.DeploymentName).json"
        New-StorageAccountTableRow -Table $tableObject -PartitionKey $deployment.Id -DeploymentName $deployment.deploymentName -Hash $hash
        Remove-Item "./$($deployment.DeploymentName).json"
        $processedDeployments++
    }
} catch {
    Write-Output "Error: $($_.Exception.Message)"
    continue
}
$elapsedTime = $(Get-Date) - $StartTime
$totalTime = '{0:HH:mm:ss}' -f ([datetime]$elapsedTime.Ticks)

Write-Output 'Processed Tenant deployments: ' + $processedDeployments 'Time spent '+$totalTime ''
#endregion

#region Getting all Subscriptions deployments
$StartTime = $(Get-Date)
$subscriptions = Get-AzSubscription
$tableRows = @()

foreach ($sub in $subscriptions) {
    Select-AzSubscription -Subscription $sub.name

    $processedDeployments = 0
    try {
        $azDeployments = Get-AzDeployment

        foreach ($deployment in $azDeployments) {
            Save-AzDeploymentTemplate -DeploymentName $deployment.DeploymentName -Force | Out-Null
            $hash = Get-TemplateHash -TemplatePath "./$($deployment.DeploymentName).json"
            $tableRows += [PSCustomObject]@{
                deploymentName = $deployment.DeploymentName
                deploymentId   = $deployment.Id
                hash           = $hash
            }
            Remove-Item "./$($deployment.DeploymentName).json"
            $processedDeployments++
        }
    } catch {
        Write-Output "Error: $($_.Exception.Message)"
        continue
    }
}
Select-AzSubscription -SubscriptionId $storageSubscriptionId
foreach ($row in $tableRows) {
    New-StorageAccountTableRow -Table $tableObject -PartitionKey $row.deploymentId -DeploymentName $row.deploymentName -Hash $row.hash
}
$elapsedTime = $(Get-Date) - $StartTime
$totalTime = '{0:HH:mm:ss}' -f ([datetime]$elapsedTime.Ticks)

Write-Output 'Processed Subscriptions deployments: ' + $processedDeployments 'Time spent '+$totalTime ''
#endregion

#region Getting all Resource Group deployments per each Subscription
$StartTime = $(Get-Date)
$tableRows = @()

foreach ($sub in $subscriptions) {
    Select-AzSubscription -Subscription $sub.name
    $resourceGroups = Get-AzResourceGroup

    $processedDeployments = 0
    foreach ($rg in $resourceGroups) {
        try {
            $azDeployments = Get-AzResourceGroupDeployment

            foreach ($deployment in $azDeployments) {
                #exporting the deployment template object
                Save-AzDeploymentTemplate -DeploymentName $deployment.DeploymentName -Force | Out-Null
                #Generating hash value
                $hash = Get-TemplateHash -TemplatePath "./$($deployment.DeploymentName).json"
                #Adding results to object
                $tableRows += [PSCustomObject]@{
                    deploymentName = $deployment.DeploymentName
                    deploymentId   = $rg
                    hash           = $hash
                }
                #Removing temporal json file
                Remove-Item "./$($deployment.DeploymentName).json"
                $processedDeployments++
            }
        } catch {
            Write-Output "Error: $($_.Exception.Message)"
            continue
        }
    }
}

Select-AzSubscription -SubscriptionId $storageSubscriptionId
foreach ($row in $tableRows) {
    New-StorageAccountTableRow -Table $tableObject -PartitionKey $row.deploymentId -DeploymentName $row.deploymentName -Hash $row.hash
}
$elapsedTime = $(Get-Date) - $StartTime
$totalTime = '{0:HH:mm:ss}' -f ([datetime]$elapsedTime.Ticks)

Write-Output 'Processed Resource Group deployments: ' + $processedDeployments 'Time spent '+$totalTime ''
#endregion
