In this scenario you have onboarded both the module library and the CI environment, as described in [Getting started Scenario 2 - Onboard module library and CI environment](./Getting%20started%20-%20Scenario%201%20Onboard%20module%20library%20and%20CI%20environment) and you would therefore need to fetch latest changes for both.

Depending on the DevOps environment you have chosen (GitHub or DevOps) you may have a different situation.

The update process is the following:

### _Navigation_

- [1. Sync your copy of the library](#1-sync-your-copy-of-the-library)
- [2. Apply specific settings to files](#2-apply-specific-settings-to-files)
- [3. (Optional) Re-apply your customizations](#3-optional-re-apply-your-customizations)
- [4. Run dependencies pipeline](#4-run-dependencies-pipeline)
- [5. Update module parameter files](#5-update-module-parameter-files)
- [6. (Optional) Convert library to ARM](#6-optional-convert-library-to-arm)
- [7. Push updated code](#7-push-updated-code)
- [8. Test and publish modules](#8-test-and-publish-modules)

# 1. Sync your copy of the library

<details>
<summary>GitHub public repository</summary>

    You have a public fork of public CARML source repository in your target organization.

    1. Keep your fork synced to the fork upstream repository, on the GitHub web UI or through the GitHub CLI or the command line, as explaind in [Syncing a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork) documentation.
    1. Sync your local copy of the fork taking care of eventual customizations you can have in place.

</details>
<p>

<details>
<summary>GitHub private repository</summary>

    You have created your GitHub target repository and uploaded there the content of the CARML repository.

    Clone/download CARML repository to create a local copy of it, as explained in Azure DevOps Repository section in [Getting started - Scenario 2 Onboard module library and CI environment](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#2-forkclone-the-repository-into-your-devops-environment)

</details>
<p>

<details>
<summary>Azure DevOps private git</summary>

    You have created your target repository and uploaded there the content of the CARML repository.

    Clone/download CARML repository to create a local copy of it, as explained in Azure DevOps Repository section in [Getting started - Scenario 2 Onboard module library and CI environment](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#2-forkclone-the-repository-into-your-devops-environment)

</details>
<p>

# 2. Apply specific settings to files

Personalize files with your specific settings:
1. [Update default name prefix](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#31-update-default-nameprefix)
1. Update variables file ([`global.variables.yml`](https://github.com/Azure/ResourceModules/blob/main/global.variables.yml)) as explained in [Set up variables file](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#322-set-up-variables-file)

# 3. (Optional) Re-apply your customizations

There are different options for library's customization:
- [Option 1 - Library improvement](./Fetching%20latest%20updates#option-1---library-improvement)
- [Option 2 - Specific requirements](./Fetching%20latest%20updates#option-2---specific-requirements)

The recommendation is to [contribute](./Contribution%20guide) to the public CARML repository so that your updates can improve the public library. In this way your changes will be available on the public library when fetching updates, modules will be already tested with your changes and you won't need to take care of customization on each update.

In some cases, you might need to add to the library company/organization' specifics, that are not sharable with the public CARML repository.

In this scenario every time you'll fetch updates from the public CARML repository merge conflicts are expected. You'll have to compare the new public code with your customized one and re-apply your customizations to the updated code.

This process can be automated, by script or CI, if customization tasks are repeatable.

# 4. Run dependencies pipeline

Run the '*dependencies pipeline*' to update dependencies configuration that can be updated on the downloaded CARML release. Follow [Deploy dependencies](./Fetching%20latest%20changes%20-%20Scenario%202%20Module%20library%20only#4-deploy-dependencies) section in Getting started - Scenario 2 Onboard module library and CI environment documentation to do this.

# 5. Update module parameter files

Follow the [Update module parameter files](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#5-update-module-parameter-files) procedure

# 6. (Optional) Convert library to ARM

Follow istructions in [(Optional) Convert library to ARM](./Fetching%20latest%20changes%20-%20Scenario%202%20Module%20library%20only#6-optional-convert-library-to-arm)

# 7. Push updated code

Push the updated local code to your remote public fork (for GitHub public repository scenario) or on your remote target repository for GitHub private repository and Azure DevOps private git scenarios.
# 8. Test and publish modules

Follow [Test and publish modules](./Fetching%20latest%20changes%20-%20Scenario%201%20Module%20library%20only#5-test-and-publish-modules) section in [Fetching latest changes - Scenario 1 Module library only](./Fetching%20latest%20changes%20-%20Scenario%201%20Module%20library%20only) page.
