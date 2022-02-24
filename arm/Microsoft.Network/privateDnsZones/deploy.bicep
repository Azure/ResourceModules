@description('Required. Private DNS zone name.')
param name string

@description('Optional. Array of A records.')
param aRecords array = []

@description('Optional. Array of AAAA records.')
param aaaaRecords array = []

@description('Optional. Array of CNAME records.')
param cnameRecords array = []

@description('Optional. Array of MX records.')
param mxRecords array = []

@description('Optional. Array of PTR records.')
param ptrRecords array = []

@description('Optional. Array of SOA records.')
param soaRecords array = []

@description('Optional. Array of SRV records.')
param srvRecords array = []

@description('Optional. Array of TXT records.')
param txtRecords array = []

@description('Optional. Array of custom objects describing vNet links of the DNS zone. Each object should contain properties \'vnetResourceId\' and \'registrationEnabled\'. The \'vnetResourceId\' is a resource ID of a vNet to link, \'registrationEnabled\' (bool) enables automatic DNS registration in the zone for the linked vNet.')
param virtualNetworkLinks array = []

@description('Optional. The location of the PrivateDNSZone. Should be global.')
param location string = 'global'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: name
  location: location
  tags: tags
}

module privateDnsZone_aRecords 'a/deploy.bicep' = [for (aRecord, index) in aRecords: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-ARecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: aRecord.name
    aaaaRecords: aRecord.aaaaRecords
    aRecords: aRecord.aRecords
    cname: aRecord.cname
    metadata: aRecord.metadata
    mxRecords: aRecord.mxRecords
    ptrRecords: aRecord.ptrRecords
    soaRecord: aRecord.soaRecord
    srvRecords: aRecord.srvRecords
    ttl: contains(aRecord, 'ttl') ? aRecord.ttl : 3600
    txtRecords: aRecord.txtRecords
  }
}]

module privateDnsZone_aaaaRecords 'aaaa/deploy.bicep' = [for (aaaaRecord, index) in aaaaRecords: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-AAAARecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: aaaaRecord.name
    aaaaRecords: aaaaRecord.aaaaRecords
    aRecords: aaaaRecord.aRecords
    cname: aaaaRecord.cname
    metadata: aaaaRecord.metadata
    mxRecords: aaaaRecord.mxRecords
    ptrRecords: aaaaRecord.ptrRecords
    soaRecord: aaaaRecord.soaRecord
    srvRecords: aaaaRecord.srvRecords
    ttl: contains(aaaaRecord, 'ttl') ? aaaaRecord.ttl : 3600
    txtRecords: aaaaRecord.txtRecords
  }
}]

module privateDnsZone_cnameRecords 'cname/deploy.bicep' = [for (cnameRecord, index) in cnameRecords: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-CNAMERecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: cnameRecord.name
    aaaaRecords: cnameRecord.aaaaRecords
    aRecords: cnameRecord.aRecords
    cname: cnameRecord.cname
    metadata: cnameRecord.metadata
    mxRecords: cnameRecord.mxRecords
    ptrRecords: cnameRecord.ptrRecords
    soaRecord: cnameRecord.soaRecord
    srvRecords: cnameRecord.srvRecords
    ttl: contains(cnameRecord, 'ttl') ? cnameRecord.ttl : 3600
    txtRecords: cnameRecord.txtRecords
  }
}]

module privateDnsZone_mxRecords 'mx/deploy.bicep' = [for (mxRecord, index) in mxRecords: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-MXRecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: mxRecord.name
    aaaaRecords: mxRecord.aaaaRecords
    aRecords: mxRecord.aRecords
    cname: mxRecord.cname
    metadata: mxRecord.metadata
    mxRecords: mxRecord.mxRecords
    ptrRecords: mxRecord.ptrRecords
    soaRecord: mxRecord.soaRecord
    srvRecords: mxRecord.srvRecords
    ttl: contains(mxRecord, 'ttl') ? mxRecord.ttl : 3600
    txtRecords: mxRecord.txtRecords
  }
}]

