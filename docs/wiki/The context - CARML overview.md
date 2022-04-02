This section provides an overview of the Common Azure Resource Modules Library (CARML) repository.

<img src="media\Context\CARLM_overview_white.png" alt="CARML overview" height="500">

The contents of this repository are twofold: a library of comprehensive Azure resource modules that conform to the Azure Resource Reference, as well as a continuous integration (CI) environment that enables testing and versioning.

- The library hosts a collection of comprehensive, reusable, Bicep-based building blocks to deploy Azure resources. In addition, it provides optional features across modules, such as child resources, role assignments, locks and diagnostic settings. An overview of the CARML library is first introduced in this section page [The context - CARML library](./The%20context%20-%20CARML%20library), while further details are provided by the corresponding Wiki section [The library](./The%20library).
- The continuous integration (CI) environment ensures the modules are valid and can perform the intended deployments. As such, the repository includes built-in lifecycle capabilities for each module, supporting continuous validation and versioned publishing across multiple target locations. An overview of the CARML CI environment is first introduced in this section page [The context - CARML CI environment](./The%20context%20-%20CARML%20CI%20environment), while further details are provided by the corresponding Wiki section [The CI environment](./The%20CI%20environment).


That supports GitHub & Azure DevOps as well as Bicep & ARM

