# Known Issues

This section gives you an overview of the repositories larger known issues. We are actively working on resolving these problems and track them as issues.


---
### _Navigation_
- [Module specifc](#module-specific)
- [Testing specifc](#testing-specific)
- [Pipeline specifc](#pipeline-specific)
---


## Module specific
This section outlines known issues that currently affect our modules.

### Consistency
While we work hard on aliginig all modules to a common standard we're still there. One of the biggest remining challenges is the consistent handling of child-resources across all modules (e.g. Container for a Storage Account). However, we already have a plan ready and are currently implementing the same.

## Testing specific
This section outlines known issues that currently affect our testing.

### Not all modules are removed after their test deployment
In general, the current approach works for about 80-90% of the modules. That said, there are several different reasons why some of the modules are currently not auto-removed:
- The module does not support tags: The current test implementation heavily relies on tags to find and remove a test-deployed resource. However, as not all resources support tags (for example Role Assignments), these must be removed in a different way that is yet to be implemented.
- The module's resources must be removed in a specific order: Some resources like Azure NetAppFiles & VirtualWan, while supporting tags, cannot be removed as is. Due to their nature they deploy several child-resources that must be removed first. However, the current implementation of the removal is not aware of these limitations.

### Insufficient parameter files
We have yet to implement the full set of parameter files we need in order to test all possible scenarios. The most important first step will be a 'minimum-set' parameter file vs. a 'maximum-set' parameter file for each module, followed by parmeter files for specific scenarios

## Pipeline specific
This section outlines known issues that currently affect our pipelines.
