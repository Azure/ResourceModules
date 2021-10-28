# Testing Design

This section gives you an overview of the design principals the testing follows.

---
### _Navigation_

- [Module Dependencies](#Module-Dependencies)

---

## Approach

To ensure a baseline module code quality across all the modules, modules are validated before publishing them.

This is achieved by executing three "tasks":

- general static code module validation
- module API version validation
- actual deployment of the module

### Static code validation

All Module Unit tests are performed with the help of Pester and are required to have consistent, clean and syntactically correct tests to ensure successful deployments.

The following activities are run by `.github/actions/templates/validateModuleGeneral/action.yml` executing the `arm/.global/global.module.tests.ps1` script.

- Module folder completeness. e.g.:
  - reame.md mus exists
  - template file (either deploy.json or deploy.bicep) exists
- Template File Syntax and aligned with convention. e.g.
  - template file (or the built bicep template) converts from JSON and has all expected properties
  - variable names are camelCase
- Module (readme.md) documentation. e.g.:
  - is not empty
  - contains all the mandatory sections
  - describes all the parameters
- Test Parameter Files. e.g.:
  - at least one *parameters.json should exist
  - files should be valid JSON

### Additional resources

- [Pester Wiki](https://github.com/pester/Pester/wiki)
- [Pester on GitHub](https://github.com/pester/Pester)
- [Pester Setup and Commands](https://pester.dev/docs/commands/Setup)

### API validation

In this phase, the workflow will verify if the module is one of the latest 5 api version using `.github/actions/templates/validateModuleApis/action.yml` executing the `arm/.global/global.module.tests.ps1` script.

### Deployment validation

In this phase, the module is actually used in the sandbox environment to verify it can succesfully be deployed.

This happens using the `.github/actions/templates/validateModuleDeploy/action.yml` pipeline and the `.github/actions/templates/validateModuleDeploy/scripts/Test-TemplateWithParameterFile.ps1` script.

> **Note**<br>
Currently the list of the parameter file used to test the module is hardcoded in the module specific workflow, as the **parameterFilePaths** in the _job_deploy_module_ and _job_tests_module_deploy_validate_ jobs.

#### Module Dependencies

In order to successfully deploy and test all Modules in your desired environment some Modules have to have resources deployed beforehand.

Here is the full list of Modules which have dependencies on other Services.

> **Note**<br>
If we speak from **Modules** in this context we mean the **Services** which get created from these Modules.

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
- WvdApplicationGroups
  - WvdHostPool
- WvdApplications
  - WvdAppliccationGroups

#### Services (in order)

Provided the dependencies listed above, the following list of services need to be deployed to be able to test all the modules:

1. VirtualNetwork
1. StorageAccounts
1. KeyVault
1. LogAnalytics
1. PublicIPPrefix
1. PublicIPAddresses
1. EventHubNamespaces
1. EventHubs (only needed if EventHubs are used for Monitoring in addition to LogAnalytics)
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

#### Required Secrets and Keys

The following secrets and keys needs to be created:

1. KeyVault secrets
   - administratorLogin for AzureSQLServer
   - administratorLoginPassword for AzureSQLServer
   - encryptionKey for DiskEncryptionSet
   - adminUserName for VirtualMachine
   - adminPassword for VirtualMachine
1. DiskEncryptionSet needs key pre-created (encryptionKey)
1. SQLManagedInstance needs key pre-created (encryptionKeySqlMi)
   - administratorLogin
   - administratorLoginPassword
