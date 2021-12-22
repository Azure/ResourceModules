# Convert bicep files into ARM helper script

At the time of writing bicep is still in a beta phase. For this reason, some people may want to wait for bicep's _General Availability_ and prefer to use ARM Templates meanwhile.
For those scenarios, a script is supplied with the CARML library, leveraging the bicep toolkit translator/compiler, to support the conversion from CARML bicep modules to ARM Templates.
This page documents the conversion utility and how to use it.

---

### _Navigation_

- [Convert bicep files into ARM helper script](#convert-bicep-files-into-arm-helper-script)
    - [_Navigation_](#navigation)
- [Location](#location)
- [What it does](#what-it-does)
- [How to use it](#how-to-use-it)
  - [Examples](#examples)

---
# Location

`You can find the script under /utilities/tools/ConvertTo-ARMTemplate.ps1`

# What it does

The script finds all 'deploy.bicep' files and tries to convert them to json-based ARM templates
by using the following steps.
1. Remove existing deploy.json files
1. Convert bicep files to json
1. Remove bicep metadata from json
1. Remove bicep files and folders
1. Update pipeline files - Replace .bicep with .json in pipeline files
# How to use it

The script can be called with the following parameters:

| name | description |
|-|-|
| -Path | The path to the root of the repo. |
| -ConvertChildren | Convert child resource modules to bicep. |
| -SkipMetadataCleanup | Skip Cleanup of bicep metadata from json files |
| -SkipbicepCleanUp | Skip removal of bicep files and folders |
| -SkipWorkflowUpdate | Skip replacing .bicep with .json in workflow files |

## Examples

Converts top level bicep modules to json based ARM template, cleaning up all bicep files and folders and updating the workflow files to use the json files.
```powershell
. .\utilities\tools\ConvertTo-ARMTemplate.ps1
```

Only converts top level bicep modules to json based ARM template, keeping metadata in json, keeping all bicep files and folders, and not updating workflows.
```powershell
. .\utilities\tools\ConvertTo-ARMTemplate.ps1 -ConvertChildren -SkipMetadataCleanup -SkipBicepCleanUp -SkipWorkflowUpdate
```
