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

[CmdletBinding()]
Param (
    [Parameter(Mandatory = $true)]
    [String] $AzureDevOpsRepositoryName,

    [Parameter(Mandatory = $true)]
    [String] $AzureDevOpsRepositoryHomePageName,

    [Parameter(Mandatory = $true)]
    [String] $GitHubRepositoryURL,

    [Parameter(Mandatory = $true)]
    [String] $GitHubPAT,

    [Parameter(Mandatory = $true)]
    [String] $GitHubRepositoryName
)

#Region: Get the current Azure Deployments.
$azDeployments = Get-AzDeployment
foreach ($deployment in $azDeployments.DeploymentName) {
    ((Save-AzDeploymentTemplate -DeploymentName $deployment -Force) | Get-FileHash -Algorithm SHA256) | Select-Object -Property Hash
}
