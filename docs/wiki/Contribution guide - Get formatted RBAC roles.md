Use this script to get the roles for a given Provider Namespace & Resource Type in the format required by either Bicep or ARM/JSON Templates in any RBAC deployment.

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [How to use it](#how-to-use-it)

---
# Location

You can find the script under [`/utilities/tools/Get-RoleAssignmentList.ps1`](https://github.com/Azure/ResourceModules/blob/main/utilities/tools/Get-RoleAssignmentList.ps1)

# How it works

This script
1. Fetches all available roles from Azure
1. Filters them down to any role that include the provided provider namespace & resource type
1. Goes through all provided role names, matches them with those from the Azure portal to get the matching RoleDefinitionId and provides an output string, formatted like `'<roleName>': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','<roleDefinitionId>')` for each match
1. Returns the result as an object with a key for the Bicep & ARM format respectively

# How to use it

The script only expects you to provide the Provider Namespace & Resource Type for which you want to fetch the roles for.

1. Run the script with for example the parameters for the KeyVault: `Get-RoleAssignmentList -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'`. The output would for example be

   ```yml
   VERBOSE: Bicep
   VERBOSE: -----
      Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b24988ac-6180-42a0-ab88-20f7382dd24c')
      'Key Vault Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','00482a5a-887f-4fb3-b363-3b7fe8e74483')
      Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
      Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','acdd72a7-3385-48ef-bd42-f606fba81ae7')
      (...)
   VERBOSE:
   VERBOSE: ARM
   VERBOSE: ---
      "Owner":       "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions','8e3af657-a8ff-443c-a75c-2fe8c4bcb635')]",
      "Contributor": "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b24988ac-6180-42a0-ab88-20f7382dd24c')]",
      "Reader":      "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions','acdd72a7-3385-48ef-bd42-f606fba81ae7')]",
      "Key Vault Administrator": "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions','00482a5a-887f-4fb3-b363-3b7fe8e74483')]",
      (...)
   ```
1. Copy the output into the RBAC file into the `builtInRoleNames` variable. For the same example, using Bicep this would be:

   ```bicep
   var builtInRoleNames = {
      Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b24988ac-6180-42a0-ab88-20f7382dd24c')
      'Key Vault Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','00482a5a-887f-4fb3-b363-3b7fe8e74483')
      Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
      Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','acdd72a7-3385-48ef-bd42-f606fba81ae7')
   }
   ```

For further details on how to use the function, please refer to the script's local documentation.
> **Note:** The script must be loaded ('*dot-sourced*') before the function can be invoked.
