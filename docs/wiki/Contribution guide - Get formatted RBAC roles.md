Use this script to format a given raw 'Roles' table from the Azure portal to the format required by either Bicep or ARM/JSON Templates in any RBAC deployment.

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [How to use it](#how-to-use-it)

---
# Location

You can find the script under [`/utilities/tools/Get-FormattedRBACRoles.ps1`](../../utilities/tools/Get-FormattedRBACRoleList.ps1)

# How it works

This script
1. Leverages a list of role names that the Azure portal provides for a given resource type
1. Fetches all available roles from Azure
1. Goes through all provided role names, matches them with those from the Azure portal to get the matching RoleDefinitionId and provides an output string, formatted like `'<roleName>': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','<roleDefinitionId>')` for each match
1. Prints the result to the terminal

# How to use it

The script does not accept any custom parameters, but expects you to replace the placeholder in the `rawRoles` 'here-string' variable inside the script with the value fetched from the Azure portal, as detailed below.

```PowerShell
$rawRoles = @'
    <paste the table here>
'@
```

To get the list of roles in the expected format:
1. Navigate to the Azure portal
1. Deploy one instance of the service you want to fetch the roles for
1. Navigate to the `Access Control (IAM)` blade in the resource
1. Open the `Roles` tab
1. Set the `Type` in the dropdown to `BuiltInRole`

   <img src="./media/ContributionGuide/rbacRoles.png" alt="Complete deployment flow filtered" height="300">

1. Select and copy the entire table as is to the `$rawRoles` 'here-string' PowerShell variable.

   The result should look similar to

   ```PowerShell
   $rawRoles = @'
   Owner
   Grants full access to manage all resources, including the ability to assign roles in Azure RBAC.
   builtInRole
   General
   View
   Contributor
   Grants full access to manage all resources, but does not allow you to assign roles in Azure RBAC, manage assignments in Azure Blueprints, or share image galleries.
   BuiltInRole
   General
   View
   Reader
   View all resources, but does not allow you to make any changes.
   BuiltInRole
   General
   View
   '@
   ```
1. Run the script. The output for the above example would be

    ```yml
    VERBOSE: Bicep
    VERBOSE: -----
     'Owner':       subscriptionResourceId('Microsoft.Authorization/roleDefinitions','8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
     'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b24988ac-6180-42a0-ab88-20f7382dd24c')
     'Reader':      subscriptionResourceId('Microsoft.Authorization/roleDefinitions','acdd72a7-3385-48ef-bd42-f606fba81ae7')
    VERBOSE:
    VERBOSE: ARM
    VERBOSE: ---
     "Owner":       "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions','8e3af657-a8ff-443c-a75c-2fe8c4bcb635')]",
     "Contributor": "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b24988ac-6180-42a0-ab88-20f7382dd24c')]",
     "Reader":      "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions','acdd72a7-3385-48ef-bd42-f606fba81ae7')]",
    ```
1. Copy the output into the RBAC file into the `builtInRoleNames` variable. For the same example, using Bicep this would be:

   ```bicep
   var builtInRoleNames = {
      'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
      'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
      'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
   }
   ```

For further details on how to use the function, please refer to the script's local documentation.
> **Note:** The script must be loaded ('*dot-sourced*') before the function can be invoked.
