function Get-ResourceModuleName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $path
    )

    if(-not (Test-Path "$path/readme.md")) {
        Write-Warning "No [readme.md] found in folder [$path]"
        return " |"
    }

    $moduleReadMeContent = Get-Content -Path "$path/readme.md"
    $moduleName = $moduleReadMeContent[0].TrimStart('# ')

    if(-not [String]::IsNullOrEmpty($moduleName)) {
        return " $moduleName |"
    } else {
        return " |"
    }
}

<#
.SYNOPSIS
Get a string that indicates whether there are ARM/Bicep templates available in the given path

.DESCRIPTION
Get a string that indicates whether there are ARM/Bicep templates available in the given path.
The string represents markdown table columns.
Files must follow the naming schema 'deploy.json' & 'deploy.bicep'

.PARAMETER path
Mandatory. The path to check for templates

.EXAMPLE
Get-TypeColumnString -path 'C:\MyModule'

May return a string like ':heavy_check_mark: | :heavy_check_mark: |' if both ARM & bicep templates are available in the given module path
#>
function Get-TypeColumnString {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $path
    )

    $moduleFiles = Get-ChildItem -Path $path -File

    $outputString = ""

    if ($moduleFiles.Name -contains 'deploy.json') {
        # ARM exists
        $outputString += " :heavy_check_mark: |"
    }
    else {
        $outputString += " |"
    }

    if ($moduleFiles.Name -contains 'deploy.bicep') {
        # bicep exists
        $outputString += " :heavy_check_mark: |"
    }
    else {
        $outputString += " |"
    }

    return $outputString
}


<#
.SYNOPSIS
Get the number of nested module levels

.DESCRIPTION
Get the number of nested module levels. If the return value is greater than 0, the provided folder path contains at least one module in a lower level
A module is identified by folders that do not contain module-specific folders such as 'parameters'.
In other words, a module would contain a folder with e.g. a 'parameters' folder and would hence not count towards the hierarchy of parent folders.

.PARAMETER path
Mandatory. The path to search in.

.EXAMPLE
> (Get-RelevantDepth -path 'C:\dev\ApiManagement') -gt 0

