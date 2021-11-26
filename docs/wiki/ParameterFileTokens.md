# Parameter File Tokens

This section provides details on the Tokens Replacement Functionality that enables the use of tokens inside template Parameter Files instead of plain text strings.

---

### _Navigation_

- [Description](#description)
- [How it works](#how-it-works)
  - [Token Types](#token-types)
    - [1. Default Tokens (Environment Variables) [Default]](#1-default-tokens-environment-variables-default)
    - [2. Local Custom Tokens (Source Control) [Optional]](#2-local-custom-tokens-source-control-optional)
  - [How Tokens are replaced in a Parameter File](#how-tokens-are-replaced-in-a-parameter-file)

---
## Description

The Resource Modules Library Pipelines contains a Token replacement function that enables Parameter files to contain tokens (i.e. `<<subscriptionId>>`, `<<tenantId>>`) instead of using static values. This helps with the following:

- Allows the repository to be portable without having static values from where it was cloned.
- Enables dynamic updates of the tokens from single locations without having to modify all files.
- Not adding more environment variables to workflows/pipelines whenever new tokens are required for the environment.

## How it works

### Token Types

There are (2) Token types that can be applied on a Parameter File:

#### 1. Default Tokens (Environment Variables) [Default]

These are tokens constructed from Environment Variables, which are defined in the Workflow (Pipeline). Review [Getting Started - GitHub specific prerequisites](./GettingStarted.md) for more information on these Environment Variables.

#### 2. Local Custom Tokens (Source Control) [Optional]

These are tokens defined in the Git Repository inside a [Settings.json](https://github.com/Azure/ResourceModules/blob/main/settings.json) file. This allows creating tokens that are local and updatable via Source Control mechanisms. Here is an example on where these tokens are stored. You can add key-value pairs as required:

```json
"localTokens": {
    "tokens": [
        {
            "name": "tokenName",
            "value": "tokenValue"
        }
    ]
}
```

---
**Note**: Do not store sensitive information in this location as they will be present in your Git History. Follow best [practices and guidelines](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/best-practices#security-recommendations-for-parameters) on how to handle secrets in template deployments.

---

### How Tokens are replaced in a Parameter File

The below diagram illustrates the Token Replacement Functionality via the [Validate](https://github.com/Azure/ResourceModules/blob/main/.github/actions/templates/validateModuleDeploy/action.yml) and [Deploy](https://github.com/Azure/ResourceModules/blob/main/.github/actions/templates/deployModule/action.yml) Actions/Templates.

<img src="./media/paramFileTokenGetTokens.jpg" alt="paramFileTokenGet">

1- The user creates local custom Parameter File Tokens in the [Settings.json](https://github.com/Azure/ResourceModules/blob/main/settings.json) under the `localTokens` - `tokens` property.

2- The parameter files can now be tokenized as per required value. And the token format can look like `<<tokenName>>`. Example:

  ```json
  "adminPassword": {
    "reference": {
        "keyVault": {
            "id": "/subscriptions/<<subscriptionId>>/resourceGroups/platform-core-rg/providers/Microsoft.KeyVault/vaults/<<exampleLocalToken>>-keyVault"
        },
        "secretName": "<<exampleLocalToken>>"
    }
  }
  ```

3- The user runs the modules workflow/pipeline, either from their remote branch or main branch so that it triggers the regular module deployment process.

4- The tokens will be retrieved at runtime and replaced with the original values before handed over to the validation or deployment task/step.

5- The Validate/Deploy task will consume the modified parameter files with the required values in order to validate/deploy the Azure resource.