module privateDnsZone_ptrRecords 'ptr/deploy.bicep' = [for (ptrRecord, index) in ptrRecords: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-PTRRecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: ptrRecord.name
    aaaaRecords: ptrRecord.aaaaRecords
    aRecords: ptrRecord.aRecords
    cname: ptrRecord.cname
    metadata: ptrRecord.metadata
    mxRecords: ptrRecord.mxRecords
    ptrRecords: ptrRecord.ptrRecords
    soaRecord: ptrRecord.soaRecord
    srvRecords: ptrRecord.srvRecords
    ttl: contains(ptrRecord, 'ttl') ? ptrRecord.ttl : 3600
    txtRecords: ptrRecord.txtRecords
  }
}]

module privateDnsZone_soaRecords 'soa/deploy.bicep' = [for (soaRecord, index) in soaRecords: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-SOARecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: soaRecord.name
    aaaaRecords: soaRecord.aaaaRecords
    aRecords: soaRecord.aRecords
    cname: soaRecord.cname
    metadata: soaRecord.metadata
    mxRecords: soaRecord.mxRecords
    ptrRecords: soaRecord.ptrRecords
    soaRecord: soaRecord.soaRecord
    srvRecords: soaRecord.srvRecords
    ttl: contains(soaRecord, 'ttl') ? soaRecord.ttl : 3600
    txtRecords: soaRecord.txtRecords
  }
}]

module privateDnsZone_srvRecords 'srv/deploy.bicep' = [for (srvRecord, index) in srvRecords: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-SRVRecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: srvRecord.name
    aaaaRecords: srvRecord.aaaaRecords
    aRecords: srvRecord.aRecords
    cname: srvRecord.cname
    metadata: srvRecord.metadata
    mxRecords: srvRecord.mxRecords
    ptrRecords: srvRecord.ptrRecords
    soaRecord: srvRecord.soaRecord
    srvRecords: srvRecord.srvRecords
    ttl: contains(srvRecord, 'ttl') ? srvRecord.ttl : 3600
    txtRecords: srvRecord.txtRecords
  }
}]

module privateDnsZone_txtRecords 'txt/deploy.bicep' = [for (txtRecord, index) in txtRecords: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-TXTRecord-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: txtRecord.name
    aaaaRecords: txtRecord.aaaaRecords
    aRecords: txtRecord.aRecords
    cname: txtRecord.cname
    metadata: txtRecord.metadata
    mxRecords: txtRecord.mxRecords
    ptrRecords: txtRecord.ptrRecords
    soaRecord: txtRecord.soaRecord
    srvRecords: txtRecord.srvRecords
    ttl: contains(txtRecord, 'ttl') ? txtRecord.ttl : 3600
    txtRecords: txtRecord.txtRecords
  }
}]

module privateDnsZone_virtualNetworkLinks 'virtualNetworkLinks/deploy.bicep' = [for (virtualNetworkLink, index) in virtualNetworkLinks: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-VirtualNetworkLink-${index}'
  params: {
    privateDnsZoneName: privateDnsZone.name
    name: contains(virtualNetworkLink, 'name') ? virtualNetworkLink.name : '${last(split(virtualNetworkLink.virtualNetworkResourceId, '/'))}-vnetlink'
    virtualNetworkResourceId: virtualNetworkLink.virtualNetworkResourceId
    location: contains(virtualNetworkLink, 'location') ? virtualNetworkLink.location : 'global'
    registrationEnabled: contains(virtualNetworkLink, 'registrationEnabled') ? virtualNetworkLink.registrationEnabled : false
    tags: contains(virtualNetworkLink, 'tags') ? virtualNetworkLink.tags : {}
  }
}]

resource privateDnsZone_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${privateDnsZone.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: privateDnsZone
}

module privateDnsZone_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: privateDnsZone.id
  }
}]

@description('The resource group the private DNS zone was deployed into')
output resourceGroupName string = resourceGroup().name

@description('The name of the private DNS zone')
output name string = privateDnsZone.name

@description('The resource ID of the private DNS zone')
output resourceId string = privateDnsZone.id
