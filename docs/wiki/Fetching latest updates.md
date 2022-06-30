CARML library is continuously improved and updated.

This section provides an overview on how to get your library updated.

## CARML updates' impact on your copy of the library
Updates can have different impacts on your version of the library:
- impacts limited to the CI framework

    a general **pipeline update** can be done by copying/replacing any code outside of the `arm` folder. Refer to [Upgrade from 0.3.1 to 0.4.0](./Upgrade%20from%200.3.1%20to%200.4.0#general-pipeline-updates) as an example.

- impacts limited to specific modules

    new created modules or changed ones can be updated by copying/replacing the content of the new `arm` folder on your own `arm` folder. Refer to [Upgrade from 0.3.1 to 0.4.0](./Upgrade%20from%200.3.1%20to%200.4.0#general-import-of-new-modules) as an example.
- impacts on all the modules when design changes are implemented

    you can update your local code by a copy/replace, but comparing your local repository to the updated one, you'll probably find that changes are not limited
    to the `arm` folder, but they impact the `utilities` folder and files contained in the root folder (e.g `settings.json`) in same cases.

Before to proceed with the updates it's always recommended to check the new release's highlights on the [releases](https://github.com/Azure/ResourceModules/releases) page, and the [closed pull requests](https://github.com/Azure/ResourceModules/pulls?q=is%3Apr+is%3Aclosed) to have an overview of what has been changed and the possible impact on your library.

## Customization
Another factor to take into account before updating your local copy of the library is the customization.
### Option 1 - Library improvement
As a [Solution Developer](./The%20context%20-%20Logical%20layers%20and%20personas#solution-developer) you may need to modify existing modules to get a new feature that is not implemented yet or to fix a bug.

In this scenario we recommend to [contribute](./Contribution%20guide) to the public CARML repository, in the spirit of collaboration and open source principles, helping to maintain a common codebase.

In this way your improved code will be part of next updates and releases of the public CARML library and you won't need to take care of customization and do code comparison each time you'll update your local version of the library.
Another advantage is that CARML public modules are tested, so you won't need to mange the test of your customization at each update.

You can also specify a priority when you [create](./Contribution%20guide%20-%20Contribution%20flow#create-or-pick-up-an-issue) the issue so that it's evaluated when updating the public library.

### Option 2 - Specific requirements
As a [Module Developer](./The%20context%20-%20Logical%20layers%20and%20personas#module-developer) you might add to the library  company/organization specifics, either via conventions, parameters, extensions, or CI-specific changes.

In this scenario every time you'll update your own library you'll have to compare the new public code with your customized one and re-apply your customizations to the updated code. This process can be automated, by script or CI, if customization tasks are repeatable.

Public CARML module are not tested with your customization, so you'll also need to manage the test of your updated and customized modules.

We recommend to adopt module library with the CI environment in this case, to automate the import of new code and speed up the test process.

## Update procedure
A different scenario can apply depending on your use of the library:
- [**Scenario 1:** module library only](./Fetching%20latest%20changes%20-%20Scenario%201%20Module%20library%20only). In this case we refer to the update of your copy of module templates that can be stored locally, as Template Specs or on a private Bicep Registry, as explained in [Template Orchestration](./Solution%20creation#template-orchestration).
- [**Scenario 2:** module library and CI environment](./Fetching%20latest%20changes%20-%20Scenario%202%20Module%20library%20and%20CI%20environment). In this case we refer to the update of your internalized library's repository and the related CI environment, this usually happens when adopting the [Pipeline Orchestration](./Solution%20creation#pipeline-orchestration) approach.


