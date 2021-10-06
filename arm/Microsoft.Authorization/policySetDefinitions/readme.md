# policySetDefinition

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2019-10-01|
|`Microsoft.Authorization/policySetDefinitions`|2020-09-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `policySetDefinitionName` | string | Required. Required. Specifies the name of the policy Set Definition (Initiative). Space characters will be replaced by (-) and converted to lowercase |  | |
| `displayName` | string | Optional. Optional. The display name of the Set Definition (Initiative) |  | |
| `policySetDescription` | string | Optional. The description name of the Set Definition (Initiative) |  | |
| `metadata` | object | Optional. Optional. The Set Definition (Initiative) metadata. Metadata is an open ended object and is typically a collection of key value pairs. |  | |
| `policyDefinitions` | array | Required. The array of Policy definitions object to include for this policy set. Each object must include the Policy definition ID, and optionally other properties like parameters |  |  |
| `policyDefinitionGroups` | string | Optional. The metadata describing groups of policy definition references within the Policy Set Definition (Initiative). |  | |
| `parameters` | object | Optional. The Set Definition (Initiative) parameters that can be used in policy definition references.|  | | 
| `subscriptionId` | string | Optional. The ID of the azure subscription where the initiative is being deployed at. Cannot use with management group id parameter. | | 
| `managementGroupId` | string | Optional. The ID of the management group where the initiative is being deployed at. Cannot use with subscription id parameter. | | 
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
| `policySetDefinitionId` | string | The ID of the Policy Set Definitions (Initiatives) |
| `policySetDefinitionName` | string | Name of the Policy Set Definitions (Initiatives) |

## Considerations

- Policy Set Definitions (Initiatives) have a dependency on Policy Assignments being applied before creating an initiative. You can use the Policy Assignment [Module](../policyDefinitions/deploy.bicep) to deploy a Policy Definition and then create an initiative for it on the required scope.

## Additional resources

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2018-02-01/deployments)
- [Policy Set Definitions (Initiatives)](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policysetdefinitions?tabs=bicep)