Check if the path 'C:\dev\ApiManagement' contains any number of nested modules
#>
function Get-RelevantDepth {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $path
    )

    # Get only folders that contain no files (aka are parent folders)
    if (-not ($relevantSubfolders = (Get-Childitem $path -Directory -Recurse -Exclude @('.bicep', 'parameters')).fullName)) {
        return 0
    }
    $sanitizedPaths = $relevantSubfolders | ForEach-Object { $_.Replace($path, '') }

    $depths = $sanitizedPaths | ForEach-Object { ($_.Split('\') | Measure-Object).Count - 1 }

    return ($depths | Measure-Object -Maximum).Maximum
}

<#
.SYNOPSIS
Populate the given row with sub-modules in the given path

.DESCRIPTION
Populate the given row with sub-modules in the given path. Resources are concanted as a path.

.PARAMETER subPath
Mandatory. The path to process with respect to its contained modules

.PARAMETER concatedBase
Mandatory. The relative folder path from root down to the current level.

.PARAMETER row
Mandatory. The table row to populate/concat with additional modules

.PARAMETER provider
Mandatory. The current provider for this path

.EXAMPLE
> Get-ResolvedSubServiceRow -subPath 'C:\dev\Microsoft.ApiManagement\serviceResources' -concatedBase "Microsoft.ApiManagement\serviceResources" -row "| `Microsoft.ApiManagement` | <p>[service](Microsoft.ApiManagement\service)" -provider "Microsoft.ApiManagement"

Populate row "| `Microsoft.ApiManagement` | <p>[service](Microsoft.ApiManagement\service)" with additional modules found in path 'C:\dev\Microsoft.ApiManagement\serviceResources'
#>
function Get-ResolvedSubServiceRow {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $subPath,

        [Parameter(Mandatory)]
        [string] $concatedBase,

        [Parameter(Mandatory)]
        [string[]] $output,

        [Parameter(Mandatory)]
        [string] $provider
    )

    $subFolders = Get-ChildItem -Path $subPath -Directory -Recurse -Exclude @('.bicep', 'parameters')

    foreach ($subfolder in $subFolders.FullName) {
        $subFolderName = (Split-Path $subfolder -Leaf)

        if ((Get-RelevantDepth -path $subfolder) -gt 0) {
            $concatedBase = Join-Path $concatedBase $subFolderName
            $output += Get-ResolvedSubServiceRow -subPath $subfolder -concatedBase $concatedBase -output $output -provider $provider
        }
        else {
            $relativePath = Join-Path $concatedBase $subFolderName
            $subName = $relativePath.Replace("$provider\", '').Replace('Resources\', '\')

            $outputString = '| |'

            # Name column
            $outputString += Get-ResourceModuleName -path $subfolder

            $outputString += ' [{0}]({1}) |' -f $subName, $relativePath

            $outputString += Get-TypeColumnString -path $subfolder

            $output += $outputString
        }
    }

    return $output
}

<#
.SYNOPSIS
Generate a markdown table for all modules in the given path.

.DESCRIPTION
Generate a markdown table for all modules in the given path. Returns an array with one row for each service provider.
Folders should follow the structure:

Microsoft.Sql
├─ server [module]
└─ serverResources
    └─ databases [module]

Where sub-resources are part of a subfolder [<parentResource>Resources]

Results in a table like

    "| Resource provider namespace | Resource Name                  | Azure service | ARM | Bicep |"
    "| --------------------------- | ------------------------------ | ------------- | --- | ----- |"
    "| `Microsoft.Sql`             | SQL Managed Instances          | [managedInstances](Microsoft.Sql/managedInstances) | :heavy_check_mark: | |
    "|                             | SQL Managed Instances Database | [managedInstances\databases](Microsoft.Sql\managedInstancesResources\databases) | :heavy_check_mark: | |

.PARAMETER path
Mandatory. The path to resolve

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\Modules'

Generate a markdown table for all modules in path 'C:\dev\Modules'
#>
function Get-ModulesAsMarkdownTable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $path
    )

    $output = [System.Collections.ArrayList]@(
        "| Resource provider namespace | Resource Name | Azure service | ARM | Bicep |",
        "| --------------------------- | ------------- | ------------- | --- | ----- |"
    )

    if ($topLevelFolders = Get-ChildItem -Path $path -Depth 1 -Filter "Microsoft.*") {
        $topLevelFolders = $topLevelFolders.FullName | Sort-Object
    }
    else {
        return $output
    }

    $previousProvider = ''
    foreach ($topLevelFolder in $topLevelFolders) {
        $provider = Split-Path $topLevelFolder -Leaf

        $subFolders = Get-ChildItem -Path $topLevelFolder -Directory -Recurse -Exclude @('.bicep', 'parameters') -Depth 0

        foreach ($subfolder in $subFolders.FullName) {
            $subFolderName = (Split-Path $subfolder -Leaf)
            $concatedBase = $subfolder.Replace((Split-Path $topLevelFolder -Parent), '').Substring(1)

            if ((Get-RelevantDepth -path $subfolder) -gt 0) {
                $output = Get-ResolvedSubServiceRow -subPath $subfolder -concatedBase $concatedBase -output $output -provider $provider
            }
            else {
                # Provider columns
                if ($previousProvider -eq $provider) {
                    $row = "| | "
                }
                else {
                    $row = "| ``$provider`` | "
                    $previousProvider = $provider
                }

                # Name column
                $row += Get-ResourceModuleName -path $subfolder

                # Path column
                $row += ('[{0}]({1}) |' -f $subFolderName, $concatedBase)

                # Type columns
                $row += Get-TypeColumnString -path $subfolder

                $output += $row.Replace('\', '/')
            }
        }
    }

    # Flip slashes
    for ($rowIndex = 0; $rowIndex -lt $output.Count; $rowIndex++) {
        $output[$rowIndex] = $output[$rowIndex].Replace('\', '/')
    }

    return $output
}