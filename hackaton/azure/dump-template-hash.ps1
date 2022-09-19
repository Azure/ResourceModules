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


$storageAccount = ' '
$resourceGroup = ' '


Function CreateStg ($storageAccount, $content) {
    $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
    $ctx = $storageAccount.Context
    $partitionKey = 'Commits'
    New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
    $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable
}

Function UploadToStg ($storageAccount, $content) {
    Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey $_.commitId -property $commit -UpdateExisting | Out-Null
}


##Create Storage Account table
# $storageAccount = Get-AzStorageAccount -Name $env:storageAccount -ResourceGroupName $env:resourceGroup
# $ctx = $storageAccount.Context
# $partitionKey = 'Commits'
# New-AzStorageTable -Name $partitionKey -Context $ctx -ErrorAction SilentlyContinue | Out-Null
# $table = (Get-AzStorageTable –Name $partitionKey –Context $ctx).CloudTable


$subscriptions = Get-AzSubscription

$StartTime = $(Get-Date)

foreach ($sub in $subscriptions) {
    Select-AzSubscription -Subscription $sub.name

    #Region: Get the current Azure Deployments.
    $processedDeployments = 0
    try {
        $azDeployments = Get-AzDeployment

        foreach ($deployment in $azDeployments) {
            #Write-Output 'Processing: ' $deployment.DeploymentName
            Save-AzDeploymentTemplate -DeploymentName $deployment.DeploymentName -Force | Out-Null
            (Get-FileHash -Path "./$($deployment.DeploymentName).json" -Algorithm SHA256).Hash | Out-Null # invoke Function
            Remove-Item "./$($deployment.DeploymentName).json"
            $processedDeployments++
        }
    } catch {
        Write-Output "Error: $($_.Exception.Message)"
        continue
    }
}

$elapsedTime = $(Get-Date) - $StartTime
$totalTime = '{0:HH:mm:ss}' -f ([datetime]$elapsedTime.Ticks)

Write-Output 'Processed deployments: ' + $processedDeployments 'Time spent '+$totalTime ''
