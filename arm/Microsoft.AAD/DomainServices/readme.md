# Azure Active Directory Domain Services `[Microsoft.AAD/DomainServices]`

This template deploys Azure Active Directory Domain Services (AADDS).

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Considerations](#Considerations)
- [Get base64encoded code from pfx](#Get-base64encoded-code-from-pfx)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AAD/domainServices` | 2021-05-01 |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `domainName` | string | The domain name specific to the Azure ADDS service. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `additionalRecipients` | array | `[]` |  | The email recipient value to receive alerts |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `domainConfigurationType` | string | `'FullySynced'` |  | The value is to provide domain configuration type |
| `externalAccess` | string | `'Enabled'` |  | The value is to enable the Secure LDAP for external services of Azure ADDS Services |
| `filteredSync` | string | `'Enabled'` |  | The value is to synchronise scoped users and groups - This is enabled by default |
| `kerberosArmoring` | string | `'Enabled'` |  | The value is to enable to provide a protected channel between the Kerberos client and the KDC - This is enabled by default |
| `kerberosRc4Encryption` | string | `'Enabled'` |  | The value is to enable Kerberos requests that use RC4 encryption - This is enabled by default |
| `ldaps` | string | `'Enabled'` |  | A flag to determine whether or not Secure LDAP is enabled or disabled. |
| `location` | string | `[resourceGroup().location]` |  | The location to deploy the Azure ADDS Services |
| `lock` | string | `'NotSpecified'` | `[CanNotDelete, NotSpecified, ReadOnly]` | Specify the type of lock. |
| `logsToEnable` | array | `[SystemSecurity, AccountManagement, LogonLogoff, ObjectAccess, PolicyChange, PrivilegeUse, DetailTracking, DirectoryServiceAccess, AccountLogon]` | `[SystemSecurity, AccountManagement, LogonLogoff, ObjectAccess, PolicyChange, PrivilegeUse, DetailTracking, DirectoryServiceAccess, AccountLogon]` | The name of logs that will be streamed. |
| `name` | string | `[parameters('domainName')]` |  | The name of the AADDS resource. Defaults to the domain name specific to the Azure ADDS service. |
| `notifyDcAdmins` | string | `'Enabled'` |  | The value is to notify the DC Admins - This is enabled by default  |
| `notifyGlobalAdmins` | string | `'Enabled'` |  | The value is to notify the Global Admins - This is enabled by default |
| `ntlmV1` | string | `'Enabled'` |  | The value is to enable clients making request using NTLM v1 - This is enabled by default |
| `pfxCertificate` | string | `''` |  | The certificate required to configure Secure LDAP. The parameter passed here should be a base64encoded representation of the certificate pfx file |
| `pfxCertificatePassword` | secureString | `''` |  | The password to decrypt the provided Secure LDAP certificate pfx file. |
| `replicaSets` | array | `[]` |  | Additional replica set for the managed domain |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sku` | string | `'Standard'` | `[Standard, Enterprise, Premium]` | The name of the sku specific to Azure ADDS Services. |
| `syncNtlmPasswords` | string | `'Enabled'` |  | The value is to enable synchronised users to use NTLM authentication - This is enabled by default |
| `syncOnPremPasswords` | string | `'Enabled'` |  | The value is to enable on-premises users to authenticate against managed domain - This is enabled by default |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `tlsV1` | string | `'Enabled'` |  | The value is to enable clients making request using TLSv1 - This is enabled by default |


### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

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

## Considerations

The network security group has to be created prior to running this module and assign to the Azure ADDS Subnet and associating a route table to the same subnet is not recommended.

## Get base64encoded code from pfx
Follow the below powershell commands to generate the base64 encoded code from a pfx file:
```powershell
  $file=get-content "<<pfx certificate file path>>" -encoding byte
  [System.Convert]::ToBase64String($file) | Out-File pfx-encoded-bytes.txt
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The domain name of the Azure Active Directory Domain Services(Azure ADDS) |
| `resourceGroupName` | string | The name of the resource group the Azure Active Directory Domain Services(Azure ADDS) was created in. |
| `resourceId` | string | The resource ID of the Azure Active Directory Domain Services(Azure ADDS) |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Domainservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.AAD/2021-05-01/domainServices)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
