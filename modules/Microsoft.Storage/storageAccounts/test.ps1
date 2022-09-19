
resourceGroupName = "validate-rg"
templateFile="main.bicep"

az group create --name $resourceGroupName --location australiaeast

az deployment group create --resource-group $resourceGroupName --template-file $templateFile


alias specifying the registry
`module stgModule 'br/pbr:bicep/modules/core/storage:v1' = {`

alias that specifies the registry and module path.

`module stgModule  'br/pbr:storage:v1' = {`
