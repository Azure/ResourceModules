param name string

module storageModule 'br/pbr:microsoft.storage.storageaccounts:latest' = {
  name: 'stgStorage'
  params: {
    name: name
  }
}
