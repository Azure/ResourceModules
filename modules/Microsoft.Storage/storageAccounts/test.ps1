az acr update --name adpsxxazacrx009 --anonymous-pull-enabled

az group create --name validate-rg --location australiaeast
az deployment group create --resource-group validate-rg --template-file main.bicep

az acr repository show --name adpsxxazacrx009 --image bicep/modules/microsoft.automation.automationaccounts:0.5.1296-prerelease

oras pull adpsxxazacrx009.azurecr.io/bicep/modules/microsoft.automation.automationaccounts:0.5.1296-prerelease --media-type application/vnd.oci.image.manifest.v1+json

az bicep publish --file main.bicep --target br:adpsxxazacrx009

# azure docs
oras push adpsxxazacrx009.azurecr.io/samples/artifact:v1 --manifest-config /dev/null:application/vnd.unknown.config.v1+json ./artifact.txt
oras push myregistry.azurecr.io/samples/artifact:1.0     --manifest-config /dev/null:application/vnd.unknown.config.v1+json ./artifact.txt:application/vnd.unknown.layer.v1+txt
# oras docs
oras push adpsxxazacrx009.azurecr.io/hello-artifact:v1 --manifest-config /dev/null:application/vnd.acme.rocket.config ./artifact.txt
https://oras.land/cli/1_pushing/
