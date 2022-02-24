$inputObject = @{
    DeploymentName            = "CARML-workload-$(-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])"
    TemplateFile              = 'C:\Git\GitHub\Azure\ResourceModules\workload\deploy.bicep' # Get the path via a right-click on the template file in VSCode & select 'Copy Path'
    Location                  = 'WestEurope' # E.g. WestEurope
    Verbose                   = $true
    ResourceGroupName         = 'workload-rg' # E.g. workload-rg
    StorageAccountName        = 'sadsvet12312' # Must be globally unique
    KeyVaultName              = 'kvdsvet12312' # Must be globally unique
    LogAnalyticsWorkspaceName = 'lawdsvet12312' # E.g. carml-law
}
New-AzSubscriptionDeployment @inputObject

{"clientId": "48dbecc5-bbe5-4a52-8dd0-8c5702513133", "clientSecret": "n9dTpj84~rJ8ha8.kkORZ_3JDK2gSblqw8", "subscriptionId": "47041275-ef6a-42af-a770-ee0fb2227eec", "tenantId": "284a3525-0ec7-454c-8a03-90ed7e7a68ce" }
