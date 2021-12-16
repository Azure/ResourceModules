// Module tests

// Test with only required parameters
module test_required_params '../deploy.bicep' = {
  name: 'test_required_params'
  params: {
    storageAccountSku: 'Standard_GRS'
  }
}

// Test with containers
module test_with_containers '../deploy.bicep' = {
  name: 'test_with_containers'
  params: {
    storageAccountSku: 'Standard_GRS'
    blobServices: {
      containers: [
        {
          name: 'avdscripts'
          roleAssignments: []
        }
        {
          name: 'archivecontainer'
          enableWORM: true
          WORMRetention: 666
          allowProtectedAppendWrites: false
          roleAssignments: []
        }
      ]
    }
  }
}
