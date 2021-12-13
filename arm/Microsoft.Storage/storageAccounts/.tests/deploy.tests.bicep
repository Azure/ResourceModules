module noname '../deploy.bicep' = {
  name: 'noname'
  params: {
    storageAccountSku: 'Standard_LRS'
    blobServices: {
      containers: [
        {
          name: 'avdscripts'
          publicAccess: 'Container'
          roleAssignments: []
        }
        {
          name: 'archivecontainer'
          publicAccess: 'Container'
          enableWORM: true
          WORMRetention: 666
          allowProtectedAppendWrites: false
          roleAssignments: []
        }
      ]
    }
  }
}
