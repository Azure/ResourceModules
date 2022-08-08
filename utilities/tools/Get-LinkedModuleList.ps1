<#
.SYNOPSIS
Get a list of all resource/module references in a given module path

.DESCRIPTION
As an output you will receive a hashtable that (for each provider namespace) lists the
- Directly deployed resources (e.g. via "resource myDeployment 'Microsoft.(..)/(..)@(..)'")
- Linked local module templates (e.g. via "module myDeployment '../../deploy.bicep'")
- Linked remote module tempaltes (e.g. via "module rg 'br/modules:(..):(..)'")

.PARAMETER path
Optional. The path to search in. Defaults to the 'modules' folder

.EXAMPLE
Get-LinkedModuleList

Invoke the function with the default path. Returns an object such as:
{
    "Microsoft.Compute/availabilitySets": {
        "localPathReferences": ".bicep/nested_roleAssignments.bicep",
        "remoteReferences": null,
        "resourceReferences": [
            "Microsoft.Resources/deployments@2021-04-01",
            "Microsoft.Compute/availabilitySets@2021-07-01",
            "Microsoft.Authorization/locks@2017-04-01",
            "Microsoft.Compute/availabilitySets@2021-04-01",
            "Microsoft.Authorization/roleAssignments@2022-04-01"
        ]
    },
    (...)
}

.EXAMPLE
Get-LinkedModuleList -path './Microsoft.Sql'

Get only the references of the modules in folder path './Microsoft.Sql'
#>
function Get-LinkedModuleList {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $path = (Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'modules')
    )

    $resultSet = @{}

    # Get all top-level module folders (i.e. one level below 'Microsoft.*')
    $topLevelFolderPaths = (Get-ChildItem -Path $path -Recurse -Depth 1 -Directory).FullName
    $topLevelFolderPaths = $topLevelFolderPaths | Where-Object { $_ -like '*Microsoft.*' -and (Split-Path $_ -Leaf) -notlike 'Microsoft.*' }

    foreach ($topLevelFolderPath in $topLevelFolderPaths) {

        $moduleTemplatePaths = (Get-ChildItem -Path $topLevelFolderPath -Recurse -Depth 1 -Filter '*.bicep' -File).FullName

        $resourceReferences = [System.Collections.ArrayList]@()
        $localPathReferences = [System.Collections.ArrayList]@()
        $remoteReferences = [System.Collections.ArrayList]@()

        foreach ($templatePath in $moduleTemplatePaths) {
            $content = Get-Content -Path $templatePath

            $resourceReferences += $content | Where-Object { $_ -match "^resource .+ '(.+)' .+$" } | ForEach-Object { $matches[1] }
            $localPathReferences += $content | Where-Object { $_ -match "^module .+ '(.+.bicep)' .+$" } | ForEach-Object { $matches[1] }
            $remoteReferences += $content | Where-Object { $_ -match "^module .+ '(.+:.+)' .+$" } | ForEach-Object { $matches[1] }
        }

        $providerNamespace = Split-Path (Split-Path $topLevelFolderPath -Parent) -Leaf
        $resourceType = Split-Path $topLevelFolderPath -Leaf

        $resultSet["$providerNamespace/$resourceType"] = @{
            resourceReferences  = $resourceReferences | Select-Object -Unique
            localPathReferences = $localPathReferences | Select-Object -Unique
            remoteReferences    = $remoteReferences | Select-Object -Unique
        }
    }

    return $resultSet
}
