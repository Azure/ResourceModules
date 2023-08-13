<#
.SYNOPSIS
Re-format the name of every CARML module to match the requirements of the Public Bicep Registry

.DESCRIPTION
The names are formatted as per the following rules:
- Add a '-' prefix to every upper-case character
- Make the entire name lower case

For example, it re-formats
- 'AppConfiguration\configurationStores\keyValues\deploy.bicep'
to
- app-configuration\configuration-stores\key-values\deploy.bicep

.PARAMETER ModulesFolderPath
Mandatory. The path to the modules who's folder names should be converted.

.EXAMPLE
Set-CARMLFoldersForPBRSingular -ModulesFolderPath 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules'

Convert all folders in path 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules'

.EXAMPLE
Set-CARMLFoldersForPBRSingular -ModulesFolderPath 'C:\dev\ip\GitHub\Azure\ResourceModules\modules' -WorkflowsPath 'C:\dev\ip\GitHub\Azure\ResourceModules\.github\workflows' -PipelinesPath 'C:\dev\ip\GitHub\Azure\ResourceModules\.azuredevops\modulePipelines' -UtilitiesPath 'C:\dev\ip\GitHub\Azure\ResourceModules\utilities' -Verbose

Convert all folders in path 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules' and replaces all pipeline, workflows and utility references

.EXAMPLE
Set-CARMLFoldersForPBRSingular -ResourceProviderPath 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules\KeyVault'

Convert all folders in path 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules\KeyVault' included

