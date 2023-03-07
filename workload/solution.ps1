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



az ad sp create-for-rbac --name 'token454sp' --role 'Contributor' --scopes '/subscriptions/00461249-f3ba-465e-855e-d64aac4eb75f' --output 'json'
{
    'appId': 'b3ac6846-3af4-490c-bdbb-4326ef34682e',
    'displayName': 'token454sp',
    'password': 'zvk8Q~Ru_XKl.wof0qgLOdmwFghTy9S49gC9ydAO',
    'tenant': '29208c38-8fc5-4a03-89e2-9b6e8e4b388b'
}
az role assignment create --assignee 'b3ac6846-3af4-490c-bdbb-4326ef34682e' --role 'User Access Administrator' --subscriptuion '00461249-f3ba-465e-855e-d64aac4eb75f'

# --scope argument will become required for creating a role assignment in the breaking change release of the fall of 2023. Please explicitly specify --scope.

az ad sp list --display-name 'token454sp' --query '[].id' --output tsv

# 4f22ec4b-c6f7-4f18-879a-ec78f3136323


{ 'clientId': 'b3ac6846-3af4-490c-bdbb-4326ef34682e', 'clientSecret': 'zvk8Q~Ru_XKl.wof0qgLOdmwFghTy9S49gC9ydAO', 'subscriptionId': '00461249-f3ba-465e-855e-d64aac4eb75f', 'tenantId': '29208c38-8fc5-4a03-89e2-9b6e8e4b388b' }
