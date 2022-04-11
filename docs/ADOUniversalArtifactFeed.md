# Azure DevOps Universal Artifact Feed
This document was started to supplement #927. The purpose of this document is to show the dependent components needed to publish ResourceModules in Azure Artifacts in github actions

# Implementation Exploration
1. There is currently no Microsoft Supported Github Action for pushing to an Azure Artifacts feed
1. Instead, you can use this [Azure CLI Action](https://github.com/marketplace/actions/azure-cli-action) with the `azure-devops` extension as shown [here](https://docs.microsoft.com/en-us/azure/devops/artifacts/quickstarts/universal-packages?view=azure-devops)


# Dependent Components
The command to run would be
```
az artifacts universal publish \
                        --organization https://dev.azure.com/<YOUR_ORGANIZATION> \
                        --feed <FEED_NAME> \
                        --name <PACKAGE_NAME> \
                        --version <PACKAGE_VERSION> \
                        --description <PACKAGE_DESCRIPTION> \
                        --path <PACKAGE_DIRECTORY>
```

## The dependent components are
1. An organization
1. An Azure Artifacts Feed
1. The name of the package (each module can be published to its own package)
1. The version of the package (each module package will be versioned. TODO: check back with team to see how we currently semver our modules. This method can be reused to version the artifact package)
1. The description of the package (each module package should have a description. TODO: check back with team to see how we currently host descriptions of our modules. This method can be reused to add description to the artifact package)
1. The path of the module (this can be a for loop on the arm folder. TODO: check back with team to see if there's a reusable method for for looping over paths of each module)


