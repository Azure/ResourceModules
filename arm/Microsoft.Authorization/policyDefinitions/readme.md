# PolicyDefinition

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2019-10-01|
|`Microsoft.Authorization/policyDefinitions`|2020-09-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `policyDefinitionName` | string | Required. Specifies the name of the policy definition. Space characters will be replaced by (-) and converted to lowercase |  | |
| `displayName` | string | Optional. The display name of the policy definition. |  | |
| `policyDescription` | string | Optional. The policy definition description. |  | |
| `mode` | string | Optional. The policy definition mode. Default is All, Some examples are All, Indexed, Microsoft.KeyVault.Data. | All | |
| `metadata` | object | Optional. The policy Definition metadata. Metadata is an open ended object and is typically a collection of key value pairs. |  | |
| `parameters` | array | Optional. The policy definition parameters that can be used in policy definition references. |  | |
| `policyRule` | object | Required. The Policy Rule details for the Policy Definition' |  | |
| `subscriptionId` | string | Optional. ID of the Subscription where you want to deploy the policy definition. Cannot use this parameter with the management group Id | | 
| `managementGroupId` | string | Optional. ID of the Management Group where you want to deploy the policy definition. Cannot use this parameter with subscription Id | | 
| `location` | string | Optional. Location for all resources. |  | |

### Parameter Usage: `managementGroupId`

To deploy resource to a Management Group, provide the `managementGroupId` as an input parameter to the module.

```json
"managementGroupId": {
	"value": "contoso-group"
}
```

> The name of the Management Group in the deployment does not have to match the value of the `managementGroupId` in the input parameters. 

### Parameter Usage: `subscriptionId`

To deploy resource to an Azure Subscription, provide the `subscriptionId` as an input parameter to the module. **Example**:

```json
"subscriptionId": {
	"value": "12345678-b049-471c-95af-123456789012"
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `policyDefinitionId` | string | The ID of the Policy definition |
| `policyDefinitionName` | string | Name of the Policy definition |
| `roleDefinitionIds` | array | An array of the Role Definition Resource IDs that the policy definition uses. Only available if policy definition contains it |

## Considerations

## Additional resources

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [Policy Definitions](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policydefinitions?tabs=bicep)
