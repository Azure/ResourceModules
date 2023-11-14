# Registration Definitions `[Microsoft.ManagedServices/registrationDefinitions]`

This module deploys a `Registration Definition` and a `Registration Assignment` (often referred to as 'Lighthouse' or 'resource delegation')
on subscription or resource group scopes. This type of delegation is very similar to role assignments but here the principal that is
assigned a role is in a remote/managing Azure Active Directory tenant. The templates are run towards the tenant where
the Azure resources you want to delegate access to are, providing 'authorizations' (aka. access delegation) to principals in a
remote/managing tenant.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ManagedServices/registrationAssignments` | [2019-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedServices/2019-09-01/registrationAssignments) |
| `Microsoft.ManagedServices/registrationDefinitions` | [2019-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedServices/2019-09-01/registrationDefinitions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/managed-services.registration-definition:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Rg](#example-2-rg)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module registrationDefinition 'br:bicep/modules/managed-services.registration-definition:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-msrdmax'
  params: {
    // Required parameters
    authorizations: [
      {
        principalId: '<< SET YOUR PRINCIPAL ID 1 HERE >>'
        principalIdDisplayName: 'ResourceModules-Reader'
        roleDefinitionId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
      }
      {
        principalId: '<< SET YOUR PRINCIPAL ID 2 HERE >>'
        principalIdDisplayName: 'ResourceModules-Contributor'
        roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<< SET YOUR PRINCIPAL ID 3 HERE >>'
        principalIdDisplayName: 'ResourceModules-LHManagement'
        roleDefinitionId: '91c1777a-f3dc-4fae-b103-61d183457e46'
      }
    ]
    managedByTenantId: '<< SET YOUR TENANT ID HERE >>'
    name: 'Component Validation - msrdmax Subscription assignment'
    registrationDescription: 'Managed by Lighthouse'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "authorizations": {
      "value": [
        {
          "principalId": "<< SET YOUR PRINCIPAL ID 1 HERE >>",
          "principalIdDisplayName": "ResourceModules-Reader",
          "roleDefinitionId": "acdd72a7-3385-48ef-bd42-f606fba81ae7"
        },
        {
          "principalId": "<< SET YOUR PRINCIPAL ID 2 HERE >>",
          "principalIdDisplayName": "ResourceModules-Contributor",
          "roleDefinitionId": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<< SET YOUR PRINCIPAL ID 3 HERE >>",
          "principalIdDisplayName": "ResourceModules-LHManagement",
          "roleDefinitionId": "91c1777a-f3dc-4fae-b103-61d183457e46"
        }
      ]
    },
    "managedByTenantId": {
      "value": "<< SET YOUR TENANT ID HERE >>"
    },
    "name": {
      "value": "Component Validation - msrdmax Subscription assignment"
    },
    "registrationDescription": {
      "value": "Managed by Lighthouse"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

### Example 2: _Rg_

<details>

<summary>via Bicep module</summary>

```bicep
module registrationDefinition 'br:bicep/modules/managed-services.registration-definition:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-msrdrg'
  params: {
    // Required parameters
    authorizations: [
      {
        principalId: '<< SET YOUR PRINCIPAL ID 1 HERE >>'
        principalIdDisplayName: 'ResourceModules-Reader'
        roleDefinitionId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
      }
      {
        principalId: '<< SET YOUR PRINCIPAL ID 2 HERE >>'
        principalIdDisplayName: 'ResourceModules-Contributor'
        roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<< SET YOUR PRINCIPAL ID 3 HERE >>'
        principalIdDisplayName: 'ResourceModules-LHManagement'
        roleDefinitionId: '91c1777a-f3dc-4fae-b103-61d183457e46'
      }
    ]
    managedByTenantId: '<< SET YOUR TENANT ID HERE >>'
    name: 'Component Validation - msrdrg Resource group assignment'
    registrationDescription: 'Managed by Lighthouse'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    resourceGroupName: '<resourceGroupName>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "authorizations": {
      "value": [
        {
          "principalId": "<< SET YOUR PRINCIPAL ID 1 HERE >>",
          "principalIdDisplayName": "ResourceModules-Reader",
          "roleDefinitionId": "acdd72a7-3385-48ef-bd42-f606fba81ae7"
        },
        {
          "principalId": "<< SET YOUR PRINCIPAL ID 2 HERE >>",
          "principalIdDisplayName": "ResourceModules-Contributor",
          "roleDefinitionId": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<< SET YOUR PRINCIPAL ID 3 HERE >>",
          "principalIdDisplayName": "ResourceModules-LHManagement",
          "roleDefinitionId": "91c1777a-f3dc-4fae-b103-61d183457e46"
        }
      ]
    },
    "managedByTenantId": {
      "value": "<< SET YOUR TENANT ID HERE >>"
    },
    "name": {
      "value": "Component Validation - msrdrg Resource group assignment"
    },
    "registrationDescription": {
      "value": "Managed by Lighthouse"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module registrationDefinition 'br:bicep/modules/managed-services.registration-definition:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-msrdwaf'
  params: {
    // Required parameters
    authorizations: [
      {
        principalId: '<< SET YOUR PRINCIPAL ID 1 HERE >>'
        principalIdDisplayName: 'ResourceModules-Reader'
        roleDefinitionId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
      }
      {
        principalId: '<< SET YOUR PRINCIPAL ID 2 HERE >>'
        principalIdDisplayName: 'ResourceModules-Contributor'
        roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<< SET YOUR PRINCIPAL ID 3 HERE >>'
        principalIdDisplayName: 'ResourceModules-LHManagement'
        roleDefinitionId: '91c1777a-f3dc-4fae-b103-61d183457e46'
      }
    ]
    managedByTenantId: '<< SET YOUR TENANT ID HERE >>'
    name: 'Component Validation - msrdwaf Subscription assignment'
    registrationDescription: 'Managed by Lighthouse'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "authorizations": {
      "value": [
        {
          "principalId": "<< SET YOUR PRINCIPAL ID 1 HERE >>",
          "principalIdDisplayName": "ResourceModules-Reader",
          "roleDefinitionId": "acdd72a7-3385-48ef-bd42-f606fba81ae7"
        },
        {
          "principalId": "<< SET YOUR PRINCIPAL ID 2 HERE >>",
          "principalIdDisplayName": "ResourceModules-Contributor",
          "roleDefinitionId": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<< SET YOUR PRINCIPAL ID 3 HERE >>",
          "principalIdDisplayName": "ResourceModules-LHManagement",
          "roleDefinitionId": "91c1777a-f3dc-4fae-b103-61d183457e46"
        }
      ]
    },
    "managedByTenantId": {
      "value": "<< SET YOUR TENANT ID HERE >>"
    },
    "name": {
      "value": "Component Validation - msrdwaf Subscription assignment"
    },
    "registrationDescription": {
      "value": "Managed by Lighthouse"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizations`](#parameter-authorizations) | array | Specify an array of objects, containing object of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider's Active Directory and the principalIdDisplayName is visible to customers. |
| [`managedByTenantId`](#parameter-managedbytenantid) | string | Specify the tenant ID of the tenant which homes the principals you are delegating permissions to. |
| [`name`](#parameter-name) | string | Specify a unique name for your offer/registration. i.e '<Managing Tenant> - <Remote Tenant> - <ResourceName>'. |
| [`registrationDescription`](#parameter-registrationdescription) | string | Description of the offer/registration. i.e. 'Managed by <Managing Org Name>'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | Specify the name of the Resource Group to delegate access to. If not provided, delegation will be done on the targeted subscription. |

### Parameter: `authorizations`

Specify an array of objects, containing object of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider's Active Directory and the principalIdDisplayName is visible to customers.
- Required: Yes
- Type: array

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location deployment metadata.
- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `managedByTenantId`

Specify the tenant ID of the tenant which homes the principals you are delegating permissions to.
- Required: Yes
- Type: string

### Parameter: `name`

Specify a unique name for your offer/registration. i.e '<Managing Tenant> - <Remote Tenant> - <ResourceName>'.
- Required: Yes
- Type: string

### Parameter: `registrationDescription`

Description of the offer/registration. i.e. 'Managed by <Managing Org Name>'.
- Required: Yes
- Type: string

### Parameter: `resourceGroupName`

Specify the name of the Resource Group to delegate access to. If not provided, delegation will be done on the targeted subscription.
- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `assignmentResourceId` | string | The registration assignment resource ID. |
| `name` | string | The name of the registration definition. |
| `resourceId` | string | The resource ID of the registration definition. |
| `subscriptionName` | string | The subscription the registration definition was deployed into. |

## Cross-referenced modules

_None_

## Notes

### Considerations

This module can be deployed both at subscription and resource group level:

- To deploy the module at resource group level, provide a valid name of an existing Resource Group in the `resourceGroupName` parameter.
- To deploy the module at the subscription level, leave the `resourceGroupName` parameter empty.

#### Permissions required to create delegations

This deployment must be done by a non-guest account in the customer's tenant which has a role with the `Microsoft.Authorization/roleAssignments/write` permission,
such as [`Owner`](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) for the subscription being onboarded (or which contains the resource groups that are being onboarded).

If the subscription was created through the Cloud Solution Provider (CSP) program, any user who has the AdminAgent role in your service provider tenant can perform the deployment.


#### Permissions required to remove delegations

##### From customer side

Users in the customer's tenant who have a role with the `Microsoft.Authorization/roleAssignments/write` permission, such as
[`Owner`](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) can remove service provider
access to that subscription (or to resource groups in that subscription). To do so, the user can go to the Service providers
page of the Azure portal and delete the delegation.

##### From managing tenant side

Users in a managing tenant can remove access to delegated resources if they were granted the
[`Managed Services Registration Assignment Delete Role`](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#managed-services-registration-assignment-delete-role)
for the customer's resources. If this role was not assigned to any service provider users, the delegation can **only** be
removed by a user in the customer's tenant.

#### Limitations with Lighthouse and resource delegation

There are a couple of limitations that you should be aware of with Lighthouse:

- Only allows resource delegation within Azure Resource Manager. Excludes Azure Active Directory, Microsoft 365 and Dynamics 365.
- Only supports delegation of control plane permissions. Excludes data plane access.
- Only supports subscription and resource group scopes. Excludes tenant and management group delegations.
- Only supports built-in roles, with the exception of `Owner`. Excludes the use of custom roles.
