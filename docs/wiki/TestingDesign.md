# Testing Design

This section gives you an overview of the design principals the testing follows.

---

### _Navigation_

- [Approach](#approach)
- [Static code validation](#static-code-validation)
- [API version validation](#api-version-validation)
- [Template validation](#template-validation)
- [Deployment validation](#deployment-validation)
  - [Module dependencies](#module-dependencies)
    - [Overview of modules dependencies](#overview-of-modules-dependencies)
    - [Services (in order)](#services-in-order)
    - [Required secrets and keys](#required-secrets-and-keys)

---

## Approach

To ensure a baseline module code quality across all the modules, modules are validated before publishing them.

All tests are executed as part of the individual module pipelines, run each time any module code was altered, and ensure that only modules that pass each test successfully are published. If a test fails, it tells you in the pipeline log exactly what went wrong and in most cases gives you recommendations what to do to resolve the problem.

The general idea is that you should fail as early as possible to allow for minimal wasted time and a fast response time.

> ***Note:*** Both the Template Validation and Template Deployment tests are only as good as their parameter files. Hence you should make sure that you test at least a minimum set of parameters and a maximum set of parameters. Furthermore it makes sense to have different parameter files for different scenarios to test each variant.

Tests falls into four categories:

- Static code validation
- API version validation
- Template Validation with parameter file(s)
- Template Deployment with parameter file(s)

## Static code validation

All Module Unit tests are performed with the help of [Pester](https://github.com/pester/Pester) and are required to have consistent, clean and syntactically correct tests to ensure that our modules are configured correctly, documentation is up to date, and modules don't turn stale.

The following activities are run executing the `arm/.global/global.module.tests.ps1` script.

- **File & folder tests** validate that the module folder structure is set up in the intended way. e.g.:
  - reame.md must exists
  - template file (either deploy.json or deploy.bicep) exists
  - compliance with file naming convention
- **Deployment template tests** check the template's structure and elements for errors as well as consistency matters. e.g.
  - template file (or the built bicep template) converts from JSON and has all expected properties
  - variable names are camelCase
  - the minimum set of outputs are returned
- **Module (readme.md) documentation** contains all required sections. e.g.:
  - is not empty
  - contains all the mandatory sections
  - describes all the parameters
- **Parameter Files**. e.g.:
  - at least one `*parameters.json` should exist
  - files should be valid JSON

### Additional resources

- [Pester Wiki](https://github.com/pester/Pester/wiki)
- [Pester on GitHub](https://github.com/pester/Pester)
- [Pester Setup and Commands](https://pester.dev/docs/commands/Setup)

## API version validation

In this phase, the workflow will verify if the module is one of the latest 5 (non-preview) api version using the `arm/.global/global.module.tests.ps1` script.

## Template validation

The template validation tests execute a dry-run with each parameter file provided & configured for a module. For example, if you have two parameter files for a module, one with the minimum set of parameters, one with the maximum, the tests will run an `Test-AzDeployment` (_- the command may vary based on the template schema_) with each of the two parameter files to see if the template would be able to be deployed with them. This test could fail either because the template is invalid, or because any of the parameter files is configured incorrectly.

## Deployment validation

If all other tests passed, the deployment tests are the ultimate module validation. Using the available & configured parameter files for a module, each is deployed to Azure (in parallel) and verifies if the deployment works end to end.

Most of the resources are deleted by default after their deployment, to keep costs down and to be able to retest resource modules from scratch in the next run. However, the removal step can be skipped in case further investigation on the deployed resource is needed. For further details, please refer to the (.\PipelinesUsage.md) section.

This happens using the `.github/actions/templates/validateModuleDeploy/scripts/Test-TemplateWithParameterFile.ps1` script.

> **Note**<br>
Currently the list of the parameter file used to test the module is hardcoded in the module specific workflow, as the **parameterFilePaths** in the _job_deploy_module_ and _job_tests_module_deploy_validate_ jobs.

### Module dependencies

In order to successfully deploy and test all Modules in your desired environment some Modules have to have resources deployed beforehand.

> **Note**<br>
If we speak from **modules** in this context we mean the **Services** which get created from these modules.

Here is the full list of Modules which have dependencies on other Services.

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

#### Required secrets and keys

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
