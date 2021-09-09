#region Helper functions

<#
.SYNOPSIS
Get a properly formatted 'Deploy to Azure' button for the template in the given path

.DESCRIPTION
Get a properly formatted 'Deploy to Azure' button for the template in the given path
NOTE: This function requires that the Repo lives inside the 'Azure' organization

.PARAMETER path
Mandatory. The path to the module to generate the url for

.PARAMETER repositoryName
Mandatory. The name of the repository the content is included in.

.EXAMPLE
Get-DeployToAzureUrl -path 'C:\Modules\MyModule' -repositoryName 'Modules'

Generate an 'Deploy to Azure' button for module 'MyModule'
#>
function Get-DeployToAzureUrl {


    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $path,

        [Parameter(Mandatory)]
        [string] $repositoryName
    )

    if(-not (Test-Path -Path "$path\deploy.json")) {
        Write-Warning "ARM Template in path [$path\deploy.json] not found. Unable to generate 'Deploy to Azure' button."
        return ''
    }

    $baseUrl = "[![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/"
    $templateUri = "https://raw.githubusercontent.com/Azure/{0}/main/{1}/deploy.json" -f $repositoryName, ($path -split "\\$repositoryName\\")[1]

    return ("{0}{1}>)" -f $baseUrl, ([System.Web.HttpUtility]::UrlEncode($templateUri)))
}

<#
.SYNOPSIS
Extract the resource name from the provided module path's readme

.DESCRIPTION
Extract the resource name from the provided module path's readme

.PARAMETER path
Mandatory. The path to the module to process

.EXAMPLE
Get-ResourceModuleName -path 'C:\KeyVault'

Get the resource name defined in the KeyVault-Module's readme. E.g. 'Key Vault'
#>
function Get-ResourceModuleName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $path
    )

    if (-not (Test-Path "$path/readme.md")) {
        Write-Warning "No [readme.md] found in folder [$path]"
        return ""
    }

    $moduleReadMeContent = Get-Content -Path "$path/readme.md"
    $moduleName = $moduleReadMeContent[0].TrimStart('# ')

    if (-not [String]::IsNullOrEmpty($moduleName)) {
        return $moduleName
    }
    else {
        return ""
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
        $outputString += " :heavy_check_mark: /"
    }
    else {
        $outputString += " /"
    }

    if ($moduleFiles.Name -contains 'deploy.bicep') {
        # bicep exists
        $outputString += " :heavy_check_mark: "
    }
    else {
        $outputString += ""
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

.PARAMETER columnsInOrder
Mandatory. The set of columns to add to the table in the order you expect them in the table.
Available are 'Name', 'Provider namespace', 'Resource Type', 'ARM / Bicep' and 'Deploy'

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
        [string] $provider,

        [Parameter(Mandatory)]
        [string[]] $columnsInOrder,

        [Parameter(Mandatory = $false)]
        [string] $repositoryName
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

            $outputString = "|"
            foreach ($column in $columnsInOrder) {
                switch ($column) {
                    'Name' {
                        $outputString += ' {0} |' -f (Get-ResourceModuleName -path $subfolder)
                    }
                    'Provider namespace' {

                        $outputString += ' |'
                    }
                    'Resource Type' {
                        $outputString += (' [{0}]({1}) |' -f $subName, $relativePath)
                    }
                    'ARM / Bicep' {
                        $outputString += "{0} |" -f (Get-TypeColumnString -path $subfolder)
                    }
                    'Deploy' {
                        if(-not $repositoryName) {
                            throw "If you want to generate a 'Deploy to Azure button' you must provide the 'repositoryName' parameter"
                        }
                        $outputString += ' {0} |' -f (Get-DeployToAzureUrl -path $subfolder -repositoryName $repositoryName)
                    }
                    Default {
                        Write-Warning "Column [$column] not existing. Available are: [ Name |Provider namespace | Resource Type | ARM / Bicep | Deploy ]"
                    }
                }
            }
            $output += $outputString
        }
    }

    return $output
}
#endregion

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

    "| Name                           | Provider namespace | Resource Type                                                                   | ARM / Bicep |"
    "| ------------------------------ | ------------------ | ------------------------------------------------------------------------------- | ----------- |"
    "| SQL Managed Instances          | `Microsoft.Sql`    | [managedInstances](Microsoft.Sql/managedInstances)                              | :heavy_check_mark: / |
    "| SQL Managed Instances Database |                    | [managedInstances\databases](Microsoft.Sql\managedInstancesResources\databases) | :heavy_check_mark: / :heavy_check_mark: |

