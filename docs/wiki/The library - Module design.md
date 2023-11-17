This section details the design principles followed by the CARML Bicep modules.

---

### _Navigation_

- [General guidelines](#general-guidelines)
- [File \& folder structure](#file--folder-structure)
  - [Structure](#structure)
    - [**Child resources**](#child-resources)
  - [Naming](#naming)
  - [Patterns](#patterns)
    - [Locks](#locks)
    - [Role Assignments (RBAC)](#role-assignments-rbac)
      - [1st Element in main resource](#1st-element-in-main-resource)
      - [2nd Element as nested `.bicep/nested_roleAssignments.bicep` file](#2nd-element-as-nested-bicepnested_roleassignmentsbicep-file)
    - [Diagnostic Settings](#diagnostic-settings)
    - [Private Endpoints](#private-endpoints)
      - [1st element in main resource](#1st-element-in-main-resource-1)
- [Bicep template guidelines](#bicep-template-guidelines)
  - [Parameters](#parameters)
  - [Variables](#variables)
  - [Resources](#resources)
  - [Modules](#modules)
    - [Deployment names](#deployment-names)
  - [Outputs](#outputs)
- [ReadMe](#readme)
- [Module test files](#module-test-files)
- [Telemetry](#telemetry)
  - [Overview](#overview)
  - [Technical Details](#technical-details)
  - [Opting Out](#opting-out)
  - [Telemetry vs Customer Usage Attribution](#telemetry-vs-customer-usage-attribution)

---

Modules are written in a flexible way; therefore, you don't need to modify them from project to project, use case to use case, as they aim to cover most of the functionality that a given resource type can provide, in a way that you can interact with any module just by sending the required parameters to it - i.e., you don't have to know how the template of the particular module works inside, just take a look at the `README.md` file of the given module to consume it.

The modules are multi-purpose; therefore, contain a lot of dynamic expressions (functions, variables, etc.), so there's no need to maintain multiple instances for different use cases.

They can be deployed in different configurations just by changing the input parameters. They are perceived by the **user** as black boxes, where they don't have to worry about the internal complexity of the code, as they only interact with them by their parameters.

# General guidelines

- All resource modules in the 'modules' folder should not allow deployment loops on the top-level resource but may optionally allow deployment loops on their child resources.
  > **Example:** The storage account module allows the deployment of a single storage account with, optionally, multiple blob containers, multiple file shares, multiple queues and/or multiple tables.
- The 'constructs' folder contains examples of deployment logic built on top of resource modules included in the 'modules' folder, allowing for example, deployment loops on top-level resources.
  > **Example:** The VirtualNetworkPeering construct leverages the VirtualNetworkPeering module to deploy multiple virtual network peering connections at once.
- Where the resource type in question supports it, the module should have support for:
  1. **Diagnostic logs** and **metrics** (you can have them sent to one ore more of the following destination types: storage account, log analytics and event hub).
  1. Resource and child-resource level **RBAC** (for example, providing data contributor access on a storage account; granting file share/blob container level access in a storage account)
  1. **Tags** (as objects)
  1. **Locks**
  1. **Private Endpoints** (if supported)
  1. **User-Managed Identities** (if supported)
  1. **Customer-managed Keys** (if supported)

---

# File & folder structure

- [Structure](#structure)
- [Naming](#naming)
- [Patterns](#patterns)

A **CARML module** consists of

- The Bicep template deployment file (`main.bicep`).
- One or multiple module test files (`main.test.bicep`) that will be used for testing, located in the `.test` folder and its subfolders.
- A `README.md` file which describes the module itself.
- A `version.json` file which contains information on the module's major and minor version.

A module usually represents a single resource or a set of closely related resources. For example, a storage account and the associated lock or virtual machine and network interfaces. Modules are located in the `modules` folder.

Also, as described in the [General Guidelines](#general-guidelines), each module should be implemented with all capabilities it and its children support.

## Structure

Modules in the repository are structured based on their main resource provider (for example, `Microsoft.Web`) and resource type (for example, `serverfarms`) where each section of the path corresponds to its place in the hierarchy. However, for cases that do not fit into this schema, we provide the following guidance:

### **Child resources**

Resources like `Microsoft.Sql/servers` may have dedicated templates for child resources such as `Microsoft.Sql/servers/databases`. In these cases, we recommend to create a subfolder named after the child resource, so that the path to the child resource folder is consistent with its resource type. In the given example, we would have a `databases` subfolder in the `servers` parent folder.

```txt
Microsoft.Sql
└─ servers [module]
  └─ databases [child-module/resource]
```

In this folder, we recommend to place the child resource-template alongside a ReadMe (that can be generated via the [Set-Module](./Contribution%20guide%20-%20Generate%20module%20Readme) script) and optionally further nest additional folders for it's child resources.

The parent template should reference all it's direct child-templates to allow for an end-to-end deployment experience while allowing any user to also reference 'just' the child resource itself. In case of the SQL server example, the server template would reference the database module and encapsulate it in a loop to allow for the deployment of multiple databases. For example

```Bicep
@description('Optional. The databases to create in the server')
param databases array = []

module server_databases 'databases/main.bicep' = [for (database, index) in databases: {}]
```

## Naming

Use the following naming standard for module files and folders:

- A module's 'Provider namespace' folder is lowercase, avoids the `Microsoft.` prefix and uses a `-` as a separator whenever the API reference would have an upper case (for example `'Microsoft.RecoveryServices'` would have a folder name `'recovery-services'`)
- A module's 'Resource Type' folder is lowercase, singular and uses a `-` as a separator whenever the API reference would have an upper case (for example, `'storageAccounts'` would be `'storage-account'`, or `'virtualMachines'` be `virtual-machine`).
- Extension resource modules are placed in the `.bicep` subfolder and named `nested_<crossReferencedResourceType>.bicep`

  ```txt
  <ProviderNamespace>
  └─ <ResourceType>
      ├─ .bicep
      |  ├─ nested_extensionResource1.bicep
      ├─ .test
      |  └─ ...
      ├─ main.bicep
      └─ README.md
  ```

  > **Example**: `nested_roleAssignments.bicep` in the `web\site\.bicep` folder contains the `site` resource's RBAC implementation.
  >
  > ```txt
  > web
  > └─ site
  >    ├─ .bicep
  >    |  └─ nested_roleAssignments.bicep
  >    ├─ .test
  >    |  └─ ...
  >    ├─ main.bicep
  >    └─ README.md
  > ```

## Patterns

This section details patterns among extension resources that are usually very similar in their structure among all modules supporting them:

### Locks

The locks extension can be added as a `resource` to the resource template directly.

<details>
<summary>Details</summary>

```bicep
@description('Optional. The lock settings of the service.')
param lock lockType

resource <mainResource>_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: <mainResource>
}
```

> **Note:** How locks are passed to other resource templates depends on the type of module relationship:
>
> - Child and extension resources
>   - Locks are not automatically passed down, as they are inherited by default in Azure
>   - The reference of the child/extension template should look similar to: `lock: <childExtensionObject>.?lock ?? lock`
>   - Using this implementation, a lock is only deployed to the child/extension resource if explicitly specified in the module's test file
>   - For example, the lock of a Storage Account module is not automatically passed to a Storage Container child-deployment. Instead, the Storage Container resource is automatically locked by Azure together with a locked Storage Account
> - Cross-referenced resources
>   - All cross-referenced resources share the lock with the main resource to prevent depending resources to be changed or deleted
>   - The reference of the cross-referenced resource template should look similar to: `lock: <referenceObject>.?lock ?? lock`
>   - Using this implementation, a lock of the main resource is implicitly passed to the referenced module template
>   - For example, the lock of a Key Vault module is automatically passed to an also deployed Private Endpoint module deployment

</details>

<p>

### Role Assignments (RBAC)

The RBAC deployment has 2 elements. A module that contains the implementation, and a module reference in the parent resource - each with it's own loop to enable you to deploy n-amount of role assignments to n-amount of principals.

<details>
<summary>Details</summary>

#### 1st Element in main resource

```bicep
@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

module <mainResource>_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: <mainResource>.id
  }
}]
```

#### 2nd Element as nested `.bicep/nested_roleAssignments.bicep` file

Here, you specify the platform roles available for the main resource.

The `builtInRoleNames` variable contains the list of applicable roles for the specific resource which the `nested_roleAssignments.bicep` template applies.

> **Note**: You use the helper script [Get-RoleAssignmentList.ps1](./Contribution%20guide%20-%20Get%20formatted%20RBAC%20roles) to get a formatted list of RBAC roles for a given service, used in the CARML modules.

The element requires you to provide both the `principalIds` & `roleDefinitionOrIdName` to assign to the principal IDs. Also, the `resourceId` is target resource's resource ID that allows us to reference it as an `existing` resource. Note, the implementation of the `split` in the resource reference becomes longer the deeper you go in the child resource hierarchy.

```bicep
@sys.description('Required. The IDs of the principals to assign the role to.')
param principalIds array

@sys.description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
param roleDefinitionIdOrName string

@sys.description('Required. The resource ID of the resource to apply the role assignment to.')
param resourceId string

@sys.description('Optional. The principal type of the assigned principal ID.')
@allowed([
  'ServicePrincipal'
  'Group'
  'User'
  'ForeignGroup'
  'Device'
  ''
])
param principalType string = ''

@sys.description('Optional. The description of the role assignment.')
param description string = ''

@sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
param condition string = ''

@sys.description('Optional. Version of the condition.')
@allowed([
  '2.0'
])
param conditionVersion string = '2.0'

@sys.description('Optional. ID of the delegated managed identity resource.')
param delegatedManagedIdentityResourceId string = ''

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  // <optionalAdditionalRoles>

}

resource <mainResource> '<mainResourceProviderNamespace>/<resourceType>@<resourceTypeApiVersion>' existing = {
  // top-level RBAC
  name: last(split(resourceId,'/'))
  // 2nd level RBAC
  // name: '${split(resourceId,'/')[8]}/${split(resourceId,'/')[10]}'
  // 3rd level RBAC
  // name: '${split(resourceId,'/')[8]}/${split(resourceId,'/')[10]}/${split(resourceId,'/')[12]'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for principalId in principalIds: {
  name: guid(<mainResource>.id, principalId, roleDefinitionIdOrName)
  properties: {
    description: description
    roleDefinitionId: contains(builtInRoleNames, roleDefinitionIdOrName) ? builtInRoleNames[roleDefinitionIdOrName] : roleDefinitionIdOrName
    principalId: principalId
    principalType: !empty(principalType) ? any(principalType) : null
    condition: !empty(condition) ? condition : null
    conditionVersion: !empty(conditionVersion) && !empty(condition) ? conditionVersion : null
    delegatedManagedIdentityResourceId: !empty(delegatedManagedIdentityResourceId) ? delegatedManagedIdentityResourceId : null
  }
  scope: <mainResource>
}]
```

</details>

<p>

### Diagnostic Settings

The diagnostic settings may differ slightly, from resource to resource. Most notably, the `<LogsIfAny>` as well as `<MetricsIfAny>` may be different and have to be added by you. Also possible, and default setting is to use the category `allLogs`. If using `allLogs`, the other `<LogsIfAny>` are not needed. However, it may also happen that a given resource type simply doesn't support any metrics and/or logs. In this case, you can then remove the parameter and property from the module you develop.

<details>
<summary>Details</summary>

```bicep

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  <LogsIfAny>
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  <MetricsIfAny>
])
param diagnosticMetricsToEnable array = [
  <MetricsIfAny>
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs' && item != ''): {
  category: category
  enabled: true
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
  }
] : contains(diagnosticLogCategoriesToEnable, '') ? [] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
}]

resource <mainResource>_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: <mainResource>
}
```

</details>

<p>

### Private Endpoints

The Private Endpoint deployment has 2 elements. A module that contains the implementation, and a module reference in the parent resource. The first one loops through the endpoints we want to create, the second one processes them.

<details>
<summary>Details</summary>

#### 1st element in main resource

```bicep
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

module <mainResource>_privateEndpoints 'https://github.com/Azure/ResourceModules/blob/main/network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-<mainResource>-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(<mainResource>.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: <mainResource>.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: contains(privateEndpoint, 'location') ? privateEndpoint.location : reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: contains(privateEndpoint, 'lock') ? privateEndpoint.lock : lock
    privateDnsZoneGroup: contains(privateEndpoint, 'privateDnsZoneGroup') ? privateEndpoint.privateDnsZoneGroup : {}
    roleAssignments: contains(privateEndpoint, 'roleAssignments') ? privateEndpoint.roleAssignments : []
    tags: contains(privateEndpoint, 'tags') ? privateEndpoint.tags : {}
    manualPrivateLinkServiceConnections: contains(privateEndpoint, 'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []
    customDnsConfigs: contains(privateEndpoint, 'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []
    ipConfigurations: contains(privateEndpoint, 'ipConfigurations') ? privateEndpoint.ipConfigurations : []
    applicationSecurityGroups: contains(privateEndpoint, 'applicationSecurityGroups') ? privateEndpoint.applicationSecurityGroups : []
    customNetworkInterfaceName: contains(privateEndpoint, 'customNetworkInterfaceName') ? privateEndpoint.customNetworkInterfaceName : ''
  }
}]
```

</details>

---

# Bicep template guidelines

Within a bicep file, use the following conventions:

- [Parameters](#parameters)
- [Variables](#variables)
- [Resources](#resources)
- [Modules](#modules)
- [Outputs](#outputs)

## Parameters

- Parameter names are in camelCase, e.g., `allowBlobPublicAccess`.
- Descriptions contain type of requirement:
  - `Required` - The parameter value must be provided. The parameter does not have a default value and hence the module expects input.
  - `Conditional` - The parameter value can be optional or required based on a condition, mostly based on the value provided to other parameters.
  - `Optional` - The parameter value is not mandatory. The module provides a default value for the parameter.
  - `Generated` - The parameter value is generated within the module and should not be specified as input.
- Parameters mapping to resource properties should align with resource property names as much as possible and should not artificially include a resource type's name prefix to avoid redundancy.
  > For example, the input parameter of the Key Vault module which maps to the `name` resource property should be just `name` and not `keyVaultName`. The rationale is that the consumers know that the name is for the Key Vault if they deploy its module.
- If a property value allows a single value only, there is no need to introduce a parameter for it. Instead it can be hardcoded into the deployment.
  > For example, the name of a Blob Container Immutability Policy resource can only be `default`. Hence we can implement its name property directly as `name: 'default'`.
- If a property value allows a single value only, but the value is used in more than one place, a variable should be introduced to be leveraged in the multiple occurrences.
  > For example, in cases where the resource name can be hardcoded and the resource supports diagnostic settings, also the default value for the diagnostic settings name `"<resourceName>-diagnosticSettings"` is affected. In those cases, we recommend to introduce an additional variable `'var name = '<theHardcodedValue>'`' (e.g., `var name = 'default'`) to be used both in the main resource's name (e.g., `'name: name'`), as well as the diagnostic settings name: `'name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'`'.

## Variables

- Variable names are in camelCase, e.g., `builtInRoleNames`.

## Resources

- Resource names are in camelCase, e.g., `resourceGroup`.
- The name used as a reference is the singular name of the resource that it deploys, i.e.:
  - `resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01'`
  - `resource virtualMachine 'Microsoft.Compute/virtualMachines@2020-06-01'`
- Parent reference

  - If working on a child resource, refrain from string concatenation and instead, use the parent reference via the `existing` keyword.
  - The way this is implemented differs slightly the lower you go in the hierarchy. Note the following examples:

    - 1st level child resource (example _storageAccount/blobService_)

      ```bicep
      resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
        name: storageAccountName
      }

      resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
        name: name
        parent: storageAccount
        properties: {...}
      }
      ```

    - 2nd level child resource (example _storageAccount/blobService/container_)

      ```bicep
      resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
        name: storageAccountName

        resource blobServices 'blobServices@2021-06-01' existing = {
          name: blobServicesName
        }
      }

      resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
        name: name
        parent: storageAccount::blobServices
        properties: {...}
      }
      ```

    - 3rd level child resource (example _storageAccount/blobService/container/immutabilityPolicies_)

      ```bicep
      resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
        name: storageAccountName

        resource blobServices 'blobServices@2021-06-01' existing = {
          name: blobServicesName

          resource container 'containers@2019-06-01' existing = {
            name: containerName
          }
        }
      }

      resource immutabilityPolicy 'Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies@2019-06-01' = {
        name: name
        parent: storageAccount::blobServices::container
        properties: {...}
      }
      ```

## Modules

- Module symbolic names are in camel_Snake_Case, following the schema `<mainResourceType>_<referencedResourceType>` e.g., `storageAccount_fileServices`, `virtualMachine_nic`, `resourceGroup_roleAssignments`.
- Modules enable you to reuse code from a Bicep file in other Bicep files. As such, they're normally leveraged for deploying child resources (e.g., file services in a storage account), cross referenced resources (e.g., network interface in a virtual machine) or extension resources (e.g., role assignment in a resource group).
- When a module requires to deploy a resource whose resource type is outside of the main module's provider namespace, the module of this additional resource is referenced locally. For example, when extending the Key Vault module with Private Endpoints, instead of including in the Key Vault module an ad hoc implementation of a Private Endpoint, the Key Vault directly references the Private Endpoint module (i.e., `module privateEndpoint 'https://github.com/Azure/ResourceModules/blob/main/network/private-endpoint/main.bicep'`). Major benefits of this implementation are less code duplication, more consistency throughout the module library and allowing the consumer to leverage the full interface provided by the referenced module.
  > **Note**: Cross-referencing modules from the local repository creates a dependency for the modules applying this technique on the referenced modules being part of the local repository. Reusing the example from above, the Key Vault module has a dependency on the referenced Private Endpoint module, meaning that the repository from which the Key Vault module is deployed also requires the Private Endpoint module to be present. For this reason, we provide a utility to check for any local module references in a given path. This can be useful to determine which module folders you'd need if you don't want to keep the entire library. For further information on how to use the tool, please refer to the tool-specific [documentation](./Getting%20started%20-%20Get%20module%20cross-references).

### Deployment names

When using modules from parent resources you will need to specify a name that, when deployed, will be used to assign the deployment name.

There are some constraints that needs to be considered when naming the deployment:

- Deployment name length can't exceed 64 chars.
- Two deployments with the same name created in different Azure locations (e.g., WestEurope & EastUS) in the same scope (e.g., resource group deployments) will fail.
- Using the same deployment name more than once, will surface only the most recent deployed one in the Azure Portal.
- If more than one deployment with the same name runs at the same time to the same scope, race condition might happen.
- Human-readable names are preferable, even if not necessary.

While exceptions might be needed, the following guidance should be followed as much as possible:

- When deploying more than one resource of the same referenced module is needed, we leverage loops using integer index and items in an array as per [Bicep loop syntax](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/loops#loop-syntax). In this case, we also use `-${index}` as a suffix of the deployment name to avoid race condition:

  ```bicep
  module symbolic_name 'path/to/referenced/module/main.bicep' = [for (<item>, <index>) in <collection>: {
    name: '<deploymentName>-${index}'
    ...
  }]
  ```

  > **Example**: for the `roleAssignment` deployment in the Key Vault `secrets` template
  >
  > ```bicep
  >   module secret_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  >     name: '${deployment().name}-Rbac-${index}'
  > ```

- For referenced resources of the top-level resource inside the top-level template use the following naming structure:

  ```bicep
  '${uniqueString(deployment().name, location)}-<topLevelResourceType>-<referencedResourceType>'
  ```

  > **Example**: for the `tableServices` deployment inside the `storageAccount` template
  >
  > ```bicep
  > name: '${uniqueString(deployment().name, location)}-Storage-TableServices'
  > ```

- In the referenced resource template use the following naming structure:

  ```bicep
  '${deployment().name}-<referencedResourceType>[-${index}]'
  ```

  > **Example**: for the `tables` deployment in the `tableServices` template
  >
  > ```bicep
  > name: '${deployment().name}-Table-${index}'
  > ```

## Outputs

- Output names are in camelCase, i.e., `resourceId`
- At a minimum, reference the following:
  - `name`
  - `resourceId`
  - `resourceGroupName` for modules that are deployed at resource group scope
  - `systemAssignedMIPrincipalId` for all modules that support system-assigned managed identities
  - `location` for all modules where the primary resource has a location property
- Add a `@description('...')` annotation with meaningful description to each output.

---

# ReadMe

Each module must come with a ReadMe Markdown file that outlines what the module contains and 'how' it can be used.
Its primary components are in order:

- A title with a reference to the primary resource in Start Case followed by the primary resource namespace e.g., <code>Key Vaults `[Microsoft.KeyVault/vaults]`</code>.
- A short description
- A **Resource types** section with a table that outlines all resources that can be deployed as part of the module.
- A **Parameters** section with a table containing all parameters, their type, default and allowed values if any, and their description.
- An **Outputs** section with a table that describes all outputs the module template returns.
- A **Template references** section listing relevant resources [Azure resource reference](https://learn.microsoft.com/en-us/azure/templates).

Note the following recommendations:

- Refer to [Generate module Readme](./Contribution%20guide%20-%20Generate%20module%20Readme) for creating from scratch or updating the module ReadMe Markdown file.
- It is not recommended to describe how to use child resources in the parent readme file (for example, 'How to define a \[container] entry for the \[storage account]'). Instead, it is recommended to reference the child resource's ReadMe (for example, 'container/README.md').

# Module test files

Module test files in CARML are implemented using comprehensive `.bicep` test files that not only test the module's template in a certain scenario, but also deploy any required dependency for it.

Module test files follow these general guidelines:

- A module should have as many module test files as it needs to evaluate all parts of the module's functionality.
- Sensitive data should not be stored inside the module test file but rather be injected by the use of tokens, as described in the [Token replacement](./The%20CI%20environment%20-%20Token%20replacement) section, or via a [Key Vault reference](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/key-vault-parameter?tabs=azure-cli#reference-secrets-with-static-id).

Test folder guidelines:

- Each scenario should be setup in its own sub-folder (e.g. `.test/linux`)
- Sub-folder names should ideally relate to the content they deploy. For example, a sub-folder `min` should be chosen for a scenario in which only the minimum set of parameters, i.e., only required parameters, are used to deploy the module.
- Each folder should contain at least a file `main.test.bicep` and optionally an additional `dependencies.bicep` file.

Test file (`main.test.bicep`) guidelines:

- The `main.test.bicep` file should deploy any immediate dependencies (e.g. a resource group, if required) and invoke the module's main template while providing all parameters for a given test scenario.
- Parameters
  - Each file should define a parameter `serviceShort`. This parameter should be unique to this file (i.e, no two test files should share the same) as it is injected into all resource deployments, making them unique too and account for corresponding requirements.
    - As a reference you can create a identifier by combining a substring of the resource type and test scenario (e.g., in case of a Linux Virtual Machine Deployment: `vmlin`).
    - For the substring, we recommend to take the first character and subsequent upper-case characters from the resource type identifier and combine them into one string. Following you can find a few examples for reference:
      - `Microsoft.DBforPostgreSQL/flexibleServers` with a test folder `common` could be: `dfpsfscom`
      - `Microsoft.Storage/storageAccounts` with a test folder `min` could be: `ssamin`
      > **Note:** If the combination of the `servicesShort` with the rest of a resource name becomes too long, it may be necessary to bend the above recommendations and shorten the name. This can especially happen when deploying resources such as Virtual Machines or Storage Accounts that only allow comparatively short names.
  - If the module deploys a resource group level resource, the template should further have a `resourceGroupName` parameter and subsequent resource deployment. As a reference for the default name you can use `ms.<providerNamespace>.<resourceType>-${serviceShort}-test-rg`.
  - Each file should also provide a `location` parameter that may default to the deployments default location
- It is recommended to define all major resource names in the `main.test.bicep` file as it makes later maintenance easier. To implement this, make sure to pass all resource names to any referenced module.
- Further, for any test file (including the `dependencies.bicep` file), the usage of variables should be reduced to the absolute minimum. In other words: You should only use variables if you must use them in more than one place. The idea is to keep the test files as simple as possible
- References to dependencies should be implemented using resource references in combination with outputs. In other words: You should not hardcode any references into the module template's deployment. Instead use references such as `nestedDependencies.outputs.managedIdentityPrincipalId`
- If any diagnostic resources (e.g., a Log Analytics workspace) are required for a test scenario, you can reference the centralized `modules/.shared/.templates/diagnostic.dependencies.bicep` template. It will also provide you with all outputs you'd need.

> :scroll: [Example of test file](https://github.com/Azure/ResourceModules/blob/main/modules/AnalysisServices/servers/.test/common/main.test.bicep)

Dependency file (`dependencies.bicep`) guidelines:

- The `dependencies.bicep` should optionally be used if any additional dependencies must be deployed into a nested scope (e.g. into a deployed Resource Group).
- Note that you can reuse many of the assets implemented in other modules. For example, there are many recurring implementations for Managed Identities, Key Vaults, Virtual Network deployments, etc.

  - A special case to point out is the implementation of Key Vaults that require purge protection (for example, for Customer Managed Keys). As this implies that we cannot fully clean up a test deployment, it is recommended to generate a new name for this resource upon each pipeline run using the output of the `utcNow()` function at the time.

    > :scroll: [Example of test using purge protected Key Vault dependency](https://github.com/Azure/ResourceModules/tree/main/modules/batch/batch-account/.test/encr)

  - If you need a Deployment Script to set additional non-template resources up (for example certificates/files, etc.), we recommend to store it as a file in the shared `modules/.shared/.scripts` folder and load it using the template function `loadTextContent()` (for example: `scriptContent: loadTextContent('../../../../../.shared/.scripts/New-SSHKey.ps1')`). This approach makes it easier to test & validate the logic and further allows reusing the same logic across multiple test cases.

# Telemetry

## Overview

Microsoft uses the approach detailed in this section to identify the deployments of the Bicep and ARM JSON templates of the CARML library. Microsoft collects this information to provide the best experiences with their products and to operate their business. Telemetry data is captured through the built-in mechanisms of the Azure platform; therefore, it never leaves the platform, providing only Microsoft with access. Deployments are identified through a specific GUID (Globally Unique ID), indicating that the code originated from the CARML library. The data is collected and governed by Microsoft's privacy policies, located at the [Trust Center](https://www.microsoft.com/en-us/trust-center).

Telemetry collected as described here does not provide Microsoft with insights into the resources deployed, their configuration or any customer data stored in or processed by Azure resources deployed by using code from the CARML library. Microsoft does not track the usage/consumption of individual resources using telemetry described here.

> **Note:** While telemetry gathered as described here is only accessible by Microsoft, Customers have access to the exact same deployment information on the Azure portal, under the Deployments section of the corresponding scope (Resource Group, Subscription, etc.).

## Technical Details

Each module in CARML contains a `defaultTelemetry` deployment `'pid-<GUID>-${uniqueString(deployment().name)}'`, resulting in deployments such as `'pid-<GUID>-nx2c3rnlt2wru'`.

> **Note:** Though implemented at each level in a module hierarchy (e.g., storage account & blobServices), the deployment will only happen for the top-level module in a deployment, but not for its children. To illustrate this better, see the following examples:
>
> - Deployment of the KeyVault module and 2 Secrets: Results in 1 `PID` deployment for the KeyVault (and none for the secrets)
> - Deployment of the Secret module: Results in 1 `PID` deployment for the Secret

## Opting Out

Albeit telemetry described in this section is optional, the implementation follows an opt-out logic, as most commercial software solutions, this project also requires continuously demonstrating evidence of usage, hence the CARML team recommends leaving the telemetry setting on its default, enabled configuration.

This resource enables the CARML team to query the number of deployments of a given template from Azure - and as such, get insights into its adoption.

When using CARML's CI environment you can enable/disable this deployment by switching the `enableDefaultTelemetry` setting in the `settings.yml` file in the repository's root. This value is automatically injected into each individual deployment that is performed as part of the environment's pipeline.

When consuming the modules outside of CARML's pipelines you can either

- Set the parameter to a default value of `'false'`
- Set the parameter to false when deploying a module

## Telemetry vs Customer Usage Attribution

Though similar in principles, this approach is not to be confused and does not conflict with the usage of CUA IDs that are used to track Customer Usage Attribution of Azure marketplace solutions (partner solutions). The GUID-based telemetry approach described here can coexist and can be used side-by-side with CUA IDs. If you have any partner or customer scenarios that require the addition of CUA IDs, you can customize the modules of this library by adding the required CUA ID deployment while keeping the built-in telemetry solution.

> **Note:** _If you’re a partner and want to build a solution that tracks customer usage attribution (using a [CUA ID](https://learn.microsoft.com/en-us/azure/marketplace/azure-partner-customer-usage-attribution)), we recommend implementing it on the consuming template's level (i.e., the multi-module solution, such as workload/application) and apply the required naming format 'pid-<GUID>' (without the suffix)._
