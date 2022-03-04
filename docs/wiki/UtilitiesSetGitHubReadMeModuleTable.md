# GitHub ReadMe Module Table Update Script

Use this script to update a given ReadMe's module table in its 'Available Resource Modules' section.
In the platform's pipeline `platform.updateReadMe.yml`, this script is invoked each time anything in the `arm` path changes to keep the table in sync. It updates both the root ReadMe (`/readme.md`) and `arm` folder ReadMe (`/arm/readme.md`) with a different set of required columns

---

### _Navigation_

- [Location](#location)
- [How it works](#what-it-does)
- [How to use it](#how-to-use-it)

---
# Location

You can find the script under `/utilities/tools/Set-ReadMeModuleTable.ps1`

# How it works

1. The script loads the current content of the given readMe file (the one provided via the parameter `FilePath`)
1. It then generates a new table based on an either specified or default set of intended columns (for example a `name` column, and or `status` column)
1. It replaces the original content in section `Available Resource Modules` with the new table
1. If not invoked with a `-WhatIf` the script will eventually overwrite the original file with the new content

# How to use it

For details on how to use the function please refer to the script's local documentation.
> **Note:** The script must be loaded before the function can be invoked
