@description('Required. Private DNS zone name.')
param privateDnsZoneName string

@description('Required. The name of the A record.')
param name string

@description('Optional. The list of AAAA records in the record set.')
param aaaaRecords array = []

@description('Optional. The list of A records in the record set.')
param aRecords array = []

@description('Optional. The canonical name for this CNAME record.')
param cname string = ''

@description('Optional. The metadata attached to the record set.')
param metadata object = {}

@description('Optional. The list of MX records in the record set.')
param mxRecords array = []

@description('Optional. The list of PTR records in the record set.')
param ptrRecords array = []

@description('Optional. A SOA record.')
param soaRecord object = {}

@description('Optional. The list of SRV records in the record set.')
param srvRecords array = []

@description('Optional. The TTL (time-to-live) of the records in the record set.')
param ttl int = 3600

@description('Optional. The list of TXT records in the record set.')
param txtRecords array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
}

resource aRecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: name
  parent: privateDnsZone
  properties: {
    aaaaRecords: aaaaRecords
    aRecords: aRecords
    cnameRecord: empty(cname) ? null : {
      cname: cname
    }
    metadata: metadata
    mxRecords: mxRecords
    ptrRecords: ptrRecords
    soaRecord: soaRecord
    srvRecords: srvRecords
    ttl: ttl
    txtRecords: txtRecords
  }
}

@description('The name of the deployed A record')
output name string = aRecord.name

@description('The resource ID of the deployed A record')
output resourceId string = aRecord.id

@description('The resource group of the deployed A record')
output resourceGroupName string = resourceGroup().name
