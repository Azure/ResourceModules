@description('Required. Name of the Application Gateway.')
@maxLength(24)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Authentication certificates of the application gateway resource.')
param authenticationCertificates array = []

@description('Optional. Upper bound on number of Application Gateway capacity.')
param autoscaleMaxCapacity int = 10

@description('Optional. Lower bound on number of Application Gateway capacity.')
param autoscaleMinCapacity int = 0

@description('Optional. Backend address pool of the application gateway resource.')
param backendAddressPools array = []

@description('Optional. Backend http settings of the application gateway resource.')
param backendHttpSettingsCollection array = []

@description('Optional. Custom error configurations of the application gateway resource.')
param customErrorConfigurations array = []

@description('Optional. Whether FIPS is enabled on the application gateway resource.')
param enableFips bool = false

@description('Optional. Whether HTTP2 is enabled on the application gateway resource.')
param enableHttp2 bool = false

@description('Optional. The resource Id of an associated firewall policy.')
param firewallPolicyId string = ''

@description('Optional. Frontend IP addresses of the application gateway resource.')
param frontendIPConfigurations array = []

@description('Optional. Frontend ports of the application gateway resource.')
param frontendPorts array = []

@description('Optional. Subnets of the application gateway resource.')
param gatewayIPConfigurations array = []

@description('Optional. Enable request buffering.')
param enableRequestBuffering bool = false

