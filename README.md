# ![AzureIcon] Common Azure Resource Modules Library

## Description

This repository includes a library of mature and curated [Bicep][Bicep] modules as well as a Continuous Integration (CI) environment leveraged for modules' validation and versioned publishing.

The CI environment supports both ARM and Bicep and can be leveraged using GitHub actions as well as Azure DevOps pipelines.

<h1 style="color: steelblue;">Upcoming breaking changes</h1>

In between now and the release of version `0.11.0`, the `main` branch is subject to several upcoming breaking changes that will affect all modules (e.g., the renaming of folders and files).

The rationale is an ongoing effort to prepare our modules for a release in the official [Public Bicep Registry](https://github.com/Azure/bicep-registry-modules), forcing us to align the structural requirements.

For more details, please refer to the issue #3131.

## Get started

* For introduction guidance visit the [Wiki](https://github.com/Azure/ResourceModules/wiki)
* For guidance on which version of the code to leverage, see [Disclaimer](https://github.com/azure/resourcemodules#Disclaimer)
* For information on contributing, see [Contribution](<https://github.com/Azure/ResourceModules/wiki/Contribution%20guide>)
* File an issue via [GitHub Issues](https://github.com/Azure/ResourceModules/issues/new/choose)
* For reference documentation, visit [Enterprise-Scale](https://github.com/azure/enterprise-scale)
* For an outline of the module features, visit [Module overview](https://github.com/Azure/ResourceModules/wiki/The%20library%20-%20Module%20overview)

> **Note:** To ensure the modules and environment work as expected, please ensure you are using the latest version of the used tools such as PowerShell and Bicep. Especially in case of the later, note, that you need to manually update the Bicep CLI. For further information, see our [troubleshooting guide](./The%20CI%20environment%20-%20Troubleshooting).

## Available Resource Modules

| Provider namespace | Resource Type | Name |
| - | - | - |
| `aad` | [domain-services](https://github.com/Azure/ResourceModules/tree/main/modules/aad/domain-services) | [Azure Active Directory Domain Services](https://github.com/Azure/ResourceModules/tree/main/modules/aad/domain-services) |
| `analysis-services` | [servers](https://github.com/Azure/ResourceModules/tree/main/modules/analysis-services/servers) | [Analysis Services Servers](https://github.com/Azure/ResourceModules/tree/main/modules/analysis-services/servers) |
| `api-management` | [service](https://github.com/Azure/ResourceModules/tree/main/modules/api-management/service) | [API Management Services](https://github.com/Azure/ResourceModules/tree/main/modules/api-management/service) |
| `app` | [container-apps](https://github.com/Azure/ResourceModules/tree/main/modules/app/container-apps) | [Container Apps](https://github.com/Azure/ResourceModules/tree/main/modules/app/container-apps) |
|  | [managed-environments](https://github.com/Azure/ResourceModules/tree/main/modules/app/managed-environments) | [App ManagedEnvironments](https://github.com/Azure/ResourceModules/tree/main/modules/app/managed-environments) |
| `app-configuration` | [configuration-stores](https://github.com/Azure/ResourceModules/tree/main/modules/app-configuration/configuration-stores) | [App Configuration Stores](https://github.com/Azure/ResourceModules/tree/main/modules/app-configuration/configuration-stores) |
| `authorization` | [locks](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/locks) | [Authorization Locks (All scopes)](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/locks) |
|  | [policy-assignments](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/policy-assignments) | [Policy Assignments (All scopes)](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/policy-assignments) |
|  | [policy-definitions](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/policy-definitions) | [Policy Definitions (All scopes)](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/policy-definitions) |
|  | [policy-exemptions](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/policy-exemptions) | [Policy Exemptions (All scopes)](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/policy-exemptions) |
|  | [policy-set-definitions](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/policy-set-definitions) | [Policy Set Definitions (Initiatives) (All scopes)](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/policy-set-definitions) |
|  | [role-assignments](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/role-assignments) | [Role Assignments (All scopes)](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/role-assignments) |
|  | [role-definitions](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/role-definitions) | [Role Definitions (All scopes)](https://github.com/Azure/ResourceModules/tree/main/modules/authorization/role-definitions) |
| `automation` | [automation-accounts](https://github.com/Azure/ResourceModules/tree/main/modules/automation/automation-accounts) | [Automation Accounts](https://github.com/Azure/ResourceModules/tree/main/modules/automation/automation-accounts) |
| `batch` | [batch-accounts](https://github.com/Azure/ResourceModules/tree/main/modules/batch/batch-accounts) | [Batch Accounts](https://github.com/Azure/ResourceModules/tree/main/modules/batch/batch-accounts) |
| `cache` | [redis](https://github.com/Azure/ResourceModules/tree/main/modules/cache/redis) | [Redis Cache](https://github.com/Azure/ResourceModules/tree/main/modules/cache/redis) |
| `cdn` | [profiles](https://github.com/Azure/ResourceModules/tree/main/modules/cdn/profiles) | [CDN Profiles](https://github.com/Azure/ResourceModules/tree/main/modules/cdn/profiles) |
| `cognitive-services` | [accounts](https://github.com/Azure/ResourceModules/tree/main/modules/cognitive-services/accounts) | [Cognitive Services](https://github.com/Azure/ResourceModules/tree/main/modules/cognitive-services/accounts) |
| `compute` | [availability-sets](https://github.com/Azure/ResourceModules/tree/main/modules/compute/availability-sets) | [Availability Sets](https://github.com/Azure/ResourceModules/tree/main/modules/compute/availability-sets) |
|  | [disk-encryption-sets](https://github.com/Azure/ResourceModules/tree/main/modules/compute/disk-encryption-sets) | [Disk Encryption Sets](https://github.com/Azure/ResourceModules/tree/main/modules/compute/disk-encryption-sets) |
|  | [disks](https://github.com/Azure/ResourceModules/tree/main/modules/compute/disks) | [Compute Disks](https://github.com/Azure/ResourceModules/tree/main/modules/compute/disks) |
|  | [galleries](https://github.com/Azure/ResourceModules/tree/main/modules/compute/galleries) | [Azure Compute Galleries](https://github.com/Azure/ResourceModules/tree/main/modules/compute/galleries) |
|  | [images](https://github.com/Azure/ResourceModules/tree/main/modules/compute/images) | [Images](https://github.com/Azure/ResourceModules/tree/main/modules/compute/images) |
|  | [proximity-placement-groups](https://github.com/Azure/ResourceModules/tree/main/modules/compute/proximity-placement-groups) | [Proximity Placement Groups](https://github.com/Azure/ResourceModules/tree/main/modules/compute/proximity-placement-groups) |
|  | [ssh-public-keys](https://github.com/Azure/ResourceModules/tree/main/modules/compute/ssh-public-keys) | [Public SSH Keys](https://github.com/Azure/ResourceModules/tree/main/modules/compute/ssh-public-keys) |
|  | [virtual-machine-scale-sets](https://github.com/Azure/ResourceModules/tree/main/modules/compute/virtual-machine-scale-sets) | [Virtual Machine Scale Sets](https://github.com/Azure/ResourceModules/tree/main/modules/compute/virtual-machine-scale-sets) |
|  | [virtual-machines](https://github.com/Azure/ResourceModules/tree/main/modules/compute/virtual-machines) | [Virtual Machines](https://github.com/Azure/ResourceModules/tree/main/modules/compute/virtual-machines) |
| `consumption` | [budgets](https://github.com/Azure/ResourceModules/tree/main/modules/consumption/budgets) | [Consumption Budgets](https://github.com/Azure/ResourceModules/tree/main/modules/consumption/budgets) |
| `container-instance` | [container-groups](https://github.com/Azure/ResourceModules/tree/main/modules/container-instance/container-groups) | [Container Instances Container Groups](https://github.com/Azure/ResourceModules/tree/main/modules/container-instance/container-groups) |
| `container-registry` | [registries](https://github.com/Azure/ResourceModules/tree/main/modules/container-registry/registries) | [Azure Container Registries (ACR)](https://github.com/Azure/ResourceModules/tree/main/modules/container-registry/registries) |
| `container-service` | [managed-clusters](https://github.com/Azure/ResourceModules/tree/main/modules/container-service/managed-clusters) | [Azure Kubernetes Service (AKS) Managed Clusters](https://github.com/Azure/ResourceModules/tree/main/modules/container-service/managed-clusters) |
| `data-factory` | [factories](https://github.com/Azure/ResourceModules/tree/main/modules/data-factory/factories) | [Data Factories](https://github.com/Azure/ResourceModules/tree/main/modules/data-factory/factories) |
| `data-protection` | [backup-vaults](https://github.com/Azure/ResourceModules/tree/main/modules/data-protection/backup-vaults) | [Data Protection Backup Vaults](https://github.com/Azure/ResourceModules/tree/main/modules/data-protection/backup-vaults) |
| `databricks` | [workspaces](https://github.com/Azure/ResourceModules/tree/main/modules/databricks/workspaces) | [Azure Databricks Workspaces](https://github.com/Azure/ResourceModules/tree/main/modules/databricks/workspaces) |
| `db-for-my-sql` | [flexible-servers](https://github.com/Azure/ResourceModules/tree/main/modules/db-for-my-sql/flexible-servers) | [DBforMySQL Flexible Servers](https://github.com/Azure/ResourceModules/tree/main/modules/db-for-my-sql/flexible-servers) |
| `db-for-postgre-sql` | [flexible-servers](https://github.com/Azure/ResourceModules/tree/main/modules/db-for-postgre-sql/flexible-servers) | [DBforPostgreSQL Flexible Servers](https://github.com/Azure/ResourceModules/tree/main/modules/db-for-postgre-sql/flexible-servers) |
| `desktop-virtualization` | [application-groups](https://github.com/Azure/ResourceModules/tree/main/modules/desktop-virtualization/application-groups) | [Azure Virtual Desktop (AVD) Application Groups](https://github.com/Azure/ResourceModules/tree/main/modules/desktop-virtualization/application-groups) |
|  | [host-pools](https://github.com/Azure/ResourceModules/tree/main/modules/desktop-virtualization/host-pools) | [Azure Virtual Desktop (AVD) Host Pools](https://github.com/Azure/ResourceModules/tree/main/modules/desktop-virtualization/host-pools) |
|  | [scaling-plans](https://github.com/Azure/ResourceModules/tree/main/modules/desktop-virtualization/scaling-plans) | [Azure Virtual Desktop (AVD) Scaling Plans](https://github.com/Azure/ResourceModules/tree/main/modules/desktop-virtualization/scaling-plans) |
|  | [workspaces](https://github.com/Azure/ResourceModules/tree/main/modules/desktop-virtualization/workspaces) | [Azure Virtual Desktop (AVD) Workspaces](https://github.com/Azure/ResourceModules/tree/main/modules/desktop-virtualization/workspaces) |
| `dev-test-lab` | [labs](https://github.com/Azure/ResourceModules/tree/main/modules/dev-test-lab/labs) | [DevTest Labs](https://github.com/Azure/ResourceModules/tree/main/modules/dev-test-lab/labs) |
| `digital-twins` | [digital-twins-instances](https://github.com/Azure/ResourceModules/tree/main/modules/digital-twins/digital-twins-instances) | [Digital Twins Instances](https://github.com/Azure/ResourceModules/tree/main/modules/digital-twins/digital-twins-instances) |
| `document-db` | [database-accounts](https://github.com/Azure/ResourceModules/tree/main/modules/document-db/database-accounts) | [DocumentDB Database Accounts](https://github.com/Azure/ResourceModules/tree/main/modules/document-db/database-accounts) |
| `event-grid` | [domains](https://github.com/Azure/ResourceModules/tree/main/modules/event-grid/domains) | [Event Grid Domains](https://github.com/Azure/ResourceModules/tree/main/modules/event-grid/domains) |
|  | [system-topics](https://github.com/Azure/ResourceModules/tree/main/modules/event-grid/system-topics) | [Event Grid System Topics](https://github.com/Azure/ResourceModules/tree/main/modules/event-grid/system-topics) |
|  | [topics](https://github.com/Azure/ResourceModules/tree/main/modules/event-grid/topics) | [Event Grid Topics](https://github.com/Azure/ResourceModules/tree/main/modules/event-grid/topics) |
| `event-hub` | [namespaces](https://github.com/Azure/ResourceModules/tree/main/modules/event-hub/namespaces) | [Event Hub Namespaces](https://github.com/Azure/ResourceModules/tree/main/modules/event-hub/namespaces) |
| `health-bot` | [health-bots](https://github.com/Azure/ResourceModules/tree/main/modules/health-bot/health-bots) | [Azure Health Bots](https://github.com/Azure/ResourceModules/tree/main/modules/health-bot/health-bots) |
| `healthcare-apis` | [workspaces](https://github.com/Azure/ResourceModules/tree/main/modules/healthcare-apis/workspaces) | [Healthcare API Workspaces](https://github.com/Azure/ResourceModules/tree/main/modules/healthcare-apis/workspaces) |
| `insights` | [action-groups](https://github.com/Azure/ResourceModules/tree/main/modules/insights/action-groups) | [Action Groups](https://github.com/Azure/ResourceModules/tree/main/modules/insights/action-groups) |
|  | [activity-log-alerts](https://github.com/Azure/ResourceModules/tree/main/modules/insights/activity-log-alerts) | [Activity Log Alerts](https://github.com/Azure/ResourceModules/tree/main/modules/insights/activity-log-alerts) |
|  | [components](https://github.com/Azure/ResourceModules/tree/main/modules/insights/components) | [Application Insights](https://github.com/Azure/ResourceModules/tree/main/modules/insights/components) |
|  | [data-collection-endpoints](https://github.com/Azure/ResourceModules/tree/main/modules/insights/data-collection-endpoints) | [Data Collection Endpoints](https://github.com/Azure/ResourceModules/tree/main/modules/insights/data-collection-endpoints) |
|  | [data-collection-rules](https://github.com/Azure/ResourceModules/tree/main/modules/insights/data-collection-rules) | [Data Collection Rules](https://github.com/Azure/ResourceModules/tree/main/modules/insights/data-collection-rules) |
|  | [diagnostic-settings](https://github.com/Azure/ResourceModules/tree/main/modules/insights/diagnostic-settings) | [Diagnostic Settings (Activity Logs) for Azure Subscriptions](https://github.com/Azure/ResourceModules/tree/main/modules/insights/diagnostic-settings) |
|  | [metric-alerts](https://github.com/Azure/ResourceModules/tree/main/modules/insights/metric-alerts) | [Metric Alerts](https://github.com/Azure/ResourceModules/tree/main/modules/insights/metric-alerts) |
|  | [private-link-scopes](https://github.com/Azure/ResourceModules/tree/main/modules/insights/private-link-scopes) | [Azure Monitor Private Link Scopes](https://github.com/Azure/ResourceModules/tree/main/modules/insights/private-link-scopes) |
|  | [scheduled-query-rules](https://github.com/Azure/ResourceModules/tree/main/modules/insights/scheduled-query-rules) | [Scheduled Query Rules](https://github.com/Azure/ResourceModules/tree/main/modules/insights/scheduled-query-rules) |
|  | [webtests](https://github.com/Azure/ResourceModules/tree/main/modules/insights/webtests) | [Web Tests](https://github.com/Azure/ResourceModules/tree/main/modules/insights/webtests) |
| `key-vault` | [vaults](https://github.com/Azure/ResourceModules/tree/main/modules/key-vault/vaults) | [Key Vaults](https://github.com/Azure/ResourceModules/tree/main/modules/key-vault/vaults) |
| `kubernetes-configuration` | [extensions](https://github.com/Azure/ResourceModules/tree/main/modules/kubernetes-configuration/extensions) | [Kubernetes Configuration Extensions](https://github.com/Azure/ResourceModules/tree/main/modules/kubernetes-configuration/extensions) |
|  | [flux-configurations](https://github.com/Azure/ResourceModules/tree/main/modules/kubernetes-configuration/flux-configurations) | [Kubernetes Configuration Flux Configurations](https://github.com/Azure/ResourceModules/tree/main/modules/kubernetes-configuration/flux-configurations) |
| `logic` | [workflows](https://github.com/Azure/ResourceModules/tree/main/modules/logic/workflows) | [Logic Apps (Workflows)](https://github.com/Azure/ResourceModules/tree/main/modules/logic/workflows) |
| `machine-learning-services` | [workspaces](https://github.com/Azure/ResourceModules/tree/main/modules/machine-learning-services/workspaces) | [Machine Learning Services Workspaces](https://github.com/Azure/ResourceModules/tree/main/modules/machine-learning-services/workspaces) |
| `maintenance` | [maintenance-configurations](https://github.com/Azure/ResourceModules/tree/main/modules/maintenance/maintenance-configurations) | [Maintenance Configurations](https://github.com/Azure/ResourceModules/tree/main/modules/maintenance/maintenance-configurations) |
| `managed-identity` | [user-assigned-identities](https://github.com/Azure/ResourceModules/tree/main/modules/managed-identity/user-assigned-identities) | [User Assigned Identities](https://github.com/Azure/ResourceModules/tree/main/modules/managed-identity/user-assigned-identities) |
| `managed-services` | [registration-definitions](https://github.com/Azure/ResourceModules/tree/main/modules/managed-services/registration-definitions) | [Registration Definitions](https://github.com/Azure/ResourceModules/tree/main/modules/managed-services/registration-definitions) |
| `management` | [management-groups](https://github.com/Azure/ResourceModules/tree/main/modules/management/management-groups) | [Management Groups](https://github.com/Azure/ResourceModules/tree/main/modules/management/management-groups) |
| `net-app` | [net-app-accounts](https://github.com/Azure/ResourceModules/tree/main/modules/net-app/net-app-accounts) | [Azure NetApp Files](https://github.com/Azure/ResourceModules/tree/main/modules/net-app/net-app-accounts) |
| `network` | [application-gateway-web-application-firewall-policies](https://github.com/Azure/ResourceModules/tree/main/modules/network/application-gateway-web-application-firewall-policies) | [Application Gateway Web Application Firewall (WAF) Policies](https://github.com/Azure/ResourceModules/tree/main/modules/network/application-gateway-web-application-firewall-policies) |
|  | [application-gateways](https://github.com/Azure/ResourceModules/tree/main/modules/network/application-gateways) | [Network Application Gateways](https://github.com/Azure/ResourceModules/tree/main/modules/network/application-gateways) |
|  | [application-security-groups](https://github.com/Azure/ResourceModules/tree/main/modules/network/application-security-groups) | [Application Security Groups (ASG)](https://github.com/Azure/ResourceModules/tree/main/modules/network/application-security-groups) |
|  | [azure-firewalls](https://github.com/Azure/ResourceModules/tree/main/modules/network/azure-firewalls) | [Azure Firewalls](https://github.com/Azure/ResourceModules/tree/main/modules/network/azure-firewalls) |
|  | [bastion-hosts](https://github.com/Azure/ResourceModules/tree/main/modules/network/bastion-hosts) | [Bastion Hosts](https://github.com/Azure/ResourceModules/tree/main/modules/network/bastion-hosts) |
|  | [connections](https://github.com/Azure/ResourceModules/tree/main/modules/network/connections) | [Virtual Network Gateway Connections](https://github.com/Azure/ResourceModules/tree/main/modules/network/connections) |
|  | [ddos-protection-plans](https://github.com/Azure/ResourceModules/tree/main/modules/network/ddos-protection-plans) | [DDoS Protection Plans](https://github.com/Azure/ResourceModules/tree/main/modules/network/ddos-protection-plans) |
|  | [dns-resolvers](https://github.com/Azure/ResourceModules/tree/main/modules/network/dns-resolvers) | [DNS Resolvers](https://github.com/Azure/ResourceModules/tree/main/modules/network/dns-resolvers) |
|  | [dns-zones](https://github.com/Azure/ResourceModules/tree/main/modules/network/dns-zones) | [Public DNS Zones](https://github.com/Azure/ResourceModules/tree/main/modules/network/dns-zones) |
|  | [express-route-circuits](https://github.com/Azure/ResourceModules/tree/main/modules/network/express-route-circuits) | [ExpressRoute Circuits](https://github.com/Azure/ResourceModules/tree/main/modules/network/express-route-circuits) |
|  | [express-route-gateway](https://github.com/Azure/ResourceModules/tree/main/modules/network/express-route-gateway) | [Express Route Gateways](https://github.com/Azure/ResourceModules/tree/main/modules/network/express-route-gateway) |
|  | [firewall-policies](https://github.com/Azure/ResourceModules/tree/main/modules/network/firewall-policies) | [Firewall Policies](https://github.com/Azure/ResourceModules/tree/main/modules/network/firewall-policies) |
|  | [front-doors](https://github.com/Azure/ResourceModules/tree/main/modules/network/front-doors) | [Azure Front Doors](https://github.com/Azure/ResourceModules/tree/main/modules/network/front-doors) |
|  | [ip-groups](https://github.com/Azure/ResourceModules/tree/main/modules/network/ip-groups) | [IP Groups](https://github.com/Azure/ResourceModules/tree/main/modules/network/ip-groups) |
|  | [load-balancers](https://github.com/Azure/ResourceModules/tree/main/modules/network/load-balancers) | [Load Balancers](https://github.com/Azure/ResourceModules/tree/main/modules/network/load-balancers) |
|  | [local-network-gateways](https://github.com/Azure/ResourceModules/tree/main/modules/network/local-network-gateways) | [Local Network Gateways](https://github.com/Azure/ResourceModules/tree/main/modules/network/local-network-gateways) |
|  | [nat-gateways](https://github.com/Azure/ResourceModules/tree/main/modules/network/nat-gateways) | [NAT Gateways](https://github.com/Azure/ResourceModules/tree/main/modules/network/nat-gateways) |
|  | [network-interfaces](https://github.com/Azure/ResourceModules/tree/main/modules/network/network-interfaces) | [Network Interface](https://github.com/Azure/ResourceModules/tree/main/modules/network/network-interfaces) |
|  | [network-managers](https://github.com/Azure/ResourceModules/tree/main/modules/network/network-managers) | [Network Managers](https://github.com/Azure/ResourceModules/tree/main/modules/network/network-managers) |
|  | [network-security-groups](https://github.com/Azure/ResourceModules/tree/main/modules/network/network-security-groups) | [Network Security Groups](https://github.com/Azure/ResourceModules/tree/main/modules/network/network-security-groups) |
|  | [network-watchers](https://github.com/Azure/ResourceModules/tree/main/modules/network/network-watchers) | [Network Watchers](https://github.com/Azure/ResourceModules/tree/main/modules/network/network-watchers) |
|  | [private-dns-zones](https://github.com/Azure/ResourceModules/tree/main/modules/network/private-dns-zones) | [Private DNS Zones](https://github.com/Azure/ResourceModules/tree/main/modules/network/private-dns-zones) |
|  | [private-endpoints](https://github.com/Azure/ResourceModules/tree/main/modules/network/private-endpoints) | [Private Endpoints](https://github.com/Azure/ResourceModules/tree/main/modules/network/private-endpoints) |
|  | [private-link-services](https://github.com/Azure/ResourceModules/tree/main/modules/network/private-link-services) | [Private Link Services](https://github.com/Azure/ResourceModules/tree/main/modules/network/private-link-services) |
|  | [public-ip-addresses](https://github.com/Azure/ResourceModules/tree/main/modules/network/public-ip-addresses) | [Public IP Addresses](https://github.com/Azure/ResourceModules/tree/main/modules/network/public-ip-addresses) |
|  | [public-ip-prefixes](https://github.com/Azure/ResourceModules/tree/main/modules/network/public-ip-prefixes) | [Public IP Prefixes](https://github.com/Azure/ResourceModules/tree/main/modules/network/public-ip-prefixes) |
|  | [route-tables](https://github.com/Azure/ResourceModules/tree/main/modules/network/route-tables) | [Route Tables](https://github.com/Azure/ResourceModules/tree/main/modules/network/route-tables) |
|  | [trafficmanagerprofiles](https://github.com/Azure/ResourceModules/tree/main/modules/network/trafficmanagerprofiles) | [Traffic Manager Profiles](https://github.com/Azure/ResourceModules/tree/main/modules/network/trafficmanagerprofiles) |
|  | [virtual-hubs](https://github.com/Azure/ResourceModules/tree/main/modules/network/virtual-hubs) | [Virtual Hubs](https://github.com/Azure/ResourceModules/tree/main/modules/network/virtual-hubs) |
|  | [virtual-network-gateways](https://github.com/Azure/ResourceModules/tree/main/modules/network/virtual-network-gateways) | [Virtual Network Gateways](https://github.com/Azure/ResourceModules/tree/main/modules/network/virtual-network-gateways) |
|  | [virtual-networks](https://github.com/Azure/ResourceModules/tree/main/modules/network/virtual-networks) | [Virtual Networks](https://github.com/Azure/ResourceModules/tree/main/modules/network/virtual-networks) |
|  | [virtual-wans](https://github.com/Azure/ResourceModules/tree/main/modules/network/virtual-wans) | [Virtual WANs](https://github.com/Azure/ResourceModules/tree/main/modules/network/virtual-wans) |
|  | [vpn-gateways](https://github.com/Azure/ResourceModules/tree/main/modules/network/vpn-gateways) | [VPN Gateways](https://github.com/Azure/ResourceModules/tree/main/modules/network/vpn-gateways) |
|  | [vpn-sites](https://github.com/Azure/ResourceModules/tree/main/modules/network/vpn-sites) | [VPN Sites](https://github.com/Azure/ResourceModules/tree/main/modules/network/vpn-sites) |
| `operational-insights` | [workspaces](https://github.com/Azure/ResourceModules/tree/main/modules/operational-insights/workspaces) | [Log Analytics Workspaces](https://github.com/Azure/ResourceModules/tree/main/modules/operational-insights/workspaces) |
| `operations-management` | [solutions](https://github.com/Azure/ResourceModules/tree/main/modules/operations-management/solutions) | [Operations Management Solutions](https://github.com/Azure/ResourceModules/tree/main/modules/operations-management/solutions) |
| `policy-insights` | [remediations](https://github.com/Azure/ResourceModules/tree/main/modules/policy-insights/remediations) | [Policy Insights Remediations](https://github.com/Azure/ResourceModules/tree/main/modules/policy-insights/remediations) |
| `power-bi-dedicated` | [capacities](https://github.com/Azure/ResourceModules/tree/main/modules/power-bi-dedicated/capacities) | [Power BI Dedicated Capacities](https://github.com/Azure/ResourceModules/tree/main/modules/power-bi-dedicated/capacities) |
| `purview` | [accounts](https://github.com/Azure/ResourceModules/tree/main/modules/purview/accounts) | [Purview Accounts](https://github.com/Azure/ResourceModules/tree/main/modules/purview/accounts) |
| `recovery-services` | [vaults](https://github.com/Azure/ResourceModules/tree/main/modules/recovery-services/vaults) | [Recovery Services Vaults](https://github.com/Azure/ResourceModules/tree/main/modules/recovery-services/vaults) |
| `resources` | [deployment-scripts](https://github.com/Azure/ResourceModules/tree/main/modules/resources/deployment-scripts) | [Deployment Scripts](https://github.com/Azure/ResourceModules/tree/main/modules/resources/deployment-scripts) |
|  | [resource-groups](https://github.com/Azure/ResourceModules/tree/main/modules/resources/resource-groups) | [Resource Groups](https://github.com/Azure/ResourceModules/tree/main/modules/resources/resource-groups) |
|  | [tags](https://github.com/Azure/ResourceModules/tree/main/modules/resources/tags) | [Resources Tags](https://github.com/Azure/ResourceModules/tree/main/modules/resources/tags) |
| `security` | [azure-security-center](https://github.com/Azure/ResourceModules/tree/main/modules/security/azure-security-center) | [Azure Security Center (Defender for Cloud)](https://github.com/Azure/ResourceModules/tree/main/modules/security/azure-security-center) |
| `service-bus` | [namespaces](https://github.com/Azure/ResourceModules/tree/main/modules/service-bus/namespaces) | [Service Bus Namespaces](https://github.com/Azure/ResourceModules/tree/main/modules/service-bus/namespaces) |
| `service-fabric` | [clusters](https://github.com/Azure/ResourceModules/tree/main/modules/service-fabric/clusters) | [Service Fabric Clusters](https://github.com/Azure/ResourceModules/tree/main/modules/service-fabric/clusters) |
| `signal-r-service` | [signal-r](https://github.com/Azure/ResourceModules/tree/main/modules/signal-r-service/signal-r) | [SignalR Service SignalR](https://github.com/Azure/ResourceModules/tree/main/modules/signal-r-service/signal-r) |
|  | [web-pub-sub](https://github.com/Azure/ResourceModules/tree/main/modules/signal-r-service/web-pub-sub) | [SignalR Web PubSub Services](https://github.com/Azure/ResourceModules/tree/main/modules/signal-r-service/web-pub-sub) |
| `sql` | [managed-instances](https://github.com/Azure/ResourceModules/tree/main/modules/sql/managed-instances) | [SQL Managed Instances](https://github.com/Azure/ResourceModules/tree/main/modules/sql/managed-instances) |
|  | [servers](https://github.com/Azure/ResourceModules/tree/main/modules/sql/servers) | [Azure SQL Servers](https://github.com/Azure/ResourceModules/tree/main/modules/sql/servers) |
| `storage` | [storage-accounts](https://github.com/Azure/ResourceModules/tree/main/modules/storage/storage-accounts) | [Storage Accounts](https://github.com/Azure/ResourceModules/tree/main/modules/storage/storage-accounts) |
| `synapse` | [private-link-hubs](https://github.com/Azure/ResourceModules/tree/main/modules/synapse/private-link-hubs) | [Azure Synapse Analytics](https://github.com/Azure/ResourceModules/tree/main/modules/synapse/private-link-hubs) |
|  | [workspaces](https://github.com/Azure/ResourceModules/tree/main/modules/synapse/workspaces) | [Synapse Workspaces](https://github.com/Azure/ResourceModules/tree/main/modules/synapse/workspaces) |
| `virtual-machine-images` | [image-templates](https://github.com/Azure/ResourceModules/tree/main/modules/virtual-machine-images/image-templates) | [Virtual Machine Image Templates](https://github.com/Azure/ResourceModules/tree/main/modules/virtual-machine-images/image-templates) |
| `web` | [connections](https://github.com/Azure/ResourceModules/tree/main/modules/web/connections) | [API Connections](https://github.com/Azure/ResourceModules/tree/main/modules/web/connections) |
|  | [hosting-environments](https://github.com/Azure/ResourceModules/tree/main/modules/web/hosting-environments) | [App Service Environments](https://github.com/Azure/ResourceModules/tree/main/modules/web/hosting-environments) |
|  | [serverfarms](https://github.com/Azure/ResourceModules/tree/main/modules/web/serverfarms) | [App Service Plans](https://github.com/Azure/ResourceModules/tree/main/modules/web/serverfarms) |
|  | [sites](https://github.com/Azure/ResourceModules/tree/main/modules/web/sites) | [Web/Function Apps](https://github.com/Azure/ResourceModules/tree/main/modules/web/sites) |
|  | [static-sites](https://github.com/Azure/ResourceModules/tree/main/modules/web/static-sites) | [Static Web Apps](https://github.com/Azure/ResourceModules/tree/main/modules/web/static-sites) |

## Platform

| Name | Status |
| - | - |
| Update API Specs file | [![.Platform: Update API Specs file](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Update%20API%20Specs%20file/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.apiSpecs.yml) |
| Assign Pull Request to Author | [![.Platform: Assign Pull Request to Author](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Assign%20Pull%20Request%20to%20Author/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.assignPrToAuthor.yml) |
| Test - ConvertTo-ARMTemplate.ps1 | [![.Platform: Test - ConvertTo-ARMTemplate.ps1](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Test%20-%20ConvertTo-ARMTemplate.ps1/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.convertToArmTemplate.tests.yml) |
| Clean up deployment history | [![.Platform: Clean up deployment history](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Clean%20up%20deployment%20history/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.deployment.history.cleanup.yml) |
| Library PSRule pre-flight validation | [![.Platform: Library PSRule pre-flight validation](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Library%20PSRule%20pre-flight%20validation/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.librarycheck.psrule.yml) |
| Broken Links Check | [![.Platform: Broken Links Check](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Broken%20Links%20Check/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.linkcheck.yml) |
| Linter (audit) | [![.Platform: Linter (audit)](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Linter%20(audit)/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.linter.yml) |
| Manage issues for failing pipelines | [![.Platform: Manage issues for failing pipelines](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Manage%20issues%20for%20failing%20pipelines/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.ManageIssueForFailingPipelines.yml) |
| Update ReadMe status Tables | [![.Platform: Update ReadMe status Tables](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Update%20ReadMe%20status%20Tables/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.updateReadMe.yml) |
| Update Static Test Documentation | [![.Platform: Update Static Test Documentation](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Update%20Static%20Test%20Documentation/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.updateStaticTestDocs.yml) |
| Sync Docs/Wiki | [![.Platform: Sync Docs/Wiki](https://github.com/Azure/ResourceModules/workflows/.Platform:%20Sync%20Docs/Wiki/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/platform.wiki-sync.yml) |

## Disclaimer

Please note that CARML is constantly evolving and introducing new features. The `main` branch of this repository changes frequently and thus, it always contains the latest available version of the code. Some of the updates may introduce breaking changes as well.
- **Default path**: To avoid disruptions, use distinct versions available through [releases](https://github.com/Azure/ResourceModules/releases).
- **Early adopter path**: If the risk of breaking changes is understood and accepted, you can use the code in the `main` branch directly. However, the CARML team recommends against automatically pulling code from `main`. It is always recommended to review changes before you pull them into your own repository.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

For specific guidelines on how to contribute to this repository please refer to the [Contribution guide](https://github.com/Azure/ResourceModules/wiki/Contribution%20guide) Wiki section.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.

## Learn More

* [PowerShell Documentation][PowerShellDocs]
* [Microsoft Azure Documentation][MicrosoftAzureDocs]
* [GitHubDocs][GitHubDocs]
* [Azure Resource Manager][AzureResourceManager]
* [Bicep][Bicep]

## Telemetry

Modules provided in this library have telemetry enabled by default. To learn more about this feature, please refer to the [Telemetry article](https://github.com/Azure/ResourceModules/wiki/The%20library%20-%20Module%20design#telemetry) in the wiki.

<!-- References -->

<!-- Local -->
[Wiki]: <https://github.com/Azure/Modules/wiki>
[ProjectSetup]: <https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions>
[GitHubDocs]: <https://docs.github.com/>
[AzureDevOpsDocs]: <https://learn.microsoft.com/en-us/azure/devops/?view=azure-devops>
[GitHubIssues]: <https://github.com/Azure/Modules/issues>
[Contributing]: CONTRIBUTING.md
[AzureIcon]: docs/media/MicrosoftAzure-32px.png
[PowershellIcon]: docs/media/MicrosoftPowerShellCore-32px.png

<!-- External -->
[Bicep]: <https://github.com/Azure/bicep>
[Az]: <https://img.shields.io/powershellgallery/v/Az.svg?style=flat-square&label=Az>
[AzGallery]: <https://www.powershellgallery.com/packages/Az/>
[PowerShellCore]: <https://github.com/PowerShell/PowerShell/releases/latest>
[InstallAzPs]: <https://learn.microsoft.com/en-us/powershell/azure/install-az-ps>
[AzureResourceManager]: <https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview>
[TemplateSpecs]: <https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs>

[ESLZ]: <https://github.com/Azure/Enterprise-Scale>
[AzureSecurityBenchmark]: <https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/security-governance-and-compliance#azure-security-benchmark>
[ESLZWorkloadTemplatesLibrary]: <https://github.com/Azure/Enterprise-Scale/tree/main/workloads>

<!-- Docs -->
[MicrosoftAzureDocs]: <https://learn.microsoft.com/en-us/azure/>
[PowerShellDocs]: <https://learn.microsoft.com/en-us/powershell/>
