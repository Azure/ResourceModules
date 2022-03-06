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

## 2. Fork/clone the repository into your DevOps environment

Next you'll want to create your own copy of the code. Depending on the repository environment you want to use (GitHub or Azure DevOps), the set up will be slightly different:

- GitHub Repository
  - For GitHub, you have two choices depending on your planned repository visibility:
    - If the repository may be public, we recommend to create a simple fork into the target organization. As the CARML source repository is public, a fork must be public too.
    - If you need a private version instead, we recommend you create your target repository, download/clone the CARML repository and upload the content to the created target repository
      > **Note:** This disables the feature to 'fetch' from the upstream (CARML) repository. As a result, you have to port updates manually.
- Azure DevOps Repository
    - For an Azure DevOps git, we recommend you create your target repository, download/clone the CARML repository and upload the content to the created target repository
      > **Note:** This disables the feature to 'fetch' from the upstream (CARML) repository. As a result, you have to port updates manually.

> **Note:** Whether you chose GitHub or Azure DevOps as your repository's location does not affect your options when registering the pipelines.

## 3. Configure the CI environment

</details>

<details>
<summary><b>Option 2:</b> Consume module library only</summary>
</details>

<details>
<summary><b>Option 3:</b> Contribute</summary>
</details>
