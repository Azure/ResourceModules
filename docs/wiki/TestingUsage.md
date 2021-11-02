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

```powershell

# Load the PowerShell Function For Testing
. 'C:\PathToTheResourceModulesRepository\ResourceModules\utilities\tools\Test-ModuleLocally.ps1'

# REQUIRED INPUT FOR TESTING
$TestModuleLocallyInput = @{
    ModuleName       = 'Microsoft.Authorization\roleAssignments'
    PesterTest                 = $true
    DeployTest                 = $true
    ValidateOnly               = $false
    ValidateOrDeployParameters = @{
        Location          = 'westeurope' # Name of the Azure Region to deploy the module in.
        ResourceGroupName = 'resourceGroupName' # Name of the Resource Group to deploy the module in.
        SubscriptionId    = '12345678-1234-1234-abcd-1369d14d0d45' #The subscription ID used to deploy the module in & Token replacements for <<subscriptionId>>
        ManagementGroupId = 'mg-contoso' #The Management Group ID used to deploy the module in & Token replacements for <<managementGroupId>>
        PrincipalId       = '12345678-1234-1234-abcd-1369d14d0d45' # Replace <<principalId>> token to set the Role Assignments for the module
        TenantId          = '12345678-1234-1234-abcd-1369d14d0d45' # Replace <<tenantId>> token for parameters that use the TenantID as a field
        RemoveDeployment  = $false # Only Set to True if the Module Supports Tags.
    }
}

Test-ModuleLocally @TestModuleLocallyInput -verbose

```

### Handling Parameters that require or contain a value that should be tokenized

The following scenarios are common to when to use a token value in the parameter file. Refer to [Pipeline Design](PipelinesDesign.md) for more details.

- Scenarios where resources have dependencies on other resources, which may require to be linked using `resourceId` references. [Example](../../arm/Microsoft.Network/virtualNetworksResources/virtualNetworkPeerings/.parameters/parameters.json)

    ```json
    // Example
    "remoteVirtualNetworkId": {
        "value": "/subscriptions/12345678-abcd-abcd-abcd-12345678abcd/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-sxx-az-vnet-weu-x-peer01"
    }
    ```

- Scenarios where targeting different scopes within a module deployment. [Example](../../arm/Microsoft.Authorization/policyDefinitions/.parameters/parameters.json)

    ```json
    // Example
    "subscriptionId": {
      "value": "12345678-abcd-abcd-abcd-12345678abcd"
    }
    ```

- Scenarios where there is a Role Assignment being created for the module being deployed. [Example](../../arm/Microsoft.Compute/diskEncryptionSets/.parameters/parameters.json)

    ```json
     "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<principalId1>>"
                    ]
                }
            ]
        }
    ```

- Scenarios where the Azure Tenant ID is being referenced in the parameter file

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
