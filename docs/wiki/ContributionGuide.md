# Contribution
This section outlines how you can contribute to the repository.

---
### _Navigation_
- [Set your environment up](#Set-your-environment-up)
---

## Set your environment up

The preferred method of contribution requires you to create your own fork and create pull requests into the source repository from there. To set the fork up, please follow the process described in the [Getting started section](./GettingStarted#Option-1-Use-it-as-a-basis-to-set-up-your-own-inner-source-project)

### How to contribute a module?

Modules in the repository are structured via the module's main resource provider (e.g. `Microsoft.Web/serverfarms`) where each section corresponds to its place in the hierarchy. However, for cases that do not fit into this schema we provide the following guidance:
- **Sub-Resources**<p>
  Resources like `Microsoft.Sql/servers` may have dedicated modules for sub-resources such as `Microsoft.Sql/servers/databases`. In these cases we recommend to create a subfolder with the 'parent folder name and suffix `"Resources"`' on the same level as the parent (e.g. `serversResources`) and place the sub-resource module inside this folder. In the given example we would have the following folder structure:
  ```
  Microsoft.Sql
  ├─ servers [module]
  └─ serversResources
     └─ databases [module]
  ```
- **Overlapping/Ambigious providers**<p>
  There may be cases where a folder is already leveraged by a different module with the same provider (e.g. `Microsoft.Web/sites`). In these cases we recommend to add an additional layer into the hierarchy by moving the module that originally populated the conflicting folder into a sub-folder of the same using a meaningful name. The new module can then be positioned on the same level, again with a meaningful name. For example:
  ```
  Microsoft.Web
  ├─ serverfarms [module]
  └─ sites [the conflicting name - now shared as a parent folder]
     ├─ webApp [module]
     └─ functionApp [module]
  ```
