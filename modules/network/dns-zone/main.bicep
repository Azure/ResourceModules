@description('Required. DNS zone name.')
@minLength(1)
@maxLength(63)
param name string

@description('Optional. Array of A records.')
param a array = []

@description('Optional. Array of AAAA records.')
param aaaa array = []

@description('Optional. Array of CNAME records.')
param cname array = []

@description('Optional. Array of CAA records.')
param caa array = []

@description('Optional. Array of MX records.')
param mx array = []

@description('Optional. Array of NS records.')
param ns array = []

@description('Optional. Array of PTR records.')
param ptr array = []

@description('Optional. Array of SOA records.')
param soa array = []

@description('Optional. Array of SRV records.')
param srv array = []

@description('Optional. Array of TXT records.')
param txt array = []

@description('Optional. The location of the dnsZone. Should be global.')
param location string = 'global'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

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

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    zoneType: 'Public'
  }
}

module dnsZone_A 'a/main.bicep' = [for (aRecord, index) in a: {
  name: '${uniqueString(deployment().name, location)}-dnsZone-ARecord-${index}'
  params: {
    dnsZoneName: dnsZone.name
    name: aRecord.name
    aRecords: contains(aRecord, 'aRecords') ? aRecord.aRecords : []
    metadata: contains(aRecord, 'metadata') ? aRecord.metadata : {}
    ttl: contains(aRecord, 'ttl') ? aRecord.ttl : 3600
    targetResourceId: contains(aRecord, 'targetResourceId') ? aRecord.targetResourceId : ''
    roleAssignments: contains(aRecord, 'roleAssignments') ? aRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module dnsZone_AAAA 'aaaa/main.bicep' = [for (aaaaRecord, index) in aaaa: {
  name: '${uniqueString(deployment().name, location)}-dnsZone-AAAARecord-${index}'
  params: {
    dnsZoneName: dnsZone.name
    name: aaaaRecord.name
    aaaaRecords: contains(aaaaRecord, 'aaaaRecords') ? aaaaRecord.aaaaRecords : []
    metadata: contains(aaaaRecord, 'metadata') ? aaaaRecord.metadata : {}
    ttl: contains(aaaaRecord, 'ttl') ? aaaaRecord.ttl : 3600
    targetResourceId: contains(aaaaRecord, 'targetResourceId') ? aaaaRecord.targetResourceId : ''
    roleAssignments: contains(aaaaRecord, 'roleAssignments') ? aaaaRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module dnsZone_CNAME 'cname/main.bicep' = [for (cnameRecord, index) in cname: {
  name: '${uniqueString(deployment().name, location)}-dnsZone-CNAMERecord-${index}'
  params: {
    dnsZoneName: dnsZone.name
    name: cnameRecord.name
    cnameRecord: contains(cnameRecord, 'cnameRecord') ? cnameRecord.cnameRecord : {}
    metadata: contains(cnameRecord, 'metadata') ? cnameRecord.metadata : {}
    ttl: contains(cnameRecord, 'ttl') ? cnameRecord.ttl : 3600
    targetResourceId: contains(cnameRecord, 'targetResourceId') ? cnameRecord.targetResourceId : ''
    roleAssignments: contains(cnameRecord, 'roleAssignments') ? cnameRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module dnsZone_CAA 'caa/main.bicep' = [for (caaRecord, index) in caa: {
  name: '${uniqueString(deployment().name, location)}-dnsZone-CAARecord-${index}'
  params: {
    dnsZoneName: dnsZone.name
    name: caaRecord.name
    metadata: contains(caaRecord, 'metadata') ? caaRecord.metadata : {}
    caaRecords: contains(caaRecord, 'caaRecords') ? caaRecord.caaRecords : []
    ttl: contains(caaRecord, 'ttl') ? caaRecord.ttl : 3600
    roleAssignments: contains(caaRecord, 'roleAssignments') ? caaRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module dnsZone_MX 'mx/main.bicep' = [for (mxRecord, index) in mx: {
  name: '${uniqueString(deployment().name, location)}-dnsZone-MXRecord-${index}'
  params: {
    dnsZoneName: dnsZone.name
    name: mxRecord.name
    metadata: contains(mxRecord, 'metadata') ? mxRecord.metadata : {}
    mxRecords: contains(mxRecord, 'mxRecords') ? mxRecord.mxRecords : []
    ttl: contains(mxRecord, 'ttl') ? mxRecord.ttl : 3600
    roleAssignments: contains(mxRecord, 'roleAssignments') ? mxRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module dnsZone_NS 'ns/main.bicep' = [for (nsRecord, index) in ns: {
  name: '${uniqueString(deployment().name, location)}-dnsZone-NSRecord-${index}'
  params: {
    dnsZoneName: dnsZone.name
    name: nsRecord.name
    metadata: contains(nsRecord, 'metadata') ? nsRecord.metadata : {}
    nsRecords: contains(nsRecord, 'nsRecords') ? nsRecord.nsRecords : []
    ttl: contains(nsRecord, 'ttl') ? nsRecord.ttl : 3600
    roleAssignments: contains(nsRecord, 'roleAssignments') ? nsRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module dnsZone_PTR 'ptr/main.bicep' = [for (ptrRecord, index) in ptr: {
  name: '${uniqueString(deployment().name, location)}-dnsZone-PTRRecord-${index}'
  params: {
    dnsZoneName: dnsZone.name
    name: ptrRecord.name
    metadata: contains(ptrRecord, 'metadata') ? ptrRecord.metadata : {}
    ptrRecords: contains(ptrRecord, 'ptrRecords') ? ptrRecord.ptrRecords : []
    ttl: contains(ptrRecord, 'ttl') ? ptrRecord.ttl : 3600
    roleAssignments: contains(ptrRecord, 'roleAssignments') ? ptrRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module dnsZone_SOA 'soa/main.bicep' = [for (soaRecord, index) in soa: {
  name: '${uniqueString(deployment().name, location)}-dnsZone-SOARecord-${index}'
  params: {
    dnsZoneName: dnsZone.name
    name: soaRecord.name
    metadata: contains(soaRecord, 'metadata') ? soaRecord.metadata : {}
    soaRecord: contains(soaRecord, 'soaRecord') ? soaRecord.soaRecord : {}
    ttl: contains(soaRecord, 'ttl') ? soaRecord.ttl : 3600
    roleAssignments: contains(soaRecord, 'roleAssignments') ? soaRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module dnsZone_SRV 'srv/main.bicep' = [for (srvRecord, index) in srv: {
  name: '${uniqueString(deployment().name, location)}-dnsZone-SRVRecord-${index}'
  params: {
    dnsZoneName: dnsZone.name
    name: srvRecord.name
    metadata: contains(srvRecord, 'metadata') ? srvRecord.metadata : {}
    srvRecords: contains(srvRecord, 'srvRecords') ? srvRecord.srvRecords : []
    ttl: contains(srvRecord, 'ttl') ? srvRecord.ttl : 3600
    roleAssignments: contains(srvRecord, 'roleAssignments') ? srvRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module dnsZone_TXT 'txt/main.bicep' = [for (txtRecord, index) in txt: {
  name: '${uniqueString(deployment().name, location)}-dnsZone-TXTRecord-${index}'
  params: {
    dnsZoneName: dnsZone.name
    name: txtRecord.name
    metadata: contains(txtRecord, 'metadata') ? txtRecord.metadata : {}
    txtRecords: contains(txtRecord, 'txtRecords') ? txtRecord.txtRecords : []
    ttl: contains(txtRecord, 'ttl') ? txtRecord.ttl : 3600
    roleAssignments: contains(txtRecord, 'roleAssignments') ? txtRecord.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource dnsZone_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${dnsZone.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: dnsZone
}

module dnsZone_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-dnsZone-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: dnsZone.id
  }
}]

@description('The resource group the DNS zone was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the DNS zone.')
output name string = dnsZone.name

@description('The resource ID of the DNS zone.')
output resourceId string = dnsZone.id

@description('The location the resource was deployed into.')
output location string = dnsZone.location
