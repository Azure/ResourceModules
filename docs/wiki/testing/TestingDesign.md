### Testing your Bicep module

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


## Module Dependencies
In order to successfully deploy and test all Modules in your desired environment some Modules have to have resources deployed beforehand.

Of course it is obvious and by default one should know which Azure Service needs specific resources to be deployed beforehand but here is the full list of Modules which have dependencies on other Services.

> **Note**<br>
If we speak from **Modules** in this context we mean the **Services** which get created from these Modules.

### Services (in order)
1. VirtualNetwork
1. StorageAccounts
1. KeyVault
1. LogAnalytics
1. PublicIPPrefix
1. PublicIPAddresses
1. EventHubNamespaces
1. EventHubs (only needed if EventHubs are used for Monitoring in addition to LAs)
1. ActionGroup
1. AzureSqlServer
1. AppServicePlan
1. SharedImageGallery
1. ApplicationSecurityGroups
1. NetworkSecurityGroups
1. WvdHostPool
1. WvdAppliccationGroups
1. Managed Service Identity
1. Deployment Scripts

## Modules with Dependencies

- ActivityLog
  - ActionGroup
- ActivityLogAlert
  - ActionGroup
- AzureBastion
  - VirtualNetwork / AzureBastionSubnet
- AzureFirewall
  - VirtualNetwork / AzureFirewallSubnet
- AzureNetAppFiles
  - VirtualNetwork / NetApp enabled subnet
- AzureSecurityCenter
  - LogAnalyticsWorkspace
- AzureSqlDatabase
  - AzureSqlServer
- DiskEncryptionSet
  - KeyVault / Key (encryptionKey)
- Deployment Scripts
  - Managed Service Identity
- EventHubs
  - EventHubNamespaces
- FunctionApp
  - AppServicePlan
- ImageTemplates
  - SharedImageGallery
- LoadBalancer
  - PublicIPAddresses
- MetricAlert
  - ActionGroup
  - VirtualMachines
- NetworkSecurityGroups
  - ApplicationSecurityGroups
- NSGFlowLogs
  - NetworkWatcher (needs to reside in same RG)
  - NetworkSecurityGroups
  - StorageAccount (Diagnostics)
- SQLManagedInstances
  - VirtualNetwork / Subnet
  - KeyVault / Key
  - StorageAccount / vulnerabilityAssessmentsStorageAccountId
- SQLManagedInstancesDatabases
  - SQLManagedInstances
- VirtualMachines
  - VirtualNetwork / Subnet
  - KeyVault / Secrets (admiUsername, adminPassword)
- VirtualMachineScaleSet
  - VirtualNetwork / Subnet
  - KeyVault / Secrets (admiUsername, adminPassword)
- VirtualNetworkGateway
  - PublicIPPrefix
  - VirtualNetwork (in the same rg, like AFW)
- VirtualNetworkGatewayConnection
  - KeyVault / Secret (vpnSharedKey)
- WebApp
  - AppServicePlan
- WvdApplicationGroups
  - WvdHostPool
- WvdApplications
  - WvdAppliccationGroups

## Secrets and Keys

1. KeyVault needs secrets to be created
   - administratorLogin for AzureSQLServer
   - administratorLoginPassword for AzureSQLServer
   - encryptionKey for DiskEncryptionSet
   - adminUserName for VirtualMachine
   - adminPassword for VirtualMachine
1. DiskEncryptionSet needs key pre-created (encryptionKey)
1. SQLManagedInstance needs key pre-created (encryptionKeySqlMi)
   - administratorLogin
   - administratorLoginPassword

