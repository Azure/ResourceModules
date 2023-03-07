Connect-AzAccount
# Set-AzContext.
# To override which subscription Connect-AzAccount selects by default,
# or use Update-AzConfig -DefaultSubscriptionForLogin 00000000-0000-0000-0000-000000000000
$inputObject = @{
    DeploymentName            = "workload-$(-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])"
    TemplateFile              = '/Users/andrzej_kietler/git_IaC/ResourceModules/workload/deploy.bicep' # Get the path via a right-click on the template file in VSCode & select 'Copy Path'
    Location                  = 'eastus2' # E.g. WestEurope
    Verbose                   = $true
    resourceGroupName         = 'akietler-workload-rg' # E.g. workload-rg
    storageAccountName        = 'akietlertestsa' # Must be globally unique
    keyVaultName              = 'akietlertestkv' # Must be globally unique
    logAnalyticsWorkspaceName = 'akietlertestlaw' # E.g. carml-law
}
New-AzSubscriptionDeployment @inputObject

