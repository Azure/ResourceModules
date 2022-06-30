In this scenario you have onboarded only the module library as described in [Getting started Scenario 1- Consume library](./Getting%20started%20-%20Scenario%201%20Consume%20library) and therefore you fetch lastest changes for the modules.

Modules can be stored in an accessible location like local, Template Specs, Bicep Registry or ADO universal packages.

The update process is the following:

### _Navigation_

- [1. Backup your local copy of the library](#1-backup-your-local-copy-of-the-library)
- [2. Download the library](#2-download-the-library)
- [3. (Optional) Convert library to ARM](#3-optional-convert-library-to-arm)
- [4. (Optional) Customize modules](#4-optional-customize-modules)
- [5. Test and publish modules](#5-test-and-publish-modules)
# 1. Backup your local copy of the library

<details>
<summary>Rename your local repository</summary>

Assuming the local repository location is `'D:\ResourcesModules'` rename it in `'D:\ResourcesModules_Backup'`.

The backup folder can be used to compare customized modules with the ones coming from the latest version and implement the required changes.

This can be done, for example, by the `'Compare selected'` [function](https://vscode.one/diff-vscode/) of Visual Studio Code

</details>

# 2. Download the library

To download the updated library follow the best option for your scenario, as explained in [Download the library](./Getting%20started%20-%20Scenario%202%20Consume%20library#1-download-the-library)

# 3. (Optional) Convert library to ARM

In case you aren't using Bicep you need to follow this procedure: [(Optional) Convert library to ARM](./Getting%20started%20-%20Scenario%202%20Consume%20library#2-optional-convert-library-to-arm)
# 4. (Optional) Customize modules

There are different options for library's customization:
- [Option 1 - Library improvement](./Fetching%20latest%20updates#option-1---library-improvement)
- [Option 2 - Specific requirements](./Fetching%20latest%20updates#option-2---specific-requirements)

The recommendation is to [contribute](./Contribution%20guide) to the public CARML repository so that your updates can improve the public library. In this way your changes will be available on the public library when fetching updates, modules will be already tested with your changes and you won't need to take care of customization on each update.

In some cases, you might need to add to the library company/organization' specifics, that are not sharable with the public CARML repository.

In this scenario every time you'll fetch updates from the public CARML repository merge conflicts are expected. You'll have to compare the new public code with your customized one and re-apply your customizations to the updated code.

This process can be automated, by script or CI, if customization tasks are repeatable.
# 5. Test and publish modules

If you have customized your library without contributing on the public CARML repository, public modules are not tested with your customization, so you'll need to manage the test of your updated and customized modules.

To automate the import of new code and speed up the test process we recommend to adopt [module library with the CI environment](./Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment).

If you are not using a local repository, you'll also need to publish the modules. Different procedures can apply, depending on where your version of the library is stored:

<details>
<summary>Modules publishing in Template Spec</summary>

The preferred method to publish modules to template-specs is to leverage CARML ready [CI environment](./The%20CI%20environment), however there maybe specific requirements for which this option is not applicable. As an alternative, the same [Publish-ModuleToTemplateSpec.ps1](https://github.com/Azure/ResourceModules/blob/main/utilities/pipelines/resourcePublish/Publish-ModuleToPrivateBicepRegistry.ps1) script leveraged by the publishing step of the CI environment pipeline can be executed locally.

To publish a module by running the script:
 1. Let's suppose your updated library location is `'D:\ResourcesModules'`, open a Powershell session on your machine
 1. Navigate to `'D:\ResourcesModules\utilities\pipelines\resourcePublish'` location
 1. Load the script `'Publish-ModuleToTemplateSpec.ps1'` executing:

        ```PowerShell
        . .\Publish-ModuleToTemplateSpec.ps1
        ```
 1. Run the script for the modules you need to publish, using the opportune parameters:
     - TemplateFilePath = the absolute path of the module to be published
     - ModuleVersion = the version of the module
     - TemplateSpecsRgName = the resource group that will contain the Template Spec
     - TemplateSpecsRgLocation = the location of the Template Spec
     - TemplateSpecsDescription = The description of the Template Spec

    To publish the Keyvault module with version 0.4.740 on a Template Spec that will be created in the resource group 'artifact-rg' you can execute the following example:

         ```PowerShell
        Publish-ModuleToTemplateSpec -TemplateFilePath "D:\ResourcesModules\modules\Microsoft.KeyVault\vaults\deploy.bicep" -ModuleVersion "0.4.740" -TemplateSpecsRgName 'artifact-rg'  -TemplateSpecsRgLocation 'West Europe' -TemplateSpecsDescription 'CARML KV Template Spec'
        ```
    As the modules to be published are more than one a script that calls the `'Publish-ModuleToTemplateSpec'` function for each of the modules can be created.

 1. Update your master template in order to use the new version of the published modules.

    For the [Template Specs' example in Solutions](./Solution%20creation#examples) page, supposing you have published version '0.4.740' of modules, you need to replace all the occurences of '0.4.735' with '0.4.740'.
</details>
<p>

<details>
<summary>Modules publishing in Bicep Registry</summary>

The preferred method to publish modules to Bicep Registry is to leverage CARML ready [CI environment](./The%20CI%20environment), however there maybe specific requirements for which this option is not applicable. As an alternative, the same [Publish-ModuleToPrivateBicepRegistry.ps1](https://github.com/Azure/ResourceModules/blob/main/utilities/pipelines/resourcePublish/Publish-ModuleToPrivateBicepRegistry.ps1) script leveraged by the publishing step of the CI environment pipeline can be executed locally.

To publish a module by running the script:
 1. Let's suppose your updated library location is `'D:\ResourcesModules'`, open a Powershell session on your machine
 1. Navigate to `'D:\ResourcesModules\utilities\pipelines\resourcePublish'` location
 1. Load the script `'Publish-ModuleToPrivateBicepRegistry.ps1'` executing:

        ```PowerShell
        . .\Publish-ModuleToPrivateBicepRegistry.ps1
        ```
 1. Run the script for the modules you need to publish, using the opportune parameters:
     - TemplateFilePath = the absolute path of the module to be published.
     - ModuleVersion = the version of the module.
     - BicepRegistryName =  Name of the private bicep registry to publish to.
     - BicepRegistryRgName = the resource group of the private bicep registry to publish to.

    To publish the Keyvault module with version 0.4.740 on a Bicep Registry called 'adpsxxazacrx001' that will be created in the resource group 'artifact-rg' you can execute the following command:

         ```PowerShell
        Publish-ModuleToPrivateBicepRegistry -TemplateFilePath "D:\ResourcesModules\modules\Microsoft.KeyVault\vaults\deploy.bicep" -ModuleVersion "0.4.740" -BicepRegistryName 'adpsxxazacrx001'  -BicepRegistryRgName 'artifact-rg'
        ```
    As the modules to be published are more than one a script that calls the `'Publish-ModuleToPrivateBicepRegistry'` function for each of the modules can be created.

 1. Update your master template in order to use the new version of the published modules.

    For the [Private Bicep Registry's example in Solutions](./Solution%20creation#examples) page, supposing you have published version '0.4.740' of modules, you need to replace all the occurences of '0.4.735' with '0.4.740'.
</details>
<p>

<details>
<summary>Modules publishing to Azure DevOps artifact feed</summary>

The preferred method to publish modules to Azure DevOps artifact feed is to leverage CARML ready [CI environment](./The%20CI%20environment), however there maybe specific requirements for which this option is not applicable. As an alternative, the same [Publish-ModuleToUniversalArtifactFeed.ps1](https://github.com/Azure/ResourceModules/blob/main/utilities/pipelines/resourcePublish/Publish-ModuleToUniversalArtifactFeed.ps1) script leveraged by the publishing step of the CI environment pipeline can be executed locally.

To publish a module by running the script:
 1. Let's suppose your updated library location is `'D:\ResourcesModules'`, open a Powershell session on your machine
 1. Navigate to `'D:\ResourcesModules\utilities\pipelines\resourcePublish'` location
 1. Load the script `'Publish-ModuleToUniversalArtifactFeed.ps1'` executing:

        ```PowerShell
        . .\Publish-ModuleToUniversalArtifactFeed.ps1
        ```
 1. Run the script for the modules you need to publish, using the opportune parameters:
     - TemplateFilePath = the absolute path of the module to be published.
     - ModuleVersion = the version of the module.
     - VstsOrganizationUri =  name of Azure DevOps organization URL hosting the artifacts feed.
     - VstsFeedProject = name of the project hosting the artifacts feed.
     - VstsFeedName = name to the feed to publish to.

    To publish the Keyvault module with version 0.4.740 on an artifact feed called 'Artifacts', in the project 'IaC' on organization 'fabrikam' you can execute the following command:

         ```PowerShell
        Publish-ModuleToUniversalArtifactFeed -TemplateFilePath "D:\ResourcesModules\modules\Microsoft.KeyVault\vaults\deploy.bicep" -ModuleVersion "0.4.740" -VstsOrganizationUri 'https://dev.azure.com/fabrikam' -VstsFeedProject 'IaC' -VstsFeedName 'Artifacts'
        ```
    As the modules to be published are more than one a script that calls the `'Publish-ModuleToUniversalArtifactFeed'` function for each of the modules can be created.

 1. Update your master template in order to use the new version of the published modules.

</details>
