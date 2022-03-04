This section outlines the contribution flow to the CARML repository.

Depending on the contribution, the number and execution of the required below steps may vary.

---

### _Navigation_

- [Create of pick up an issue](#Create-or-pick-up-an-issue)
- [Environment setup](#Environment-setup)
- [Develop](#Develop)
- [Validate](#Validate)
- [Open a PR](#Open-a-PR)

---

# Create or pick up an issue

We kindly ask to have an issue mapped to the contribution you'd like to make.
How you proceed from here depends on the scenario:

- If you just want to contribute to this project, but don't know yet where and how, feel free to navigate the the 'Projects' tab on the repository, check what items are currently still in the 'to-do' swim lane and pick one that speaks to you. In this case you should assign the item to yourself / or reach out to discuss its content & priority.

   <img src="./media/projectsTab.jpg" alt="Projects Tab" height="178" width="414">

  > Note: For starters we suggest to search for issues labelled with `good first issue`.

- If you find a bug or have an idea that you'd also like to work on, feel free to create an issue in the corresponding GitHub section, assign it to yourself and the project and get started.

  > Note: If you don't feel like working on that alone, you can label the issue with `help wanted` to let the community know.

# Environment setup

The preferred method of contribution requires you to create your own fork and create pull requests into the source repository from there. To set the fork up, please follow the process described in the ['Getting started - Setup environment'](./Getting%20started%20-%20Setup%20environment) section.

In case you want to contribute to the documentation, you can limit the setup to forking the repository and clone your fork locally.

In case your contribution involves changes to the library (the modules) and/or to the CI environment (the pipelines), you need to setup the full environment, such as GitHub secrets and token replacement, as detailed in the ['Getting started'](./Getting%20started) section and related sub-pages. This will allow you to test your changes against your environment before requesting to merge them to the main repo.

# Develop
Implement your contribution
Depending on the contribution (e.g., module, pipeline) note the design guidelines in the CARML wiki

# Validate
How you proceed from here depends on the scenario:

In case you want to contribute to the documentation, you can skip this step.

In case your contribution involves changes to the library (the modules) and/or to the CI environment (the pipelines), we kindly ask you to validate your updates against your environment before requesting to merge them to the main repo. Test your code leveraging the CARML CI environment, as detailed in the Pipelines usage section.

# Open a PR
Open a PR, reference the badge status of your pipeline run and link your issue to it


