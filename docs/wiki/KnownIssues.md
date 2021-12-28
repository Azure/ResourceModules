# Known Issues

This section gives you an overview of the repositories larger known issues. We are actively working on resolving these problems and track them as issues.

---

### _Navigation_

- [Module specific](#module-specific)
- [Testing specific](#testing-specific)
  - [Removal exceptions](#removal-exceptions)
  - [Limited parameter file set](#limited-parameter-file-set)
- [Pipeline specific](#pipeline-specific)

---

# Module specific

This section outlines known issues that currently affect our modules.

---

# Testing specific

This section outlines known issues that currently affect our testing.

## Removal exceptions

Not all modules are removed after their test deployment.

In general, the current approach works for about 99% of the modules. There is one known exception, that is the `osDisk` removal for the virtual machine module, as Azure has difficulties finding it without using direct REST calls.

## Limited parameter file set

We have yet to implement the full set of parameter files we need in order to test all possible scenarios. The most important first step will be a 'minimum-set' parameter file vs. a 'maximum-set' parameter file for each module, followed by parameter files for specific scenarios

---

# Pipeline specific

This section outlines known issues that currently affect our pipelines.
