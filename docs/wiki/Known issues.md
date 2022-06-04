# Known issues

This section provides an overview of the most impactful limitations and known issues. We are actively working on tracking them as GitHub issues and resolving them.

---

### _Navigation_

- [Module specific](#module-specific)
- [CI environment specific](#ci-environment-specific)
    - [Static validation](#static-validation)
    - [Deployment validation](#deployment-validation)
        - [Limited parameter file set](#limited-parameter-file-set)
    - [Publishing](#publishing)

---

# Module specific

This section outlines known issues that currently affect our modules.

## Microsoft.AAD/DomainServices

The Domain Services module pipeline is expected to fail in our environment for a few reasons:

-  The leveraged service principal has not the required permissions to actually deploy the service in the used tenant
-  The referenced (optional) `pfxCertificate` (and password) are not actually existing in the specified key vault - unless uploaded manually

To this end, the module was successfully tested manually in a dedicated environment.

If you're interested what the general pre-requisites are, please refer to the [official docs](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/tutorial-create-instance#prerequisites).

## Microsoft.KubernetesConfiguration/extensions

The module has a dependency on a pre-existing AKS cluster (managed cluster) which we don't have deployed using the dependencies pipeline for cost reasons.

## Microsoft.KubernetesConfiguration/fluxConfigurations

The module has a dependency on

- a pre-existing AKS cluster (managed cluster)
- a pre-existing Kubernetes Configuration extension deployment

which we don't have deployed using the dependencies pipeline for cost reasons.

## Microsoft.Network/vpnGateways

The module has a dependency on a pre-existing Virtual Hub which we don't have deployed using the dependencies pipeline for cost reasons.

## Microsoft.Network/virtualHubs

The module has a dependency on a pre-existing Virtual WAN which we don't have deployed using the dependencies pipeline for cost reasons.

## Microsoft.Network/vpnSites

The module has a dependency on a pre-existing Virtual WAN which we don't have deployed using the dependencies pipeline for cost reasons.

## Microsoft.Network/connections

The module has a dependency on pre-existing Virtual Network Gateways which we don't have deployed using the dependencies pipeline for cost reasons.

---

# CI environment specific

This section outlines known issues that currently affect our CI environment, i.e., our validation and publishing pipelines.

## Static validation

This section outlines known issues that currently affect the CI environment static validation step, i.e., Pester tests.

## Deployment validation

This section outlines known issues that currently affect the CI environment deployment validation step.

### Limited parameter file set

The deployment validation step aims to validate multiple configurations for each module. This is done by providing multiple parameter files to be leveraged by the same resource module, each covering a specific scenario.

The first planned step is to provide for each module a 'minimum-set' parameter file, limited to the top-level resource required parameters, vs. a 'maximum-set' parameter file, including all possible properties, child resources and extension resources. Some of our modules are still tested through one parameter file only. This is tracked by issue #1063.

## Publishing

This section outlines known issues that currently affect the CI environment publishing step.

---
