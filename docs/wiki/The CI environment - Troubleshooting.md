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
