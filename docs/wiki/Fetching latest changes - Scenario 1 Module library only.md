When the CARML library is consumed with the [*Template Orchestration*](./Solution%20creation#template-orchestration) approach modules need to be stored in an available location, where the Azure Resource Manager (ARM) can access them. This can be achieved by storing the modules templates in an accessible location like local, Template Specs or the Bicep Registry.

---
### _Navigation_

- [Local Repository](#local-repository)
- [Template Specs](#template-specs)
- [Bicep Registry](#bicep-registry)

---

# Local Repository
In case you consume the module library with a local repository, the update procedure has the following steps:
1. Backup your local repository to maintain a backup copy
    <details>
    <summary>Rename your local repository</summary>

    Assuming the local repository location is `'D:\ResourcesModules'` rename it in `'D:\ResourcesModules_Backup'`.
    The backup folder can be used to compare customized modules with the ones coming from the latest version and implement the required changes.
    This can be done, for example, by the `'Compare selected'` [function](https://vscode.one/diff-vscode/) of Visual Studio Code
    </details>

1. [Download the library](./Getting%20started%20-%20Scenario%202%20Consume%20library#1-download-the-library)
1. [(Optional) Convert library to ARM](./Getting%20started%20-%20Scenario%202%20Consume%20library#2-optional-convert-library-to-arm)

If you have customized modules, you'll need to apply customizations on the new updated modules.

# Template Specs
When the modules are stored in Template Specs a versioning feature with access to old versions is available, but a backup of the local folder can be useful if you have customized modules, as you'll need to apply the customization to the new downloaded version of the modules. The update steps are the following:
1. Backup your local repository to maintain a backup copy: you can rename the local repository as showed in the above section.
1. [Download the library](./Getting%20started%20-%20Scenario%202%20Consume%20library#1-download-the-library)
1. [(Optional) Convert library to ARM](./Getting%20started%20-%20Scenario%202%20Consume%20library#2-optional-convert-library-to-arm)
1. Apply customizations to the new version of modules if needed
1. Publish modules to Template Spec
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
        Publish-ModuleToTemplateSpec -TemplateFilePath "D:\ResourcesModules\arm\Microsoft.KeyVault\vaults\deploy.bicep" -ModuleVersion "0.4.740" -TemplateSpecsRgName 'artifact-rg'  -TemplateSpecsRgLocation 'West Europe' -TemplateSpecsDescription 'CARML KV Template Spec'
        ```
        As the modules to be published are more than one a script that calls the `'Publish-ModuleToTemplateSpec'` function for each of the modules can be created.
    </details>
    <p
1. Update your master template in order to use the new version of the published modules.
    For the [Template Specs' example in Solutions](./Solution%20creation#examples) page, supposing you have published version '0.4.740' of modules, you need to replace all the occurences of '0.4.735' with '0.4.740'.

# Bicep Registry
As the Template Specs scenario, Bicep Registry offers a versioning feature with access to old versions of modules, but a backup of the local folder can be useful if you have customized modules, as you'll need to apply the customization to the new downloaded version of the modules. The update steps are the following:
1. Backup your local repository to maintain a backup copy: you can rename the local repository as showed in the above section.
1. [Download the library](./Getting%20started%20-%20Scenario%202%20Consume%20library#1-download-the-library)
1. [(Optional) Convert library to ARM](./Getting%20started%20-%20Scenario%202%20Consume%20library#2-optional-convert-library-to-arm)
1. Apply customizations to the new version of modules if needed
1. Publish modules to Bicep Registry
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
        Publish-ModuleToPrivateBicepRegistry -TemplateFilePath "D:\ResourcesModules\arm\Microsoft.KeyVault\vaults\deploy.bicep" -ModuleVersion "0.4.740" -BicepRegistryName 'adpsxxazacrx001'  -BicepRegistryRgName 'artifact-rg'
        ```
        As the modules to be published are more than one a script that calls the `'Publish-ModuleToPrivateBicepRegistry'` function for each of the modules can be created.
    </details>
    <p
1. Update your master template in order to use the new version of the published modules.
    For the [Private Bicep Registry's example in Solutions](./Solution%20creation#examples) page, supposing you have published version '0.4.740' of modules, you need to replace all the occurences of '0.4.735' with '0.4.740'.