.PARAMETER path
Mandatory. The path to resolve

.PARAMETER columnsInOrder
Optional. The set of columns to add to the table in the order you expect them in the table.
Available are 'Name', 'Provider namespace', 'Resource Type', 'ARM / Bicep' and 'Deploy'

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\Modules'

Generate a markdown table for all modules in path 'C:\dev\Modules' with all default columns

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\Modules' -columnsInOrder @('Resource Type', 'Name')

Generate a markdown table for all modules in path 'C:\dev\Modules' with only the 'Resource Type' & 'Name' columns
#>
function Get-ModulesAsMarkdownTable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $path,

        [Parameter(Mandatory = $false)]
        [string[]] $columnsInOrder = @('Name', 'Provider namespace', 'Resource Type', 'ARM / Bicep', 'Deploy'),

        [Parameter(Mandatory = $false)]
        [string] $repositoryName
    )

    $output = [System.Collections.ArrayList]@()
    $headerRow = "|"
    foreach ($column in $columnsInOrder) {
        switch ($column) {
            'Name' { $headerRow += ' Name |' }
            'Provider namespace' { $headerRow += ' Provider namespace |' }
            'Resource Type' { $headerRow += ' Resource Type |' }
            'ARM / Bicep' { $headerRow += ' ARM / Bicep |' }
            'Deploy' { $headerRow += ' Deploy |' }
            Default {
                Write-Warning "Column [$column] not existing. Available are: [ Name |Provider namespace | Resource Type | ARM / Bicep | Deploy ]"
            }
        }
    }
    $output += $headerRow

    $headerSubRow = "|"
    for ($index = 0; $index -lt $columnsInOrder.Count; $index++) {
        $headerSubRow += ' - |'
    }
    $output += $headerSubRow

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
                $output = Get-ResolvedSubServiceRow -subPath $subfolder -concatedBase $concatedBase -output $output -provider $provider -columnsInOrder $columnsInOrder -repositoryName $repositoryName
            }
            else {

                $row = '|'

                foreach ($column in $columnsInOrder) {
                    switch ($column) {
                        'Name' {
                            $row += ' {0} |' -f (Get-ResourceModuleName -path $subfolder)
                        }
                        'Provider namespace' {
                            if ($previousProvider -eq $provider) {
                                $row += " |"
                            }
                            else {
                                if ($provider -like "Microsoft.*") {
                                    # Shorten Microsoft to save some space
                                    $shortProvider = "MS.{0}" -f ($provider.TrimStart('Microsoft.'))
                                    $row += " ``$shortProvider`` |"
                                }
                                else {
                                    $row += " ``$provider`` |"
                                }
                                $previousProvider = $provider
                            }
                        }
                        'Resource Type' {
                            $row += (' [{0}]({1}) |' -f $subFolderName, $concatedBase)
                        }
                        'ARM / Bicep' {
                            $row += "{0} |" -f (Get-TypeColumnString -path $subfolder)
                        }
                        'Deploy' {
                            if(-not $repositoryName) {
                                throw "If you want to generate a 'Deploy to Azure button' you must provide the 'repositoryName' parameter"
                            }
                            $row += ' {0} |' -f (Get-DeployToAzureUrl -path $subfolder -repositoryName $repositoryName)
                        }
                        Default {
                            Write-Warning "Column [$column] not existing. Available are: [ Name |Provider namespace | Resource Type | ARM / Bicep | Deploy ]"
                        }
                    }
                }
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