function Set-DiagnosticModuleData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $true)]
        [Hashtable] $ModuleData
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        $resourceTypeSingular = Get-ResourceTypeSingularName -ResourceType $ResourceType
        $diagnosticOptions = Get-DiagnosticOptionsList -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType

        if (-not $diagnosticOptions) {
            return
        }

        $ModuleData.additionalParameters += @(
            @{
                name        = 'diagnosticLogsRetentionInDays'
                type        = 'int'
                description = 'Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.'
                required    = $false
                default     = 365
                minimum     = 0
                maximum     = 365
            }
            @{
                name        = 'diagnosticStorageAccountId'
                type        = 'string'
                description = 'Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.'
                required    = $false
                default     = ''
            }
            @{
                name        = 'diagnosticWorkspaceId'
                type        = 'string'
                description = 'Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.'
                required    = $false
                default     = ''
            }
            @{
                name        = 'diagnosticEventHubAuthorizationRuleId'
                type        = 'string'
                description = 'Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.'
                required    = $false
                default     = ''
            }
            @{
                name        = 'diagnosticEventHubName'
                type        = 'string'
                description = 'Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.'
                required    = $false
                default     = ''
            }
        )

        $diagnosticResource = @(
            "resource $($resourceTypeSingular)_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {"
            '  name: diagnosticSettingsName'
            '  properties: {'
            '    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null'
            '    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null'
            '    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null'
            '    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null'
        )

        # Metric-specific
        if ($diagnosticOptions.Metrics) {
            # TODO: Clarify: Might need to be always 'All metrics' if any metric exists
            $ModuleData.additionalParameters += @(
                @{
                    name          = 'diagnosticMetricsToEnable'
                    type          = 'array'
                    description   = 'The name of metrics that will be streamed.'
                    required      = $false
                    allowedValues = @(
                        'AllMetrics'
                    )
                    default       = @(
                        'AllMetrics'
                    )
                }
            )
            $ModuleData.variables += @(
                'var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {'
                '  category: metric'
                '  timeGrain: null'
                '  enabled: true'
                '  retentionPolicy: {'
                '    enabled: true'
                '    days: diagnosticLogsRetentionInDays'
                '  }'
                '}]'
                ''
            )

            $diagnosticResource += '    metrics: diagnosticsMetrics'
        }

        # Log-specific
        if ($diagnosticOptions.Logs) {
            $ModuleData.additionalParameters += @(
                @{
                    name          = 'diagnosticLogCategoriesToEnable'
                    type          = 'array'
                    description   = 'The name of logs that will be streamed.'
                    required      = $false
                    allowedValues = $diagnosticOptions.Logs
                    default       = $diagnosticOptions.Logs
                }
            )
            $ModuleData.variables += @(
                'var diagnosticsLogs = [for category in diagnosticLogCategoriesToEnable: {'
                '  category: category'
                '  enabled: true'
                '  retentionPolicy: {'
                '    enabled: true'
                '    days: diagnosticLogsRetentionInDays'
                '  }'
                '}]'
                ''
            )

            $diagnosticResource += '    logs: diagnosticsLogs'
        }

        $diagnosticResource += @(
            '  }'
            "  scope: $resourceTypeSingular"
            '}'
            ''
        )

        $ModuleData.resources += $diagnosticResource

        # Other variables
        $ModuleData.variables += @(
            "@description('Optional. The name of the diagnostic setting, if deployed.')"
            "param diagnosticSettingsName string = '`${name}-diagnosticSettings'"
        )
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
