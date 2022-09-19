az acr update --name adpsxxazacrx009 --anonymous-pull-enabled

az group create --name validate-rg --location australiaeast
az deployment group create --resource-group validate-rg --template-file main.bicep
