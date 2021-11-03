# Testing Usage

This section gives you an overview of how to test the bicep modules.

---

### _Navigation_

- [Tool: Testing your Bicep module](#tool-testing-your-bicep-module)
  - [Handling Resource IDs or Parameters that require or contain Subscription IDs](#handling-resource-ids-or-parameters-that-require-or-contain-subscription-ids)

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

### Handling Resource IDs or Parameters that require or contain Subscription IDs

- Scenarios where resources have dependencies on other resources, which may require to be linked using `resourceId` references. [Example](../../arm/Microsoft.Network/virtualNetworksResources/virtualNetworkPeerings/.parameters/parameters.json)

    ```json
    // Example
    "remoteVirtualNetworkId": {
        "value": "/subscriptions/12345678-abcd-abcd-abcd-12345678abcd/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-sxx-az-vnet-x-peer01"
    }
    ```

- Scenarios where targeting different scopes within a module deployment. [Example](../../arm/Microsoft.Authorization/policyDefinitions/.parameters/parameters.json)

    ```json
    // Example
    "subscriptionId": {
      "value": "12345678-abcd-abcd-abcd-12345678abcd"
    }
    ```

For these use cases, before committing the change and testing the module using GitHub actions, replace the subscription ID values with `<<subscriptionId>>`. This allows the pipelines to replace the string with the right subscription ID before the template is deployed to Azure.

---
**Note**: Failure to replace the subscription ID value so will result in a Pester test failure that detects if you are using a hard-coded subscription ID.

---
