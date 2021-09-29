param cuaId string

module pid_cuaId './nested_pid_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

output resourceGroupId string = resourceGroup().id