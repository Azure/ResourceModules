$TestModuleLocallyInput = @{
    TemplateFilePath           = '.\modules\Microsoft.Compute\virtualMachines\deploy.bicep'
    PesterTest                 = $true
    DeploymentTest             = $true
    ValidationTest             = $true
    ValidateOrDeployParameters = @{
        Location          = 'australiaeast'
        ResourceGroupName = 'rg-internalvalidationrg'
        SubscriptionId    = '0875dd37-7547-4e1d-9543-fee6ed24ff8a'
        RemoveDeployment  = $false
    }

}

.\utilities\tools\Test-ModuleLocally.ps1 @TestModuleLocallyInput -Verbose

Test-ModuleLocally @TestModuleLocallyInput

