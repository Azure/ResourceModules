<#
.SYNOPSIS
You can use this script to excact a formatted list of RBAC roles used in the CARML modules based on the RBAC lists in Azure

.DESCRIPTION
For modules that manage roleAssignments, update the list of roles to only be the applicable roles. One way of doing this:
- Deploy an instance of the resource you are working on, go to IAM page and copy the list from Roles.
- Use the following script to generate and output the applicable roles needed in the bicep/ARM module:

.NOTES
Raw Roles should look like

$rawRoles = @'
Owner
Grants full access to manage all resources, including the ability to assign roles in Azure RBAC.
BuiltInRole
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
#>

$rawRoles = @'
    <paste the table here>
'@

$resourceRoles = @()
$rawRolesArray = $rawRoles -split "`n"
for ($i = 0; $i -lt $rawRolesArray.Count; $i += 5) {
    $resourceRoles += $rawRolesArray[$i].Trim()
}

$allRoles = az role definition list --custom-role-only false --query '[].{roleName:roleName, id:id, roleType:roleType}' | ConvertFrom-Json

$resBicep = [System.Collections.ArrayList]@()
$resArm = [System.Collections.ArrayList]@()
foreach ($resourceRole in $resourceRoles) {
    $matchingRole = $allRoles | Where-Object { $_.roleName -eq $resourceRole }
    $resBicep += "'{0}': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','{1}')" -f $resourceRole, ($matchingRole.id.split('/')[-1])
    $resArm += "`"{0}`": `"[subscriptionResourceId('Microsoft.Authorization/roleDefinitions','{1}')]`"," -f $resourceRole, ($matchingRole.id.split('/')[-1])
}

Write-Verbose 'Bicep' -Verbose
Write-Verbose '-----' -Verbose
$resBicep

Write-Verbose '' -Verbose
Write-Verbose 'ARM' -Verbose
Write-Verbose '---' -Verbose
$resArm
