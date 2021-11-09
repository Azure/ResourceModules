# Testing Usage

This section gives you an overview of how to test the bicep modules.

---

### _Navigation_

- [Testing Usage](#testing-usage)
    - [_Navigation_](#navigation)
  - [Tool: Testing your Bicep module](#tool-testing-your-bicep-module)
  - [Tool: Use The Test-ModuleLocally Script To Perform Pester Testing, Token Replacement and Deployment of the Module.](#tool-use-the-test-modulelocally-script-to-perform-pester-testing-token-replacement-and-deployment-of-the-module)
    - [Handling Parameters that require or contain a value that should be tokenized](#handling-parameters-that-require-or-contain-a-value-that-should-be-tokenized)

---

## Tool: Testing your Bicep module

When you have done your changes and want to validate, run the following:

```pwsh
Invoke-Pester -Configuration @{
    Run        = @{
        Container = New-PesterContainer -Path 'arm/.global/global.module.tests.ps1' -Data @{
            moduleFolderPaths = "C:\dev\ip\Azure-ResourceModules\ResourceModules\arm\Microsoft.EventGrid/topics"
        }
    }
    Filter     = @{
        #ExcludeTag = 'ApiCheck'
        #Tag = 'ApiCheck'
    }
    TestResult = @{
        TestSuiteName = 'Global Module Tests'
        Enabled       = $false
    }
    Output     = @{
        Verbosity = 'Detailed'
    }
}
```

## Tool: Use The Test-ModuleLocally Script To Perform Pester Testing, Token Replacement and Deployment of the Module.

The below example can be used on your local environment to load the 'Test-ModuleLocally.ps1' script and modify the required parameters as below to enable you to perform the tests locally before pushing to source control.

```powershell
#########[ Function Test-ModulesLocally.ps1 ]#############

. 'C:\Users\ahmadabdalla\github\ahmadabdalla\ResourceModules\utilities\tools\Test-ModuleLocally.ps1'

#########[ Function Test-ModulesLocally.ps1 ]#############

. 'C:\Users\ahmadabdalla\github\ahmadabdalla\ResourceModules\utilities\tools\Test-ModuleLocally.ps1'

# REQUIRED INPUT FOR TESTING
$TestModuleLocallyInput = @{
    ModuleName                    = 'Microsoft.Network\applicationSecurityGroups'
    PesterTest                    = $true
    DeploymentTest                = $true
    ValidationTest                = $false
    ValidateOrDeployParameters    = @{
        Location          = 'australiaeast'
        ResourceGroupName = 'validation-rg'
        SubscriptionId    = '12345678-1234-1234-1234-123456789123'
        ManagementGroupId = 'mg-contoso'
        RemoveDeployment  = $false
    }
    DeployAllModuleParameterFiles = $false
    GetParameterFileTokens        = $true
    #TokenKeyVaultName             = 'contoso-platform-kv'
    OtherCustomParameterFileTokens      = @(
        @{ Name = 'deploymentSpId'; Value = '12345678-1234-1234-1234-123456789123' }
        @{ Name = 'tenantId'; Value = '12345678-1234-1234-1234-123456789123' }
    )
}

```

### Handling Parameters that require or contain a value that should be tokenized

The following scenarios are common to when to use a token value in the parameter file. Refer to [Pipeline Design](./ParameterFileTokens.md) for more details.

- Scenarios where resources have dependencies on other resources, which may require to be linked using `resourceId` references. [Example](../../arm/Microsoft.Network/virtualNetworksResources/virtualNetworkPeerings/.parameters/parameters.json)

    ```json
    // Example
    "remoteVirtualNetworkId": {
        "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-sxx-az-vnet-x-peer01"
    }
    ```

- Scenarios where targeting different scopes within a module deployment. [Example](../../arm/Microsoft.Authorization/policyDefinitions/.parameters/parameters.json)

    ```json
    // Example
    "subscriptionId": {
      "value": "<<subscriptionId>>"
    }
    ```

- Scenarios where there is a Role Assignment being created for the module being deployed. [Example](../../arm/Microsoft.Compute/diskEncryptionSets/.parameters/parameters.json)

    ```json
     "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        }
    ```

- Scenarios where A management Group ID is being referenced in the parameter file. [Example](../../arm/Microsoft.Management/managementGroups/.parameters/parameters.json)

    ```json
        "parentId": {
            "value": "<<managementGroupId>."
        }

    ```

For these use cases, before committing the change and testing the module using GitHub actions, replace the original value with the token value like `<<subscriptionId>>`. This allows the pipelines to replace the string with the original value before the template is deployed to Azure.

---
**Note**: There are pester tests that target the use of tokens in parameter files where it detects certain keywords (i.e. /subscriptions/, 'subscriptionId', 'principalId'). Hence ensure you tokenize these values to ensure these tests are successful.

---
