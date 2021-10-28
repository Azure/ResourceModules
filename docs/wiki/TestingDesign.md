# Testing Design

This section gives you an overview of the design principals the testing follows.

---
### _Navigation_
- [Design Overview](#Design-Overview)
  - [Unit Tests](#unit-tests)
  - [Template Validation Tests](#template-validation-tests)
  - [Template Deployment Tests](#template-deployment-tests)
- [Module Dependencies](#Module-Dependencies)
---


## Design Overview  Approach

Our lifecycle management & testing framework runs 3 types of tests on all its modules:
- Pester-driven Unit Tests
- Template Validation Tests
- Template Deployment Tests
All tests are executed as part of the individual module pipelines, run each time any module code was altered, and ensure that only modules that pass each test successfully are published. If a test fails, it tells you in the pipeline log exactly what went wrong and in most cases gives you recommendations what to do to resolve the problem.

The general idea is that you should fail as early as possible to allow for minimal wasted time and a fast response time.

> ***Note:*** Both the Template Validation and Template Deployment tests are only as good as there parameter files. Hence you should make sure that you test at least a minimum set of parameters and a maximum set of parameters. Furthermore it may make sense to have different parameter files for different scenarios to test each variant.

### Unit Tests
Our Unit Tests are configured in the `global.module.tests.ps1` script and execute static tests across several different area to ensure that our modules are configured correctly, documentation is up to date, and modules don't turn stale.
We can categorize these tests into a few different categories:

- **File & folder tests:** These tests validate that the module folder structure is set up in the intended way. For example, we test that each module should contain a parameters folder with at least on parameter file in it that follows a specific naming convention.
- **ReadMe tests:** These tests ensure that a module's readme contains all required sections, that for example the documented parameters match the ones in the template, and that a consistent format is applied.
- **Deployment template tests:** These tests check the template's structure and elements for errors as well as consistency matters. For example, we test that names are set up in a certain way, that if specific resources are contained in the template that they are set up in the format we want them in, and for example that a minimum set of outputs are always returned.
- **Api version tests:** These tests make sure that the API versions applied to resources are somewhat recent. For example, the test may check that an applied API version should not be older than the five latest (non-preview) versions.

### Template Validation Tests
The template validation tests execute a dry-run with each parameter file provided & configured for a module. For example, if you have two parameter files for a module, one with the minimum set of parameters, one with the maximum, the tests will run an `Test-AzDeployment` (_- the command may vary based on the template schema_) with each of the two parameter files to see if the template would be able to be deployed with them. This test could fail either because the template is invalid, or because any of the parameter files is configured incorrectly.

### Template Deployment Tests
If all other tests passed, the deployment tests are the ultimate module validation. Using the available & configured parameter files for a module, each is deployed to Azure (in parallel) and verifies if the deployment works end to end.

By default, any test-deployed module is removed after the test. However, you can also disable this mechanic in case you want to investigate the deployed resource yourself. For further details, please refer to the (.\PipelinesUsage.md) section.

## Module Dependencies
In order to successfully deploy and test all modules in your desired environment some modules have to have resources deployed beforehand.

Of course it is obvious and by default one should know which Azure Service needs specific resources to be deployed beforehand but here is the full list of modules which have dependencies on other Services.

> **Note**<br>
If we speak from **modules** in this context we mean the **Services** which get created from these modules.

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
1. AvdHostPool
1. AvdAppliccationGroups
1. Managed Service Identity
1. Deployment Scripts

#### Overview of modules dependencies

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
- AvdApplicationGroups
  - AvdHostPool
- AvdApplications
  - AvdAppliccationGroups

#### Required Secrets and Keys

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
