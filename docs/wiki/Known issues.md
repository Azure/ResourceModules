This section provides an overview of the most impactful limitations and known issues. We are actively working on tracking them as GitHub issues and resolving them.

---

### _Navigation_

- [Module specific](#module-specific)
  - [Microsoft.AAD/DomainServices](#microsoftaaddomainservices)
  - [Microsoft.KubernetesConfiguration/extensions](#microsoftkubernetesconfigurationextensions)
  - [Microsoft.KubernetesConfiguration/fluxConfigurations](#microsoftkubernetesconfigurationfluxconfigurations)
  - [Microsoft.Management/managementGroups](#microsoftmanagementmanagementgroups)
  - [Microsoft.Network/vpnGateways](#microsoftnetworkvpngateways)
  - [Microsoft.Network/virtualHubs](#microsoftnetworkvirtualhubs)
  - [Microsoft.Network/vpnSites](#microsoftnetworkvpnsites)
  - [Microsoft.Network/connections](#microsoftnetworkconnections)
  - [Microsoft.Synapse/workspaces](#microsoftsynapseworkspaces)
- [CI environment specific](#ci-environment-specific)
  - [Static validation](#static-validation)
  - [Deployment validation](#deployment-validation)
    - [Limited module test file set](#limited-module-test-file-set)
  - [Publishing](#publishing)
  - [Dependencies pipeline](#dependencies-pipeline)

---

# Module specific

This section outlines known issues that currently affect the modules.

## Microsoft.AAD/DomainServices

The Domain Services module pipeline is expected to fail in our development/validation environment for a few reasons:

-  The leveraged service principal doesn't have the required permissions to actually deploy the service in the used tenant.
-  The referenced (optional) `pfxCertificate` and password don't actually exist in the specified Key Vault - unless uploaded manually.

Therefore, the module was manually tested in a dedicated environment.

For the general prerequisites, please refer to the [official docs](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/tutorial-create-instance#prerequisites).

## Microsoft.KubernetesConfiguration/extensions

The module has a dependency on a pre-existing AKS cluster (managed cluster) which we don't have deployed using the dependencies pipeline for cost reasons.

## Microsoft.KubernetesConfiguration/fluxConfigurations

The module has a dependency on

- a pre-existing AKS cluster (managed cluster)
- a pre-existing Kubernetes Configuration extension deployment

which we don't have deployed using the dependencies pipeline for cost reasons.

## Microsoft.Management/managementGroups

The Management Group module does not currently include the role assignments extension resource.

Including RBAC capabilities has been tested setting the scope to the previously created management group and resulted in failing already in the validation step with the error: '`ManagementGroupNotFound - The management group 'EXAMPLEMG' cannot be found`'.

A related issue has been opened to the Bicep board [#6832](https://github.com/Azure/bicep/issues/6832).

Further details are also provided in issue [#1342](https://github.com/Azure/ResourceModules/issues/1342).

## Microsoft.Network/vpnGateways

The module has a dependency on a pre-existing Virtual Hub which we don't have deployed using the dependencies pipeline for cost reasons.

## Microsoft.Network/virtualHubs

The module has a dependency on a pre-existing Virtual WAN which we don't have deployed using the dependencies pipeline for cost reasons.

## Microsoft.Network/vpnSites

The module has a dependency on a pre-existing Virtual WAN which we don't have deployed using the dependencies pipeline for cost reasons.

## Microsoft.Network/connections

The module has a dependency on pre-existing Virtual Network Gateways which we don't have deployed using the dependencies pipeline for cost reasons.

## Microsoft.Synapse/workspaces

The change from Bicep version `v0.10.13` to `v0.10.61` introduced a new validation that causes a `scope` statement in the module to fail. This issue is tracked in the Bicep issue [8403](https://github.com/Azure/bicep/issues/8403). A new Bicep version will either resolve the issue, or, the module will be updated accordingly.

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

## Publishing

This section outlines known issues that currently affect the CI environment publishing step.

## Dependencies pipeline

The dependencies pipeline currently fails on the Disk Encryption Set resource creation when deployed more than once.

In the majority of cases you will only need to run the dependencies pipeline just once, as a prerequisite before using the module pipelines. It is then possible you will not experience this problem.

> **Workaround**: In case you need to rerun the dependencies pipeline on top of existing resources created by the first run, please delete the Disk Encription Set resource before the rerun.

Further details are tracked in issue [#1727](https://github.com/Azure/ResourceModules/issues/1727).

---
