@description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Array of cache rules. Objects with properties: source (req), target (opt), name (opt). name and target will be derived from source if not defined.')
param repoCaches array = []

resource registry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' existing = {
  name: registryName
}

resource cacheRules 'Microsoft.ContainerRegistry/registries/cacheRules@2023-01-01-preview' = [for repo in repoCaches: {
  name: contains(repo, 'name') ? repo.name : replace(replace(repo.source, '/', '-'), '.', '-')
  parent: registry
  properties: {
    sourceRepository: repo.source
    targetRepository: contains(repo, 'target') ? repo.target : repo.source
  }
}]
