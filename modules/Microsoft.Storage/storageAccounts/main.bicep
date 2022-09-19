param name string

module stgModule 'br/pbr:microsoft.storage.storageaccounts:0.5.1296-prerelease' = {
  name: 'stgStorage'
  params: {
    name: name
  }
}
