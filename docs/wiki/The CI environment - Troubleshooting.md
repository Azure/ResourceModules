This section provides an outline of technical CI-specific challenges that were raised in the past and some guidance on how to resolve them.

---

### _Navigation_

- [Error reading JToken from JsonReader](#error-reading-jtoken-from-jsonreader)

---

# Error reading JToken from JsonReader

> Related error messages:
>
> - `The template is not valid. .github/workflows/ms.eventgrid.topics.yml (Line: 116, Col: 29): Error reading JToken from JsonReader. Path '', line 0, position 0.`

Potential reasons

- The `AZURE_CREDENTIALS` are not configured as a single-line string, but as a multiline JSON.

  - **Solution:** As per the [documentation](https://github.com/Azure/ResourceModules/wiki/Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#321-set-up-secrets) please ensure that the secret is created in one line. That means using

    ```json
    { "it's a me" }
    ```

    instead of

    ```json
    {
      "it's a me"
    }
    ```

  - **Background:** If configured as a multiline object, GitHub interprets each line as a dedicated secret value. This leads to a situation where characters like `{` & `}` are treated as individual secrets - and values that are passed as JSON strings between pipeline jobs that contain these characters cannot be passed anymore (as per GitHubs default behavior). For example: `{"removeDeployment": true}`. Because this value isn't passed anymore, subsequently the line `removeDeployment: '${{ (fromJson(needs.job_initialize_pipeline.outputs.workflowInput)).removeDeployment }}'` that references it throws the error message you're seeing.

# Outdated Bicep CLI version

> Related error messages:
>
> - `Error BCP018: Expected the ":" character at this location.`
> - `Error BCP022: Expected a property name at this location.`
> - `Error BCP236: Expected a new line or comma character at this location.`
> - `...` with the described reason below, there can be any amount of error messages you may encounter

Potential reasons

- The Bicep CLI version is outdated.
  - **Solution:** Update the version of Bicep you're using on your machine. This can include:
    - The Bicep extension for VS Code ([ref](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#visual-studio-and-bicep-extension))
    - The Bicep extension for the Azure CLI ([ref](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-cli))
    - The Bicep CLI ([ref](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-powershell)
  - **Background:** When using Bicep on your local device, you usually handle 2 different tools: The 'Bicep' extension for the Azure CLI (identified by commands such as `az bicep version`) and the Bicep CLI itself (identified by commands such as `bicep --version`). The later is the one responsible for compiling Bicep templates into ARM templates. The Bicep extension for Visual Studio Code usually automatically updates the Azure CLI extension. However, the same is not true for the Bicep CLI version. This you have to update yourself.
