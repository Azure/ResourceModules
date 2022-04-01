This section provides an overview of the Common Azure Resource Modules Library (CARML) repository.

<img src="media\Context\CARLM_overview_white.png" alt="CARML overview" height="500">

The purpose of the CARML repository is twofold:
- To host a collection of Azure resource modules with the intent to cover as many Azure resources and their child-resources as possible. As such, users can use the modules as they are, alter them and or use them to deploy their environments. This part is covered by [The library](./The%20context%20-%20CARML%20library) page.
- To ensure the modules are valid and can perform the intended deployments, the repository comes with a CI environment for each module. If successful it will also publish them in one or multiple target locations. This part is covered by [The CI environment](./The%20context%20-%20CARML%20CI%20environment) page.

As we want to enable any user of this repository's content to not only leverage its modules but actually also re-use the platform, the platform itself is set up so that you can plug it into your own environment with just a few basic steps described in the [Getting started](./Getting%20started) section. You may choose to add or remove modules, define your own locations you want to publish to and as such create your own open- or inner-source library.
