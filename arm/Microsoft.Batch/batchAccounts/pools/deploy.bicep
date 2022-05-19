@description('Conditional. The name of the parent Batch Account. Required if the template is used in a standalone deployment.')
param batchAccountName string = ''

@description('Optional. The list of user identities associated with the Batch pool.')
param userAssignedIdentities object = {}

@description('The list of application licenses must be a subset of available Batch service application licenses. If a license is requested which is not supported, pool creation will fail.')
param applicationLicenses array = []

@description('The list of application packages to install on the nodes. There is a maximum of 10 application package references on any given pool.')
@maxLength(10)
param applicationPackages array = []

var identityType = !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

var identity = {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
}

resource batchAccount 'Microsoft.Batch/batchAccounts@2022-01-01' existing = {
  name: batchAccountName
}

resource symbolicname 'Microsoft.Batch/batchAccounts/pools@2022-01-01' = {
  name: 'string'
  parent: batchAccount.name
  identity: identity
  properties: {
    applicationLicenses: applicationLicenses
    applicationPackages: applicationPackages
    [
      {
        id: 'string'
        version: 'string'
      }
    ]
    certificates: [
      {
        id: 'string'
        storeLocation: 'string'
        storeName: 'string'
        visibility: [
          'string'
        ]
      }
    ]
    deploymentConfiguration: {
      cloudServiceConfiguration: {
        osFamily: 'string'
        osVersion: 'string'
      }
      virtualMachineConfiguration: {
        containerConfiguration: {
          containerImageNames: [
            'string'
          ]
          containerRegistries: [
            {
              identityReference: {
                resourceId: 'string'
              }
              password: 'string'
              registryServer: 'string'
              username: 'string'
            }
          ]
          type: 'DockerCompatible'
        }
        dataDisks: [
          {
            diskSizeGB: int
            lun: int
            storageAccountType: 'string'
          }
        ]
        diskEncryptionConfiguration: {
          targets: [
            'string'
          ]
        }
        extensions: [
          {
            autoUpgradeMinorVersion: bool
            name: 'string'
            protectedSettings: any()
            provisionAfterExtensions: [
              'string'
            ]
            publisher: 'string'
            settings: any()
            type: 'string'
            typeHandlerVersion: 'string'
          }
        ]
        imageReference: {
          id: 'string'
          offer: 'string'
          publisher: 'string'
          sku: 'string'
          version: 'string'
        }
        licenseType: 'string'
        nodeAgentSkuId: 'string'
        nodePlacementConfiguration: {
          policy: 'string'
        }
        osDisk: {
          ephemeralOSDiskSettings: {
            placement: 'CacheDisk'
          }
        }
        windowsConfiguration: {
          enableAutomaticUpdates: bool
        }
      }
    }
    displayName: 'string'
    interNodeCommunication: 'string'
    metadata: [
      {
        name: 'string'
        value: 'string'
      }
    ]
    mountConfiguration: [
      {
        azureBlobFileSystemConfiguration: {
          accountKey: 'string'
          accountName: 'string'
          blobfuseOptions: 'string'
          containerName: 'string'
          identityReference: {
            resourceId: 'string'
          }
          relativeMountPath: 'string'
          sasKey: 'string'
        }
        azureFileShareConfiguration: {
          accountKey: 'string'
          accountName: 'string'
          azureFileUrl: 'string'
          mountOptions: 'string'
          relativeMountPath: 'string'
        }
        cifsMountConfiguration: {
          mountOptions: 'string'
          password: 'string'
          relativeMountPath: 'string'
          source: 'string'
          username: 'string'
        }
        nfsMountConfiguration: {
          mountOptions: 'string'
          relativeMountPath: 'string'
          source: 'string'
        }
      }
    ]
    networkConfiguration: {
      dynamicVNetAssignmentScope: 'string'
      endpointConfiguration: {
        inboundNatPools: [
          {
            backendPort: int
            frontendPortRangeEnd: int
            frontendPortRangeStart: int
            name: 'string'
            networkSecurityGroupRules: [
              {
                access: 'string'
                priority: int
                sourceAddressPrefix: 'string'
                sourcePortRanges: [
                  'string'
                ]
              }
            ]
            protocol: 'string'
          }
        ]
      }
      publicIPAddressConfiguration: {
        ipAddressIds: [
          'string'
        ]
        provision: 'string'
      }
      subnetId: 'string'
    }
    scaleSettings: {
      autoScale: {
        evaluationInterval: 'string'
        formula: 'string'
      }
      fixedScale: {
        nodeDeallocationOption: 'string'
        resizeTimeout: 'string'
        targetDedicatedNodes: int
        targetLowPriorityNodes: int
      }
    }
    startTask: {
      commandLine: 'string'
      containerSettings: {
        containerRunOptions: 'string'
        imageName: 'string'
        registry: {
          identityReference: {
            resourceId: 'string'
          }
          password: 'string'
          registryServer: 'string'
          username: 'string'
        }
        workingDirectory: 'string'
      }
      environmentSettings: [
        {
          name: 'string'
          value: 'string'
        }
      ]
      maxTaskRetryCount: int
      resourceFiles: [
        {
          autoStorageContainerName: 'string'
          blobPrefix: 'string'
          fileMode: 'string'
          filePath: 'string'
          httpUrl: 'string'
          identityReference: {
            resourceId: 'string'
          }
          storageContainerUrl: 'string'
        }
      ]
      userIdentity: {
        autoUser: {
          elevationLevel: 'string'
          scope: 'string'
        }
        userName: 'string'
      }
      waitForSuccess: bool
    }
    taskSchedulingPolicy: {
      nodeFillType: 'string'
    }
    taskSlotsPerNode: int
    userAccounts: [
      {
        elevationLevel: 'string'
        linuxUserConfiguration: {
          gid: int
          sshPrivateKey: 'string'
          uid: int
        }
        name: 'string'
        password: 'string'
        windowsUserConfiguration: {
          loginMode: 'string'
        }
      }
    ]
    vmSize: 'string'
  }
}
