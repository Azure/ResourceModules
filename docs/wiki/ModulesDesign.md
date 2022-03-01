# Modules Design

This section gives you an overview of the design principals the bicep modules follow.

---

### _Navigation_

- [General guidelines](#general-guidelines)
- [File & folder structure](#file--folder-structure)
  - [Naming](#naming)
  - [Structure](#structure)
  - [Patterns](#patterns)
- [Bicep template guidelines](#bicep-template-guidelines)
  - [Parameters](#parameters)
  - [Variables](#variables)
  - [Resource](#resource)
  - [Outputs](#outputs)
- [ReadMe](#readme)
- [Parameter files](#parameter-files)

---

Modules are written in a quite flexible way, therefore you don't need to modify them from project to project, as the aim is to cover most of the functionality that a given resource type can provide, in a way that you can interact with any module just by sending the required parameters to it - i.e. you don't have to know how the template of the particular module works inside, just take a look at the `readme.md` file of the given module to consume it.

The modules are multi-purpose, therefore contain a lot of dynamic expressions (functions, variables, etc.), so there's no need to maintain multiple instances for different use cases.

They can be deployed in different configurations just by changing the input parameters. They are perceived by the **user** as black boxes, where they don't have to worry about the internal complexity of the code, as they only interact with them by their parameters.

# General guidelines

- All resource modules in the 'arm' folder should not allow deployment loops on the top level resource but may optionally allow deployment loops on their child-resources.
  > **Example:** The storage account module allows the deployment of a single storage account with, optionally, multiple blob containers, multiple file shares, multiple queues and/or multiple tables.
- The 'constructs' folder contains examples of deployment logic built on top of resource modules contained in the 'arm' folder, allowing for example deployment loops on top level resources.
  > **Example:** The VirtualNetworkPeering construct leverages the VirtualNetworkPeering module to deploy multiple virtual network peerings at once
- Where the resource type in question supports it, the module should have support for:
  1. **Diagnostic logs** and **metrics** (you can have them sent to any combination of storage account, log analytics and event hub)
  2. Resource and child-resource level **RBAC** (for example providing data contributor access on a storage account; granting file share/blob container level access in a storage account)
  3. **Tags** (as objects)
  4. **Locks**
  5. **Private Endpoints** (if supported)

---

# File & folder structure

- [Structure](#structure)
- [Naming](#naming)
- [Patterns](#patterns)

A **CARML module** consists of

- The bicep template deployment file (`deploy.bicep`).
- One or multiple template parameters files (`*parameters.json`) that will be used for testing, located in the `.parameters` sub-folder.
- A `readme.md` file which describes the module itself.

A module usually represents a single resource or a set of closely related resources. For example, a storage account and the associated lock or virtual machine and network interfaces. Modules are located in the `arm` folder.

Also, each module should be implemented with all capabilities it and its children support. This includes
- `Locks`
- `RBAC`
- `Diagnostic Settings`
- and ideally also `Private Endpoints`.

## Structure

Modules in the repository are structured via the module's main resource provider (for example `Microsoft.Web`) and resource type (for example `serverfarms`) where each section of the path corresponds to its place in the hierarchy. However, for cases that do not fit into this schema we provide the following guidance:

### **Child-Resources**

Resources like `Microsoft.Sql/servers` may have dedicated templates for child-resources such as `Microsoft.Sql/servers/databases`. In these cases we recommend to create a sub-folder called after the child-resource name, so that the path to the child-resource folder is consistent with its resource type. In the given example we would have a sub-folder `databases` in the parent-folder `servers`.

```
Microsoft.Sql
└─ servers [module]
  └─ databases [child-module/resource]
```

In this folder we recommend to place the child-resource-template alongside a ReadMe (that can be generated via the [Set-ModuleReadMe](./UtilitiesSetModuleReadMe) script) and optionally further nest additional folders for it's child-resources.

The parent template should reference all it's direct child-templates to allow for an end-to-end deployment experience while allowing any user to also reference 'just' the child-resource itself. In the case of the SQL-server example the server template would reference the database module and encapsulate it it in a loop to allow for the deployment of n-amount of databases. For example

```Bicep
@description('Optional. The databases to create in the server')
param databases array = []

module server_databases 'databases/deploy.bicep' = [for (database, index) in databases: {}]
```

Each module should come with a `.bicep` folder with a least the `nested_cuaId.bicep` file in it

## Naming

Use the following naming standard for module files and folders:

- Module folders are in camelCase and their name reflects the main resource type of the Bicep module they are hosting (e.g. `storageAccounts`, `virtualMachines`).
- Cross-referenced and extension resource modules are placed in the `.bicep` subfolder and named `nested_<crossReferencedResourceType>.bicep`

  ``` txt
  Microsoft.<Provider>
  └─ <service>
      ├─ .bicep
      |  ├─ nested_crossReferencedResource1.bicep
      |  └─ nested_crossReferencedResource2.bicep
      ├─ .parameters
      |  └─ parameters.json
      ├─ deploy.bicep
      └─ readme.md
  ```

  >**Example**: `nested_serverfarms.bicep` in the `Microsoft.Web\sites\.bicep` folder contains the cross-referenced `serverfarm` module leveraged by the top level `site` resource.
  >``` txt
  >Microsoft.Web
  >└─ sites
  >    ├─ .bicep
  >    |  ├─ nested_components.bicep
  >    |  ├─ nested_cuaId.bicep
  >    |  ├─ nested_privateEndpoint.bicep
  >    |  ├─ nested_rbac.bicep
  >    |  └─ nested_serverfarms.bicep
  >    ├─ .parameters
  >    |  └─ parameters.json
  >    ├─ deploy.bicep
  >    └─ readme.md
  >```

## Patterns

This section details patterns among extension resources that are usually very similar in their structure among all modules supporting them:

- [Locks](#locks)
- [RBAC](#rbac)
- [Diagnostic Settings](#diagnostic-settings)
- [Private Endpoints](#private-endpoints)

### Locks

The locks extension can be added as a `resource` to the resource template directly.

```bicep
@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

resource <mainResource>_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${<mainResource>.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: <mainResource>
}
```

### RBAC

The RBAC deployment has 2 elements to it. A module that contains the implementation, and a module reference in the parent resource - each with it's own loop to enable you to deploy n-amount of role assignments to n-amount of principals.

#### 1st Element in main resource
```bicep
@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

module <mainResource>_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: <mainResource>.id
  }
}]
```

#### 2nd Element as nested `.bicep/nested_rbac.bicep` file

Here you specify the platform roles available for the main resource.

The `builtInRoleNames` variable contains the list of applicable roles for the specific resource to which the nested_rbac.bicep module applies.
>**Note**: You use the helper script [Get-FormattedRBACRoles.ps1](./UtilitiesGetFormattedRBACRoleList) to extract a formatted list of RBAC roles used in the CARML modules based on the RBAC lists in Azure.

The element requires you to provide both the `principalIds` & `roleDefinitionOrIdName` to assign to the principal IDs. Also, the `resourceId` is target resource's resource ID that allows us to reference it as an `existing` resource. Note, the implementation of the `split` in the resource reference becomes longer the deeper you go in the child-resource hierarchy.

```bicep
param principalIds array
param roleDefinitionIdOrName string
param resourceId string

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

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = [for principalId in principalIds: {
  name: guid(<mainResource>.name, principalId, roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleDefinitionIdOrName) ? builtInRoleNames[roleDefinitionIdOrName] : roleDefinitionIdOrName
    principalId: principalId
  }
  scope: <mainResource>
}]
```

### Diagnostic settings

The diagnostic settings may differ slightly depending from resource to resource. Most notably, the `<LogsIfAny>` as well as `<MetricsIfAny>` may be different and have to be added by you. However, it may just as well be the case they no metrics or no logs are existing. You can then remove the parameter and property from the resource itself.

```bicep
@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  <LogsIfAny>
])
param logsToEnable array = [
  <LogsIfAny>
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  <MetricsIfAny>
])
param metricsToEnable array = [
  <MetricsIfAny>
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsMetrics = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

resource <mainResource>_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: '${<mainResource>.name}-diagnosticSettings'
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

### Private Endpoints

The Private Endpoint deployment has 2 elements to it. A module that contains the implementation, and a module reference in the parent resource. The first loops through the endpoints we want to create, the second processes them.

#### 1st element in main resource

```bicep
@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

module <mainResource>_privateEndpoints '.bicep/nested_privateEndpoint.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-PrivateEndpoint-${index}'
  params: {
    privateEndpointResourceId: <mainResource>.id
    privateEndpointVnetLocation: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    privateEndpointObj: privateEndpoint
    tags: tags
  }
}]
```

#### 2nd Element as nested `.bicep/nested_privateEndpoint.bicep` file

```bicep
param privateEndpointResourceId string
param privateEndpointVnetLocation string
param privateEndpointObj object
param tags object

var privateEndpointResourceName = last(split(privateEndpointResourceId, '/'))
var privateEndpoint_var = {
  name: contains(privateEndpointObj, 'name') ? (empty(privateEndpointObj.name) ? '${privateEndpointResourceName}-${privateEndpointObj.service}' : privateEndpointObj.name) : '${privateEndpointResourceName}-${privateEndpointObj.service}'
  subnetResourceId: privateEndpointObj.subnetResourceId
  service: [
    privateEndpointObj.service
  ]
  privateDnsZoneResourceIds: contains(privateEndpointObj, 'privateDnsZoneResourceIds') ? (empty(privateEndpointObj.privateDnsZoneResourceIds) ? [] : privateEndpointObj.privateDnsZoneResourceIds) : []
  customDnsConfigs: contains(privateEndpointObj, 'customDnsConfigs') ? (empty(privateEndpointObj.customDnsConfigs) ? null : privateEndpointObj.customDnsConfigs) : null
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: privateEndpoint_var.name
  location: privateEndpointVnetLocation
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoint_var.name
        properties: {
          privateLinkServiceId: privateEndpointResourceId
          groupIds: privateEndpoint_var.service
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: privateEndpoint_var.subnetResourceId
    }
    customDnsConfigs: privateEndpoint_var.customDnsConfigs
  }
}

resource privateDnsZoneGroups 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = if (!empty(privateEndpoint_var.privateDnsZoneResourceIds)) {
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [for privateDnsZoneResourceId in privateEndpoint_var.privateDnsZoneResourceIds: {
      name: last(split(privateDnsZoneResourceId, '/'))
      properties: {
        privateDnsZoneId: privateDnsZoneResourceId
      }
    }]
  }
  parent: privateEndpoint
}
```

---

# Bicep template guidelines

Within a bicep file, use the following conventions:

- [Parameters](#parameters)
- [Variables](#variables)
- [Resources](#resources)
- [Modules](#modules)
- [Outputs](#outputs)

## Parameters

- Parameter names are in camelCase, e.g. `allowBlobPublicAccess`.
- Descriptions contain type of requirement:
  - `Optional` - Is not needed at any point. Module contains default values.
  - `Required` - Is required to be provided. Module does not have a default value and will expect input.
  - `Generated` - Should not be used to provide a parameter. Used to generate data used in the deployment that cannot be generated other places in the template. i.e. the `utcNow()` function.
  - `Conditional` - Optional or required parameter depending on other inputs.

## Variables

- Variable names are in camelCase, e.g. `builtInRoleNames`.

## Resources

- Resource names are in camelCase, e.g. `resourceGroup`.
- The name used as a reference is the singular name of the resource that it deploys, i.e:
  - `resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01'`
  - `resource virtualMachine 'Microsoft.Compute/virtualMachines@2020-06-01'`
- Parent reference
  - If working on a child-resource, refrain from string concatenation and instead use the parent reference via the `existing` keyword.
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

  - Module symbolic names are in camel_Snake_Case, following the schema `<mainResourceType>_<referencedResourceType>` e.g. `storageAccount_fileServices`, `virtualMachine_nic`, `resourceGroup_rbac`.
  - Modules enable you to reuse code from a Bicep file in other Bicep files. As such they're normally leveraged for deploying child resources (e.g. file services in a storage account), cross referenced resources (e.g. network interface in a virtual machine) or extension resources (e.g. role assignment in a resource group).

### Deployment names

When using modules from parent resources you will need to specify a name that, when deployed, will be used to assign the deployment name.

There are some constraints that needs to be considered when naming the deployment:

- Deployment name length can't exceed 64 chars.
- Two deployments with the same name created in different Azure locations (e.g. WestEurope & EastUS) in the same scope (e.g. resource group deployments) will fail.
- Using the same deployment name more than once, will surface only the most recent deployed one in the Azure Portal.
- If more than one deployment with the same name runs at the same time to the same scope, race condition might happen.
- Human-readable names are preferable, even if not necessary.

While exceptions might be needed, the following guidance should be followed as much as possible:

- When deploying more than one resource of the same referenced module is needed, we leverage loops using integer index and items in an array as per [Bicep loop syntax](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/loops#loop-syntax). In this case we also use `-${index}` as a suffix of the deployment name to avoid race condition:

  ```
  module symbolic_name 'path/to/referenced/module/deploy.bicep' = [for (<item>, <index>) in <collection>: {
    name: '<deploymentName>-${index}'
    ...
  }]
  ```
  > **Example**: for the `roleAssignment` deployment in the key vault `secrets` template
  > ```
  >   module secret_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  >     name: '${deployment().name}-Rbac-${index}'
  > ```

- For referenced resources of the top-level resource inside the top-level template use the following naming structure:

  ```
  '${uniqueString(deployment().name, location)}-<topLevelResourceType>-<referencedResourceType>'
  ```
  > **Example**: for the `tableServices` deployment inside the `storageAccount` template
  > ```
  > name: '${uniqueString(deployment().name, location)}-Storage-TableServices'
  > ```

- In the referenced resource template use the following naming structure:

  ```
  '${deployment().name}-<referencedResourceType>[-${index}]'
  ```
  > **Example**: for the `tables` deployment in the `tableServices` template
  > ```
  > name: '${deployment().name}-Table-${index}'
  > ```

## Outputs

- Output names are in camelCase, i.e `resourceId`
- At a minimum, reference the following:
  - `name`
  - `resourceId`
  - `resourceGroupName` for resources deployed at resource group scope
  - `systemAssignedPrincipalId` for all resources supporting a managed identity
- Add a `@description('...')` annotation with meaningful description to each output.

---

# ReadMe

Each module must come with a ReadMe markdown file that outlines what the module contains and 'how' it can be used.
Its primary components are in order:
- A title with a reference to the primary resource in Start Case followed by the primary resource namespace e.g. <code>Key Vaults `[Microsoft.KeyVault/vaults]`</code>.
- A short description
- A **Resource types** section with a table that outlines all resources that can be deployed as part of the module.
- A **Parameters** section with a table containing all parameters, their type, default and allowed values if any, and their description.
- Optionally, a **Parameter Usage** section that shows how to use complex structures such as parameter objects or array of objects, e.g. roleAssignments, tags, privateEndpoints.
- An **Outputs** section with a table that describes all outputs the module template returns.
- A **Template references** section listing relevant resources [ARM template reference](https://docs.microsoft.com/en-us/azure/templates).

Note the following recommendations
- Use our module ReadMe generation script [Set-ModuleReadMe](./UtilitiesSetModuleReadMe) that will do most of the work for you.
- It is not recommended to describe how to use child resources in the parent readme file (for example 'How to define a [container] entry for the [storage account]'). Instead it is recommended to reference the child resource's ReadMe instead (for example 'container/readme.md').

# Parameter files

Parameter files in CARML leverage the common `deploymentParameters.json` schema for ARM deployments. As parameters are usually specific to their corresponding template, we have only very few general recommendations:
- Parameter file names should ideally relate to the content they deploy. For example, a parameter file `min.parameters.json` should be chosen for a parameter file that contains only the minimum set of parameter to deploy the module.
- Likewise, the `name` parameter we have in most modules should give some indication of the file it was deployed with. For example, a `min.parameters.json` parameter file for the virtual network module may have a `name` property with the value `sxx-az-vnet-min-001` where `min` relates to the prefix of the parameter file itself.
- A module should have as many parameter files as it needs to evaluate all parts of the module's functionality.
- Sensitive data should not be stored inside the parameter file but rather be injected by the use of [tokens](./ParameterFileTokens.md) or via a [key vault reference](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/key-vault-parameter?tabs=azure-cli#reference-secrets-with-static-id).
