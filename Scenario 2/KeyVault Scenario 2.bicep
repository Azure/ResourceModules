param kvlocation string = resourceGroup().location

module keyvault '../arm/Microsoft.KeyVault/vaults/deploy.bicep' = {
  name: 'aksvault'
  params: {
    location: kvlocation
    "privateEndpoints": {
      "value": [
          // Example showing all available fields
          {
              "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
              "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
              "s ervice": "blob",
              "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                  "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
              ],
              "customDnsConfigs": [ // Optional
                  {
                      "fqdn": "customname.test.local",
                      "ipAddresses": [
                          "10.10.10.10"
                      ]
                  }
              ]
          }
        },
      ]
    "accessPolicies": {
      "value": [
          {
              "tenantId": null, // Optional
              "applicationId": null, // Optional
              "objectId": null,
              "permissions": {
                  "certificates": [
                      "All"
                  ],
                  "keys": [
                      "All"
                  ],
                  "secrets": [
                      "All"
                  ]
              }
          }
      ]
  }
  }

  }
}
