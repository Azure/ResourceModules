The repository is built so that you can create your own private 1:1 clone and be able to reuse the same concepts and features in your own environment such as GitHub.

This requires several steps:

1. [Configure your Azure environment](#1-configure-your-azure-environment)
1. [Fork/clone the repository into your DevOps environment](#2-forkclone-the-repository-into-your-devops-environment)
1. [Configure the CI environment](#3-configure-the-ci-environment)
1. [Deploy dependencies](#4-deploy-dependencies)
1. [Update module parameter files](#5-update-module-parameter-files)

Depending on the DevOps environment you choose (GitHub or Azure DevOps) make sure you also account for the specific requirements outlined below.

# 1. Configure your Azure environment

CARML tests the deployments and stores the module artifacts in an Azure subscription. To do so, it requires a service principal with access to it.

In this first step make sure you
- Have/create an Azure Active Directory Service Principal with at least `Contributor` & `User Access Administrator` permissions on the Management-Group/Subscription you want to test the modules in
- Note down the following pieces of information
  - Application (Client) ID
  - Service Principal Object ID (**not** the object ID of the application)
  - Service Principal Secret (password)
  - Tenant ID
  - Subscription ID
  - Parent Management Group ID

# 2. Fork/clone the repository into your DevOps environment

Next you'll want to create your own copy of the code. Depending on the repository environment you want to use (GitHub or Azure DevOps), the set up will be slightly different.

> **Note:** Whether you chose GitHub or Azure DevOps as your repository's location does not affect your options when registering the pipelines.

<details>
<summary>GitHub Repository</summary>

For GitHub, you have two choices depending on your planned repository visibility:
- If the repository may be **public**, we recommend to create a simple fork into the target organization. As the CARML source repository is public, a fork must be public too.
- If you need a **private** version instead, we recommend you create your target repository, download/clone the CARML repository (ref. 'how to' below) and upload the content to the created target repository
  > **Note:** This disables the feature to 'fetch' from the upstream (CARML) repository. As a result, you have to port updates manually.

</details>

<details>
<summary>Azure DevOps Repository</summary>

For a **private** Azure DevOps git, we recommend you create your target repository, download/clone the CARML repository (ref. 'how to' below) and upload the content to the created target repository
> **Note:** This disables the feature to 'fetch' from the upstream (CARML) repository. As a result, you have to port updates manually.

</details>

<p><p>

<details>
<summary><b>How to:</b> Clone/download the repository</summary>
To save a local copy of the repository you can either clone the repository or download it as a `.zip` file.
A clone is a direct reference the the source repository which enables you to pull updates as they happen in the source repository. To achieve this you have to have `Git` installed and run the command

```PowerShell
  git clone 'https://github.com/Azure/ResourceModules.git'
```

from the command-line of your choice.

If you instead just want to have a copy of the repository's content you can instead download it in the `.zip` format. You can do this by navigating to the repository folder of your choice (for example root), then select the `<> Code` button on the top left and click on `Download ZIP` on the opening blade.

 <img src="./media/cloneDownloadRepo.JPG" alt="How to download repository" height="266">

</details>

<p>

# 3. Configure the CI environment

To configure the CI environment you have to perform several tasks:
- [3.1 Update default `namePrefix`](#31-update-default-nameprefix)
- [3.2 Setup CI-environment-specific configuration](#32-setup-ci-environment-specific-configuration)

> **Note:** While you can use the browser, we recommend that you clone all files from your local machine and update them using, for example, Visual Studio Code.

## 3.1 Update default `namePrefix`

To lower the barrier to entry and allow users to easily define their own naming conventions, we introduced a default `'name prefix'` for all deployed resources.

Each pipeline in CARML that deploys resources uses a logic that automatically replaces "tokens" (i.e. placeholders) in any parameter file. Tokens are stored in only a few central locations to facilitate maintenance.

To update the `namePrefix`, perform the following steps:

1. Open the `settings.json` file in the repository root directory.

1. Replace the `"value": "<...>"` of token `namePrefix` with a different value:

    ```json
    {
        "name": "namePrefix",
        "value": "<...>"
    }
    ```
    > **Note:** The value should be a 3-5 character long string like `cntso`. Longer strings are not recommended as they may conflict with Azure resource name length restrictions.

    <!-- TODO: Handle
    > **Note:** You may also introduce additional tokens later if need be. For further guidelines please refer to the [./] section.
    -->

## 3.2 Setup CI-environment-specific configuration

While the concepts are the same, the configuration of the CI environment can differ drastically depending on the DevOps environment in which you want to register and run your pipelines. Following you can find instructions on how to perform the remaining configuration in the corresponding DevOps environment:

<details>
<summary>GitHub</summary>

### 3.2.1 Setup secrets
### 3.2.2 Setup variables (esp. ACR)
### 3.2.3 Enable actions

</details>

<details>
<summary>Azure DevOps</summary>

### 3.2.1 Setup service connection
### 3.2.2 Setup secrets
### 3.2.3 Setup variables (esp. ACR)
### 3.2.4 Register pipelines

</details>

<p>

# 4. Deploy dependencies


# 5. Update module parameter files

- TODO: e.g. VM key

</details>


<!-- TODO: Reference interoperability (ConvertTo-ARM) for scenario 1 & 2 -->
<!-- TODO: Explains publishing (variables) that must be specified -->
