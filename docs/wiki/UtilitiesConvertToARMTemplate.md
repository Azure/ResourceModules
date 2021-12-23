# Bicep to ARM conversion script

At the time of writing bicep is still in a beta phase. For this reason, some people may want to wait for bicep's _General Availability_ and prefer to use ARM Templates for the time being.
For these scenarios, the CARML library provides a script that uses the Bicep Toolkit translator/compiler to support the conversion of CARML Bicep modules to ARM templates.
This page documents the conversion utility and how to use it.

---

### _Navigation_

- [Location](#location)
- [How it works](#what-it-does)
- [How to use it](#how-to-use-it)
  - [Examples](#examples)

---
# Location

You can find the script under `/utilities/tools/ConvertTo-ARMTemplate.ps1`

# How it works

The script finds all 'deploy.bicep' files and tries to convert them to json-based ARM templates
by using the following steps.
1. Remove existing deploy.json files
1. Convert bicep files to json
1. Remove bicep metadata from json
1. Remove bicep files and folders
1. Update pipeline files - Replace .bicep with .json in pipeline files

# How to use it

## Example 1: Convert top level bicep modules to json based ARM template, cleaning up all bicep files and folders and updating the workflow files to use the json files

```powershell
. './utilities/tools/ConvertTo-ARMTemplate.ps1'
```

## Example 2: Only convert top level bicep modules to json based ARM template, keeping metadata in json, keeping all bicep files and folders, and not updating workflows

```powershell
. './utilities/tools/ConvertTo-ARMTemplate.ps1' -ConvertChildren -SkipMetadataCleanup -SkipBicepCleanUp -SkipWorkflowUpdate
```
