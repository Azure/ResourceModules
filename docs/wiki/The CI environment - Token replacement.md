If you are forking or cloning the repository, you can use 'tokens' inside your parameter files. Tokens allow you to test deploying modules in your own environment (i.e. using tokens for your naming conventions), or apply other customizations to your resources (i.e. using your own subscription ID inside a Resource ID string). See details in the [Parameter File Tokens Design](./ParameterFileTokens).

The repository contains a [Settings.json](https://github.com/Azure/ResourceModules/blob/main/settings.json) that enables you to define local tokens and store them in source control. The token format is a `name` and `value` pair as shown in the following example:

```json
"localTokens": {
  "tokens": [
      {
        "name": "tokenName",
        "value": "tokenValue",
        "metadata":{
          "description":"token description"
        }
      }
    ]
}
```

Let us say you'd want to use this token inside a Key Vault parameter file, to deploy the key vault with a name that contains this token:

```json
"parameters": {
    "name": {
        "value": "<<tokenName>>-keyVault"
    }
}
```

Once the Key Vault is deployed, you'll notice that the Key Vault name in Azure will be `tokenValue-keyVault`

> The token prefix `<<` and suffix `>>` in the above example are also configurable in the [Settings.json](https://github.com/Azure/ResourceModules/blob/main/settings.json) file. They are however the default used in the CARML main repository.

---
Note: There are default tokens that can be enabled on any resource that leverages the [GitHub specific prerequisites](GettingStarted#github-specific-prerequisites) secrets.

- `<<subscriptionId>>`: Will point to the Azure subscription.
- `<<managementGroupId>>`: Will point to the Azure an Azure Management Group.
- `<<tenantId>>`: Will point to the Azure Tenant ID.
- `<<deploymentSpId>>`: Will point to the Service Principal ID used for deployments.
- `<<resourceGroupName>>`: Will point to the Azure Resource Group where the resources are being deployed to. (This isn't defined in the secrets section but is injected at runtime)

Review [Parameter File Tokens Design](./ParameterFileTokens) for more details.
