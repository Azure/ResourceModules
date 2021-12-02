# Testing Usage

This section gives you an overview of how to test the bicep modules.

---

### _Navigation_

- [Tool: Testing your Bicep module](#tool-testing-your-bicep-module)
- [Tool: Use The Test-ModuleLocally Script To Perform Pester Testing, Token Replacement and Deployment of the Module.](#tool-use-the-test-modulelocally-script-to-perform-pester-testing-token-replacement-and-deployment-of-the-module)
- [Handling Parameters that require or contain a value that should be tokenized](#handling-parameters-that-require-or-contain-a-value-that-should-be-tokenized)

---

# Tool: Testing your Bicep module

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

---

# Tool: Use The Test-ModuleLocally Script To Perform Pester Testing, Token Replacement and Deployment of the Module.

The below example can be used on your local environment to load the 'Test-ModuleLocally.ps1' script and modify the required parameters as below to enable you to perform the tests locally before pushing to source control.

```powershell
#########[ Function Test-ModulesLocally.ps1 ]#############
$pathToRepository = '<pathToClonedRepo>'
. "$pathToRepository\utilities\tools\Test-ModuleLocally.ps1"

# REQUIRED INPUT FOR TESTING
$TestModuleLocallyInput = @{
    templateFilePath              = "$pathToRepository\arm\Microsoft.Authorization\roleDefinitions\deploy.bicep"
    PesterTest                    = $true
    DeploymentTest                = $true
    ValidationTest                = $false
    ValidateOrDeployParameters    = @{
        Location          = 'australiaeast'
        ResourceGroupName = 'validation-rg'
        SubscriptionId    = '12345678-1234-1234-1234-123456789123'
        ManagementGroupId = 'mg-contoso'
    }
    AdditionalTokens      = @(
        @{ Name = 'deploymentSpId'; Value = '12345678-1234-1234-1234-123456789123' }
        @{ Name = 'tenantId'; Value = '12345678-1234-1234-1234-123456789123' }
    )
}
```

> You can use the `Get-Help` cmdlet to show more options on how you can use this script.

---

## Handling Parameters that require or contain a value that should be tokenized

The following scenarios are common to when to use a token value in the parameter file. Refer to [Parameter File Tokens Design](./ParameterFileTokens) for more details.

- Scenarios where resources have dependencies on other resources, which may require to be linked using `resourceId` references.

    ```json
    "remoteVirtualNetworkId": {
        "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-sxx-az-vnet-x-peer01"
    }
    ```

- Scenarios where targeting different scopes within a module deployment.

    ```json
    "subscriptionId": {
      "value": "<<subscriptionId>>" //Default Token
    }
    ```

- Scenarios where there is a Role Assignment being created for the module being deployed.

    ```json
     "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>" //Default Token
                    ]
                }
            ]
        }
    ```

- Scenarios where A management Group ID is being referenced in the parameter file.

    ```json
        "parentId": {
            "value": "<<managementGroupId>>"
        }

    ```

---
**Note**: There are pester tests that target the use of tokens in parameter files where it detects certain keywords (i.e. /subscriptions/, 'subscriptionId'). Hence ensure you tokenize these values to ensure these tests are successful.

---