.NOTES
This script should only be run AFTER the 'Microsoft.' provider namespace prefix was removed.
Identifiers such as 'DBforPostgreSQL' becomes 'd-bfor-postgre-s-q-l' which should probably be manually reverted to 'db-for-postgre-sql'.
#>
function Set-CARMLFoldersForPBRSingular {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModulesFolderPath,

        [Parameter(Mandatory = $false)]
        [string] $ResourceProviderPath = '',

        [Parameter(Mandatory = $false)]
        [string] $WorkflowsPath = '',

        [Parameter(Mandatory = $false)]
        [string] $PipelinesPath = '',

        [Parameter(Mandatory = $false)]
        [string] $UtilitiesPath = ''
    )

    # $specialConversionHash = @{
    #     'a'                                                     = 'a'
    #     'aaaa'                                                  = 'aaaa'
    #     'access-policies'                                       = 'access-policy'
    #     'accounts'                                              = 'account'
    #     'action-groups'                                         = 'action-group'
    #     'activity-log-alerts'                                   = 'activity-log-alert'
    #     'administrators'                                        = 'administrator'
    #     'agent-pools'                                           = 'agent-pool'
    #     'api-version-sets'                                      = 'api-version-set'
    #     'apis'                                                  = 'api'
    #     'application-gateway-web-application-firewall-policies' = 'application-gateway-web-application-firewall-policy'
    #     'application-gateways'                                  = 'application-gateway'
    #     'application-groups'                                    = 'application-group'
    #     'application-security-groups'                           = 'application-security-group'
    #     'application-types'                                     = 'application-type'
    #     'applications'                                          = 'application'
    #     'artifactsources'                                       = 'artifactsource'
    #     'authorization-rules'                                   = 'authorization-rule'
    #     'authorization-servers'                                 = 'authorization-server'
    #     'automation-accounts'                                   = 'automation-account'
    #     'availability-sets'                                     = 'availability-set'
    #     'azure-firewalls'                                       = 'azure-firewall'
    #     'azure-security-center'                                 = 'azure-security-center'
    #     'backend-address-pools'                                 = 'backend-address-pool'
    #     'backends'                                              = 'backend'
    #     'backup-config'                                         = 'backup-config'
    #     'backup-long-term-retention-policies'                   = 'backup-long-term-retention-policy'
    #     'backup-fabrics'                                        = 'backup-fabric'
    #     'backup-policies'                                       = 'backup-policy'
    #     'backup-short-term-retention-policies'                  = 'backup-short-term-retention-policy'
    #     'backup-storage-config'                                 = 'backup-storage-config'
    #     'backup-vaults'                                         = 'backup-vault'
    #     'basic-publishing-credentials-policies'                 = 'basic-publishing-credentials-policy'
    #     'bastion-hosts'                                         = 'bastion-host'
    #     'batch-accounts'                                        = 'batch-account'
    #     'blob-services'                                         = 'blob-service'
    #     'budgets'                                               = 'budget'
    #     'caa'                                                   = 'caa'
    #     'caches'                                                = 'cache'
    #     'capacities'                                            = 'capacity'
    #     'capacity-pools'                                        = 'capacity-pool'
    #     'clusters'                                              = 'cluster'
    #     'cname'                                                 = 'cname'
    #     'collections'                                           = 'collection'
    #     'components'                                            = 'component'
    #     'computes'                                              = 'compute'
    #     'config'                                                = 'config'
    #     'config--appsettings'                                   = 'config--appsetting'
    #     'config--authsettingsv2'                                = 'config--authsettingsv2'
    #     'configuration-stores'                                  = 'configuration-store'
    #     'configurations'                                        = 'configuration'
    #     'configurations--customdnssuffix'                       = 'configurations--customdnssuffix'
    #     'configurations--networking'                            = 'configurations--networking'
    #     'connection-monitors'                                   = 'connection-monitor'
    #     'connections'                                           = 'connection'
    #     'connectivity-configurations'                           = 'connectivity-configuration'
    #     'consumergroups'                                        = 'consumergroup'
    #     'container-apps'                                        = 'container-app'
    #     'container-groups'                                      = 'container-group'
    #     'containers'                                            = 'container'
    #     'costs'                                                 = 'cost'
    #     'custom-domains'                                        = 'custom-domain'
    #     'data-collection-endpoints'                             = 'data-collection-endpoint'
    #     'data-collection-rules'                                 = 'data-collection-rule'
    #     'data-exports'                                          = 'data-export'
    #     'data-sources'                                          = 'data-source'
    #     'database-accounts'                                     = 'database-account'
    #     'databases'                                             = 'database'
    #     'ddos-protection-plans'                                 = 'ddos-protection-plan'
    #     'deployment-scripts'                                    = 'deployment-script'
    #     'diagnostic-settings'                                   = 'diagnostic-setting'
    #     'dicomservices'                                         = 'dicomservice'
    #     'digital-twins-instances'                               = 'digital-twins-instance'
    #     'disaster-recovery-configs'                             = 'disaster-recovery-config'
    #     'disk-encryption-sets'                                  = 'disk-encryption-set'
    #     'disks'                                                 = 'disk'
    #     'dns-forwarding-rulesets'                               = 'dns-forwarding-ruleset'
    #     'dns-resolvers'                                         = 'dns-resolver'
    #     'dns-zones'                                             = 'dns-zone'
    #     'domain-services'                                       = 'domain-service'
    #     'domains'                                               = 'domain'
    #     'elastic-pools'                                         = 'elastic-pool'
    #     'encryption-protector'                                  = 'encryption-protector'
    #     'endpoints'                                             = 'endpoint'
    #     'endpoints--event-grid'                                 = 'endpoints--event-grid'
    #     'endpoints--event-hub'                                  = 'endpoints--event-hub'
    #     'endpoints--service-bus'                                = 'endpoints--service-bus'
    #     'eventhubs'                                             = 'eventhub'
    #     'eventSubscriptions'                                    = 'eventSubscription'
    #     'express-route-circuits'                                = 'express-route-circuit'
    #     'express-route-gateway'                                 = 'express-route-gateway'
    #     'extensions'                                            = 'extension'
    #     'factories'                                             = 'factory'
    #     'fhirdestinations'                                      = 'fhirdestination'
    #     'fhirservices'                                          = 'fhirservice'
    #     'file-services'                                         = 'file-service'
    #     'firewall-policies'                                     = 'firewall-policy'
    #     'firewall-rules'                                        = 'firewall-rule'
    #     'flexible-servers'                                      = 'flexible-server'
    #     'flow-logs'                                             = 'flow-log'
    #     'flux-configurations'                                   = 'flux-configuration'
    #     'forwarding-rules'                                      = 'forwarding-rule'
    #     'front-doors'                                           = 'front-door'
    #     'galleries'                                             = 'gallery'
    #     'graphs'                                                = 'graph'
    #     'gremlin-databases'                                     = 'gremlin-database'
    #     'groups'                                                = 'group'
    #     'health-bots'                                           = 'health-bot'
    #     'host-pools'                                            = 'host-pool'
    #     'hosting-environments'                                  = 'hosting-environment'
    #     'hub-route-tables'                                      = 'hub-route-table'
    #     'hub-virtual-network-connections'                       = 'hub-virtual-network-connection'
    #     'hybrid-connections'                                    = 'hybrid-connection'
    #     'hybrid-connection-namespaces'                          = 'hybrid-connection-namespace'
    #     'identity-providers'                                    = 'identity-provider'
    #     'image-templates'                                       = 'image-template'
    #     'images'                                                = 'image'
    #     'immutability-policies'                                 = 'immutability-policy'
    #     'inbound-nat-rules'                                     = 'inbound-nat-rule'
    #     'integration-runtimes'                                  = 'integration-runtime'
    #     'iotconnectors'                                         = 'iotconnector'
    #     'ip-groups'                                             = 'ip-group'
    #     'job-schedules'                                         = 'job-schedule'
    #     'key-values'                                            = 'key-value'
    #     'keys'                                                  = 'key'
    #     'labs'                                                  = 'lab'
    #     'linked-backends'                                       = 'linked-backend'
    #     'linked-services'                                       = 'linked-service'
    #     'linked-storage-accounts'                               = 'linked-storage-account'
    #     'load-balancers'                                        = 'load-balancer'
    #     'local-network-gateways'                                = 'local-network-gateway'
    #     'local-users'                                           = 'local-user'
    #     'locks'                                                 = 'lock'
    #     'maintenance-configurations'                            = 'maintenance-configuration'
    #     'managed-clusters'                                      = 'managed-cluster'
    #     'managed-environments'                                  = 'managed-environment'
    #     'managed-instances'                                     = 'managed-instance'
    #     'managed-private-endpoints'                             = 'managed-private-endpoint'
    #     'managed-virtual-networks'                              = 'managed-virtual-network'
    #     'management-group'                                      = 'management-group'
    #     'management-groups'                                     = 'management-group'
    #     'management-policies'                                   = 'management-policy'
    #     'metric-alerts'                                         = 'metric-alert'
    #     'migration-configurations'                              = 'migration-configuration'
    #     'modules'                                               = 'module'
    #     'mongodb-databases'                                     = 'mongodb-database'
    #     'mx'                                                    = 'mx'
    #     'named-values'                                          = 'named-value'
    #     'namespaces'                                            = 'namespace'
    #     'nat-gateways'                                          = 'nat-gateway'
    #     'nat-rules'                                             = 'nat-rule'
    #     'net-app-accounts'                                      = 'net-app-account'
    #     'network-groups'                                        = 'network-group'
    #     'network-interfaces'                                    = 'network-interface'
    #     'network-managers'                                      = 'network-manager'
    #     'network-rule-sets'                                     = 'network-rule-set'
    #     'network-security-groups'                               = 'network-security-group'
    #     'network-watchers'                                      = 'network-watcher'
    #     'notificationchannels'                                  = 'notificationchannel'
    #     'ns'                                                    = 'ns'
    #     'origins'                                               = 'origin'
    #     'policies'                                              = 'policy'
    #     'policy-assignments'                                    = 'policy-assignment'
    #     'policy-definitions'                                    = 'policy-definition'
    #     'policy-exemptions'                                     = 'policy-exemption'
    #     'policy-set-definitions'                                = 'policy-set-definition'
    #     'policysets'                                            = 'policyset'
    #     'portalsettings'                                        = 'portalsetting'
    #     'private-dns-zone-groups'                               = 'private-dns-zone-group'
    #     'private-dns-zones'                                     = 'private-dns-zone'
    #     'private-endpoints'                                     = 'private-endpoint'
    #     'private-link-hubs'                                     = 'private-link-hub'
    #     'private-link-scopes'                                   = 'private-link-scope'
    #     'private-link-services'                                 = 'private-link-service'
    #     'products'                                              = 'product'
    #     'profiles'                                              = 'profile'
    #     'protected-items'                                       = 'protected-item'
    #     'protection-containers'                                 = 'protection-container'
    #     'proximity-placement-groups'                            = 'proximity-placement-group'
    #     'ptr'                                                   = 'ptr'
    #     'public-ip-addresses'                                   = 'public-ip-address'
    #     'public-ip-prefixes'                                    = 'public-ip-prefix'
    #     'queue-services'                                        = 'queue-service'
    #     'queues'                                                = 'queue'
    #     'redis'                                                 = 'redis'
    #     'registration-definitions'                              = 'registration-definition'
    #     'registries'                                            = 'registry'
    #     'relays'                                                = 'relay'
    #     'remediations'                                          = 'remediation'
    #     'replication-alert-settings'                            = 'replication-alert-setting'
    #     'replication-fabrics'                                   = 'replication-fabric'
    #     'replication-policies'                                  = 'replication-policy'
    #     'replication-protection-container-mappings'             = 'replication-protection-container-mapping'
    #     'replication-protection-containers'                     = 'replication-protection-container'
    #     'replications'                                          = 'replication'
    #     'resource-group'                                        = 'resource-group'
    #     'resource-groups'                                       = 'resource-group'
    #     'role-assignments'                                      = 'role-assignment'
    #     'role-definitions'                                      = 'role-definition'
    #     'route-tables'                                          = 'route-table'
    #     'rule-collection-groups'                                = 'rule-collection-group'
    #     'rule-collections'                                      = 'rule-collection'
    #     'rules'                                                 = 'rule'
    #     'runbooks'                                              = 'runbook'
    #     'saved-searches'                                        = 'saved-searche'
    #     'scaling-plans'                                         = 'scaling-plan'
    #     'scheduled-query-rules'                                 = 'scheduled-query-rule'
    #     'schedules'                                             = 'schedule'
    #     'scope-connections'                                     = 'scope-connection'
    #     'scoped-resources'                                      = 'scoped-resource'
    #     'secrets'                                               = 'secret'
    #     'security-admin-configurations'                         = 'security-admin-configuration'
    #     'security-alert-policies'                               = 'security-alert-policy'
    #     'security-rules'                                        = 'security-rule'
    #     'serverfarms'                                           = 'serverfarm'
    #     'servers'                                               = 'server'
    #     'service'                                               = 'service'
    #     'service-endpoint-policies'                             = 'service-endpoint-policy'
    #     'shares'                                                = 'share'
    #     'signal-r'                                              = 'signal-r'
    #     'sites'                                                 = 'site'
    #     'slots'                                                 = 'slot'
    #     'soa'                                                   = 'soa'
    #     'software-update-configurations'                        = 'software-update-configuration'
    #     'solutions'                                             = 'solution'
    #     'sql-databases'                                         = 'sql-database'
    #     'srv'                                                   = 'srv'
    #     'ssh-public-keys'                                       = 'ssh-public-key'
    #     'static-members'                                        = 'static-member'
    #     'static-sites'                                          = 'static-site'
    #     'storage-accounts'                                      = 'storage-account'
    #     'storage-insight-configs'                               = 'storage-insight-config'
    #     'subnets'                                               = 'subnet'
    #     'subscription'                                          = 'subscription'
    #     'subscriptions'                                         = 'subscription'
    #     'system-topics'                                         = 'system-topic'
    #     'table-services'                                        = 'table-service'
    #     'tables'                                                = 'table'
    #     'tags'                                                  = 'tags'
    #     'topics'                                                = 'topic'
    #     'trafficmanagerprofiles'                                = 'trafficmanagerprofile'
    #     'txt'                                                   = 'txt'
    #     'user-assigned-identities'                              = 'user-assigned-identity'
    #     'variables'                                             = 'variable'
    #     'vaults'                                                = 'vault'
    #     'virtual-hubs'                                          = 'virtual-hub'
    #     'virtual-machine-scale-sets'                            = 'virtual-machine-scale-set'
    #     'virtual-machines'                                      = 'virtual-machine'
    #     'virtual-network-gateways'                              = 'virtual-network-gateway'
    #     'virtual-network-links'                                 = 'virtual-network-link'
    #     'virtual-network-peerings'                              = 'virtual-network-peering'
    #     'virtual-network-rules'                                 = 'virtual-network-rule'
    #     'virtual-networks'                                      = 'virtual-network'
    #     'virtual-wans'                                          = 'virtual-wan'
    #     'virtualnetworks'                                       = 'virtualnetwork'
    #     'volumes'                                               = 'volume'
    #     'vpn-gateways'                                          = 'vpn-gateway'
    #     'vpn-sites'                                             = 'vpn-site'
    #     'vulnerability-assessments'                             = 'vulnerability-assessment'
    #     'wcf-relays'                                            = 'wcf-relay'
    #     'web-pub-sub'                                           = 'web-pub-sub'
    #     'webhooks'                                              = 'webhook'
    #     'webtests'                                              = 'webtest'
    #     'workflows'                                             = 'workflow'
    #     'workspaces'                                            = 'workspace'
    # }

    $jsonFile = Join-Path $PSScriptRoot '\rtMapping.jsonc'
    $specialConversionHash = Get-Content -Raw $jsonFile | ConvertFrom-Json -AsHashtable

    $relevantFolderPaths = @()
    # Get all module folder names
    if ($ResourceProviderPath -ne '') {
        $relevantFolderPaths += (Get-ChildItem -Path $ResourceProviderPath -Recurse -Directory).FullName | Where-Object {
            $_ -notlike '*.bicep*' -and
            $_ -notlike '*.shared*' -and
            $_ -notlike '*.test*'
        }
        Write-Verbose ("relevantFolderPaths $relevantFolderPaths") -Verbose
        Write-Verbose ("ResourceProviderPath $ResourceProviderPath") -Verbose
        $relevantFolderPaths += $ResourceProviderPath
        Write-Verbose ("relevantFolderPaths $relevantFolderPaths") -Verbose

    } else {
        $relevantFolderPaths = (Get-ChildItem -Path $ModulesFolderPath -Recurse -Directory).FullName | Where-Object {
            $_ -notlike '*.bicep*' -and
            $_ -notlike '*.shared*' -and
            $_ -notlike '*.test*'
        }
    }
    $relevantFolderPaths | Sort-Object -Descending

    # Iterate on all folder names
    foreach ($folderPath in $relevantFolderPaths) {

        # Convert each folder name to its kebab-case
        $folderName = Split-Path $folderPath -Leaf

        if ($specialConversionHash.ContainsKey($folderName)) {
            $newName = $specialConversionHash[$folderName]
        } else {
            # (?<!^): This is a negative lookbehind assertion that ensures the match is not at the beginning of the string. This is used to exclude the first character from being replaced.
            # ([A-Z]): This captures any uppercase letter from A to Z using parentheses.
            $newName = $folderName
            #$newName = $newName.substring(0, 1).tolower() + $newName.substring(1)
        }
        Write-Verbose ("$folderName $newName") -Verbose

        # Replace the name if the new name is not the same as the old
        if ($newName -ine $folderName) {
            if ($PSCmdlet.ShouldProcess(('Folder [{0}] to [{1}]' -f ((Split-Path $folderPath -Leaf)), $newName), 'Update')) {
                $null = Rename-Item -Path $folderPath -NewName $newName -Force
            }
        }

        # Replace local module references in files across the whole library

        # Get file paths
        $filePaths = (Get-ChildItem -Path $ModulesFolderPath -Recurse | Select-String "$folderName.*main.bicep" -List | Select-Object Path).Path

        # Iterate on all files
        foreach ($filePath in $filePaths) {
            # Replace content
            Write-Verbose ("   $filePath") -Verbose
            (Get-Content $filePath) -creplace "(/|')($folderName)/(.*main.bicep)", "`$1$newName/`$3" | Set-Content $filePath
        }

        # Replace local module references in workflows
        if ($WorkflowsPath -ne '') {
            # Get file paths
            $workflowsfilePaths = (Get-ChildItem -Path $WorkflowsPath -Recurse | Select-String "modules.*$folderName" -List | Select-Object Path).Path

            # Iterate on all files
            foreach ($workflowsfilePath in $workflowsfilePaths) {
                # Replace content
                Write-Verbose ("   $workflowsfilePath") -Verbose
            (Get-Content $workflowsfilePath) -creplace "(modules.*)/($folderName)", "`$1/$newName" | Set-Content $workflowsfilePath
            }
        }

        # Replace local module references in ado pipelines
        if ($PipelinesPath -ne '') {
            # Get file paths
            $pipelinesfilePaths = (Get-ChildItem -Path $PipelinesPath -Recurse | Select-String "modules.*$folderName" -List | Select-Object Path).Path

            # Iterate on all files
            foreach ($pipelinesfilePath in $pipelinesfilePaths) {
                # Replace content
                Write-Verbose ("   $pipelinesfilePath") -Verbose
            (Get-Content $pipelinesfilePath) -creplace "(modules.*)/($folderName)", "`$1/$newName" | Set-Content $pipelinesfilePath
            }
        }

        # Replace local module references in utilities
        if ($UtilitiesPath -ne '') {
            # Get file paths
            $utilitiesFilePaths = (Get-ChildItem -Path $UtilitiesPath -Recurse | Select-String "modules.*$folderName" -List | Select-Object Path).Path

            # Iterate on all files
            foreach ($utilitiesFilePath in $utilitiesFilePaths) {
                # Replace content
                Write-Verbose ("   $utilitiesFilePath") -Verbose
            (Get-Content $utilitiesFilePath) -creplace "(modules.*)/($folderName)", "`$1/$newName" | Set-Content $utilitiesFilePath
            }
        }
    }
}
