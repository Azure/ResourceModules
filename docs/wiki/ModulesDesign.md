# Modules Design

This section gives you an overview of the design principals the bicep modules follow.

---

### _Navigation_

- [General guidelines](#general-guidelines)
- [File & folder structure](#file--folder-structure)
  - [Naming](#naming)
  - [Structure](#structure)
- [Bicep template guidelines](#bicep-template-guidelines)
  - [Parameters](#parameters)
  - [Variables](#variables)
  - [Resource](#resource)
  - [Outputs](#outputs)
- [ReadMe](#readme)

---

Modules are written in an quite flexible way, therefore you don’t need to modify them from project to project, as the aim is to cover most of the functionality that a given resource type can provide, in a way that you can interact with any module just by sending the required parameters to it – i.e. you don’t have to know how the template of the particular module works inside, just take a look at the readme.md file of the given module to consume it.

The modules are multi-purpose, therefore contain a lot of dynamic expressions (functions, variables, etc.), so there’s no need to maintain multiple instances for different use cases.

They can be deployed in different configurations just by changing the input parameters. They are perceived by the **user** as black boxes, where they don’t have to worry about the internal complexity of the code, as they only interact with them by their parameters.

## General guidelines

- All resource modules in the 'arm' folder should not allow deployment loops on the top level resource but may optionally allow deployment loops on their child-resources.
  > **Example:** The storage account module allows the deployment of a single storage account with, optionally, multiple blob containers, multiple file shares, multiple queues and/or multiple tables.
- The 'constructs' folder contains examples of deployment logic built on top of resource modules contained in the 'arm' folder, allowing for example deployment loops on top level resources.
  > **Example:** The VirtualNetworkPeering construct leverages the VirtualNetworkPeering module to deploy multiple virtual network peerings at once
- Where the resource type in question supports it, the module should have support for:
  1. **Diagnostic logs** and **metrics** (you can have them sent to any combination of storage account, log analytics and event hub)
  2. Resource and child-resource level **RBAC** (for example providing data contributor access on a storage account; granting file share/blob container level access in a storage account)
  3. **Tags** (as objects)
  4. **Locks**
  5. **Private Endpoints** (if supported)

## File & folder structure

A **Module** consists of

- the bicep template deployment file (`deploy.bicep`)
- one or multiple template parameters files (`*parameters.json`) that will be used for testing – located in the `parameters` sub-folder
- a `readme.md` file which describes the module itself

A module usually represents a single resource or a set of closely related resources. For example, a storage account and the associated lock or virtual machine and network interfaces. Modules are located in the `arm` folder.

### Naming

Use the following naming standard for module files and folders:

- Modules name reflect the resource type
- Files and folders within the module folder are all in lower case
- Child-resource modules (in .bicep sub-folder) are named `nested_<childResourceType>.bicep`

``` txt
Microsoft.<provider>
└─ <service>
    ├─ .bicep
    |  ├─ nested_providerResource1.bicep
    |  └─ nested_providerResource2.bicep
    ├─parameters
    |  └─ parameters.json
    ├─ deploy.bicep
    └─ readme.md
```

for example

``` txt
Microsoft.Web
└─ sites
    ├─ .bicep
    |  ├─ nested_rbac.bicep
    |  └─ nested_cuaId.bicep
    ├─parameters
    |  └─ parameters.json
    ├─ deploy.bicep
    └─ readme.md
```

### Structure

Modules in the repository are structured via the module's main resource provider (for example `Microsoft.Web`) and resource type (for example `serverfarms`) where each section of the path corresponds to its place in the hierarchy. However, for cases that do not fit into this schema we provide the following guidance:

- **Child-Resources**<p>

  > Post-MVP

   Resources like `Microsoft.Sql/servers` may have dedicated templates for child-resources such as `Microsoft.Sql/servers/databases`. In these cases we recommend to create a sub-folder called after the child-resource name, so that the path to the child-resource folder is consistent with its resource type. In the given example we would have a sub-folder `databases` in the parent-folder `servers`.

   ```
   Microsoft.Sql
   └─ servers [module]
      └─ databases [child-module/resource]
   ```

   In this folder we recommend to place the child-resource-template alongside a ReadMe (that can be generated via the `.github\workflows\scripts\Set-ModuleReadMe.ps1` script) and optionally further nest additional folders for it's child-resources. The parent template should reference all it's child-templates to allow for an end to end deployment experience while allowing any user to also reference 'just' the child-resource itself. In the case of the SQL-server example the server template would reference the database module and encapsulate it it in a loop to allow for the deployment of n-amount of databases.

<!--
- **Overlapping/Ambigious providers**<p>
  There may be cases where a folder is already leveraged by a different module with the same resource provider. In these cases we recommend to add an additional layer into the hierarchy by moving the module that originally populated the conflicting folder into a sub-folder of the same using a meaningful name. The new module can then be positioned on the same level, again with a meaningful name. For example:
  ```
  Microsoft.<provider>
  ├─ <service1> [module]
  └─ <service2> [the conflicting name - now shared as a parent folder]
     ├─ <service2Variant1> [module]
     └─ <service2Variant2> [module]
  ```

  > ***Note:*** The intend should always be to add new logic to the original template instead of adding artificial new modules. Hence, this solution should only be applied if no other solutions work.
-->

## Bicep template guidelines

Within a bicep file, follow the following conventions:

### Parameters

- camelCase, i.e `resourceGroupName`
- Descriptions contain type of requirement:
  - `Optional` - Is not needed at any point. Module contains default values.
  - `Required` - Is required to be provided. Module does not have a default value and will expect input.
  - `Generated` - Should not be used to provide a parameter. Used to generate data used in the deployment that cannot be generated other places in the template. i.e. the `utcNow()` function.
  - `Conditional` - Optional or required parameter depending on other inputs.

### Variables

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

### Resource

- camelCase, i.e `resourceGroup`
- The name used as a reference is the singular name of the resource that it deploys, i.e:
  - `resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01'`
  - `resource virtualMachine 'Microsoft.Compute/virtualMachines@2020-06-01'`
- For child resources, use a shorthand of the resource type declaration, i.e:
  - `resource serviceBusNamespace_authorizationRules 'AuthorizationRules@2020-06-01'`

- Modules:
  - camel_Snake_Case, i.e `resourceGroup_rbac` ?
  - All module references go into a child folder on the module called `.bicep`
  - File name for nested module is structured as follows: `nested_<resourceName>.bicep` i.e:
    - `nested_rbac.bicep`

> Post-MVP

- Child-resources go into a sub-folder with the name of the child (for example `databases` in case of the SQL server module).

### Outputs

- camelCase, i.e `resourceGroupResourceId`
- At a minimum, reference the following:
  - `<resourceReference>Name`, i.e. `resourceGroupName`
  - `<resourceReference>ResourceId`, i.e. `resourceGroupResourceId`
- Add a `@description('...')` annotation with meaningful description to each output


## ReadMe

Each module must come with a ReadMe markdown file that outlines what the module contains and 'how' it can be used.
It primary components are
- A title with a reference to the primary resource (for example <code>KeyVault `[Microsoft.KeyVault/vaults]`</code>)
- A description
- A table that outlines all resources that can be deployed as part of the module (Resource Types)
- A table that shows all parameters, what they are used for, what values they allow, etc. (Parameters)
- A custom 'Parameter Usage' section that show how to use special types of characters (e.g. roleAssignments)
- A table that describes all outputs the module template returns
- A  references table to directly jump to the resources [ARM template reference](https://docs.microsoft.com/en-us/azure/templates)

Note the following recommendations
- Use our module generation script `Set-ModuleReadMe` that will do most of the work for you. Currently you can find it at 'utilities\tools\Set-ModuleReadMe.ps1'. Just load the file and invoke the function like this `Set-ModuleReadMe -TemplateFilePath '<pathToModule>/deploy.bicep'`
- It is not recommended to describe how to use child resources in the parent readme file (for example 'How to define a [container] entry for the [storage account]'). Instead it is recommended to reference the child resource's ReadMe instead (for example 'container/readme.md').
