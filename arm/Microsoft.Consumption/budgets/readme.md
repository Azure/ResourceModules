# Budgets `[Microsoft.Consumption/budgets]`

This module deploys budgets for subscriptions.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Consumption/budgets` | 2019-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `actionGroups` | array | `[]` |  | Optional. List of action group resource IDs that will receive the alert. |
| `amount` | int |  |  | Required. The total amount of cost or usage to track with the budget. |
| `category` | string | `Cost` | `[Cost, Usage]` | Optional. The category of the budget, whether the budget tracks cost or usage. |
| `contactEmails` | array | `[]` |  | Optional. The list of email addresses to send the budget notification to when the thresholds are exceeded. |
| `contactRoles` | array | `[]` |  | Optional. The list of contact roles to send the budget notification to when the thresholds are exceeded. |
| `endDate` | string |  |  | Optional. The end date for the budget. If not provided, it will default to 10 years from the start date. |
| `name` | string |  |  | Optional. The name of the budget. |
| `resetPeriod` | string | `Monthly` | `[Monthly, Quarterly, Annually, BillingMonth, BillingQuarter, BillingAnnual]` | Optional. The time covered by a budget. Tracking of the amount will be reset based on the time grain. BillingMonth, BillingQuarter, and BillingAnnual are only supported by WD customers. |
| `startDate` | string | `[format('{0}-{1}-01T00:00:00Z', utcNow('yyyy'), utcNow('MM'))]` |  | Required. The start date for the budget. Start date should be the first day of the month and cannot be in the past (except for the current month). |
| `thresholds` | array | `[50, 75, 90, 100, 110]` |  | Optional. Percent thresholds of budget for when to get a notification. Can be up to 5 thresholds, where each must be between 1 and 1000. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the budget |
| `resourceId` | string | The resource ID of the budget |
| `subscriptionName` | string | The subscription the budget was deployed into |

## Template references

- [Budgets](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Consumption/2019-05-01/budgets)
