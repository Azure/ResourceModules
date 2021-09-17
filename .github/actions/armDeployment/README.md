# armDeployment

- [armDeployment](#armdeployment)
  - [Description](#description)
  - [Design Principals](#design-principals)
  - [Action Inputs](#action-inputs)
  - [Assumptions](#assumptions)
  - [Current Features](#current-features)
  - [Action Logic](#action-logic)
    - [**PowerShell**: New-ArmDeployment.ps1](#powershell-new-armdeploymentps1)
      - [Features](#features)
      - [Examples](#examples)
  - [Contributing](#contributing)
  - [Trademarks](#trademarks)

## Description

armDeployment is a simple GitHub composite action that allows deploying Azure Resource Manager (ARM) Templates across 4 scopes: `tenant`, `managementGroup`, `subscription` and `resourceGroup`. It uses the `$schema` property of the template to determine the target scope of the deployment.

## Design Principals

- Should be easy to use and troubleshoot.
- Avoid unnecessary abstractions.

## Action Inputs

The following table describes the inputs used in the action:

| Input Name             | Type     | Required | Description                                                                                                                |
| ---------------------- | -------- | -------- | -------------------------------------------------------------------------------------------------------------------------- |
| templateFile           | `string` | `true`   | Path to the Template file (.json)                                                                                          |
| templateParametersFile | `string` | `true`   | Path to a template file, files (comma separated), or directory containing files (.parameters.json)                         |
| location               | `string` | `true`   | The location for the deployment. Applies to all scopes                                                                     |
| tags                   | `object` | `false`  | Object of key-value pairs for tags (if resource supports tags as an input in the template)                                 |
| resourceGroupName      | `string` | `false`  | Name of the Resource Group if targeting `resourceGroup`. Script will attempt to deploy Resource Group if it does not exist |
| subscriptionId         | `string` | `false`  | The ID the Azure Subscription if targeting `resourceGroup` or `subscription`                                               |
| managementGroupId      | `string` | `false`  | The ID the Azure Management Group if targeting `managementGroup`                                                           |

## Assumptions

- Authentication has previously been performed in a previous action (i.e. azure/login@v1.1)
- the Service Principal and Context used for the deployment already has the required permissions on the target scope (including 'tenant' level deployments)
- Parameter Folder contains files that have the (*.parameters.json) extension.

## Current Features

- Management Group level deployment
- Subscription level deployment
- Resource Group level deployment
- Tenant level deployment

## Action Logic

armDeployment uses the following actions to deploy resources into Azure:

| Action Type                                                | Description                                | Details                                     |
| ---------------------------------------------------------- | ------------------------------------------ | ------------------------------------------- |
| [azure/powershell@v1](https://github.com/Azure/powershell) | GitHub action for Azure PowerShell scripts | [Details](#powershell-new-armdeploymentps1) |


### **PowerShell**: New-ArmDeployment.ps1

See [Script](New-ArmDeployment.ps1) for details on parameters required

#### Features

- Supports single parameter file, multiple files, folder. All files must use the extension '.parameters.json' 
- 2 times retry mechanism with 5 seconds apart.

#### Examples

```powershell

# Management Group Deployment - Parameter Folder - With Tags

.\.github\actions\armDeployment\New-ArmDeployment.ps1 -templateFile "abc.json" -templateParametersFile "myFiles\prod" -managementGroupId "mg-contoso" -location "australiaeast" -tags "@{a=1}" 

# Management Group Deployment - Parameter File - No Tags

.\.github\actions\armDeployment\New-ArmDeployment.ps1 -templateFile "abc.json" -templateParametersFile "abc.parameters.json" -managementGroupId "mg-contoso" -location "australiaeast"

# Subscription Deployment - Parameter File(s) - No Tags

.\.github\actions\armDeployment\New-ArmDeployment.ps1 -templateFile "abc.json" -templateParametersFile "parameters.json","abc2.parameters.json" -subscriptionId "abc-defg-hij" -location "australiaeast"

# Resource Group Deployment Parameter Folder - With Tags

.\.github\actions\armDeployment\New-ArmDeployment.ps1 -templateFile "abc.json" -templateParametersFile "myFiles\prod" -resourceGroupName "my-RG" -subscriptionId "abc-defg-hij" -location "australiaeast" -tags "@{a=1}" 

# Tenant Deployment - No Tags

.\.github\actions\armDeployment\New-ArmDeployment.ps1 -templateFile "abc.json" -templateParametersFile "myFiles\prod" -location "australiaeast" 

```

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
