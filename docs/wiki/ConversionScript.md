# Convert Bicep files into ARM helper script

As Bicep is still in a beta phase and many people are used to ARM, it may make sense, to wait for Bicep's _General Availability_. In that case, the bicep module files need to be converted to ARM files. A translator/compiler to do that is part of the Bicep toolkit. To run the tool on all bicep files and do some cleanup, a conversion script is supplied with the CARML library. This page is about this script and how to use it.

---

### _Navigation_

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
1. Remove Bicep metadata from json
1. Remove bicep files and folders
1. Update workflow files - Replace .bicep with .json in workflow files
# How to use it

The script can be called with the following parameters:

| name | description |
|-|-|
| -Path | The path to the root of the repo. |
| -ConvertChildren | Convert child resource modules to bicep. |
| -SkipMetadataCleanup | Skip Cleanup of Bicep metadata from json files |
| -SkipBicepCleanUp | Skip removal of bicep files and folders |
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
