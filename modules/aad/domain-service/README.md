# Azure Active Directory Domain Services `[Microsoft.AAD/domainServices]`

This module deploys an Azure Active Directory Domain Services (AADDS).

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Considerations](#Considerations)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AAD/domainServices` | [2021-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AAD/2021-05-01/domainServices) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `domainName` | string | The domain name specific to the Azure ADDS service. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `pfxCertificate` | securestring | `''` | The certificate required to configure Secure LDAP. Should be a base64encoded representation of the certificate PFX file. Required if secure LDAP is enabled and must be valid more than 30 days. |
| `pfxCertificatePassword` | securestring | `''` | The password to decrypt the provided Secure LDAP certificate PFX file. Required if secure LDAP is enabled. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `additionalRecipients` | array | `[]` |  | The email recipient value to receive alerts. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', AccountLogon, AccountManagement, allLogs, DetailTracking, DirectoryServiceAccess, LogonLogoff, ObjectAccess, PolicyChange, PrivilegeUse, SystemSecurity]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `domainConfigurationType` | string | `'FullySynced'` | `[FullySynced, ResourceTrusting]` | The value is to provide domain configuration type. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `externalAccess` | string | `'Enabled'` | `[Disabled, Enabled]` | The value is to enable the Secure LDAP for external services of Azure ADDS Services. |
| `filteredSync` | string | `'Enabled'` |  | The value is to synchronize scoped users and groups. |
| `kerberosArmoring` | string | `'Enabled'` | `[Disabled, Enabled]` | The value is to enable to provide a protected channel between the Kerberos client and the KDC. |
| `kerberosRc4Encryption` | string | `'Enabled'` | `[Disabled, Enabled]` | The value is to enable Kerberos requests that use RC4 encryption. |
| `ldaps` | string | `'Enabled'` | `[Disabled, Enabled]` | A flag to determine whether or not Secure LDAP is enabled or disabled. |
| `location` | string | `[resourceGroup().location]` |  | The location to deploy the Azure ADDS Services. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `name` | string | `[parameters('domainName')]` |  | The name of the AADDS resource. Defaults to the domain name specific to the Azure ADDS service. |
| `notifyDcAdmins` | string | `'Enabled'` | `[Disabled, Enabled]` | The value is to notify the DC Admins. |
| `notifyGlobalAdmins` | string | `'Enabled'` | `[Disabled, Enabled]` | The value is to notify the Global Admins. |
| `ntlmV1` | string | `'Enabled'` | `[Disabled, Enabled]` | The value is to enable clients making request using NTLM v1. |
| `replicaSets` | array | `[]` |  | Additional replica set for the managed domain. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sku` | string | `'Standard'` | `[Enterprise, Premium, Standard]` | The name of the SKU specific to Azure ADDS Services. |
| `syncNtlmPasswords` | string | `'Enabled'` | `[Disabled, Enabled]` | The value is to enable synchronized users to use NTLM authentication. |
| `syncOnPremPasswords` | string | `'Enabled'` | `[Disabled, Enabled]` | The value is to enable on-premises users to authenticate against managed domain. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `tlsV1` | string | `'Enabled'` | `[Disabled, Enabled]` | The value is to enable clients making request using TLSv1. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The domain name of the Azure Active Directory Domain Services(Azure ADDS). |
| `resourceGroupName` | string | The name of the resource group the Azure Active Directory Domain Services(Azure ADDS) was created in. |
| `resourceId` | string | The resource ID of the Azure Active Directory Domain Services(Azure ADDS). |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module domainService './aad/domain-service/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-aaddscom'
  params: {
    // Required parameters
    domainName: 'onmicrosoft.com'
    // Non-required parameters
    additionalRecipients: [
      '@noreply.github.com'
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    name: 'aaddscom001'
    pfxCertificate: '<pfxCertificate>'
    pfxCertificatePassword: '<pfxCertificatePassword>'
    replicaSets: [
      {
        location: 'WestEurope'
        subnetId: '<subnetId>'
      }
    ]
    sku: 'Standard'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
    "domainName": {
      "value": "onmicrosoft.com"
    },
    // Non-required parameters
    "additionalRecipients": {
      "value": [
        "@noreply.github.com"
      ]
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "name": {
      "value": "aaddscom001"
    },
    "pfxCertificate": {
      "value": "<pfxCertificate>"
    },
    "pfxCertificatePassword": {
      "value": "<pfxCertificatePassword>"
    },
    "replicaSets": {
      "value": [
        {
          "location": "WestEurope",
          "subnetId": "<subnetId>"
        }
      ]
    },
    "sku": {
      "value": "Standard"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>
