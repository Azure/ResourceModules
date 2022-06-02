This section provides details on the tokens replacement functionality that enables the use of tokens inside template parameter files instead of plain text strings.

---

### _Navigation_

- [Description](#description)
- [Token Types](#token-types)
  - [Default tokens](#default-tokens)
  - [Optional local custom tokens](#optional-local-custom-tokens)
- [How it works](#how-it-works)
  - [How Tokens are replaced in a Parameter File](#how-tokens-are-replaced-in-a-parameter-file)

---

# Description

Tokens allow you to test deploying modules in your own environment (i.e. using tokens for your naming conventions), or apply other customizations to your resources (i.e. injecting a subscription ID inside a Resource ID string).

The [module pipelines](./The%20CI%20environment%20-%20Pipeline%20design#module-pipelines) leverage a token replacement function that enables parameter files to contain tokens (i.e. `<<subscriptionId>>`, `<<tenantId>>`) instead of using static values. This helps with the following:

- Allows the repository to be portable without having static values from where it was cloned.
- Enables dynamic updates of the tokens from single locations without having to modify all files.
- Not adding more environment variables to workflows/pipelines whenever new tokens are required for the environment.

# Token Types

There are 2 types of tokens that can be applied on a parameter file:

## Default Tokens

These are tokens constructed from environment variables, which are defined in the workflow (Pipeline). Review [Getting Started - GitHub specific prerequisites](./GettingStarted) for more information on these environment variables.

- `<<subscriptionId>>`: Will point to the Azure subscription.
- `<<managementGroupId>>`: Will point to the Azure an Azure Management Group.
- `<<tenantId>>`: Will point to the Azure Tenant ID.
- `<<deploymentSpId>>`: Will point to the Service Principal ID used for deployments.
- `<<resourceGroupName>>`: Will point to the Azure Resource Group where the resources are being deployed to. (This isn't defined in the secrets section but is injected at runtime)

## (Optional) Local Custom Tokens

These are tokens defined in the Git Repository inside a [Settings.json](https://github.com/Azure/ResourceModules/blob/main/settings.json) file. This allows creating tokens that are local and updatable via Source Control mechanisms. Here is an example on where these tokens are stored. You can add key-value pairs as required:

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

The token prefix `'<<'` and suffix `'>>'` in the above example are also configurable in the [Settings.json](https://github.com/Azure/ResourceModules/blob/main/settings.json) file.

The solution comes with one predefined local token `namePrefix`. When validating modules through the CI environment, you must update it to a custom value as described in the [Update default nameprefix](./Getting%20started%20-%20Scenario%201%20Onboard%20module%20library%20and%20CI%20environment#31-update-default-nameprefix) paragraph. This is done to avoid conflicts with resources requiring a globally unique name, such as storage accounts or key vaults.

> **Note**: Do not store sensitive information in this location as they will be present in your Git History. Follow best [practices and guidelines](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/best-practices#security-recommendations-for-parameters) on how to handle secrets in template deployments.

# How it works

The below image compares the different token types that can be used for parameter file tokens:

<img src="./media/CIEnvironment/tokenTypes.png" alt="tokenTypes">

## How tokens are replaced in a parameter file

The below diagram illustrates the Token Replacement Functionality via the [Validate](https://github.com/Azure/ResourceModules/blob/main/.github/actions/templates/validateModuleDeploy/action.yml) and [Deploy](https://github.com/Azure/ResourceModules/blob/main/.github/actions/templates/deployModule/action.yml) Actions/Templates.

<img src="./media/CIEnvironment/tokenReplacement.png" alt="tokenReplacement">

- **1A.** The user creates default tokens as [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository) or [Azure DevOps Pipeline Variables](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/?view=azure-devops), that are injected as environment variables.
- **1B.** The user can also create local custom Parameter File Tokens in the [Settings.json](https://github.com/Azure/ResourceModules/blob/main/settings.json) under the `localTokens` - `tokens` property.
- **2.** The parameter files can now be tokenized as per required value. And the token format can look like `<<tokenName>>`. Example:

  ```json
  "adminPassword": {
    "reference": {
        "keyVault": {
            "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/<<exampleLocalToken>>-keyVault"
        },
        "secretName": "<<exampleLocalToken>>"
    }
  }
  ```
- **3A.** The Replace Tokens function gets the default tokens from the environment variables.
  > Default Tokens are harder to scale as they are explicitly defined in deploy/validate task, workflows and pipelines, and requires updating these components as you create more tokens.

- **3B.** The Replace Tokens function gets local custom tokens from the [Settings.json](https://github.com/Azure/ResourceModules/blob/main/settings.json).
  > Local Tokens are easier to scale as you just need to define them in this file without adding new environment variables or modifying workflows or tasks.

- **3C.** The Replace Tokens function gets the Module Parameter file (tokenized and not deployable) and then all tokens are processed for replacement.

- **3D.** The updated Module Parameter file is then saved, replacing the tokenized version. This file is now 'deployable'.

- **4A.** The Validate/Deploy function retrieves the latest updated module Parameter file.

- **4B.** The Validate/Deploy function validates the deployment artifacts for the module before deploying it to the Azure Sandbox Subscription.
