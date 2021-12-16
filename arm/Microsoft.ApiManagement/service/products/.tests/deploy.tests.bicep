// Module tests

// Test with only required parameters
module test_required_params '../deploy.bicep' = {
  name: 'test_required_params'
  params: {
    name: 'product001'
    apiManagementServiceName: 'apimtest001'
  }
}
