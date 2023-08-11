This page provides an overview of the CARML CI environment. For further details, refer to the dedicated wiki section, "[The CI environment](./The%20CI%20environment)".

---

### _Navigation_

- [Deployment flow](#deployment-flow)
  - [Module versioning](#module-versioning)
- [Where does the CARML CI environment fit in?](#where-does-the-carml-ci-environment-fit-in)

---

The Continuous Integration environment (CI environment) is a set of automation components that are used for continuously validating and publishing module artifacts (Bicep registry repositories, template specs, universal packages). Technically, the CI environment consists of a DevOps platform (GitHub or Azure DevOps) hosting related pipelines and scripts, as well as an Azure environment (Azure AD tenant with management group(s) and subscription(s)) in which the modules are validated by the automation pipelines and scripts.

In the following chapters, we're going to explain where the CI environment fits and how it is used.

# Deployment flow

This paragraph provides an overview of the standard development-to-deployment flow that goes from source modules to target solutions.

<img src="./media/Context/Deployment_flow.png" alt="Deployment flow" height="300">

This flow generally covers 3 phases:

1. In the **Develop modules** phase modules are first implemented/updated and then validated using one or multiple module test files, testing their successful deployment to a sandbox subscription to prove their correctness.

1. The next phase, **Publish modules**, packages and publishes the tested and approved modules to a target location for later consumption. The target location (also known as package store or artifact store) should support versioning to allow referencing a specific module version and to avoid breaking changes when referencing them.

1. In the final **Consume modules** phase, published modules are referenced and combined to deploy more complex architectures (multi-module solutions) such as workloads/applications or individual services.

## Module versioning

Deploying resources by referencing their corresponding modules from source control has one major drawback: If your deployments directly rely on your source repository, then they will by default use the latest code.

Applying software development lifecycle concepts like _publishing build artifacts and versioning_ enables you to have a point in time version of a module. By introducing versions to your modules, the consuming orchestration can and should specify a module version needed, and deploy the Azure solution leveraging it.

In case a breaking change is introduced to a module and an updated version is published, no deployments are affected as they still reference the previously published version. Instead, a deliberate decision must be made to upgrade the solution to reference newer module versions.

Also, if you reference a module version that was tested in and has passed through the CI environment, you can trust that it complies the qualitative and functional standards.

# Where does the CARML CI environment fit in?

To ensure the modules hosted by the CARML library are valid and can perform the intended deployments, the repository comes with a continuous integration (CI) environment for each module.
If the validation is successful, the CI environment is also publishing versioned modules to one or multiple target locations, from where they can be referenced by solutions consuming them.

The CARML CI environment covers `Phase #1`, (the validation) & `Phase #2` (the publishing) of the [deployment flow](#deployment-flow) section - these include the steps typically performed by the *CARML module developer* persona.

The *CARML solution developer* and *solution consumer* personas are usually working in `Phase #2` and `Phase #3`, i.e., building/leveraging complex, multi-module solutions by consuming the already tested and versioned modules previously placed in an artifact store.

<img src="./media/Context/Deployment_flow_users.png" alt="Deployment flow" height="400">

The below diagram shows the details of how the different phases are interconnected:

<img src="./media/Context/Deployment_flow_detail_white.png" alt="Complete deployment flow" height="500">

The top row represents your orchestration environment, for example, _GitHub_ or _Azure DevOps_. The bottom row represents your _Azure_ cloud environment.

From left to right, there are the three phases introduced before, _Develop modules_, _Publish modules_ & _Consume modules_. The diagram shows how each phase interacts with the Azure environment.

1. Starting with **Develop modules**, the top left box shows the test pipelines that exist for each module, performing the following steps:
   - _Static validation_: Pester & PSRule tests are run on each module to ensure a baseline code quality across the library.
   - _Deployment validation_: An actual Azure deployment is performed in a validation/sandbox subscription, shown in the bottom left corner. The subscription is intended to be without any link to production. Resources deployed here should be considered temporary and be removed after testing.
   - _Publishing_: Runs only if the previous steps are successful and initiates the second phase as described below.

1. The **Publish modules** phase is shown in the center box of the diagram. If all tests for a module succeed, the module is published to a given target location. Currently, the target locations supported by the CARML CI environment are:
   - _[Template specs](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs?tabs=azure-powershell)_
   - _[Private Bicep registry](https://learn.microsoft.com/en-gb/azure/azure-resource-manager/bicep/private-module-registry)_
   - _[Azure DevOps Universal Packages](https://learn.microsoft.com/en-us/azure/devops/artifacts/concepts/feeds?view=azure-devops)_.
     > Note: this is only available if using Azure DevOps pipelines.

   To dive deeper and understand which target locations may be best suited for your use case, we provide further information in the [Publish-location considerations](./Solution%20creation#publish-location-considerations) section.

1. The third phase, **Consume modules** is represented on the right. The top right corner provides examples of orchestrations deploying the target solutions by referencing the published modules. The deployments performed in this third phase are supposed to target an integration/production environment. This phase references the validated and published modules coming out of the CARML CI environment, and leverages them with the correctly configured parameters to orchestrate their deployment in the intended order.
