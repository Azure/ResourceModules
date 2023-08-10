In this scenario you have onboarded only the module library as described in [Getting started Scenario 1- Consume library](./Getting%20started%20-%20Scenario%201%20Consume%20library) and you would therefore need to fetch latest changes for the modules.

Modules can be stored in an accessible location like local, Template Specs, Bicep Registry or ADO universal packages.

The update process is the following:

1. [Backup your local copy of the library](#1-backup-your-local-copy-of-the-library)
1. [Download the library](#2-download-the-library)
1. [(Optional) Convert library to ARM](#3-optional-convert-library-to-arm)
1. [(Optional) Customize modules](#4-optional-customize-modules)
1. [Test and publish modules](#5-test-and-publish-modules)

# 1. Backup your local copy of the library

Rename your local repository. Assuming the local repository location is `'D:\ResourcesModules'` rename it in `'D:\ResourcesModules_Backup'`.

# 2. Download the library

To download the updated library follow the best option for your scenario, as explained in [Download the library](./Getting%20started%20-%20Scenario%201%20Consume%20library#1-download-the-library)

# 3. (Optional) Convert library to ARM

In case you aren't using Bicep you need to follow this procedure: [(Optional) Convert library to ARM](./Getting%20started%20-%20Scenario%201%20Consume%20library#2-optional-convert-library-to-arm)

# 4. (Optional) Customize modules

The backup folder from step 1, can be used to compare customized modules with the ones coming from the latest version and to implement the required changes. For example, the `'Compare selected'` [function](https://vscode.one/diff-vscode/) in Visual Studio Code can be leveraged for that purpose.

If your copy deviates from the upstream version due to customizations you applied to the code, you'll have to re-apply your customizations to the updated code. This process may be automated, by script or CI, if customization tasks are repeatable.

> **Note**: If customizations are general improvements which may be useful for the public, the recommendation is to [contribute](./Contribution%20guide) to the public CARML repository so that your updates can improve the public library. This way, your changes will already be available the next time you fetch from upstream, as modules would already been tested, and would not conflict with your customizations.

# 5. Test and publish modules

To test and publish updated modules, follow the best option for your scenario in [Test and publish modules](./Getting%20started%20-%20Scenario%201%20Consume%20library#3-test-and-publish-modules)

> **Note:** It may be the case that names of modules changed. While this won't have an effect on any existing solution you may have based on the library, it will mean that for new module versions you will need to adopt the new module names.
