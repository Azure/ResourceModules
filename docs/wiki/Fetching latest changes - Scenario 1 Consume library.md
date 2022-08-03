In this scenario you have onboarded only the module library as described in [Getting started Scenario 1- Consume library](./Getting%20started%20-%20Scenario%201%20Consume%20library) and you would therefore need to fetch latest changes for the modules.

Modules can be stored in an accessible location like local, Template Specs, Bicep Registry or ADO universal packages.

The update process is the following:

### _Navigation_

- [1. Backup your local copy of the library](#1-backup-your-local-copy-of-the-library)
- [2. Download the library](#2-download-the-library)
- [3. (Optional) Convert library to ARM](#3-optional-convert-library-to-arm)
- [4. (Optional) Customize modules](#4-optional-customize-modules)
- [5. Test and publish modules](#5-test-and-publish-modules)

# 1. Backup your local copy of the library

Rename your local repository. Assuming the local repository location is `'D:\ResourcesModules'` rename it in `'D:\ResourcesModules_Backup'`.

The backup folder can be used to compare customized modules with the ones coming from the latest version and implement the required changes.

This can be done, for example, by the `'Compare selected'` [function](https://vscode.one/diff-vscode/) of Visual Studio Code.

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

To test and publish updated modules follow the best option for your scenario in [Test and publish modules](./Getting%20started%20-%20Scenario%201%20Consume%20library#3-test-and-publish-modules)

