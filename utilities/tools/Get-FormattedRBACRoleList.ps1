<#
.SYNOPSIS
You can use this script to excact a formatted list of RBAC roles used in the CARML modules based on the RBAC lists in Azure

.DESCRIPTION
For modules that manage roleAssignments, update the list of roles to only be the applicable roles. One way of doing this:
- Deploy an instance of the resource you are working on, go to IAM page and copy the list from Roles.
- Use the following script to generate and output the applicable roles needed in the bicep/ARM module:

.NOTES
Raw Roles should look like

$rawRoles = @'
Owner
Grants full access to manage all resources, including the ability to assign roles in Azure RBAC.
BuiltInRole
General
View
Contributor
Grants full access to manage all resources, but does not allow you to assign roles in Azure RBAC, manage assignments in Azure Blueprints, or share image galleries.
BuiltInRole
General
View
Reader
View all resources, but does not allow you to make any changes.
BuiltInRole
General
View
'@
#>

$rawRoles = @'
Owner
Grants full access to manage all resources, including the ability to assign roles in Azure RBAC.
BuiltInRole
General
View
Contributor
Grants full access to manage all resources, but does not allow you to assign roles in Azure RBAC, manage assignments in Azure Blueprints, or share image galleries.
BuiltInRole
General
View
Reader
View all resources, but does not allow you to make any changes.
BuiltInRole
General
View
AcrDelete
acr delete
BuiltInRole
Containers
View
AcrImageSigner
acr image signer
BuiltInRole
Containers
View
AcrPull
acr pull
BuiltInRole
Containers
View
AcrPush
acr push
BuiltInRole
Containers
View
AcrQuarantineReader
acr quarantine data reader
BuiltInRole
Containers
View
AcrQuarantineWriter
acr quarantine data writer
BuiltInRole
Containers
View
AgFood Platform Sensor Partner Contributor
Provides contribute access to manage sensor related entities in AgFood Platform Service
BuiltInRole
None
View
AgFood Platform Service Admin
Provides admin access to AgFood Platform Service
BuiltInRole
AI + Machine Learning
View
AgFood Platform Service Contributor
Provides contribute access to AgFood Platform Service
BuiltInRole
AI + Machine Learning
View
AgFood Platform Service Reader
Provides read access to AgFood Platform Service
BuiltInRole
AI + Machine Learning
View
AnyBuild Builder
Basic user role for AnyBuild. This role allows listing of agent information and execution of remote build capabilities.
BuiltInRole
None
View
API Management Service Contributor
Can manage service and the APIs
BuiltInRole
Integration
View
API Management Service Operator Role
Can manage service but not the APIs
BuiltInRole
Integration
View
API Management Service Reader Role
Read-only access to service and APIs
BuiltInRole
Integration
View
App Configuration Data Owner
Allows full access to App Configuration data.
BuiltInRole
Integration
View
App Configuration Data Reader
Allows read access to App Configuration data.
BuiltInRole
Integration
View
Application Group Contributor
Contributor of the Application Group.
BuiltInRole
Other
View
Application Insights Component Contributor
Can manage Application Insights components
BuiltInRole
Monitor
View
Application Insights Snapshot Debugger
Gives user permission to use Application Insights Snapshot Debugger features
BuiltInRole
Monitor
View
Attestation Contributor
Can read write or delete the attestation provider instance
BuiltInRole
Security
View
Attestation Reader
Can read the attestation provider properties
BuiltInRole
Security
View
Automation Contributor
Manage azure automation resources and other resources using azure automation.
BuiltInRole
None
View
Automation Job Operator
Create and Manage Jobs using Automation Runbooks.
BuiltInRole
Management + Governance
View
Automation Operator
Automation Operators are able to start, stop, suspend, and resume jobs
BuiltInRole
Management + Governance
View
Automation Runbook Operator
Read Runbook properties - to be able to create Jobs of the runbook.
BuiltInRole
Management + Governance
View
Autonomous Development Platform Data Contributor (Preview)
Grants permissions to upload and manage new Autonomous Development Platform measurements.
BuiltInRole
Preview
View
Autonomous Development Platform Data Owner (Preview)
Grants full access to Autonomous Development Platform data.
BuiltInRole
Preview
View
Autonomous Development Platform Data Reader (Preview)
Grants read access to Autonomous Development Platform data.
BuiltInRole
Preview
View
Avere Contributor
Can create and manage an Avere vFXT cluster.
BuiltInRole
Storage
View
Avere Operator
Used by the Avere vFXT cluster to manage the cluster
BuiltInRole
Storage
View
Azure Arc Enabled Kubernetes Cluster User Role
List cluster user credentials action.
BuiltInRole
Management + Governance
View
Azure Arc Kubernetes Admin
Lets you manage all resources under cluster/namespace, except update or delete resource quotas and namespaces.
BuiltInRole
Management + Governance
View
Azure Arc Kubernetes Cluster Admin
Lets you manage all resources in the cluster.
BuiltInRole
Management + Governance
View
Azure Arc Kubernetes Viewer
Lets you view all resources in cluster/namespace, except secrets.
BuiltInRole
Management + Governance
View
Azure Arc Kubernetes Writer
Lets you update everything in cluster/namespace, except (cluster)roles and (cluster)role bindings.
BuiltInRole
Management + Governance
View
Azure Arc VMware Administrator role
Arc VMware VM Contributor has permissions to perform all connected VMwarevSphere actions.
BuiltInRole
None
View
Azure Arc VMware Private Cloud User
Azure Arc VMware Private Cloud User has permissions to use the VMware cloud resources to deploy VMs.
BuiltInRole
None
View
Azure Arc VMware Private Clouds Onboarding
Azure Arc VMware Private Clouds Onboarding role has permissions to provision all the required resources for onboard and deboard vCenter instances to Azure.
BuiltInRole
None
View
Azure Arc VMware VM Contributor
Arc VMware VM Contributor has permissions to perform all VM actions.
BuiltInRole
None
View
Azure Connected Machine Onboarding
Can onboard Azure Connected Machines.
BuiltInRole
Management + Governance
View
Azure Connected Machine Resource Administrator
Can read, write, delete and re-onboard Azure Connected Machines.
BuiltInRole
Management + Governance
View
Azure Connected SQL Server Onboarding
Microsoft.AzureArcData service role to access the resources of Microsoft.AzureArcData stored with RPSAAS.
BuiltInRole
Management + Governance
View
Azure Digital Twins Data Owner
Full access role for Digital Twins data-plane
BuiltInRole
Other
View
Azure Digital Twins Data Reader
Read-only role for Digital Twins data-plane properties
BuiltInRole
Other
View
Azure Event Hubs Data Owner
Allows for full access to Azure Event Hubs resources.
BuiltInRole
Analytics
View
Azure Event Hubs Data Receiver
Allows receive access to Azure Event Hubs resources.
BuiltInRole
Analytics
View
Azure Event Hubs Data Sender
Allows send access to Azure Event Hubs resources.
BuiltInRole
Analytics
View
Azure Kubernetes Service Cluster Admin Role
List cluster admin credential action.
BuiltInRole
Containers
View
Azure Kubernetes Service Cluster User Role
List cluster user credential action.
BuiltInRole
Containers
View
Azure Kubernetes Service Contributor Role
Grants access to read and write Azure Kubernetes Service clusters
BuiltInRole
Containers
View
Azure Kubernetes Service Policy Add-on Deployment
Deploy the Azure Policy add-on on Azure Kubernetes Service clusters
BuiltInRole
None
View
Azure Kubernetes Service RBAC Admin
Lets you manage all resources under cluster/namespace, except update or delete resource quotas and namespaces.
BuiltInRole
Containers
View
Azure Kubernetes Service RBAC Cluster Admin
Lets you manage all resources in the cluster.
BuiltInRole
Containers
View
Azure Kubernetes Service RBAC Reader
Allows read-only access to see most objects in a namespace. It does not allow viewing roles or role bindings. This role does not allow viewing Secrets, since reading the contents of Secrets enables access to ServiceAccount credentials in the namespace, which would allow API access as any ServiceAccount in the namespace (a form of privilege escalation). Applying this role at cluster scope will give access across all namespaces.
BuiltInRole
Containers
View
Azure Kubernetes Service RBAC Writer
Allows read/write access to most objects in a namespace.This role does not allow viewing or modifying roles or role bindings. However, this role allows accessing Secrets and running Pods as any ServiceAccount in the namespace, so it can be used to gain the API access levels of any ServiceAccount in the namespace. Applying this role at cluster scope will give access across all namespaces.
BuiltInRole
Containers
View
Azure Maps Contributor
Grants access all Azure Maps resource management.
BuiltInRole
None
View
Azure Maps Data Contributor
Grants access to read, write, and delete access to map related data from an Azure maps account.
BuiltInRole
Web
View
Azure Maps Data Reader
Grants access to read map related data from an Azure maps account.
BuiltInRole
Web
View
Azure Maps Search and Render Data Reader
Grants access to very limited set of data APIs for common visual web SDK scenarios. Specifically, render and search data APIs.
BuiltInRole
None
View
Azure Relay Listener
Allows for listen access to Azure Relay resources.
BuiltInRole
Integration
View
Azure Relay Owner
Allows for full access to Azure Relay resources.
BuiltInRole
Integration
View
Azure Relay Sender
Allows for send access to Azure Relay resources.
BuiltInRole
Integration
View
Azure Service Bus Data Owner
Allows for full access to Azure Service Bus resources.
BuiltInRole
Integration
View
Azure Service Bus Data Receiver
Allows for receive access to Azure Service Bus resources.
BuiltInRole
Integration
View
Azure Service Bus Data Sender
Allows for send access to Azure Service Bus resources.
BuiltInRole
Integration
View
Azure Spring Cloud Config Server Contributor
Allow read, write and delete access to Azure Spring Cloud Config Server
BuiltInRole
None
View
Azure Spring Cloud Config Server Reader
Allow read access to Azure Spring Cloud Config Server
BuiltInRole
None
View
Azure Spring Cloud Data Reader
Allow read access to Azure Spring Cloud Data
BuiltInRole
Web
View
Azure Spring Cloud Service Registry Contributor
Allow read, write and delete access to Azure Spring Cloud Service Registry
BuiltInRole
None
View
Azure Spring Cloud Service Registry Reader
Allow read access to Azure Spring Cloud Service Registry
BuiltInRole
None
View
Azure Stack Registration Owner
Lets you manage Azure Stack registrations.
BuiltInRole
Integration
View
Azure VM Managed identities restore Contributor
Azure VM Managed identities restore Contributors are allowed to perform Azure VM Restores with managed identities both user and system
BuiltInRole
None
View
AzureML Data Scientist
Can perform all actions within an Azure Machine Learning workspace, except for creating or deleting compute resources and modifying the workspace itself.
BuiltInRole
None
View
AzureML Metrics Writer (preview)
Lets you write metrics to AzureML workspace
BuiltInRole
Preview
View
Backup Contributor
Lets you manage backup service,but can't create vaults and give access to others
BuiltInRole
Storage
View
Backup Operator
Lets you manage backup services, except removal of backup, vault creation and giving access to others
BuiltInRole
Storage
View
Backup Reader
Can view backup services, but can't make changes
BuiltInRole
Storage
View
Billing Reader
Allows read access to billing data
BuiltInRole
Management + Governance
View
BizTalk Contributor
Lets you manage BizTalk services, but not access to them.
BuiltInRole
Other
View
Blockchain Member Node Access (Preview)
Allows for access to Blockchain Member nodes
BuiltInRole
Preview
View
Blueprint Contributor
Can manage blueprint definitions, but not assign them.
BuiltInRole
Management + Governance
View
Blueprint Operator
Can assign existing published blueprints, but cannot create new blueprints. NOTE: this only works if the assignment is done with a user-assigned managed identity.
BuiltInRole
Management + Governance
View
CDN Endpoint Contributor
Can manage CDN endpoints, but can’t grant access to other users.
BuiltInRole
Networking
View
CDN Endpoint Reader
Can view CDN endpoints, but can’t make changes.
BuiltInRole
Networking
View
CDN Profile Contributor
Can manage CDN profiles and their endpoints, but can’t grant access to other users.
BuiltInRole
Networking
View
CDN Profile Reader
Can view CDN profiles and their endpoints, but can’t make changes.
BuiltInRole
Networking
View
Chamber Admin
Lets you manage everything under your HPC Workbench chamber.
BuiltInRole
None
View
Chamber User
Lets you view everything under your HPC Workbench chamber, but not make any changes.
BuiltInRole
None
View
Classic Network Contributor
Lets you manage classic networks, but not access to them.
BuiltInRole
Networking
View
Classic Storage Account Contributor
Lets you manage classic storage accounts, but not access to them.
BuiltInRole
Storage
View
Classic Storage Account Key Operator Service Role
Classic Storage Account Key Operators are allowed to list and regenerate keys on Classic Storage Accounts
BuiltInRole
Storage
View
Classic Virtual Machine Contributor
Lets you manage classic virtual machines, but not access to them, and not the virtual network or storage account they’re connected to.
BuiltInRole
Compute
View
ClearDB MySQL DB Contributor
Lets you manage ClearDB MySQL databases, but not access to them.
BuiltInRole
None
View
CodeSigning Certificate Profile Signer
Sign files with a certificate profile. This role is in preview and subject to change.
BuiltInRole
None
View
Cognitive Services Contributor
Lets you create, read, update, delete and manage keys of Cognitive Services.
BuiltInRole
AI + Machine Learning
View
Cognitive Services Custom Vision Contributor
Full access to the project, including the ability to view, create, edit, or delete projects.
BuiltInRole
AI + Machine Learning
View
Cognitive Services Custom Vision Deployment
Publish, unpublish or export models. Deployment can view the project but can’t update.
BuiltInRole
AI + Machine Learning
View
Cognitive Services Custom Vision Labeler
View, edit training images and create, add, remove, or delete the image tags. Labelers can view the project but can’t update anything other than training images and tags.
BuiltInRole
AI + Machine Learning
View
Cognitive Services Custom Vision Reader
Read-only actions in the project. Readers can’t create or update the project.
BuiltInRole
AI + Machine Learning
View
Cognitive Services Custom Vision Trainer
View, edit projects and train the models, including the ability to publish, unpublish, export the models. Trainers can’t create or delete the project.
BuiltInRole
AI + Machine Learning
View
Cognitive Services Data Reader (Preview)
Lets you read Cognitive Services data.
BuiltInRole
Preview
View
Cognitive Services Face Recognizer
Lets you perform detect, verify, identify, group, and find similar operations on Face API. This role does not allow create or delete operations, which makes it well suited for endpoints that only need inferencing capabilities, following 'least privilege' best practices.
BuiltInRole
AI + Machine Learning
View
Cognitive Services Immersive Reader User
Provides access to create Immersive Reader sessions and call APIs
BuiltInRole
None
View
Cognitive Services Language Owner
Has access to all Read, Test, Write, Deploy and Delete functions under Language portal
BuiltInRole
None
View
Cognitive Services Language Reader
Has access to Read and Test functions under Language portal
BuiltInRole
None
View
Cognitive Services Language Writer
Has access to all Read, Test, and Write functions under Language Portal
BuiltInRole
None
View
Cognitive Services LUIS Owner
Has access to all Read, Test, Write, Deploy and Delete functions under LUIS
BuiltInRole
None
View
Cognitive Services LUIS Reader
Has access to Read and Test functions under LUIS.
BuiltInRole
None
View
Cognitive Services LUIS Writer
Has access to all Read, Test, and Write functions under LUIS
BuiltInRole
None
View
Cognitive Services Metrics Advisor Administrator
Full access to the project, including the system level configuration.
BuiltInRole
AI + Machine Learning
View
Cognitive Services Metrics Advisor User
Access to the project.
BuiltInRole
AI + Machine Learning
View
Cognitive Services QnA Maker Editor
Let’s you create, edit, import and export a KB. You cannot publish or delete a KB.
BuiltInRole
AI + Machine Learning
View
Cognitive Services QnA Maker Reader
Let’s you read and test a KB only.
BuiltInRole
AI + Machine Learning
View
Cognitive Services Speech Contributor
Full access to Speech projects, including read, write and delete all entities, for real-time speech recognition and batch transcription tasks, real-time speech synthesis and long audio tasks, custom speech and custom voice.
BuiltInRole
AI + Machine Learning
View
Cognitive Services Speech User
Access to the real-time speech recognition and batch transcription APIs, real-time speech synthesis and long audio APIs, as well as to read the data/test/model/endpoint for custom models, but can’t create, delete or modify the data/test/model/endpoint for custom models.
BuiltInRole
AI + Machine Learning
View
Cognitive Services User
Lets you read and list keys of Cognitive Services.
BuiltInRole
AI + Machine Learning
View
Collaborative Data Contributor
Can manage data packages of a collaborative.
BuiltInRole
None
View
Collaborative Runtime Operator
Can manage resources created by AICS at runtime
BuiltInRole
None
View
Compute Gallery Sharing Admin
This role allows user to share gallery to another subscription/tenant or share it to the public.
BuiltInRole
None
View
Cosmos DB Account Reader Role
Can read Azure Cosmos DB Accounts data
BuiltInRole
Databases
View
Cosmos DB Operator
Lets you manage Azure Cosmos DB accounts, but not access data in them. Prevents access to account keys and connection strings.
BuiltInRole
Databases
View
CosmosBackupOperator
Can submit restore request for a Cosmos DB database or a container for an account
BuiltInRole
Databases
View
CosmosRestoreOperator
Can perform restore action for Cosmos DB database account with continuous backup mode
BuiltInRole
Databases
View
Cost Management Contributor
Can view costs and manage cost configuration (e.g. budgets, exports)
BuiltInRole
Management + Governance
View
Cost Management Reader
Can view cost data and configuration (e.g. budgets, exports)
BuiltInRole
Management + Governance
View
Data Box Contributor
Lets you manage everything under Data Box Service except giving access to others.
BuiltInRole
Storage
View
Data Box Reader
Lets you manage Data Box Service except creating order or editing order details and giving access to others.
BuiltInRole
Storage
View
Data Factory Contributor
Create and manage data factories, as well as child resources within them.
BuiltInRole
Analytics
View
Data Lake Analytics Developer
Lets you submit, monitor, and manage your own jobs but not create or delete Data Lake Analytics accounts.
BuiltInRole
Storage
View
Data Operator for Managed Disks
Provides permissions to upload data to empty managed disks, read, or export data of managed disks (not attached to running VMs) and snapshots using SAS URIs and Azure AD authentication.
BuiltInRole
None
View
Data Purger
Can purge analytics data
BuiltInRole
Analytics
View
Desktop Virtualization Application Group Contributor
Contributor of the Desktop Virtualization Application Group.
BuiltInRole
Other
View
Desktop Virtualization Application Group Reader
Reader of the Desktop Virtualization Application Group.
BuiltInRole
Other
View
Desktop Virtualization Contributor
Contributor of Desktop Virtualization.
BuiltInRole
Other
View
Desktop Virtualization Host Pool Contributor
Contributor of the Desktop Virtualization Host Pool.
BuiltInRole
Other
View
Desktop Virtualization Host Pool Reader
Reader of the Desktop Virtualization Host Pool.
BuiltInRole
Other
View
Desktop Virtualization Reader
Reader of Desktop Virtualization.
BuiltInRole
Other
View
Desktop Virtualization Session Host Operator
Operator of the Desktop Virtualization Session Host.
BuiltInRole
Other
View
Desktop Virtualization User
Allows user to use the applications in an application group.
BuiltInRole
Other
View
Desktop Virtualization User Session Operator
Operator of the Desktop Virtualization Uesr Session.
BuiltInRole
Other
View
Desktop Virtualization Workspace Contributor
Contributor of the Desktop Virtualization Workspace.
BuiltInRole
Other
View
Desktop Virtualization Workspace Reader
Reader of the Desktop Virtualization Workspace.
BuiltInRole
Other
View
DevCenter Dev Box User
Provides access to create and manage dev boxes.
BuiltInRole
None
View
DevCenter Project Admin
Provides access to manage project resources.
BuiltInRole
None
View
Device Provisioning Service Data Contributor
Allows for full access to Device Provisioning Service data-plane operations.
BuiltInRole
None
View
Device Provisioning Service Data Reader
Allows for full read access to Device Provisioning Service data-plane properties.
BuiltInRole
None
View
Device Update Administrator
Gives you full access to management and content operations
BuiltInRole
Internet of things
View
Device Update Content Administrator
Gives you full access to content operations
BuiltInRole
Internet of things
View
Device Update Content Reader
Gives you read access to content operations, but does not allow making changes
BuiltInRole
Internet of things
View
Device Update Deployments Administrator
Gives you full access to management operations
BuiltInRole
Internet of things
View
Device Update Deployments Reader
Gives you read access to management operations, but does not allow making changes
BuiltInRole
Internet of things
View
Device Update Reader
Gives you read access to management and content operations, but does not allow making changes
BuiltInRole
Internet of things
View
DevTest Labs User
Lets you connect, start, restart, and shutdown your virtual machines in your Azure DevTest Labs.
BuiltInRole
Devops
View
DICOM Data Owner
Full access to DICOM data.
BuiltInRole
None
View
DICOM Data Reader
Read and search DICOM data.
BuiltInRole
None
View
Disk Backup Reader
Provides permission to backup vault to perform disk backup.
BuiltInRole
Other
View
Disk Pool Operator
Used by the StoragePool Resource Provider to manage Disks added to a Disk Pool.
BuiltInRole
None
View
Disk Restore Operator
Provides permission to backup vault to perform disk restore.
BuiltInRole
Other
View
Disk Snapshot Contributor
Provides permission to backup vault to manage disk snapshots.
BuiltInRole
Other
View
DNS Resolver Contributor
Lets you manage DNS resolver resources.
BuiltInRole
None
View
DNS Zone Contributor
Lets you manage DNS zones and record sets in Azure DNS, but does not let you control who has access to them.
BuiltInRole
Networking
View
DocumentDB Account Contributor
Lets you manage DocumentDB accounts, but not access to them.
BuiltInRole
Databases
View
Domain Services Contributor
Can manage Azure AD Domain Services and related network configurations
BuiltInRole
None
View
Domain Services Reader
Can view Azure AD Domain Services and related network configurations
BuiltInRole
None
View
EventGrid Contributor
Lets you manage EventGrid operations.
BuiltInRole
Integration
View
EventGrid Data Sender
Allows send access to event grid events.
BuiltInRole
Integration
View
EventGrid EventSubscription Contributor
Lets you manage EventGrid event subscription operations.
BuiltInRole
Integration
View
EventGrid EventSubscription Reader
Lets you read EventGrid event subscriptions.
BuiltInRole
Integration
View
Experimentation Administrator
Experimentation Administrator
BuiltInRole
None
View
Experimentation Contributor
Experimentation Contributor
BuiltInRole
None
View
Experimentation Metric Contributor
Allows for creation, writes and reads to the metric set via the metrics service APIs.
BuiltInRole
None
View
Experimentation Reader
Experimentation Reader
BuiltInRole
None
View
FHIR Data Contributor
Role allows user or principal full access to FHIR Data
BuiltInRole
Integration
View
FHIR Data Converter
Role allows user or principal to convert data from legacy format to FHIR
BuiltInRole
Integration
View
FHIR Data Exporter
Role allows user or principal to read and export FHIR Data
BuiltInRole
Integration
View
FHIR Data Reader
Role allows user or principal to read FHIR Data
BuiltInRole
Integration
View
FHIR Data Writer
Role allows user or principal to read and write FHIR Data
BuiltInRole
Integration
View
Grafana Admin
Built-in Grafana admin role
BuiltInRole
None
View
Grafana Editor
Built-in Grafana Editor role
BuiltInRole
None
View
Grafana Viewer
Built-in Grafana Viewer role
BuiltInRole
None
View
Graph Owner
Create and manage all aspects of the Enterprise Graph - Ontology, Schema mapping, Conflation and Conversational AI and Ingestions
BuiltInRole
None
View
Guest Configuration Resource Contributor
Lets you read, write Guest Configuration Resource.
BuiltInRole
None
View
HDInsight Cluster Operator
Lets you read and modify HDInsight cluster configurations.
BuiltInRole
Analytics
View
HDInsight Domain Services Contributor
Can Read, Create, Modify and Delete Domain Services related operations needed for HDInsight Enterprise Security Package
BuiltInRole
Analytics
View
Hierarchy Settings Administrator
Allows users to edit and delete Hierarchy Settings
BuiltInRole
Management + Governance
View
Hybrid Server Onboarding
Can onboard new Hybrid servers to the Hybrid Resource Provider.
BuiltInRole
None
View
Hybrid Server Resource Administrator
Can read, write, delete, and re-onboard Hybrid servers to the Hybrid Resource Provider.
BuiltInRole
None
View
Integration Service Environment Contributor
Lets you manage integration service environments, but not access to them.
BuiltInRole
Integration
View
Integration Service Environment Developer
Allows developers to create and update workflows, integration accounts and API connections in integration service environments.
BuiltInRole
Integration
View
Intelligent Systems Account Contributor
Lets you manage Intelligent Systems accounts, but not access to them.
BuiltInRole
Integration
View
IoT Hub Data Contributor
Allows for full access to IoT Hub data plane operations.
BuiltInRole
Internet of things
View
IoT Hub Data Reader
Allows for full read access to IoT Hub data-plane properties
BuiltInRole
Internet of things
View
IoT Hub Registry Contributor
Allows for full access to IoT Hub device registry.
BuiltInRole
Internet of things
View
IoT Hub Twin Contributor
Allows for read and write access to all IoT Hub device and module twins.
BuiltInRole
Internet of things
View
Key Vault Administrator
Perform all data plane operations on a key vault and all objects in it, including certificates, keys, and secrets. Cannot manage key vault resources or manage role assignments. Only works for key vaults that use the 'Azure role-based access control' permission model.
BuiltInRole
Security
View
Key Vault Certificates Officer
Perform any action on the certificates of a key vault, except manage permissions. Only works for key vaults that use the 'Azure role-based access control' permission model.
BuiltInRole
Security
View
Key Vault Contributor
Lets you manage key vaults, but not access to them.
BuiltInRole
Security
View
Key Vault Crypto Officer
Perform any action on the keys of a key vault, except manage permissions. Only works for key vaults that use the 'Azure role-based access control' permission model.
BuiltInRole
Security
View
Key Vault Crypto Service Encryption User
Read metadata of keys and perform wrap/unwrap operations. Only works for key vaults that use the 'Azure role-based access control' permission model.
BuiltInRole
Security
View
Key Vault Crypto User
Perform cryptographic operations using keys. Only works for key vaults that use the 'Azure role-based access control' permission model.
BuiltInRole
Security
View
Key Vault Reader
Read metadata of key vaults and its certificates, keys, and secrets. Cannot read sensitive values such as secret contents or key material. Only works for key vaults that use the 'Azure role-based access control' permission model.
BuiltInRole
Security
View
Key Vault Secrets Officer
Perform any action on the secrets of a key vault, except manage permissions. Only works for key vaults that use the 'Azure role-based access control' permission model.
BuiltInRole
Security
View
Key Vault Secrets User
Read secret contents. Only works for key vaults that use the 'Azure role-based access control' permission model.
BuiltInRole
Security
View
Knowledge Consumer
Knowledge Read permission to consume Enterprise Graph Knowledge using entity search and graph query
BuiltInRole
None
View
Kubernetes Cluster - Azure Arc Onboarding
Role definition to authorize any user/service to create connectedClusters resource
BuiltInRole
Management + Governance
View
Kubernetes Extension Contributor
Can create, update, get, list and delete Kubernetes Extensions, and get extension async operations
BuiltInRole
Management + Governance
View
Lab Assistant
The lab assistant role
BuiltInRole
None
View
Lab Contributor
The lab contributor role
BuiltInRole
None
View
Lab Creator
Lets you create new labs under your Azure Lab Accounts.
BuiltInRole
Devops
View
Lab Operator
The lab operator role
BuiltInRole
None
View
Lab Services Contributor
The lab services contributor role
BuiltInRole
None
View
Lab Services Reader
The lab services reader role
BuiltInRole
None
View
Load Test Contributor
View, create, update, delete and execute load tests. View and list load test resources but can not make any changes.
BuiltInRole
None
View
Load Test Owner
Execute all operations on load test resources and load tests
BuiltInRole
None
View
Load Test Reader
View and list all load tests and load test resources but can not make any changes
BuiltInRole
None
View
Log Analytics Contributor
Log Analytics Contributor can read all monitoring data and edit monitoring settings. Editing monitoring settings includes adding the VM extension to VMs; reading storage account keys to be able to configure collection of logs from Azure Storage; adding solutions; and configuring Azure diagnostics on all Azure resources.
BuiltInRole
Analytics
View
Log Analytics Reader
Log Analytics Reader can view and search all monitoring data as well as and view monitoring settings, including viewing the configuration of Azure diagnostics on all Azure resources.
BuiltInRole
Analytics
View
Logic App Contributor
Lets you manage logic app, but not access to them.
BuiltInRole
Integration
View
Logic App Operator
Lets you read, enable and disable logic app.
BuiltInRole
Integration
View
Managed Application Contributor Role
Allows for creating managed application resources.
BuiltInRole
Management + Governance
View
Managed Application Operator Role
Lets you read and perform actions on Managed Application resources
BuiltInRole
Management + Governance
View
Managed Applications Reader
Lets you read resources in a managed app and request JIT access.
BuiltInRole
Management + Governance
View
Managed HSM contributor
Lets you manage managed HSM pools, but not access to them.
BuiltInRole
Security
View
Managed Identity Contributor
Create, Read, Update, and Delete User Assigned Identity
BuiltInRole
Identity
View
Managed Identity Operator
Read and Assign User Assigned Identity
BuiltInRole
Identity
View
Managed Services Registration assignment Delete Role
Managed Services Registration Assignment Delete Role allows the managing tenant users to delete the registration assignment assigned to their tenant.
BuiltInRole
Management + Governance
View
Management Group Contributor
Management Group Contributor Role
BuiltInRole
Management + Governance
View
Management Group Reader
Management Group Reader Role
BuiltInRole
Management + Governance
View
Media Services Account Administrator
Create, read, modify, and delete Media Services accounts; read-only access to other Media Services resources.
BuiltInRole
Web
View
Media Services Live Events Administrator
Create, read, modify, and delete Live Events, Assets, Asset Filters, and Streaming Locators; read-only access to other Media Services resources.
BuiltInRole
Web
View
Media Services Media Operator
Create, read, modify, and delete Assets, Asset Filters, Streaming Locators, and Jobs; read-only access to other Media Services resources.
BuiltInRole
Web
View
Media Services Policy Administrator
Create, read, modify, and delete Account Filters, Streaming Policies, Content Key Policies, and Transforms; read-only access to other Media Services resources. Cannot create Jobs, Assets or Streaming resources.
BuiltInRole
Web
View
Media Services Streaming Endpoints Administrator
Create, read, modify, and delete Streaming Endpoints; read-only access to other Media Services resources.
BuiltInRole
Web
View
Microsoft Sentinel Automation Contributor
Microsoft Sentinel Automation Contributor
BuiltInRole
Security
View
Microsoft Sentinel Contributor
Microsoft Sentinel Contributor
BuiltInRole
Security
View
Microsoft Sentinel Reader
Microsoft Sentinel Reader
BuiltInRole
Security
View
Microsoft Sentinel Responder
Microsoft Sentinel Responder
BuiltInRole
Security
View
Microsoft.Kubernetes connected cluster role
Microsoft.Kubernetes connected cluster role.
BuiltInRole
None
View
Monitoring Contributor
Can read all monitoring data and update monitoring settings.
BuiltInRole
Monitor
View
Monitoring Metrics Publisher
Enables publishing metrics against Azure resources
BuiltInRole
Monitor
View
Monitoring Reader
Can read all monitoring data.
BuiltInRole
Monitor
View
Network Contributor
Lets you manage networks, but not access to them.
BuiltInRole
Networking
View
New Relic APM Account Contributor
Lets you manage New Relic Application Performance Management accounts and applications, but not access to them.
BuiltInRole
Management + Governance
View
Object Anchors Account Owner
Provides user with ingestion capabilities for an object anchors account.
BuiltInRole
None
View
Object Anchors Account Reader
Lets you read ingestion jobs for an object anchors account.
BuiltInRole
None
View
Object Understanding Account Owner
Provides user with ingestion capabilities for Azure Object Understanding.
BuiltInRole
None
View
Object Understanding Account Reader
Lets you read ingestion jobs for an object understanding account.
BuiltInRole
None
View
PlayFab Contributor
Provides contributor access to PlayFab resources
BuiltInRole
None
View
PlayFab Reader
Provides read access to PlayFab resources
BuiltInRole
None
View
Policy Insights Data Writer (Preview)
Allows read access to resource policies and write access to resource component policy events.
BuiltInRole
Preview
View
Private DNS Zone Contributor
Lets you manage private DNS zone resources, but not the virtual networks they are linked to.
BuiltInRole
Networking
View
Project Babylon Data Curator
The Microsoft.ProjectBabylon data curator can create, read, modify and delete catalog data objects and establish relationships between objects. This role is in preview and subject to change.
BuiltInRole
Preview
View
Project Babylon Data Reader
The Microsoft.ProjectBabylon data reader can read catalog data objects. This role is in preview and subject to change.
BuiltInRole
Preview
View
Project Babylon Data Source Administrator
The Microsoft.ProjectBabylon data source administrator can manage data sources and data scans. This role is in preview and subject to change.
BuiltInRole
Preview
View
Purview role 1 (Deprecated)
Deprecated role.
BuiltInRole
Preview
View
Purview role 2 (Deprecated)
Deprecated role.
BuiltInRole
Preview
View
Purview role 3 (Deprecated)
Deprecated role.
BuiltInRole
Preview
View
Quota Request Operator
Read and create quota requests, get quota request status, and create support tickets.
BuiltInRole
Management + Governance
View
Reader and Data Access
Lets you view everything but will not let you delete or create a storage account or contained resource. It will also allow read/write access to all data contained in a storage account via access to storage account keys.
BuiltInRole
Storage
View
Redis Cache Contributor
Lets you manage Redis caches, but not access to them.
BuiltInRole
Databases
View
Remote Rendering Administrator
Provides user with conversion, manage session, rendering and diagnostics capabilities for Azure Remote Rendering
BuiltInRole
Mixed Reality
View
Remote Rendering Client
Provides user with manage session, rendering and diagnostics capabilities for Azure Remote Rendering.
BuiltInRole
Mixed Reality
View
Reservation Purchaser
Lets you purchase reservations
BuiltInRole
Management + Governance
View
Resource Policy Contributor
Users with rights to create/modify resource policy, create support ticket and read resources/hierarchy.
BuiltInRole
Management + Governance
View
Scheduled Patching Contributor
Provides access to manage maintenance configurations with maintenance scope InGuestPatch and corresponding configuration assignments
BuiltInRole
None
View
Scheduler Job Collections Contributor
Lets you manage Scheduler job collections, but not access to them.
BuiltInRole
Other
View
Schema Registry Contributor (Preview)
Read, write, and delete Schema Registry groups and schemas.
BuiltInRole
Preview
View
Schema Registry Reader (Preview)
Read and list Schema Registry groups and schemas.
BuiltInRole
Preview
View
Search Index Data Contributor
Grants full access to Azure Cognitive Search index data.
BuiltInRole
Web
View
Search Index Data Reader
Grants read access to Azure Cognitive Search index data.
BuiltInRole
Web
View
Search Service Contributor
Lets you manage Search services, but not access to them.
BuiltInRole
Web
View
Security Admin
Security Admin Role
BuiltInRole
Security
View
Security Assessment Contributor
Lets you push assessments to Security Center
BuiltInRole
Security
View
Security Detonation Chamber Publisher
Allowed to publish and modify platforms, workflows and toolsets to Security Detonation Chamber
BuiltInRole
Security
View
Security Detonation Chamber Reader
Allowed to query submission info and files from Security Detonation Chamber
BuiltInRole
Security
View
Security Detonation Chamber Submission Manager
Allowed to create and manage submissions to Security Detonation Chamber
BuiltInRole
Security
View
Security Detonation Chamber Submitter
Allowed to create submissions to Security Detonation Chamber
BuiltInRole
Security
View
Security Manager (Legacy)
This is a legacy role. Please use Security Administrator instead
BuiltInRole
Security
View
Security Reader
Security Reader Role
BuiltInRole
Security
View
Services Hub Operator
Services Hub Operator allows you to perform all read, write, and deletion operations related to Services Hub Connectors.
BuiltInRole
Other
View
SignalR AccessKey Reader
Read SignalR Service Access Keys
BuiltInRole
Web
View
SignalR App Server
Lets your app server access SignalR Service with AAD auth options.
BuiltInRole
Preview
View
SignalR REST API Owner
Full access to Azure SignalR Service REST APIs
BuiltInRole
Preview
View
SignalR REST API Reader
Read-only access to Azure SignalR Service REST APIs
BuiltInRole
Preview
View
SignalR Service Owner
Full access to Azure SignalR Service REST APIs
BuiltInRole
Web
View
SignalR/Web PubSub Contributor
Create, Read, Update, and Delete SignalR service resources
BuiltInRole
Web
View
Site Recovery Contributor
Lets you manage Site Recovery service except vault creation and role assignment
BuiltInRole
Management + Governance
View
Site Recovery Operator
Lets you failover and failback but not perform other Site Recovery management operations
BuiltInRole
Management + Governance
View
Site Recovery Reader
Lets you view Site Recovery status but not perform other management operations
BuiltInRole
Management + Governance
View
Spatial Anchors Account Contributor
Lets you manage spatial anchors in your account, but not delete them
BuiltInRole
Mixed Reality
View
Spatial Anchors Account Owner
Lets you manage spatial anchors in your account, including deleting them
BuiltInRole
Mixed Reality
View
Spatial Anchors Account Reader
Lets you locate and read properties of spatial anchors in your account
BuiltInRole
Mixed Reality
View
SQL DB Contributor
Lets you manage SQL databases, but not access to them. Also, you can't manage their security-related policies or their parent SQL servers.
BuiltInRole
Databases
View
SQL Managed Instance Contributor
Lets you manage SQL Managed Instances and required network configuration, but can’t give access to others.
BuiltInRole
Databases
View
SQL Security Manager
Lets you manage the security-related policies of SQL servers and databases, but not access to them.
BuiltInRole
Databases
View
SQL Server Contributor
Lets you manage SQL servers and databases, but not access to them, and not their security -related policies.
BuiltInRole
Databases
View
Storage Account Backup Contributor
Lets you perform backup and restore operations using Azure Backup on the storage account.
BuiltInRole
Storage
View
Storage Account Contributor
Lets you manage storage accounts, including accessing storage account keys which provide full access to storage account data.
BuiltInRole
Storage
View
Storage Account Key Operator Service Role
Storage Account Key Operators are allowed to list and regenerate keys on Storage Accounts
BuiltInRole
Storage
View
Storage Blob Data Contributor
Allows for read, write and delete access to Azure Storage blob containers and data
BuiltInRole
Storage
View
Storage Blob Data Owner
Allows for full access to Azure Storage blob containers and data, including assigning POSIX access control.
BuiltInRole
Storage
View
Storage Blob Data Reader
Allows for read access to Azure Storage blob containers and data
BuiltInRole
Storage
View
Storage Blob Delegator
Allows for generation of a user delegation key which can be used to sign SAS tokens
BuiltInRole
Storage
View
Storage File Data SMB Share Contributor
Allows for read, write, and delete access in Azure Storage file shares over SMB
BuiltInRole
Storage
View
Storage File Data SMB Share Elevated Contributor
Allows for read, write, delete and modify NTFS permission access in Azure Storage file shares over SMB
BuiltInRole
Storage
View
Storage File Data SMB Share Reader
Allows for read access to Azure File Share over SMB
BuiltInRole
Storage
View
Storage Queue Data Contributor
Allows for read, write, and delete access to Azure Storage queues and queue messages
BuiltInRole
Storage
View
Storage Queue Data Message Processor
Allows for peek, receive, and delete access to Azure Storage queue messages
BuiltInRole
Storage
View
Storage Queue Data Message Sender
Allows for sending of Azure Storage queue messages
BuiltInRole
Storage
View
Storage Queue Data Reader
Allows for read access to Azure Storage queues and queue messages
BuiltInRole
Storage
View
Storage Table Data Contributor
Allows for read, write and delete access to Azure Storage tables and entities
BuiltInRole
Storage
View
Storage Table Data Reader
Allows for read access to Azure Storage tables and entities
BuiltInRole
Storage
View
Stream Analytics Query Tester
Lets you perform query testing without creating a stream analytics job first
BuiltInRole
None
View
Support Request Contributor
Lets you create and manage Support requests
BuiltInRole
Management + Governance
View
Tag Contributor
Lets you manage tags on entities, without providing access to the entities themselves.
BuiltInRole
Management + Governance
View
Test Base Reader
Let you view and download packages and test results.
BuiltInRole
None
View
Traffic Manager Contributor
Lets you manage Traffic Manager profiles, but does not let you control who has access to them.
BuiltInRole
Networking
View
User Access Administrator
Lets you manage user access to Azure resources.
BuiltInRole
General
View
Virtual Machine Administrator Login
View Virtual Machines in the portal and login as administrator
BuiltInRole
Compute
View
Virtual Machine Contributor
Lets you manage virtual machines, but not access to them, and not the virtual network or storage account they're connected to.
BuiltInRole
Compute
View
Virtual Machine Local User Login
View Virtual Machines in the portal and login as a local user configured on the arc server
BuiltInRole
None
View
Virtual Machine User Login
View Virtual Machines in the portal and login as a regular user.
BuiltInRole
Compute
View
Web Plan Contributor
Lets you manage the web plans for websites, but not access to them.
BuiltInRole
Web
View
Web PubSub Service Owner (Preview)
Full access to Azure Web PubSub Service REST APIs
BuiltInRole
Preview
View
Web PubSub Service Reader (Preview)
Read-only access to Azure Web PubSub Service REST APIs
BuiltInRole
Preview
View
Website Contributor
Lets you manage websites (not web plans), but not access to them.
BuiltInRole
Web
View
Windows Admin Center Administrator Login
Let's you manage the OS of your resource via Windows Admin Center as an administrator.
BuiltInRole
None
View
Workbook Contributor
Can save shared workbooks.
BuiltInRole
Monitor
View
Workbook Reader
Can read workbooks.
BuiltInRole
Monitor
View
WorkloadBuilder Migration Agent Role
WorkloadBuilder Migration Agent Role.
BuiltInRole
None
View
'@

$resourceRoles = @()
$rawRolesArray = $rawRoles -split "`n"
for ($i = 0; $i -lt $rawRolesArray.Count; $i += 5) {
    $resourceRoles += $rawRolesArray[$i].Trim()
}

$allRoles = az role definition list --custom-role-only false --query '[].{roleName:roleName, id:id, roleType:roleType}' | ConvertFrom-Json

$resBicep = [System.Collections.ArrayList]@()
$resArm = [System.Collections.ArrayList]@()
foreach ($resourceRole in $resourceRoles) {
    $matchingRole = $allRoles | Where-Object { $_.roleName -eq $resourceRole }
    $resBicep += "'{0}': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','{1}')" -f $resourceRole, ($matchingRole.id.split('/')[-1])
    $resArm += "`"{0}`": `"[subscriptionResourceId('Microsoft.Authorization/roleDefinitions','{1}')]`"," -f $resourceRole, ($matchingRole.id.split('/')[-1])
}

Write-Verbose 'Bicep' -Verbose
Write-Verbose '-----' -Verbose
$resBicep

Write-Verbose '' -Verbose
Write-Verbose 'ARM' -Verbose
Write-Verbose '---' -Verbose
$resArm
