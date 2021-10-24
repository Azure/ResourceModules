# Modules Design

This section gives you an overview of the design principals the bicep modules follow.

---
### _Navigation_
- [General guidelines](#General-guidelines)
- [File & folder structure](#File-&-folder-structure)
  - [Naming](#Naming)
  - [Structure](#Structure)
- [Bicep template guidelines](#Bicep-template-guidelines)
---

## General guidelines
- All modules & child-templates, excluding those in the 'constructs' folder should be designed in the way that they can deploy one single instance of the targeted resource and optionally n-amount of child-resources if available. In the example of the storage account module that means the module should be able to deploy **one** storage account but for example **n-amount** of containers, file shares and so on. However, the child-template for for example the container should again be designed to only deploy one container.
- Any logic that is build on top (for example the name generation and corresponding deployment-loop for the VM-module) should be implemented in the 'constructs' folder, referencing back to the original template.

## File & folder structure

### Naming

Files and folders within the module folder are all in lower case.

``` txt
Microsoft.Web
└─ sites
    ├─ .bicep
    |  ├─ nested_providerResource1.bicep
    |  └─ nested_providerResource2.bicep
    ├─parameters
    |  └─ parameters.json
    ├─ deploy.bicep
    └─ readme.md
```

### Structure

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


## Bicep template guidelines

Within a bicep file, follow the following conventions:

- Parameters:
  - camelCase, i.e `resourceGroupName`
  - Descriptions contain type of requirement:
    - `Optional` - Is not needed at any point. Module contains default values.
    - `Required` - Is required to be provided. Module does not have a default value and will expect input.
    - `Generated` - Should not be used to provide a parameter. Used to generate data used in the deployment that cannot be generated other places in the template. i.e. the `utcNow()` function.
    - `Conditional` - Optional or required parameter depending on other inputs.

- Variables:
  - camelCase, i.e `builtInRoleNames`
  - For modules that manage roleAssignments, update the list of roles to only be the applicable roles. One way of doing this:
    - Deploy an instance of the resource you are working on, go to IAM page and copy the list from Roles.
    - Use the following script to generate and output the applicable roles needed in the bicep/ARM module:

      ```PowerShell
      $rawRoles = @"
      <paste the table here>
      "@
      $resourceRoles = @()
      $rawRolesArray = $rawRoles -split "`n"
      for ($i = 0; $i -lt $rawRolesArray.Count; $i++) {
        if($i % 5 -eq 0) {
          $resourceRoles += $rawRolesArray[$i].Trim()
        }
      }
      $allRoles = az role definition list --custom-role-only false --query '[].{roleName:roleName, id:id, roleType:roleType}' | ConvertFrom-Json
      $resBicep = [System.Collections.ArrayList]@()
      $resArm = [System.Collections.ArrayList]@()
      foreach ($resourceRole in $resourceRoles) {
        $matchingRole = $allRoles | Where-Object { $_.roleName -eq $resourceRole }
        $resBicep += "'{0}': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','{1}')" -f $resourceRole, ($matchingRole.id.split('/')[-1])
        $resArm += "`"{0}`": `"[subscriptionResourceId('Microsoft.Authorization/roleDefinitions','{1}')]`"," -f $resourceRole, ($matchingRole.id.split('/')[-1])
      }
      Write-Host "Bicep"
      Write-Host "-----"
      $resBicep
      Write-Host "ARM"
      Write-Host "---"
      $resArm
      ```

- Resource:
  - camelCase, i.e `resourceGroup`
  - The name used as a reference is the singular name of the resource that it deploys, i.e:
    - `resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01'`
    - `resource virtualMachine 'Microsoft.Compute/virtualMachines@2020-06-01'`
  - For child resources, use a shorthand of the resource type declaration, i.e:
    - `resource serviceBusNamespace_authorizationRules 'AuthorizationRules@2020-06-01'`

- Modules:
  - camel_Snake_Case, i.e `resourceGroup_rbac` ?
  - All provider references go into a child folder on the module called `.bicep`
  - File name for nested module is structured as follows: `nested_<resourceName>.bicep` i.e:
    - `nested_rbac.bicep`

  > Post-MVP
  - Child-resources go into a sub-folder with the name of the child (for example `databases` in case of the SQL server module).

- Outputs:
  - camelCase, i.e `resourceGroupResourceId`
  - At a minimum, reference the following:
    - `<resourceReference>Name`, i.e. `resourceGroupName`
    - `<resourceReference>ResourceId`, i.e. `resourceGroupResourceId`
