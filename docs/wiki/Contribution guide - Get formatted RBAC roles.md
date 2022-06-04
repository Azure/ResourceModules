Use this script to format a given raw 'Roles' table from Azure to the format required by either Bicep or ARM/JSON Templates in any RBAC deployment.

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [How to use it](#how-to-use-it)

---
# Location

You can find the script under `/utilities/tools/Get-FormattedRBACRoles.ps1`

# How it works

1. From the provided raw and plain roles list, create a list of only the contained role names
1. Fetch all available roles from Azure
1. Go through all provided role names, match them with those from Azure to get the matching RoleDefinitionId and format a string like `'<roleName>': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','<roleDefinitionId>')` for each match
1. Print the result to the terminal

# How to use it

The script does not accept any custom parameter per se, but expects you to replace the placeholder in the `rawRoles` variable inside the script

```PowerShell
$rawRoles = @'
    <paste the table here>
'@
```

To get the list of roles in the expected format:
1. Navigate to Azure
1. Deploy one instance of the service you want to fetch the roles for
1. Navigate to the `Access Control (IAM)` blade in the resource
1. Open the `Roles` tab
1. Set the `Type` in the dropdown to `BuiltInRole`

   <img src="./media/ContributionGuide/rbacRoles.png" alt="Complete deployment flow filtered" height="300">

1. Select and copy the entire table as is to the PowerShell variable.

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
1. Copy the output into the RBAC file into the `buildInRoleNames` variable. Again, for the same example using bicep this would be:

   ```bicep
   var builtInRoleNames = {
      'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
      'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
      'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
   }
   ```

For further details on how to use the function, please refer to the script's local documentation.
> **Note:** The script must be loaded before the function can be invoked
