@sys.description('Conditional. The name of the parent lab. Required if the template is used in a standalone deployment.')
param labName string

@allowed([
  'LabVmsShutdown'
  'LabVmAutoStart'
])
@sys.description('Required. The name of the schedule.')
param name string

@allowed([
  'LabVmsShutdownTask'
  'LabVmsStartupTask'
])
@sys.description('Required. The task type of the schedule (e.g. LabVmsShutdownTask, LabVmsStartupTask).')
param taskType string

@sys.description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@sys.description('Optional. Tags of the resource.')
param tags object = {}

@sys.description('Optional. If the schedule will occur once each day of the week, specify the daily recurrence.')
param dailyRecurrence object = {}

@sys.description('Optional. If the schedule will occur multiple times a day, specify the hourly recurrence.')
param hourlyRecurrence object = {}

@sys.description('Optional. If the schedule will occur only some days of the week, specify the weekly recurrence.')
param weeklyRecurrence object = {}

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. The status of the schedule (i.e. Enabled, Disabled). Default is "Enabled".')
param status string = 'Enabled'

@sys.description('Optional. The resource ID to which the schedule belongs.')
param targetResourceId string = ''

@sys.description('Optional. The time zone ID (e.g. Pacific Standard time).')
param timeZoneId string = 'Pacific Standard time'

@allowed([
  'Enabled'
  'Disabled'
])
@sys.description('Optional. If notifications are enabled for this schedule (i.e. Enabled, Disabled). Default is "Disabled".')
param notificationSettingsStatus string = 'Disabled'

@sys.description('Conditional. The email recipient to send notifications to (can be a list of semi-colon separated email addresses). Required if "notificationSettingsStatus" is set to "Enabled" and "notificationSettingsWebhookUrl" is empty.')
param notificationSettingsEmailRecipient string = ''

@sys.description('Conditional. The webhook URL to which the notification will be sent. Required if "notificationSettingsStatus" is set to "Enabled" and "notificationSettingsWebhookUrl" is empty.')
param notificationSettingsWebhookUrl string = ''

@sys.description('Optional. The locale to use when sending a notification (fallback for unsupported languages is EN). Optional if "notificationSettingsStatus" is set to "Enabled". Default is "en".')
param notificationSettingsNotificationLocale string = 'en'

@sys.description('Optional. Time in minutes before event at which notification will be sent. Default is "30". Optional if "notificationSettingsStatus" is set to "Enabled". Default is 30 minutes.')
param notificationSettingsTimeInMinutes int = 30

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var notificationSettings = notificationSettingsStatus == 'Enabled' ? {
  status: notificationSettingsStatus
  emailRecipient: notificationSettingsEmailRecipient
  webhookUrl: notificationSettingsWebhookUrl
  notificationLocale: notificationSettingsNotificationLocale
  timeInMinutes: notificationSettingsTimeInMinutes
} : {}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource lab 'Microsoft.DevTestLab/labs@2018-10-15-preview' existing = {
  name: labName
}

resource schedule 'Microsoft.DevTestLab/labs/schedules@2018-10-15-preview' = {
  name: name
  parent: lab
  location: location
  tags: tags
  properties: {
    taskType: taskType
    dailyRecurrence: !empty(dailyRecurrence) ? dailyRecurrence : null
    hourlyRecurrence: !empty(hourlyRecurrence) ? hourlyRecurrence : null
    weeklyRecurrence: !empty(weeklyRecurrence) ? weeklyRecurrence : null
    status: status
    targetResourceId: !empty(targetResourceId) ? targetResourceId : null
    timeZoneId: timeZoneId
    notificationSettings: notificationSettings
  }
}

@sys.description('The name of the schedule.')
output name string = schedule.name

@sys.description('The resource ID of the schedule.')
output resourceId string = schedule.id

@sys.description('The name of the resource group the schedule was created in.')
output resourceGroupName string = resourceGroup().name
