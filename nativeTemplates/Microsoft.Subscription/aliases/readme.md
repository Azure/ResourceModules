# Subscription

This template will create a subscription based on the provided parameter.

## Resource types

| Resource Type                             | Api Version        |
| :---------------------------------------- | :----------------- |
| `Microsoft.Resources/deployments`         | 2019-10-01         |
| `Microsoft.Subscription/aliases`          | 2020-09-01         |
| `Microsoft.Resources/tags`                | 2020-10-01         |
| `Microsoft.Authorization/roleAssignments` | 2018-09-01-preview |

### Resource dependency

The following resources are required to be able to deploy this resource:

- *None*

## Parameters

| Parameter Name            | Type   | Default Value | Possible values     | Description                                                               |
| :------------------------ | :----- | :------------ | :------------------ | :------------------------------------------------------------------------ |
| `subscriptionAliasName`   | string |               |                     | Required. Unique alias name.                                              |
| `displayName`             | string |               |                     | Required. Subscription display name.                                      |
| `targetManagementGroupId` | string | ""            |                     | Optional. Target management group where the subscription will be created. |
| `billingScope`            | string |               |                     | Required. The account to be invoiced for the subscription.                |
| `workload`                | string | Production    | Production, DevTest | Optional. Subscription workload.                                          |
| `tags`                    | object | []            |                     | Optional. Tags of the storage account resource.                           |
| `roleAssignments`         | array  | []            |                     | Optional. Array of role assignment objects.                               |

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        // Built-in Role Definition, referenced by Name
        {
          "roleDefinitionIdOrName": "Owner",
          "principalIds": [
            "12345678-1234-1234-1234-123456780123"
            "abcd5678-1234-1234-1234-123456780123"
          ]
        },
        // Built-in Role Definition, referenced by ID
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456780123"
                "abcd5678-1234-1234-1234-123456780123"
            ]
        },
        // Custom Role Definition on Subscription scope
        {
            "roleDefinitionIdOrName": "/subscriptions/bbfef42b-7d75-4e17-9f39-bd431e69189f/providers/Microsoft.Authorization/roleDefinitions/54597af5-2126-5a52-a2ce-4bb56e90d3c8",
            "principalIds": [
                "12345678-1234-1234-1234-123456780123"
                "abcd5678-1234-1234-1234-123456780123"
            ]
        },
        // Custom Role Definition on Resource Group scope
        {
            "roleDefinitionIdOrName": "/subscriptions/bbfef42b-7d75-4e17-9f39-bd431e69189f/resourceGroups/rbacTest/providers/Microsoft.Authorization/roleDefinitions/08e417aa-3d20-5a4e-94da-b2aa45bd5929",
            "principalIds": [
                "12345678-1234-1234-1234-123456780123"
                "abcd5678-1234-1234-1234-123456780123"
            ]
        }
    ]
}
```

## Outputs

| Output Name       | Type   | Description                                      |
| :---------------- | :----- | :----------------------------------------------- |
| `subscriptionId`  | string | The subscription Id of the created subscription. |
| `tags`            | object | The tags applied to the subscription.            |
| `roleAssignments` | array  | Array of role assignment objects.                |

## Prerequisites

In order to create a subscription via code, the following pre-requisites are necessary:

- the used enrollment account in the billing scope is active and created at least one subscription manually
- A single SPN used for the template deployment with permissions to both:
  - the billing scope of the EA enrollment account.
  - deployments on the tenant scope and management group where the subscription will be provisioned.

### Permissions to create subscriptions

Refer to the [Enterprise-Scale - Enabling subscription creation](https://github.com/Azure/Enterprise-Scale/blob/main/docs/Deploy/enable-subscription-creation.md) guide on how to setup permissions. If this does not align with your scenario, please refer to the [official documentation on creating subscriptions using the API](https://docs.microsoft.com/en-us/azure/cost-management-billing/manage/programmatically-create-subscription-preview).
If you cannot find the billingID or enrollmentID using the mentioned guides, find them using the Azure portal under the 'Cost + Billing' blade. Expected format is 5-10 digits for each of the values.

### Permissions to deploy Azure Resource in tenant

The subscription module is deployed on the **Tenant scope**. Providing the [required permissions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-tenant#required-access) is not supported in the portal.
To run the commands listed here you need `User Access Administrator` or `Owner` on the tenant scope (also refered to root or '/') . Follow the [official documentation for how to elevate your permissions](https://docs.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin) to this level.

#### Quick setup

Using a quick setup we assign `Owner` on the root, allowing for all other activities within the Azure tenant. Quick setup is not recommended in production, as it breaks with principle of least privilege and would potentially scope permissions wider than applicable for your scenario.
Use quick setup for 'Minimal Viable Product' (MVP) configurations, PoC setups or test environments.

To assign `Owner` role on root to the SPN, execute the following commands:

```powershell
$SPNObjectID = Get-AzADServicePrincipal -DisplayName "[SPNName]"
New-AzRoleAssignment -ObjectID $SPNObjectID -Scope "/" -RoleDefinitionName "Owner"
```

> Note!
>
> Remember to [remove your elevated access](https://docs.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin#remove-elevated-access) after assigning the permissions on the entity that requires the permissions on root.

#### Least-privilege approach

If `Owner` permission is too excessive, provide least privilege permissions to the entity used for deploying subscriptions.
As [custom roles are not supported on the root level](https://docs.microsoft.com/en-us/azure/role-based-access-control/custom-roles#custom-role-limits), a built-in role is required.
The build-in role with the least privilege to perform the `Microsoft.Resources/deployments/*` actions is `Automation Job Operator`.

To assign `Automation Job Operator` role on root to the SPN, execute the following commands:

```powershell
$SPNObjectID = Get-AzADServicePrincipal -DisplayName "[SPNName]"
New-AzRoleAssignment -ObjectID $SPNObjectID -Scope "/" -RoleDefinitionName "Automation Job Operator"
```

A custom role can be created for with following permissions on a management group when using the template by providing the `targetManagementGroup` parameter. Using this parameter will move the subscription to them management group.

- `Microsoft.Management/managementGroups/read`
- `Microsoft.Management/managementGroups/write`
- `Microsoft.Management/managementGroups/subscriptions/delete`
- `Microsoft.Management/managementGroups/subscriptions/write`

Scope: `/providers/Microsoft.Management/managementGroups/<targetManagementGroup>`

Consider adding more of the [`Microsoft.Management`](https://docs.microsoft.com/en-us/azure/role-based-access-control/resource-provider-operations#microsoftmanagement) and [`Microsoft.Subscription`](https://docs.microsoft.com/en-us/azure/role-based-access-control/resource-provider-operations#microsoftsubscription) operations to the custom role as needed.

## Additional resources

- [Use tags to organize your Azure resources | Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [Azure Resource Manager template reference | Microsoft Docs](https://docs.microsoft.com/en-us/azure/templates/)
- [Deployments | Microsoft Docs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2019-10-01/deployments)
- [Aliases | Microsoft Docs](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Subscription/2020-09-01/aliases)
- [Programmatically create Azure subscriptions with preview APIs | Microsoft Docs](https://docs.microsoft.com/en-us/azure/cost-management-billing/manage/programmatically-create-subscription-preview)
- [Enable subscription creation to a service principal | GitHub](https://github.com/Azure/Enterprise-Scale/blob/main/docs/Deploy/enable-subscription-creation.md)
