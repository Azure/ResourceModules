# Contribution
This section outlines how you can contribute to the repository.

---
### _Navigation_
- [Set your environment up](#Set-your-environment-up)
- [How to contribute a module?](#How-to-contribute-a-module?)
---

## Set your environment up

The preferred method of contribution requires you to create your own fork and create pull requests into the source repository from there. To set the fork up, please follow the process described in the ['getting started'](./GettingStarted#Option-1-Use-it-as-a-basis-to-set-up-your-own-inner-source-project) section.

## How to contribute a module?

Modules in the repository are structured via the module's main resource provider (e.g. `Microsoft.Web/serverfarms`) where each section corresponds to its place in the hierarchy. However, for cases that do not fit into this schema we provide the following guidance:
- **Child-Resources**<p>
  > Pre-MVP

  Resources like `Microsoft.Sql/servers` may have dedicated modules for child-resources such as `Microsoft.Sql/servers/databases`. In these cases we recommend to create a childfolder with the 'parent folder name and suffix `"Resources"`' on the same level as the parent (e.g. `serversResources`) and place the child-resource module inside this folder. In the given example we would have the following folder structure:
  ```
  Microsoft.Sql
  ├─ servers [module]
  └─ serversResources
     └─ databases [module]
  ```

  > Post-MVP

   Resources like `Microsoft.Sql/servers` may have dedicated templates for child-resources such as `Microsoft.Sql/servers/databases`. In these cases we recommend to create a folder within the parent by the name of set child. In the given example we would have a child-folder `databases` in the parent-folder `servers`.

   ```
   Microsoft.Sql
   └─ servers [module]
      └─ databases [child-module/resource]
   ```


   In this folder we'd recommed to place the child-resource-template alongside a ReadMe (that can be generated via the `.github\workflows\scripts\Set-ModuleReadMe.ps1` script) and optionally further nest additional folders for it's child-resources, and so on and so forth. The parent template should reference all it's child-templates to allow for an end to end deployment experience while allowing any user to also reference 'just' the child-resource itself. In the case of the SQL-server example the server template would reference the database module and encapsulate it it in a loop to allow for the deployment of n-amount of databases.

- **Overlapping/Ambigious providers**<p>
  There may be cases where a folder is already leveraged by a different module with the same provider (e.g. `Microsoft.Web/sites`). In these cases we recommend to add an additional layer into the hierarchy by moving the module that originally populated the conflicting folder into a child-folder of the same using a meaningful name. The new module can then be positioned on the same level, again with a meaningful name. For example:
  ```
  Microsoft.Web
  ├─ serverfarms [module]
  └─ sites [the conflicting name - now shared as a parent folder]
     ├─ webApp [module]
     └─ functionApp [module]
  ```
