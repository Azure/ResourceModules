## Contribution

### Setting up yopur environment for contribution

1. Fork and clone the repo.
  * Set up a upstream, to pull from the Azure/ResourceModule repo (integration check before PR).
   ```
     git remote add upstream https://github.com/Azure/ResourceModules
     git fetch upstream
   ```

2. Set up a secret in your repo for `AZURE_CREDENTIALS` for testing changes with workflows in your own environment. The permissions that the SPN needs differ between modules. Required permissions are in some cases documented in the modules readme. See [Azure/login](https://github.com/Azure/login) for more info about the secret creation.

3. Create a branch in your own repo and do the changes. The PR will be between your working fork/branch and <upstream>/main. For the PR, follow the PR template.

4. Follow the guidelines below for the changes you do when converting/creating a module.
  * To convert a json template to bicep use `bicep decompile deploy.json --outfile deploy.bicep`
  * To convert from bicep to json use `bicep build deploy.bicep --outfile deploy.json`

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
