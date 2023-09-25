<#
.SYNOPSIS
Populate the provided ModuleData with all parameters, variables & resources required for diagnostic settings.

.DESCRIPTION
Populate the provided ModuleData with all parameters, variables & resources required for diagnostic settings.

.PARAMETER ResourceType
Mandatory. The ResourceType to fetch the available diagnostic options for.

.PARAMETER ModuleData
Mandatory. The ModuleData object to populate.

.EXAMPLE
Set-DiagnosticModuleData -ResourceType 'vaults' -ModuleData @{ parameters = @(...); resources = @(...); (...) }

Add the diagnostic module data of the resource type [Microsoft.KeyVault/vaults] to the provided module data object
#>
function Set-DiagnosticModuleData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [string[]] $DiagnosticMetricsOptions = @(),

        [Parameter(Mandatory = $false)]
        [string[]] $DiagnosticLogsOptions = @(),

        [Parameter(Mandatory = $true)]
        [Hashtable] $ModuleData
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        $resourceTypeSingular = ((Get-ResourceTypeSingularName -ResourceType $resourceType) -split '/')[-1]

        # Type check (in case PowerShell auto-converted the array to a hashtable)
        if ($ModuleData.additionalParameters -is [hashtable]) {
            $ModuleData.additionalParameters = @($ModuleData.additionalParameters)
        }
        if ($ModuleData.variables -is [hashtable]) {
            $ModuleData.variables = @($ModuleData.variables)
        }
        if ($ModuleData.resources -is [hashtable]) {
            $ModuleData.resources = @($ModuleData.resources)
        }

        $ModuleData.additionalParameters += @(
            @{
                name        = 'diagnosticLogsRetentionInDays'
                type        = 'integer'
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

        $diagnosticResource = @{
            name    = "$($resourceTypeSingular)_diagnosticSettings"
            content = @(
                "resource $($resourceTypeSingular)_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {"
                '  name: diagnosticSettingsName'
                '  properties: {'
                '    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null'
                '    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null'
                '    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null'
                '    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null'
            )
        }

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
            $ModuleData.variables += @{
                name    = 'diagnosticsMetrics'
                content = @(
                    'var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {'
                    '  category: metric'
                    '  timeGrain: null'
                    '  enabled: true'
                    '  retentionPolicy: {'
                    '    enabled: true'
                    '    days: diagnosticLogsRetentionInDays'
                    '  }'
                    '}]'
                )
            }

            $diagnosticResource.content += '    metrics: diagnosticsMetrics'
        }

        # Log-specific
        if ($DiagnosticLogsOptions) {
            $ModuleData.additionalParameters += @(
                @{
                    name          = 'diagnosticLogCategoriesToEnable'
                    type          = 'array'
                    description   = 'The name of logs that will be streamed.'
                    required      = $false
                    allowedValues = $DiagnosticLogsOptions
                    default       = $DiagnosticLogsOptions
                }
            )
            $ModuleData.variables += @{
                name    = 'diagnosticsLogs'
                content = @(
                    'var diagnosticsLogs = [for category in diagnosticLogCategoriesToEnable: {'
                    '  category: category'
                    '  enabled: true'
                    '  retentionPolicy: {'
                    '    enabled: true'
                    '    days: diagnosticLogsRetentionInDays'
                    '  }'
                    '}]'
                )
            }

            $diagnosticResource.content += '    logs: diagnosticsLogs'
        }

        $diagnosticResource.content += @(
            '  }'
            "  scope: $resourceTypeSingular"
            '}'
            ''
        )

        $ModuleData.resources += $diagnosticResource

        # Other variables
        $ModuleData.additionalParameters += @(
            @{
                name        = 'diagnosticSettingsName'
                type        = 'string'
                description = 'The name of the diagnostic setting, if deployed.'
                required    = $false
                default     = '${name}-diagnosticSettings'
            }
        )
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
