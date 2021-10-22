This section gives you an overview of how to test the bicep modules.

---
### _Navigation_
- [Tool: Testing your Bicep module](#Tool-Testing-your-Bicep-module)
---

# Tool: Testing your Bicep module

When you have done your changes and want to validate, run the following:

```pwsh
Invoke-Pester -Configuration @{
    Run        = @{
        Container = New-PesterContainer -Path 'arm/.global/global.module.tests.ps1' -Data @{
            moduleFolderPaths = "C:\dev\ip\Azure-ResourceModules\ResourceModules\arm\Microsoft.EventGrid/topics"
        }
    }
    Filter     = @{
        #ExcludeTag = 'ApiCheck'
        #Tag = 'ApiCheck'
    }
    TestResult = @{
        TestSuiteName = 'Global Module Tests'
        Enabled       = $false
    }
    Output     = @{
        Verbosity = 'Detailed'
    }
}
```
