In this scenario you have onboarded both the module library and the CI environment, as described in [Getting started Scenario 2 - Onboard module library and CI environment](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment) and you would therefore need to fetch latest changes for both.

Depending on the DevOps environment you are using (GitHub or Azure DevOps) the number and implementation of the required steps may vary.

The update process is the following:

1. [Backup your local copy of the library](#1-backup-your-local-copy-of-the-library)
1. [Sync your copy of the library](#2-sync-your-copy-of-the-library)
1. [Apply specific settings to files](#3-apply-specific-settings-to-files)
1. [(Optional) Convert library to ARM](#4-optional-convert-library-to-arm)
1. [Manual dependencies](#5-manual-dependencies)
1. [(Optional) Customize modules and CI environment](#6-optional-customize-modules-and-ci-environment)
1. [Test and publish modules](#7-test-and-publish-modules)

# 1. Backup your local copy of the library

Rename your local repository. Assuming the local repository location is `'D:\ResourcesModules'` rename it in `'D:\ResourcesModules_Backup'`.

# 2. Sync your copy of the library

<details>
<summary>GitHub public repository</summary>

You have a public fork of public CARML source repository in your target organization.

1. Keep your fork synced to the fork upstream repository, on the GitHub web UI or through the GitHub CLI or the command-line, as explained in [Syncing a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork) documentation.
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

# 3. Apply specific settings to files

Personalize files with your specific settings:
1. [Update default name prefix](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#31-update-default-nameprefix)
1. Update settings file ([`settings.yml`](https://github.com/Azure/ResourceModules/blob/main/settings.yml)) as explained in [Set up variables file](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#322-set-up-variables-file)

# 4. (Optional) Convert library to ARM

Follow instructions in [(Optional) Convert library to ARM](./Getting%20started%20-%20Scenario%201%20Consume%20library#2-optional-convert-library-to-arm)

# 5. Manual dependencies

In special cases, manual actions may be required to provision certain resources whose deployment is not covered by the module test files. Based on the modules you require to test, follow the [Manual dependencies](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#4-manual-dependencies) guidance.

# 6. (Optional) Customize modules and CI environment

The backup folder from step 1, can be used to compare your local copy with your synced copy coming from the latest version. For example, the `'Compare selected'` [function](https://vscode.one/diff-vscode/) in Visual Studio Code can be leveraged for that purpose.

If your copy deviates from the upstream version due to customizations you applied to the code, you'll have to re-apply those customizations to the updated code. This process may be automated, by script or CI, if customization tasks are repeatable.

> **Note**: If customizations are general improvements which may be useful for the public, the recommendation is to [contribute](./Contribution%20guide) to the public CARML repository so that your updates can improve the public library. This way, your changes will already be available the next time you fetch from upstream, as modules would already been tested, and would not conflict with your customizations.

# 7. Test and publish modules

Push the updated local code to your remote repository. If actions are enabled, test and publishing of modules will start automatically.
