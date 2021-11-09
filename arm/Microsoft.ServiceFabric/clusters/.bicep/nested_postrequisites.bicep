param serviceFabricClusterObj object
param supportLogStorageAccountKeys object
param location string
param tags object

var serviceFabricClusterName = split(serviceFabricClusterObj.resourceId, '/')[2]
var vmNodeType0Name = serviceFabricClusterObj.properties.nodeTypes[0].name

resource applicationDiagnosticsStorageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: location
  name: 'appdiagstrg01'
  sku: {
    name: 'Standard_LRS'
  }
  tags: tags
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  location: location
  name: '${serviceFabricClusterName}-vnet-01'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet-01'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
  tags: tags
}

resource loadBalancerPublicIPAddress 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: '${serviceFabricClusterName}-LB-PIP'
  location: location
  properties: {
    dnsSettings: {
      domainNameLabel: serviceFabricClusterName
    }
    publicIPAllocationMethod: 'Dynamic'
  }
  tags: tags
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2021-03-01' = {
  name: '${serviceFabricClusterName}-LB'
  location: location
  properties: {
    frontendIPConfigurations: [
      {
        name: 'LoadBalancerIPConfig'
        properties: {
          publicIPAddress: {
            id: loadBalancerPublicIPAddress.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'LoadBalancerBEAddressPool'
        properties: {}
      }
    ]
    loadBalancingRules: [
      {
        name: 'LBRule'
        properties: {
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${serviceFabricClusterName}-LB', 'LoadBalancerBEAddressPool')
          }
          backendPort: 19000
          enableFloatingIP: true
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${serviceFabricClusterName}-LB', 'LoadBalancerIPConfig')
          }
          frontendPort: 19000
          idleTimeoutInMinutes: 5
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', '${serviceFabricClusterName}-LB', 'FabricGatewayProbe')
          }
          protocol: 'Tcp'
        }
      }
      {
        name: 'LBHttpRule'
        properties: {
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${serviceFabricClusterName}-LB', 'LoadBalancerBEAddressPool')
          }
          backendPort: 19080
          enableFloatingIP: false
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${serviceFabricClusterName}-LB', 'LoadBalancerIPConfig')
          }
          frontendPort: 19080
          idleTimeoutInMinutes: 5
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', '${serviceFabricClusterName}-LB', 'FabricHttpGatewayProbe')
          }
          protocol: 'Tcp'
        }
      }
      {
        name: 'AppPortLBRule1'
        properties: {
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${serviceFabricClusterName}-LB', 'LoadBalancerBEAddressPool')
          }
          backendPort: 80
          enableFloatingIP: false
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${serviceFabricClusterName}-LB', 'LoadBalancerIPConfig')
          }
          frontendPort: 80
          idleTimeoutInMinutes: 5
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', '${serviceFabricClusterName}-LB', 'AppPortProbe1')
          }
          protocol: 'Tcp'
        }
      }
      {
        name: 'AppPortLBRule2'
        properties: {
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${serviceFabricClusterName}-LB', 'LoadBalancerBEAddressPool')
          }
          backendPort: 8081
          enableFloatingIP: false
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${serviceFabricClusterName}-LB', 'LoadBalancerIPConfig')
          }
          frontendPort: 8081
          idleTimeoutInMinutes: 5
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', '${serviceFabricClusterName}-LB', 'AppPortProbe2')
          }
          protocol: 'Tcp'
        }
      }
    ]
    probes: [
      {
        name: 'FabricGatewayProbe'
        properties: {
          port: 19000
          protocol: 'Tcp'
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
      {
        name: 'FabricHttpGatewayProbe'
        properties: {
          port: 19080
          protocol: 'Tcp'
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
      {
        name: 'AppPortProbe1'
        properties: {
          port: 80
          protocol: 'Tcp'
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
      {
        name: 'AppPortProbe2'
        properties: {
          port: 8081
          protocol: 'Tcp'
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
    inboundNatPools: [
      {
        name: 'LoadBalancerBEAddressNatPool'
        properties: {
          backendPort: 22
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${serviceFabricClusterName}-LB', 'LoadBalancerIPConfig')
          }
          frontendPortRangeEnd: 4500
          frontendPortRangeStart: 3389
          protocol: 'Tcp'
        }
      }
    ]
  }
  tags: tags
  dependsOn: [
    loadBalancerPublicIPAddress
  ]
}

var wadlogs = '<WadCfg><DiagnosticMonitorConfiguration>'

var wadperfcounters1 = '<PerformanceCounters scheduledTransferPeriod=\\"PT1M\\"><PerformanceCounterConfiguration counterSpecifier=\\"\\Memory\\AvailableMemory\\" sampleRate=\\"PT15S\\" unit=\\"Bytes\\"><annotation displayName=\\"Memory available\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\Memory\\PercentAvailableMemory\\" sampleRate=\\"PT15S\\" unit=\\"Percent\\"><annotation displayName=\\"Mem. percent available\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\Memory\\UsedMemory\\" sampleRate=\\"PT15S\\" unit=\\"Bytes\\"><annotation displayName=\\"Memory used\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\Memory\\PercentUsedMemory\\" sampleRate=\\"PT15S\\" unit=\\"Percent\\"><annotation displayName=\\"Memory percentage\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\Memory\\PercentUsedByCache\\" sampleRate=\\"PT15S\\" unit=\\"Percent\\"><annotation displayName=\\"Mem. used by cache\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\Processor\\PercentIdleTime\\" sampleRate=\\"PT15S\\" unit=\\"Percent\\"><annotation displayName=\\"CPU idle time\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\Processor\\PercentUserTime\\" sampleRate=\\"PT15S\\" unit=\\"Percent\\"><annotation displayName=\\"CPU user time\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\Processor\\PercentProcessorTime\\" sampleRate=\\"PT15S\\" unit=\\"Percent\\"><annotation displayName=\\"CPU percentage guest OS\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\Processor\\PercentIOWaitTime\\" sampleRate=\\"PT15S\\" unit=\\"Percent\\"><annotation displayName=\\"CPU IO wait time\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration>'

var wadperfcounters2 = '<PerformanceCounterConfiguration counterSpecifier=\\"\\PhysicalDisk\\BytesPerSecond\\" sampleRate=\\"PT15S\\" unit=\\"BytesPerSecond\\"><annotation displayName=\\"Disk total bytes\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\PhysicalDisk\\ReadBytesPerSecond\\" sampleRate=\\"PT15S\\" unit=\\"BytesPerSecond\\"><annotation displayName=\\"Disk read guest OS\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\PhysicalDisk\\WriteBytesPerSecond\\" sampleRate=\\"PT15S\\" unit=\\"BytesPerSecond\\"><annotation displayName=\\"Disk write guest OS\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\PhysicalDisk\\TransfersPerSecond\\" sampleRate=\\"PT15S\\" unit=\\"CountPerSecond\\"><annotation displayName=\\"Disk transfers\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\PhysicalDisk\\ReadsPerSecond\\" sampleRate=\\"PT15S\\" unit=\\"CountPerSecond\\"><annotation displayName=\\"Disk reads\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\PhysicalDisk\\WritesPerSecond\\" sampleRate=\\"PT15S\\" unit=\\"CountPerSecond\\"><annotation displayName=\\"Disk writes\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\PhysicalDisk\\AverageReadTime\\" sampleRate=\\"PT15S\\" unit=\\"Seconds\\"><annotation displayName=\\"Disk read time\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\PhysicalDisk\\AverageWriteTime\\" sampleRate=\\"PT15S\\" unit=\\"Seconds\\"><annotation displayName=\\"Disk write time\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\PhysicalDisk\\AverageTransferTime\\" sampleRate=\\"PT15S\\" unit=\\"Seconds\\"><annotation displayName=\\"Disk transfer time\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\\"\\PhysicalDisk\\AverageDiskQueueLength\\" sampleRate=\\"PT15S\\" unit=\\"Count\\"><annotation displayName=\\"Disk queue length\\" locale=\\"en-us\\"/></PerformanceCounterConfiguration></PerformanceCounters>'

var wadcfgxstart = '${wadlogs}${wadperfcounters1}${wadperfcounters2}<Metrics resourceId=\\"'
var wadcfgxend = '\\"><MetricAggregation scheduledTransferPeriod=\\"PT1H\\"/><MetricAggregation scheduledTransferPeriod=\\"PT1M\\"/></Metrics></DiagnosticMonitorConfiguration></WadCfg>'

var wadmetricsresourceid0 = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Compute/virtualMachineScaleSets/${vmNodeType0Name}'

resource vmScaleSets 'Microsoft.Compute/virtualMachineScaleSets@2020-12-01' = {
  name: '${vmNodeType0Name}'
  location: location
  properties: {
    overprovision: false
    upgradePolicy: {
      mode: 'Automatic'
    }
    virtualMachineProfile: {
      extensionProfile: {
        extensions: [
          {
            name: 'ServiceFabricNodeVmExt'
            properties: {
              type: 'ServiceFabricLinuxNode'
              autoUpgradeMinorVersion: true
              protectedSettings: {
                'StorageAccountKey1': supportLogStorageAccountKeys.keys[0].value
                'StorageAccountKey2': supportLogStorageAccountKeys.keys[1].value
              }
              publisher: 'Microsoft.Azure.ServiceFabric'
              settings: {
                clusterEndpoint: serviceFabricClusterObj.properties.clusterEndpoint
                nodeTypeRef: vmNodeType0Name
                durabilityLevel: 'Silver'
                enableParallelJobs: true
                nicPrefixOverride: '10.0.0.0/24'
                certificate: {
                  thumbprint: '154813CEE741AE4FC28CAE17FC16FB30888FACF3'
                  x509StoreName: 'My'
                }
              }
              typeHandlerVersion: '1.1'
            }
          }
          {
            name: 'VMDiagnosticsVmExt'
            properties: {
              type: 'LinuxDiagnostic'
              autoUpgradeMinorVersion: true
              protectedSettings: {
                storageAccountName: applicationDiagnosticsStorageAccount.name
                storageAccountKey: applicationDiagnosticsStorageAccount.listKeys().keys[0].value
                storageAccountEndPoint: applicationDiagnosticsStorageAccount.properties.primaryEndpoints.blob
              }
              publisher: 'Microsoft.OSTCExtensions'
              settings: {
                xmlCfg: base64('${wadcfgxstart}${wadmetricsresourceid0}${wadcfgxend}')
                StorageAccount: applicationDiagnosticsStorageAccount.name
              }
              typeHandlerVersion: '2.3'
            }
          }
        ]
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'NIC-0'
            properties: {
              ipConfigurations: [
                {
                  name: 'NIC-0'
                  properties: {
                    loadBalancerBackendAddressPools: [
                      {
                        id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${serviceFabricClusterName}-LB', 'LoadBalancerBEAddressPool')
                      }
                    ]
                    loadBalancerInboundNatPools: [
                      {
                        id: resourceId('Microsoft.Network/loadBalancers/inboundNatPools', '${serviceFabricClusterName}-LB', 'LoadBalancerBEAddressNatPool')
                      }
                    ]
                    subnet: {
                      id: resourceId('Microsoft.Network/virtualNetworks/subnets/', virtualNetwork.name, virtualNetwork.properties.subnets[0].name)
                    }
                  }
                }
              ]
              primary: true
            }
          }
        ]
      }
      osProfile: {
        adminPassword: 'Welkom@123456789'
        adminUsername: 'azureuser'
        computerNamePrefix: vmNodeType0Name
        secrets: [
          {
            sourceVault: {
              id: '/subscriptions/62beb424-25dc-4b94-aee1-5742c4dbf8ad/resourceGroups/CentralIndia-TestRG-1/providers/Microsoft.KeyVault/vaults/kavi-ci-kv-01'
            }
            vaultCertificates: [
              {
                //certificateStore: 'My'
                certificateUrl: 'https://kavi-ci-kv-01.vault.azure.net:443/secrets/clustercert/a1ad924a55ce404093abb9c9d5884b62'
              }
            ]
          }
        ]
      }
      storageProfile: {
        imageReference: {
          publisher: 'Canonical' //'MicrosoftWindowsServer'
          offer: 'UbuntuServer' //'WindowsServer'
          sku: '16.04-LTS' //'2016-Datacenter-with-Containers'
          version: 'latest'
        }
        osDisk: {
          caching: 'ReadOnly'
          createOption: 'FromImage'
          managedDisk: {
            storageAccountType: 'Standard_LRS'
          }
        }
      }
    }
  }
  sku: {
    name: 'Standard_D1_v2' // Must be region specific. Not all sizes are supported. The cluster will keep on 'waiting for nodes' if this size isn't correct.
    capacity: 5
    tier: 'Standard'
  }
  tags: tags
  dependsOn: [
    virtualNetwork
    loadBalancer
    applicationDiagnosticsStorageAccount
  ]
}

// Outputs
output applicationDiagnosticsStorageAccountObj object = applicationDiagnosticsStorageAccount
output virtualNetworkObj object = virtualNetwork
output loadBalancerPublicIPAddressObj object = loadBalancerPublicIPAddress
output loadBalancerObj object = loadBalancer
output vmScaleSetsObj object = vmScaleSets