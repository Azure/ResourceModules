# Budgets

This module deploys budgets for subscriptions.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Consumption/budgets` | 2019-10-01 |

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `budgetName` | string | Required. The name of the budget. |  |  |
| `category` | string | Optional. The category of the budget, whether the budget tracks cost or usage. | "Cost" | "Cost", "Usage" |
| `amount` | int | Required. The total amount of cost to track with the budget. |  |  |
| `resetPeriod` | string | Optional. The time covered by a budget. Tracking of the amount will be reset based on the time grain. BillingMonth, BillingQuarter, and BillingAnnual are only supported by WD customers. | "Monthly" | "Monthly", "Quarterly", "Annually", "BillingMonth", "BillingQuarter", "BillingAnnual" |
| `startDate` | string | Optional. Optional. The start date for the budget. Start date should be the first day of the month and cannot be in the past (except for the current month). | <current_year>-<current_month>-01T00:00:00Z |  |
| `endDate` | string | Optional. The end date for the budget. If not provided, it will default to 10 years from the start date. | "" |  |
| `alertPercentage` | int | Required. Alert % must be between 1 and 1000. |  |  |
| `contactEmails` | array | Optional. List of email addresses that will receive the alert. |  |  |
| `actionGroups` | array | Optional. List of fully qualified action group resource IDs that will receive the alert. |  |  |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `budgetName` | string | The name of the budget. |
| `budgetResourceId` | string | The Resource Id of the budget. |

## Considerations

*N/A*

## Additional resources

- [Tutorial: Create and manage Azure budgets](https://docs.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-acm-create-budgets)
- [Microsoft.Consumption/budgets template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.consumption/2019-10-01/budgets)