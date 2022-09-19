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


$StartTime = $(Get-Date)

$processedDeployments = 0

#Region: Get the current Azure Deployments.
$azDeployments = Get-AzDeployment
foreach ($deployment in $azDeployments) {
    Write-Output 'Processing: ' $deployment.DeploymentName
    Save-AzDeploymentTemplate -DeploymentName $deployment.DeploymentName -Force | Out-Null
    (Get-FileHash -Path "./$($deployment.DeploymentName).json" -Algorithm SHA256).Hash
    Remove-Item "./$($deployment.DeploymentName).json"
    $processedDeployments++
}

$elapsedTime = $(Get-Date) - $StartTime
$totalTime = '{0:HH:mm:ss}' -f ([datetime]$elapsedTime.Ticks)

Write-Output 'Processed deployments: ' $processedDeployments 'in ' $totalTime
