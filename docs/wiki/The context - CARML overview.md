# CARML overview

The _CARML_ platform hosts a collection of [resource modules](./Modules) with the intend to cover as many Azure resources and their child-resources as possible.

As such, users can use the modules as they are, alter them and or use them to deploy their environments.

To ensure the modules are valid and can perform the intended deployments, the repository comes with a [CI environment](./) for each module. If successful it will also publish them in one or multiple target locations.

As such, _CARML_ covers the `bottom box` of the [deployment model](#what-is-the-intended-the-deployment-model) section and `Phase #1` & `Phase #2` of the [deployment flow](#what-is-the-intended-deployment-flow) section.

<img src="media/completeFlowTransp.png" alt="Complete deployment flow filtered" height="500">

As we want to enable any user of this repository's content to not only leverage its modules but actually also re-use the platform, the platform itself is set up so that you can plug it into your own environment with just a few basic steps described in the [Getting Started](./GettingStarted) section. You may choose to add or remove modules, define your own locations you want to publish to and as such create your own open- or inner-source library.
