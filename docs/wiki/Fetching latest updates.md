CARML library is continuously improved and updated.

This section provides an overview on how to get your library updated.

## CARML updates' impact on your copy of the library
Updates can have different impacts on your version of the library:
- impacts limited to the CI framework

    a general **pipeline update** can be done by copying/replacing any code outside of the  `arm` folder. Refer to [Upgrade from 0.3.1 to 0.4.0](./Upgrade%20from%200.3.1%20to%200.4.0.md#general-pipeline-updates) as an example.

- impacts limited to specific modules

    new or updated modules can be updated by copying/replacing the content of the new `arm` folder on your own `arm` folder. Refer to [Upgrade from 0.3.1 to 0.4.0](./Upgrade%20from%200.3.1%20to%200.4.0.md#general-import-of-new-modules) as an example.
- impacts on all the modules, when some design changes are implemented.

    you can update your local code by a copy/replace again, but you need to compare your local repository to the updated one, not only on the `arm` folder level, but also on the `utilities` and on files that can be in the root folder (e.g `settings.json`) in same cases.

Before to proceed with the updates it's always recommended to check the new release's highlights on the [releases](https://github.com/Azure/ResourceModules/releases) page, and the [closed pull requests](https://github.com/Azure/ResourceModules/pulls?q=is%3Apr+is%3Aclosed) to have an overview of what as been changed and the possible impact on your library.
## Update procedure
A different scenario can apply depending on your use of the library:
- [**Scenario 1:** module library only](./Fetching%20latest%20changes%20-%20Scenario%201%20Module%20library%20only.md). In this case we refer to the update of your copy of module templates that can be stored locally, as Template Specs or on a private Bicep Registry, as explained in [Template Orchestration](./Solution%20creation.md#template-orchestration).
- [**Scenario 2:** module library and CI environment](./Fetching%20latest%20changes%20-%20Scenario%202%20Module%20library%20and%20CI%20environment.md). In this case we refer to the update of your internalized library's repository and the related CI environment, this usually happens when adopting the [Pipeline Orchestration](./Solution%20creation.md#pipeline-orchestration) approach.