@description('Optional. Enable response buffering.')
param enableResponseBuffering bool = false

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. ')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub')
param diagnosticEventHubName string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'ApplicationGatewayAccessLog'
  'ApplicationGatewayPerformanceLog'
  'ApplicationGatewayFirewallLog'
])
param logsToEnable array = [
  'ApplicationGatewayAccessLog'
  'ApplicationGatewayPerformanceLog'
  'ApplicationGatewayFirewallLog'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param metricsToEnable array = [
  'AllMetrics'
]

var identityType = !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

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

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Resource tags.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource applicationGateway 'Microsoft.Network/applicationGateways@2021-05-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    authenticationCertificates: authenticationCertificates
    autoscaleConfiguration: {
      maxCapacity: autoscaleMaxCapacity
      minCapacity: autoscaleMinCapacity
    }
    backendAddressPools: backendAddressPools
    backendHttpSettingsCollection: backendHttpSettingsCollection
    customErrorConfigurations: customErrorConfigurations
    enableFips: enableFips
    enableHttp2: enableHttp2
    firewallPolicy: empty(firewallPolicyId) ? {
      id: firewallPolicyId
    } : null
    forceFirewallPolicyAssociation: !empty(firewallPolicyId)
    frontendIPConfigurations: frontendIPConfigurations
    frontendPorts: frontendPorts
    gatewayIPConfigurations: gatewayIPConfigurations
    globalConfiguration: {
      enableRequestBuffering: enableRequestBuffering
      enableResponseBuffering: enableResponseBuffering
    }
    httpListeners: [
      {
        id: 'string'
        name: 'string'
        properties: {
          customErrorConfigurations: [
            {
              customErrorPageUrl: 'string'
              statusCode: 'string'
            }
          ]
          firewallPolicy: {
            id: 'string'
          }
          frontendIPConfiguration: {
            id: 'string'
          }
          frontendPort: {
            id: 'string'
          }
          hostName: 'string'
          hostNames: [
            'string'
          ]
          protocol: 'string'
          requireServerNameIndication: bool
          sslCertificate: {
            id: 'string'
          }
          sslProfile: {
            id: 'string'
          }
        }
      }
    ]
    loadDistributionPolicies: [
      {
        id: 'string'
        name: 'string'
        properties: {
          loadDistributionAlgorithm: 'string'
          loadDistributionTargets: [
            {
              id: 'string'
              name: 'string'
              properties: {
                backendAddressPool: {
                  id: 'string'
                }
                weightPerServer: int
              }
            }
          ]
        }
      }
    ]
    privateLinkConfigurations: [
      {
        id: 'string'
        name: 'string'
        properties: {
          ipConfigurations: [
            {
              id: 'string'
              name: 'string'
              properties: {
                primary: bool
                privateIPAddress: 'string'
                privateIPAllocationMethod: 'string'
                subnet: {
                  id: 'string'
                }
              }
            }
          ]
        }
      }
    ]
    probes: [
      {
        id: 'string'
        name: 'string'
        properties: {
          host: 'string'
          interval: int
          match: {
            body: 'string'
            statusCodes: [
              'string'
            ]
          }
          minServers: int
          path: 'string'
          pickHostNameFromBackendHttpSettings: bool
          port: int
          protocol: 'string'
          timeout: int
          unhealthyThreshold: int
        }
      }
    ]
    redirectConfigurations: [
      {
        id: 'string'
        name: 'string'
        properties: {
          includePath: bool
          includeQueryString: bool
          pathRules: [
            {
              id: 'string'
            }
          ]
          redirectType: 'string'
          requestRoutingRules: [
            {
              id: 'string'
            }
          ]
          targetListener: {
            id: 'string'
          }
          targetUrl: 'string'
          urlPathMaps: [
            {
              id: 'string'
            }
          ]
        }
      }
    ]
    requestRoutingRules: [
      {
        id: 'string'
        name: 'string'
        properties: {
          backendAddressPool: {
            id: 'string'
          }
          backendHttpSettings: {
            id: 'string'
          }
          httpListener: {
            id: 'string'
          }
          loadDistributionPolicy: {
            id: 'string'
          }
          priority: int
          redirectConfiguration: {
            id: 'string'
          }
          rewriteRuleSet: {
            id: 'string'
          }
          ruleType: 'string'
          urlPathMap: {
            id: 'string'
          }
        }
      }
    ]
    rewriteRuleSets: [
      {
        id: 'string'
        name: 'string'
        properties: {
          rewriteRules: [
            {
              actionSet: {
                requestHeaderConfigurations: [
                  {
                    headerName: 'string'
                    headerValue: 'string'
                  }
                ]
                responseHeaderConfigurations: [
                  {
                    headerName: 'string'
                    headerValue: 'string'
                  }
                ]
                urlConfiguration: {
                  modifiedPath: 'string'
                  modifiedQueryString: 'string'
                  reroute: bool
                }
              }
              conditions: [
                {
                  ignoreCase: bool
                  negate: bool
                  pattern: 'string'
                  variable: 'string'
                }
              ]
              name: 'string'
              ruleSequence: int
            }
          ]
        }
      }
    ]
    sku: {
      capacity: int
      name: 'string'
      tier: 'string'
    }
    sslCertificates: [
      {
        id: 'string'
        name: 'string'
        properties: {
          data: 'string'
          keyVaultSecretId: 'string'
          password: 'string'
        }
      }
    ]
    sslPolicy: {
      cipherSuites: [
        'string'
      ]
      disabledSslProtocols: [
        'string'
      ]
      minProtocolVersion: 'string'
      policyName: 'string'
      policyType: 'string'
    }
    sslProfiles: [
      {
        id: 'string'
        name: 'string'
        properties: {
          clientAuthConfiguration: {
            verifyClientCertIssuerDN: bool
          }
          sslPolicy: {
            cipherSuites: [
              'string'
            ]
            disabledSslProtocols: [
              'string'
            ]
            minProtocolVersion: 'string'
            policyName: 'string'
            policyType: 'string'
          }
          trustedClientCertificates: [
            {
              id: 'string'
            }
          ]
        }
      }
    ]
    trustedClientCertificates: [
      {
        id: 'string'
        name: 'string'
        properties: {
          data: 'string'
        }
      }
    ]
    trustedRootCertificates: [
      {
        id: 'string'
        name: 'string'
        properties: {
          data: 'string'
          keyVaultSecretId: 'string'
        }
      }
    ]
    urlPathMaps: [
      {
        id: 'string'
        name: 'string'
        properties: {
          defaultBackendAddressPool: {
            id: 'string'
          }
          defaultBackendHttpSettings: {
            id: 'string'
          }
          defaultLoadDistributionPolicy: {
            id: 'string'
          }
          defaultRedirectConfiguration: {
            id: 'string'
          }
          defaultRewriteRuleSet: {
            id: 'string'
          }
          pathRules: [
            {
              id: 'string'
              name: 'string'
              properties: {
                backendAddressPool: {
                  id: 'string'
                }
                backendHttpSettings: {
                  id: 'string'
                }
                firewallPolicy: {
                  id: 'string'
                }
                loadDistributionPolicy: {
                  id: 'string'
                }
                paths: [
                  'string'
                ]
                redirectConfiguration: {
                  id: 'string'
                }
                rewriteRuleSet: {
                  id: 'string'
                }
              }
            }
          ]
        }
      }
    ]
    webApplicationFirewallConfiguration: {
      disabledRuleGroups: [
        {
          ruleGroupName: 'string'
          rules: [
            int
          ]
        }
      ]
      enabled: bool
      exclusions: [
        {
          matchVariable: 'string'
          selector: 'string'
          selectorMatchOperator: 'string'
        }
      ]
      fileUploadLimitInMb: int
      firewallMode: 'string'
      maxRequestBodySize: int
      maxRequestBodySizeInKb: int
      requestBodyCheck: bool
      ruleSetType: 'string'
      ruleSetVersion: 'string'
    }
  }
  zones: [
    'string'
  ]
}

resource applicationGateway_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${applicationGateway.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: applicationGateway
}

resource applicationGateway_diagnosticSettingName 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: '${applicationGateway.name}-diagnosticSettings'
  properties: {
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    workspaceId: empty(diagnosticWorkspaceId) ? null : diagnosticWorkspaceId
    eventHubAuthorizationRuleId: empty(diagnosticEventHubAuthorizationRuleId) ? null : diagnosticEventHubAuthorizationRuleId
    eventHubName: empty(diagnosticEventHubName) ? null : diagnosticEventHubName
    metrics: empty(diagnosticStorageAccountId) && empty(diagnosticWorkspaceId) && empty(diagnosticEventHubAuthorizationRuleId) && empty(diagnosticEventHubName) ? null : diagnosticsMetrics
    logs: empty(diagnosticStorageAccountId) && empty(diagnosticWorkspaceId) && empty(diagnosticEventHubAuthorizationRuleId) && empty(diagnosticEventHubName) ? null : diagnosticsLogs
  }
  scope: applicationGateway
}

module applicationGateway_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AppGateway-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: applicationGateway.id
  }
}]

@description('The name of the application gateway')
output name string = applicationGateway.name

@description('The resource ID of the application gateway')
output resourceId string = applicationGateway.id

@description('The resource group the application gateway was deployed into')
output resourceGroupName string = resourceGroup().name
