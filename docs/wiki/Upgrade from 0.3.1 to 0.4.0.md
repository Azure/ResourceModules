In this area, we provide instructions to migrate from CARML version 0.3.1 to version 0.4.0. The content is divided into two main parts: The updates to the modules & to the CI environment.

# Modules
## General import of new modules
New modules can usually be migrated by adding the content of the release's `arm` folder into your own `arm` folder.

> **Note:** You should only do this in a new branch dedicated for the update process, and carefully compare any changes the platform displays.
>
> This is especially important if you have implemented any changes yourself that would otherwise be overwritten. In these cases, make sure to merge your changes with the ones suggested by CARML.
>
> Also, take special note of any new, required parameter or changed parameter name if you also modified any module's parameter files.

You will notice other changes, such as modified `parameter.json` files and `version.json` files", for which, the upgrade process is explained in more details in the corresponding section.

## Migrate AutoMange module
The original **standalone** AutoManage module was merged into the virtual machine module (as an extension to follow the latest best practices) and subsequently removed.

You can decide to keep the separate module, but note that you can now deploy AutoManage directly with a virtual machine. If you're not using the dedicated module, we recommend removing it altogether.

## Updated outputs
A more extensive, breaking change is the alignment of module outputs.

We removed all references to the module type from the output names. For example:

```bicep
output name string
```
instead of

```bicep
output storageAccountName string
```

The rational is to align all modules and shorten the outputs, as it is intuitive that the `name` output of a module `storageAccount` refers to the name of the storage account.

Migrating to this change (by overwriting the original module templates/outputs) won't affect the CI pipelines and you can use the environment as is. However, if you built solutions using relative paths to the modules, make sure you update any output reference of the same.

## Parameter file name prefix
When migrating, you may notice that many of the resource names in the module parameter files have a placeholder `<<namePrefix>>`. This placeholder is automatically replaced when running any of the CI pipelines and as such, requires changes to the [CI environment](#nameprefix-in-settingsjson) too.

You can remove these placeholders as you see fit, or migrate them together with the changes explained in the [`General pipeline updates`](#general-pipeline-updates) & [` NamePrefix in settings.json`](#nameprefix-in-settingsjson) sections of this guide.

## Version file
A `version.json` file was added to each individual module. Please make sure such a file is added to every module folder in the `arm` folder structure.

For more information on how versioning is handled see [here](https://github.com/Azure/ResourceModules/wiki/PipelinesDesign#publish).

For the modules you copy over, a `version.json` file will already be available. For any modules you created on your end, you will have to add the file yourself.

# CI environment

## General pipeline updates
General updates can be migrated by copying/replacing any code outside of the `arm` folder (i.e., `.github`, `.azuredevops`, `utilities`, `docs`). If you modified the CI environment in the meantime, make sure to carefully merge any conflicting code. Noteworthy changes include:
- renamed composite actions / templates,
- extended placeholder handling,
- extended pipeline functionality (e.g., management group level removal),
- publishing of child modules and
- overall extended publishing using `version.json` files
- additional deployments in the dependencies pipeline

## NamePrefix in settings.json
A change that affects all modules, is the introduction of the `namePrefix` property in the local `settings.json` file.
This prefix is used to simplify the introduction of a "personalized" resource name prefix, avoiding the chance of name conflict with other users.

When migrating, this change should be introduced before or together with the update of the [individual modules](#parameter-file-name-prefix), as their parameter files make have use of this placeholder.

> **Note:** Dependencies pipeline parameter files are affected too.

Also, make sure to change the value of the prefix to a custom value of your choice and not leave it with the default value. The token is used to give all module test deployments a unique flavor (which is especially important for modules that must be globally unique).
