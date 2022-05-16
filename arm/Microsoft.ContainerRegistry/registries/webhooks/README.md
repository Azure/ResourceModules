# Container Registry Webhooks

This module deploys an Container Registry webhook.

## **TABLE OF CONTENTS**

## Resource Types

| Resource Type                                         | Api Version        |
| :---------------------------------------------------- | :----------------- |
| `Microsoft.ContainerRegistry/registries`              | 2021-09-01         |
| `Microsoft.ContainerRegistry/registries/webhooks` | 2021-12-01-preview |

## Parameters

| Parameter Name       | Type   | Default Value                       | Possible Values           | Description                                                     |
| :------------------- | :----- | :---------------------------------- | :------------------------ | :-------------------------------------------------------------- |
| `registryName`       | string | N/A                                 |                           | Name of the Registry (Required)                                   |
| `location`           | string | resourceGroup().location            | Any Azure location        | location of the resource                                        |
| `webhookName`                | string | ${registryName}-webhook                          | | name of the webhook                              |
| `serviceUri`    | string   |                 N/A               |              | Name of the serviceUri (required)    |
| `status`       | string | enabled                               | enabled, disabled               | statys of webhook                                    |
| `action`     | array | [   'chart_delete' ,'chart_push', 'delete',  'push','quarantine' ] |         [   'chart_delete' ,'chart_push', 'delete',  'push','quarantine' ]                  | available actions |
| `tags`        | object | {}                            |          | tags    |
| `customHeaders`          | object | {}                            |     | custom headers for webhooks                                |
| `retPolicyDays`      | int    | 30                                  | 0-100                     | Retention days of retention policy on ACR                       |
| `scope`  | string | ''                                  | N/A                       |scopes like foo:*         |
