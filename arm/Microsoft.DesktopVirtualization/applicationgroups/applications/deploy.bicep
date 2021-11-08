@description('Required. Name of the Application Group to create the application(s) in.')
param appGroupName string

@description('Required. Name of the Application to be created in the Application Group.')
param name string

@description('Optional. Description of Application..')
param appDescription string = ''

@description('Optional. Friendly name of Application..')
param friendlyName string = ''

@description('Required. Specifies a path for the executable file for the application.')
param filePath string

@allowed([
  'Allow'
  'DoNotAllow'
  'Require'
])
@description('Optional. Specifies whether this published application can be launched with command line arguments provided by the client, command line arguments specified at publish time, or no command line arguments at all.')
param commandLineSetting string = 'DoNotAllow'

@description('Optional. Command Line Arguments for Application.')
param commandLineArguments string = ''

@description('Optional. Specifies whether to show the RemoteApp program in the RD Web Access server.')
param showInPortal bool = false

@description('Optional. Path to icon.')
param iconPath string = ''

@description('Optional. Index of the icon.')
param iconIndex int = 0

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource application 'Microsoft.DesktopVirtualization/applicationGroups/applications@2021-07-12' = {
  name: '${appGroupName}/${name}'
  properties: {
    description: appDescription
    friendlyName: friendlyName
    filePath: filePath
    commandLineSetting: commandLineSetting
    commandLineArguments: commandLineArguments
    showInPortal: showInPortal
    iconPath: iconPath
    iconIndex: iconIndex
  }
}

@description('The resource id of the deployed Application.')
output applicationResourceIds string = application.id
@description('The name of the Resource Group the AVD Application was created in.')
output applicationResourceGroup string = resourceGroup().name
@description('The Name of the Application Group to register the Application in.')
output appGroupName string = appGroupName
