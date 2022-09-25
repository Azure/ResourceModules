# REST to CARML

This module provides you with the ability to generate most of a CARML module's code by providing it with the desired Provider-Namespace / Resource-Type combination.

> **_NOTE:_** This module will not generate all the code required for a CARML module, but only a large portion of it. As the Azure API is not 100% consistent, generated modules may still require manual refactoring (e.g. by introducing variables) or may contain errors. Further, while the expected test files & folders are generated, they are not populated with content as the utility would otherwise need to know how to all required dependencies too.

### _Navigation_

- [Usage](#usage)
- [In-scope](#in-scope)
- [Out-of-scope](#out-of-scope)

---


## Usage
- Import the module using the command `Import-Module './utilities/tools/REST2CARML/REST2CARML.psm1' -Force -Verbose`
- Invoke its primary function using the command `Invoke-REST2CARML -ProviderNamespace '<ProviderNamespace>' -ResourceType '<ResourceType>' -Verbose -KeepArtifacts`
- For repeated runs it is recommended to append the `-KeepArtifacts` parameter as the function will otherwise repeatably download & eventually delete the required documentation

# In scope

- Module itself with parameters, resource & outputs
- Azure DevOps pipeline & GitHub workflow
- Extension code such as
  - Diagnostic Settings
  - RBAC
  - Locks
  - Private Endpoints

# Out of scope

- Child-Modules: Generate not only the module's code, but also that of it's children and reference them in their parent (**_can be implemented later_**).
- Idempotency: Run the module on existing code without overwriting any un-related content (**_can be implemented later_**).
