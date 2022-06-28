In this scenario you have adopted the [Pipeline Orchestration](./Solution%20creation#pipeline-orchestration) approach and you have onboarded the module library and the CI environment, as described in [Getting started Scenario 2 - Onboard module library and CI environment](./Getting%20started%20-%20Scenario%201%20Onboard%20module%20library%20and%20CI%20environment).

Depending on the DevOps environment you have chosen (GiutHub or DevOps) you may have a different situation.

### _Navigation_

- [GitHub public repository](#lgithub-public-repository)
- [GitHub private repository](#github-private-repository)
- [Azure DevOps private git](#azure-devops-private-git)

# GitHub public repository
You have a public fork of public CARML source repository in your target organization.
The update process is the following:
1. Keep your fork synced to the fork upstream repository, on the GitHub web UI or through the GitHub CLI or the command line, as explaind in [Syncing a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork) documentation.
1. Sync your local copy of the fork taking care of eventual customizations you can have in place.
1. Personalize files with your specific settings:
    1. [Update default name prefix](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#31-update-default-nameprefix)
    1. Update variables file ([`global.variables.yml`](https://github.com/Azure/ResourceModules/blob/main/global.variables.yml)) as explained in [Set up variables file](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment.md#322-set-up-variables-file)
1. (Optional) Re-apply your customizations
1. Run the '*dependencies pipeline*' to update dependencies configuration that can be updated on the downloaded CARML release. Follow [Deploy dependencies](./Fetching%20latest%20changes%20-%20Scenario%202%20Module%20library%20only#4-deploy-dependencies) section in Getting started - Scenario 2 Onboard module library and CI environment documentation to do this.
1. [Update module parameter files](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#5-update-module-parameter-files)
1. [(Optional) Convert library to ARM](./Fetching%20latest%20changes%20-%20Scenario%202%20Module%20library%20only#6-optional-convert-library-to-arm)
1. Push the updated local code to your remote public fork
1. (Optional) Test customized modules
1. Publish updated artifacts

# GitHub private repository
You have created your GitHub target repository and uploaded there the content of the CARML repository.
The update process is similar to the onboarding one:
1. Clone/download CARML repository to create a local copy of it, as explained in Azure DevOps Repository section in [Getting started - Scenario 2 Onboard module library and CI environment](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment.md#2-forkclone-the-repository-into-your-devops-environment)
1. Personalize files with your specific settings:
    1. [Update default name prefix](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#31-update-default-nameprefix)
    1. Update variables file ([`global.variables.yml`](https://github.com/Azure/ResourceModules/blob/main/global.variables.yml)) as explained in [Set up variables file](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#322-set-up-variables-file)
1. (Optional) Re-apply your customizations
1. Run the '*dependencies pipeline*' to update dependencies configuration that can be updated on the downloaded CARML release. Follow [Deploy dependencies](./Fetching%20latest%20changes%20-%20Scenario%202%20Module%20library%20only#4-deploy-dependencies) section in Getting started - Scenario 2 Onboard module library and CI environment documentation to do this.
1. [Update module parameter files](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#5-update-module-parameter-files)
1. [(Optional) Convert library to ARM](./Fetching%20latest%20changes%20-%20Scenario%202%20Module%20library%20only#6-optional-convert-library-to-arm)
1. Push the updated local code to your remote target repository
1. (Optional) Test customized modules
1. Publish updated artifacts

# Azure DevOps private git
You have created your target repository and uploaded there the content of the CARML repository.
The update process is similar to the onboarding one:
1. Clone/download CARML repository to create a local copy of it, as explained in Azure DevOps Repository section in [Getting started - Scenario 2 Onboard module library and CI environment](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment.md#2-forkclone-the-repository-into-your-devops-environment)
1. Personalize files with your specific settings:
    1. [Update default name prefix](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#31-update-default-nameprefix)
    1. Update variables file ([`global.variables.yml`](https://github.com/Azure/ResourceModules/blob/main/global.variables.yml)) as explained in [Set up variables file](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#323-set-up-variables-file)
1. (Optional) Re-apply your customizations
1. Run the '*dependencies pipeline*' to update dependencies configuration that can be updated on the downloaded CARML release. Follow [Deploy dependencies](./Fetching%20latest%20changes%20-%20Scenario%202%20Module%20library%20only#4-deploy-dependencies) section in Getting started - Scenario 2 Onboard module library and CI environment documentation to do this.
1. [Update module parameter files](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#5-update-module-parameter-files)
1. [(Optional) Convert library to ARM](./Fetching%20latest%20changes%20-%20Scenario%202%20Module%20library%20only#6-optional-convert-library-to-arm)
1. Push the updated local code to your remote target repository
1. (Optional) Test customized modules
1. Publish updated artifacts
