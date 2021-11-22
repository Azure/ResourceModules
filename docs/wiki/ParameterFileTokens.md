# Parameter File Tokens

This section provides details on the Tokens Replacement Functionality that enables the use of tokens inside template Parameter Files instead of plain text strings.

---

### _Navigation_

- [Description](#description)
- [How it works](#how-it-works)
  - [Token Types](#token-types)
    - [1. Default Tokens (Environment Variables) [Default]](#1-default-tokens-environment-variables-default)
    - [2. Local Custom Tokens (Source Control) [Optional]](#2-local-custom-tokens-source-control-optional)
    - [3. Remote Custom Tokens (Key Vault) [Optional]](#3-remote-custom-tokens-key-vault-optional)
  - [How the Token Key Vault is created](#how-the-token-key-vault-is-created)
  - [How Tokens are replaced in a Parameter File](#how-tokens-are-replaced-in-a-parameter-file)

---
## Description

The Resource Modules Library Pipelines contains a Token replacement function that enables Parameter files to contain tokens (i.e. `<<subscriptionId>>`, `<<tenantId>>`) instead of using static values. This helps with the following:

- Allows the repository to be portable without having static values from where it was cloned.
- Enables dynamic updates of the tokens from single locations without having to modify all files.
- Not adding more environment variables to workflows/pipelines whenever new tokens are required for the environment.

## How it works

### Token Types

There are (3) Token types that can be applied on a Parameter File:

#### 1. Default Tokens (Environment Variables) [Default]

These are tokens constructed from Environment Variables, which are defined in the Workflow (Pipeline). Review [Getting Started - GitHub specific prerequisites](./GettingStarted.md) for more information on these Environment Variables.

#### 2. Local Custom Tokens (Source Control) [Optional]

These are tokens defined in the Git Repository inside a [Settings.json](https://github.com/Azure/ResourceModules/blob/main/settings.json) file. This allows creating tokens that are local and updatable via Source Control mechanisms. Here is an example on where these tokens are stored. You can add key-value pairs as required:

```json
"localTokens": {
    "tokens": [
        {
            "name": "namePrefix",
            "value": "carml"
        }
    ]
}
```

---
**Note**: Do not store sensitive information in this location as they will be present in your Git History. Follow best [practices and guidelines](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/best-practices#security-recommendations-for-parameters) on how to handle secrets in template deployments.

---

#### 3. Remote Custom Tokens (Key Vault) [Optional]

These are tokens that are stored in Azure Key Vault as Secrets. This allows creating tokens that are not considered to be sensitive information, but are specific to the environment (i.e. Principal IDs for Security Principals, Tenant ID).

The Key Vault here is enabled by adding a Secret to GitHub called `PLATFORM_KEYVAULT` and providing a name of a Key Vault that is unique and hasn't been used in Azure before. This can be done by attempting to deploy a Key Vault via the Azure Portal and seeing if the name is unique, or by using the [Check Name Availability API](https://docs.microsoft.com/en-us/rest/api/keyvault/vaults/check-name-availability).

---
**Note**: The use of this Key Vault is optional, and is only deployed, and checked for tokens if the `PLATFORM_KEYVAULT` is not empty.

**Note**: If you have remote token that you consider it to be sensitive (i.e. password), make sure you only use these tokens in a parameter that is of type `secureString`, and not `string`, as the tokens will be replaced at runtime and will be available in the deployment history if the Parameter type is not `secureString`. Follow best [practices and guidelines](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/best-practices#security-recommendations-for-parameters) on how to handle secrets in template deployments.

---

> The Tokens are created as secrets in the Key Vault with the content type defined in the [Settings.json](https://github.com/Azure/ResourceModules/blob/main/settings.json) file, under the property `keyVaultSecretContentType`.

### How the Token Key Vault is created

 ---
**Note**: The use of this Key Vault is optional, and is only deployed, and checked for tokens if the `PLATFORM_KEYVAULT` is not empty.

---

<img src="./media/paramFileTokenSetKeyVault.jpg" alt="paramFileTokenSetKeyVault">

1- The user can create the secret called `PLATFORM_KEYVAULT`. This must be a unique Key Vault name across Azure.

2- The user then triggers the [Dependency Workflow](https://github.com/Azure/ResourceModules/blob/main/.github/workflows/platform.dependencies.yml) to instantiate the Platform Token Key Vault.

  > To customize the Key Vault Configuration, you can modify the [Platform Key Vault Parameter File](https://github.com/Azure/ResourceModules/blob/main/utilities/pipelines/dependencies/Microsoft.KeyVault/vaults/parameters/platform.parameters.json).

3- The Platform Key Vault is then deployed using the Key Vault Module via the dependency pipeline.

> This Key Vault uses [Azure AD RBAC](https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli) for the permissions instead of [access policies](https://docs.microsoft.com/en-us/azure/key-vault/general/assign-access-policy?tabs=azure-portal). It will automatically provide the Deployment Service Principal with the [Key Vault Administrator](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-administrator) role so that it can read and set secrets. </br>

  > You need to have permissions to read and create secrets in the provisioned Key Vault so that you can upload custom tokens. The [Key Vault Secrets Officer](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-secrets-officer) role is an example that allows you to perform data plane operations on the Key Vault.

### How Tokens are replaced in a Parameter File

 ---
**Note**: This step is always enabled even if you do not use Local/Remote Custom Parameter File Tokens. Default Tokens are always required and are alerted upon by Pester if they do not exist in the parameter file.

---

The below diagram illustrates the Token Replacement Functionality via the [Validate](https://github.com/Azure/ResourceModules/blob/main/.github/actions/templates/validateModuleDeploy/action.yml) and [Deploy](https://github.com/Azure/ResourceModules/blob/main/.github/actions/templates/deployModule/action.yml) Actions/Templates.

<img src="./media/paramFileTokenGetTokens.jpg" alt="paramFileTokenGetKeyVault">

1- The user creates local custom Parameter File Tokens in the [Settings.json](https://github.com/Azure/ResourceModules/blob/main/settings.json) under the `localTokens` - `tokens` property.

2- The user can also create remote custom Parameter File Tokens in the Key Vault

  The below script is an example on how to create a remote token in a key vault:

  ```powershell
  # **** SET PATH TO RESOURCE MODULES REPO ****
  ## Inputs:
  $KeyVaultName = 'contoso-keyVault' # Same Key Vault defined in the 'PLATFORM_KEYVAULT' GitHub Secret or ADO Pipeline Variables
  $SubscriptionId = '12345678-1234-1234-1234-123456789012'
  ## Provide Tokens
  $remoteTokens = @(
      @{ Name = 'myTokenName'; Value = 'myTokenValue' } # Specify Token Name and Value, you can add multiple.
  )
  ## Add tokens to Key Vault
  try {
      $KeyVaultSecretContentType = (Get-Content ./settings.jxson -ErrorAction Stop | ConvertFrom-Json).parameterFileTokens.remoteTokens.keyVaultSecretContentType
      Add-AzAccount -SubscriptionId $SubscriptionId
      $TokensKeyVault = Get-AzKeyVault -VaultName $KeyVaultName
      $remoteTokens | ForEach-Object {
          Set-AzKeyVaultSecret -Name $PSItem.Name -SecretValue (ConvertTo-SecureString -AsPlainText $PSItem.Value) -VaultName $TokensKeyVault.VaultName -ContentType $KeyVaultSecretContentType
      }
  } catch {
      $PSItem.Exception.Message
  }
  ```

3- The parameter files can now be tokenized as per required value. And the token format can look like `<<tokenName>>`. Example:

  ```json
  "adminPassword": {
    "reference": {
        "keyVault": {
            "id": "/subscriptions/<<subscriptionId>>/resourceGroups/platform-core-rg/providers/Microsoft.KeyVault/vaults/<<platformKeyVault>>" // Default Tokens
        },
        "secretName": "<<adminPasswordToken>>" // Custom Token
    }
  }
  ```

4- The user runs the modules workflow/pipeline, either from their remote branch or main branch so that it triggers the regular module deployment process.

5- The tokens will be retrieved at runtime and replaced with the original values before handed over to the validation or deployment task/step.

---
**Note**: The pipeline will not fail if you are not using a Key Vault for your custom tokens but it will fail if you are using tokens that are from a key vault and those values are not available to be replaced.

---

6- The Validate/Deploy task will consume the modified parameter files with the required values in order to validate/deploy the Azure resource.
