This page provides an overview of the CARML CI environment. For further details refer to the dedicated Wiki section [The CI environment](./The%20CI%20environment)

---

### _Navigation_

- [Deployment flow](#deployment-flow)
  - [Module versioning](#module-versioning)
- [Where does the CARML CI environment fit in?](#where-does-this-platform-fit-in)

---

# Deployment flow

This paragraph provides an overview of the usual deployment flow that goes from source modules to target solutions.

<img src="media\Context\Deployment_flow.png" alt="Deployment flow" height="300">

When it comes to Infrastructure as Code (IaC) deployments, the flow generally covers 3 phases:

1. In the **Develop modules** phase modules are first implemented/updated and then validated using one or multiple test-parameter files, testing their successful deployment against a sandbox subscription to prove their correctness.

1. The next phase, **Publish modules**, publishes the tested and approved modules to a target location for them to be consumed later. The target location should support versioning to allow referencing a specific module version and to avoid breaking changes when referencing them.

1. In the final **Consume modules** phase published modules are referenced and combined to deploy more complex architectures such as services or workloads.

## Module versioning

Deploying resources by referencing their corresponding modules from source control has one major drawback: If your deployments rely on what you have in your source repository then they will by default use the latest code.

Applying software development lifecycle concepts like _publishing build artifacts and versioning_ enables you to have a point in time version of a module. By introducing versions to your modules, the consuming orchestration can and should specify a module version it wants to use and deploy the Azure environment using them.

In case a breaking change is introduced and an updated version is published, no deployments are affected because they still reference the previously published version. Instead, they must make the deliberate decision to upgrade the module to reference newer versions.

# Where does the CARML CI environment fit in?

To ensure the modules hosted by the CARML library are valid and can perform the intended deployments, the repository comes with a continuous integration (CI) environment for each module.
If the validation is successful, the CI environment is also publishing versioned modules to one or multiple target locations, from where they can be referenced by solutions consuming them.

As such, the CARML CI environment covers `Phase #1`, i.e. the validation, & `Phase #2`, i.e. the publishing of the [deployment flow](#deployment-flow) section. On the other hand, a CARML consumer is usually interested in `Phase #2` and `Phase #3`, i.e. the consumption of the same deployment flow, where already tested and versioned modules can be referenced and combined to build more complex architectures.

<img src="media\Context\Deployment_flow_users.png" alt="Deployment flow" height="400">

The below diagram provides a drill down of how the different phases are interconnected:

<img src="media\Context\Deployment_flow_detail_white.png" alt="Complete deployment flow" height="500">

The top row represents your orchestration environment, for example _GitHub_ or _Azure DevOps_. The bottom row represents the _Azure_ environment.

From left to right there are the three phases introduced before, _Develop modules_, _Publish modules_ & _Consume modules_. The diagram shows how each phase interacts with the Azure environment.

1. Starting with **Develop modules**, the top left box shows the test pipelines we have for each module, executing the following:
   - _Static validation_: Pester tests are run against each module to ensure a baseline code quality across the library.
   - _Deployment validation_: An actual Azure deployment is run against a validation/sandbox subscription, shown in the bottom left corner. The subscription is intended to be without any link to production. Resources deployed here should be considered temporary and be removed after testing.
   - _Publishing_: Runs only if the previous steps are successful and triggers the second phase as described below.

1. The **Publish modules** phase is shown in the center box of the diagram. If all tests for a module succeed, the module is published to a given target location. Currently, the target locations supported by the CARML CI environment are:
   -  _[Template specs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs?tabs=azure-powershell)_
   - _[Private Bicep registry](https://docs.microsoft.com/en-gb/azure/azure-resource-manager/bicep/private-module-registry)_
   - _[Azure DevOps universal packages](https://docs.microsoft.com/en-us/azure/devops/artifacts/concepts/feeds?view=azure-devops)_.
     > Note: this is only available if using Azure DevOps pipelines.

1. The third phase **Consume modules** is represented on the right. The top right corner provides examples of orchestrations deploying the target solutions by referencing the published modules. The deployments performed in this third phase are supposed to occur to an integration/production environment. This phase references the validated and published modules coming out of the CARML CI environment and leverages them with the correctly configured parameters to orchestrate their deployment in the intended order.
