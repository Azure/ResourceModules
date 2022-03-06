This section will give on an overview on how to get started using this repository.

---

### _Navigation_
[Scenarios](#scenarios)

---

# Scenarios

<details>
<summary><b>Option 1:</b> Onboard module library and CI environment</summary>

The repository is built so that you can create your own private 1:1 clone and be able to reuse the same concepts and features in your own environment such as GitHub.

This requires three main steps:

1. Configure your Azure environment
1. Fork/clone the repository into your DevOps environment (GitHub or Azure DevOps)
1. Configure the CI environment

Depending on the DevOps environment you choose (GitHub or Azure DevOps) make sure you also account for the specific requirements outlined below.

## 1. Configure your Azure environment

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

## 1. Fork/clone the repository into your DevOps environment

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

<details>
<summary><b>How to:</b> Clone/download the repository</summary>
To save a local copy of the repository you can either clone the repository or download it as a `.zip` file.
A clone is a direct reference the the source repository which enables you to pull updates as they happen in the source repository. To achieve this you have to have `Git` installed and run the command

```PowerShell
  git clone 'https://github.com/Azure/ResourceModules.git'`
```

from the command-line of your choice.

If you instead just want to have a copy of the repository's content you can instead download it in the `.zip` format. You can do this by navigating to the repository folder of your choice (for example root), then select the `<> Code` button on the top left and click on `Download ZIP` on the opening blade.

 <img src="./media/cloneDownloadRepo.JPG" alt="How to download repository" height="266">

</details>

## 1. Configure the CI environment

While the concepts are the same, the configuration of the CI environment differs drastically depending on the DevOps environment in which you want to register and run your pipelines.


<details>
<summary>GitHub</summary>
</details>

<details>
<summary>Azure DevOps</summary>
</details>

</details>

<p>

<details>
<summary><b>Option 2:</b> Consume module library only</summary>
</details>

<p>

<details>
<summary><b>Option 3:</b> Contribute</summary>
</details>
