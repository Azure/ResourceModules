metadata name = 'Azure Virtual Desktop (AVD) Application Group Applications'
metadata description = 'This module deploys an Azure Virtual Desktop (AVD) Application Group Application.'
metadata owner = 'Azure/module-maintainers'

@sys.description('Conditional. The name of the parent Application Group to create the application(s) in. Required if the template is used in a standalone deployment.')
param appGroupName string

@sys.description('Required. Name of the Application to be created in the Application Group.')
param name string

@sys.description('Optional. Description of Application..')
param description string = ''

@sys.description('Required. Friendly name of Application..')
param friendlyName string

@sys.description('Required. Specifies a path for the executable file for the application.')
param filePath string

@allowed([
  'Allow'
  'DoNotAllow'
  'Require'
])
@sys.description('Optional. Specifies whether this published application can be launched with command-line arguments provided by the client, command-line arguments specified at publish time, or no command-line arguments at all.')
param commandLineSetting string = 'DoNotAllow'

@sys.description('Optional. Command-Line Arguments for Application.')
param commandLineArguments string = ''

@sys.description('Optional. Specifies whether to show the RemoteApp program in the RD Web Access server.')
param showInPortal bool = false

@sys.description('Optional. Path to icon.')
param iconPath string = ''

@sys.description('Optional. Index of the icon.')
param iconIndex int = 0

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource applicationGroup 'Microsoft.DesktopVirtualization/applicationGroups@2022-09-09' existing = {
  name: appGroupName
}

resource application 'Microsoft.DesktopVirtualization/applicationGroups/applications@2022-09-09' = {
  name: name
  parent: applicationGroup
  properties: {
    description: description
    friendlyName: friendlyName
    filePath: filePath
    commandLineSetting: commandLineSetting
    commandLineArguments: commandLineArguments
    showInPortal: showInPortal
    iconPath: iconPath
    iconIndex: iconIndex
  }
}

@sys.description('The resource ID of the deployed Application.')
output resourceId string = application.id

@sys.description('The name of the Resource Group the AVD Application was created in.')
output resourceGroupName string = resourceGroup().name

@sys.description('The Name of the Application Group to register the Application in.')
output name string = appGroupName
