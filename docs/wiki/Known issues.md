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

---

# CI environment specific

This section outlines known issues that currently affect our CI environment, i.e. our validation and publishing pipelines.

## Static validation

This section outlines known issues that currently affect the CI environment static validation step, i.e. Pester tests.

## Deployment validation

This section outlines known issues that currently affect the CI environment deployment validation step.

### Limited parameter file set

The deployment validation step aims to validate multiple configurations for each module. This is done by providing multiple parameter files to be leveraged by the same resource module, each covering a specific scenario.

The first planned step is to provide for each module a 'minimum-set' parameter file, limited to the top-level resource required parameters, vs. a 'maximum-set' parameter file, including all possible properties, child resources and extension resources. Some of our modules are still tested through one parameter file only. This is tracked by issue #1063.

## Publishing

This section outlines known issues that currently affect the CI environment publishing step.

---
