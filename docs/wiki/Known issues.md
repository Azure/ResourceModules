This section provides an overview of the most impactful limitations and known issues. We are actively working on tracking them as GitHub issues and resolving them.

---

### _Navigation_

- [Module specific](#module-specific)
  - [Microsoft.AAD/DomainServices](#microsoftaaddomainservices)
  - [Microsoft.Management/managementGroups](#microsoftmanagementmanagementgroups)
  - [Microsoft.RecoveryServices/vaults](#microsoftrecoveryservicesvaults)
  - [Microsoft.Network/networkManagers](#microsoftnetworknetworkmanagers)
- [CI environment specific](#ci-environment-specific)
  - [Static validation](#static-validation)
  - [Deployment validation](#deployment-validation)
    - [Limited module test file set](#limited-module-test-file-set)
    - [Limited job execution time](#limited-job-execution-time)
  - [Publishing](#publishing)

---

# Module specific

This section outlines known issues that currently affect the modules.

## Microsoft.AAD/DomainServices

The Domain Services module pipeline is expected to fail in our development/validation environment for a few reasons:

-  The leveraged service principal doesn't have the required permissions to actually deploy the service in the used tenant.
-  The referenced (optional) `pfxCertificate` and password don't actually exist in the specified Key Vault - unless uploaded manually.

Therefore, the module was manually tested in a dedicated environment.

For the general prerequisites, please refer to the [official docs](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/tutorial-create-instance#prerequisites).

## Microsoft.Management/managementGroups

The Management Group module does not currently include the role assignments extension resource.

Including RBAC capabilities has been tested setting the scope to the previously created management group and resulted in failing already in the validation step with the error: '`ManagementGroupNotFound - The management group 'EXAMPLEMG' cannot be found`'.

A related issue has been opened to the Bicep board [#6832](https://github.com/Azure/bicep/issues/6832).

Further details are also provided in issue [#1342](https://github.com/Azure/ResourceModules/issues/1342).

## Microsoft.RecoveryServices/vaults

The Recovery Services Vaults module does not currently validate the identity property (system or user assigned identity).

The module pipeline fails in the deployment validation step when system and user assigned identity parameters are added as input parameters.

A related issue has been opened in the Bug board [#2391](https://github.com/Azure/ResourceModules/issues/2391).

## Microsoft.Network/networkManagers

In order to deploy a Network Manager with the `networkManagerScopes` property set to `managementGroups`, you need to register the `Microsoft.Network` resource provider at the Management Group first ([ref](https://learn.microsoft.com/en-us/rest/api/resources/providers/register-at-management-group-scope)).

---

# CI environment specific

This section outlines known issues that currently affect the CI environment, i.e., the validation and publishing pipelines.

## Static validation

This section outlines known issues that currently affect the CI environment static validation step, i.e., Pester tests.

## Deployment validation

This section outlines known issues that currently affect the CI environment deployment validation step.

### Limited module test file set

The deployment validation step aims to validate multiple configurations for each module. This is done by providing multiple module test files to be leveraged by the same resource module, each covering a specific scenario.

The first planned step for each module is to provide a 'minimum-set' module test file, limited to the top-level resource required parameters, vs. a 'maximum-set' module test file, including all possible properties, child resources and extension resources. Some of the modules are still tested through one module test file only. This is tracked by issue [#401](https://github.com/Azure/ResourceModules/issues/401).

### Limited job execution time

GitHub workflows used to validate CARML modules are running on GitHub-hosted runners.

In such a scenario, as documented in the [Usage limits for GitHub Actions workflows](https://docs.github.com/en/actions/learn-github-actions/usage-limits-billing-and-administration#usage-limits), if a job reaches a limit of 6 hours of execution time, the job is terminated and fails to complete.

For modules that can take more than 6 hours to deploy, this restriction applies. In these cases, the corresponding deployment validation job may be terminated before completion, causing the entire module validation pipeline to fail. One module where this can happen is the **Microsoft.Sql\managedInstances** module.

## Publishing

This section outlines known issues that currently affect the CI environment publishing step.

---
