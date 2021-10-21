This section gives you an overview of the design principals the bicep modules follow.

---
### _Navigation_
- [Bicep module authoring guidelines](#Bicep-module-authoring-guidelines)
---


# Bicep module authoring guidelines

Files and folders within the module folder are all in lower case.

``` txt
    Microsoft.Web
    └─ sites
       ├─ .bicep
       |  ├─ nested_resourceName1.bicep
       |  └─ nested_resourceName2.bicep
       ├─parameters
       |  └─ parameters.json
       ├─ deploy.bicep
       └─ readme.md
```

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
  - All module references go into a child folder on the module called `.bicep`
  - File name for nested module is structured as follows: `nested_<resourceName>.bicep` i.e:
    - `nested_rbac.bicep`

- Outputs:
  - camelCase, i.e `resourceGroupResourceId`
  - At a minimum, reference the following:
    - `<resourceReference>Name`, i.e. `resourceGroupName`
    - `<resourceReference>ResourceId`, i.e. `resourceGroupResourceId`
