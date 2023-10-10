#region Helper functions
<#
.SYNOPSIS
Get a properly formatted 'Deploy to Azure' button for the template in the given path

.DESCRIPTION
Get a properly formatted 'Deploy to Azure' button for the template in the given path
NOTE: This function requires that the Repository lives inside the 'Azure' Organization

.PARAMETER path
Mandatory. The path to the module to generate the url for

.PARAMETER RepositoryName
Mandatory. The name of the repository the content is included in.

.PARAMETER Organization
Mandatory. The name of the Organization the code resides in

.EXAMPLE
Get-DeployToAzureUrl -path 'C:\Modules\MyModule' -RepositoryName 'Modules' -Organization 'Azure'

Generate an 'Deploy to Azure' button for module 'MyModule'
#>
function Get-DeployToAzureUrl {


    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $RepositoryName,

        [Parameter(Mandatory)]
        [string] $Organization
    )

    if (-not (Test-Path -Path "$Path\main.json")) {
        Write-Warning "ARM Template in path [$Path\main.json] not found. Unable to generate 'Deploy to Azure' button."
        return ''
    }

    $path = $Path -replace '\\', '/'
    $baseUrl = '[![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/'
    # Splitting by [/$RepositoryName/modules/] as the repository on the agent is checked out with a path such as [/home/runner/work/ResourceModules/ResourceModules/modules]. Splitting by only the repository name would yield wrong results.
    $templateUri = 'https://raw.githubusercontent.com/{0}/{1}/main/modules/{2}/main.json' -f $Organization, $RepositoryName, ($Path -split "\/$RepositoryName\/modules\/")[1]

    return ('{0}{1}>)' -f $baseUrl, ([System.Web.HttpUtility]::UrlEncode($templateUri)))
}

<#
.SYNOPSIS
Extract the resource name from the provided module path's readme

.DESCRIPTION
Extract the resource name from the provided module path's readme

.PARAMETER path
Mandatory. The path to the module to process

.EXAMPLE
Get-ResourceModuleName -path 'C:\key-vault\vault'

Get the resource name defined in the 'key-vault\vault'-module's readme. E.g. 'Key Vault'
#>
function Get-ResourceModuleName {

    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    if (-not (Test-Path "$Path/README.md")) {
        Write-Warning "No [README.md] found in folder [$Path]"
        return ''
    }

    $moduleReadMeContent = Get-Content -Path "$Path/README.md"
    $moduleName = $moduleReadMeContent[0].TrimStart('# ').Split('`')[0].Trim()

    if (-not [String]::IsNullOrEmpty($moduleName)) {
        return $moduleName
    } else {
        return ''
    }
}

<#
.SYNOPSIS
Get a string that indicates whether there are ARM/Bicep templates available in the given path

.DESCRIPTION
Get a string that indicates whether there are ARM/Bicep templates available in the given path.
The string represents markdown table columns.
Files must follow the naming schema 'main.json' & 'main.bicep'

.PARAMETER path
Mandatory. The path to check for templates

.EXAMPLE
Get-TypeColumnString -path 'C:\MyModule'

May return a string like ':heavy_check_mark: | :heavy_check_mark: |' if both ARM & bicep templates are available in the given module path
#>
function Get-TypeColumnString {

    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    $moduleFiles = Get-ChildItem -Path $Path -File -Force

    $outputString = ''

    # if ($moduleFiles.Name -contains 'main.json') {
    #     # ARM exists
    #     $outputString += ":heavy_check_mark:/"
    # }
    # else {
    #     $outputString += " /"
    # }

    if ($moduleFiles.Name -contains 'main.bicep') {
        # bicep exists
        $outputString += ':heavy_check_mark:'
    } else {
        $outputString += ''
    }

    return $outputString
}

<#
.SYNOPSIS
Check for the existens of any nested module levels

.DESCRIPTION
Check for the existens of any nested module levels.
A module is identified by folders that do not contain module-specific folders such as '.test'.
In other words, a module would contain a folder with e.g. a '.test' folder and would hence not count towards the hierarchy of parent folders.

.PARAMETER path
Mandatory. The path to search in.

.EXAMPLE
Measure-FolderHasNestedModule -path 'C:\dev\api-management'

Check if the path 'C:\dev\api-management' contains any number of nested modules
#>
function Measure-FolderHasNestedModule {

    [CmdletBinding()]
    [OutputType('System.Boolean')]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    # Get all folder paths that exist in the given path as long as they are not '.bicep' or '.test' folders
    # This works as long as the folder structure is consistent (e.g. no empty folders are created etc.)
    $rawFoundFolders = Get-ChildItem $Path -Directory -Recurse -Exclude @('.bicep', '.test') -Force
    $foundFolders = $rawFoundFolders | Where-Object { (Get-ChildItem $_.FullName -Directory -Depth 0 -Include '.test' -Force).count -gt 0 }
    if ($foundFolders) {
        return $true
    } else {
        return $false
    }
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

.PARAMETER output
Mandatory. List to populate/concat with additional modules

.PARAMETER provider
Mandatory. The current provider for this path

.PARAMETER ColumnsInOrder
Mandatory. The set of columns to add to the table in the order you expect them in the table.
Available are 'Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy' & 'Status'

.PARAMETER SortByColumn
Mandatory. The column to sort the table by.
Can be either 'Name' or 'ProviderNamespace'

.PARAMETER RepositoryName
Mandatory. The name of the repository the code resides in

.PARAMETER Organization
Mandatory. The name of the Organization the code resides in

.EXAMPLE
Get-ResolvedSubServiceRow -subPath 'C:\dev\api-management\api' -concatedBase "api-management\api" -output @() -provider 'api-management' -ColumnsInOrder @('Name','ProviderNamespace') -SortByColumn 'Name'

Adds a hashtable like  @{ Name = 'API Management'; 'Provider Namespace' = `api-management` }. As the specified column for sorting is 'Name', the 'Provider Namespace' will be added to each entry.
#>
function Get-ResolvedSubServiceRow {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $subPath,

        [Parameter(Mandatory)]
        [string] $concatedBase,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.ArrayList] $output,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string] $provider,

        [Parameter(Mandatory)]
        [ValidateSet('Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy', 'Status')]
        [string[]] $ColumnsInOrder,

        [Parameter(Mandatory)]
        [ValidateSet('Name', 'ProviderNamespace')]
        [string] $SortByColumn,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $true)]
        [string] $Organization,

        [Parameter(Mandatory = $false)]
        [ValidateSet('GitHub', 'ADO')]
        [string] $Environment,

        [Parameter(Mandatory = $false)]
        [string] $ProjectName = ''
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'Get-PipelineStatusUrl.ps1')

    $rawSubFolders = Get-ChildItem -Path $subPath -Directory -Recurse -Exclude @('.bicep', '.test') -Force
    # Only consider those folders that have their own parameters, i.e. are top-level modules and not child-resource modules
    $subFolders = $rawSubFolders | Where-Object { (Get-ChildItem $_.FullName -Directory -Depth 0 -Include '.test' -Force).count -gt 0 }

    foreach ($subfolder in $subFolders.FullName) {

        $subFolderName = (Split-Path $subfolder -Leaf)

        $relativePath = Join-Path $concatedBase $subFolderName
        $subName = $relativePath.Replace('\', '/').Replace("$provider/", '').Replace('Resources/', '/')

        $row = @{}
        foreach ($column in $ColumnsInOrder) {
            switch ($column) {
                'Name' {
                    switch ($Environment) {
                        'ADO' {
                            $row['Name'] = ('[{0}](https://dev.azure.com/{1}/{2}/_git/{3}?path=/modules/{4})' -f (Get-ResourceModuleName -path $subfolder), $Organization, $ProjectName, $RepositoryName, $relativePath.Replace('\', '/'))
                        }
                        'GitHub' {
                            $row['Name'] = ('[{0}](https://github.com/{1}/{2}/tree/main/modules/{3})' -f (Get-ResourceModuleName -path $subfolder), $Organization, $RepositoryName, $relativePath.Replace('\', '/'))
                        }
                    }

                }
                'ProviderNamespace' {
                    # If we don't sort by provider, we have to add the provider to each row to ensure readability of each row
                    if ($SortByColumn -eq 'Name') {
                        $row['ProviderNamespace'] += "``$provider``"
                    } else {
                        $row['ProviderNamespace'] = ''
                    }
                }
                'ResourceType' {
                    switch ($Environment) {
                        'ADO' {
                            $row['ResourceType'] = ('[{0}](https://dev.azure.com/{1}/{2}/_git/{3}?path=/modules/{4})' -f $subName, $Organization, $ProjectName, $RepositoryName, $relativePath.Replace('\', '/'))
                        }
                        'GitHub' {
                            $row['ResourceType'] = ('[{0}](https://github.com/{1}/{2}/tree/main/modules/{3})' -f $subName, $Organization, $RepositoryName, $relativePath.Replace('\', '/'))
                        }
                    }


                }
                'TemplateType' {
                    $row['TemplateType'] += Get-TypeColumnString -path $subfolder
                }
                'Deploy' {
                    $row['Deploy'] += Get-DeployToAzureUrl -path $subfolder -RepositoryName $RepositoryName -Organization $Organization
                }
                'Status' {
                    $statusInputObject = @{
                        RepositoryName     = $RepositoryName
                        Organization       = $Organization
                        PipelineFileName   = (((('ms.{0}.{1}.yml' -f $provider, $subName) -replace '-', '') -replace '\\', '/') -replace '/', '.').ToLower()
                        PipelineFolderPath = $Environment -eq 'GitHub' ? (Join-Path '.github' 'workflows') : (Join-Path '.azuredevops' 'modulePipelines')
                    }
                    $row['Status'] += Get-PipelineStatusUrl @statusInputObject
                }
                Default {
                    Write-Warning "Column [$column] not existing. Available are: [Name|ProviderNamespace|ResourceType|TemplateType|Deploy|Status]"
                }
            }
        }
        $null = $output += $row
    }
    return $output
}
#endregion

<#
.SYNOPSIS
Generate a markdown table for all modules in the given path.

.DESCRIPTION
Generate a markdown table for all modules in the given path. Returns an array with one row for each service provider
Folders should follow the structure:

Sql
├─ server [module]
└─ serverResources
    └─ databases [module]

Where sub-resources are part of a subfolder [<parentResource>Resources]

Results in a table like

    "| Name                           | Provider namespace | Resource Type                                               |"
    "| ------------------------------ | ------------------ | ------------------------------------------------------------|"
    "| SQL Managed Instances          | `Sql`              | [managedInstances](sql/managed-instance)                    |"
    "| SQL Managed Instances Database |                    | [managedInstances/databases](sql/managed-instance/database) |"

.PARAMETER Path
Mandatory. The path to resolve

.PARAMETER ColumnsInOrder
Optional. The set of columns to add to the table in the order you expect them in the table.
Available are 'Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy' & 'Status'
If no value is provided, all are added

.PARAMETER SortByColumn
Optional. The column to sort the table by.
Can be either 'Name' or 'ProviderNamespace'
If no value is provided it defaults to 'ProviderNamespace'

.PARAMETER RepositoryName
Mandatory. The name of the repository the code resides in

.PARAMETER Organization
Mandatory. The name of the Organization the code resides in

.PARAMETER Environment
Mandatory. The DevOps environment to generate the status badges for

.PARAMETER ProjectName
Optional. The project the repository is hosted in. Required if the 'environment' is 'ADO'

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\modules'

Generate a markdown table for all modules in path 'C:\dev\modules' with all default columns, sorted by 'Provider Namespace'

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\modules' -ColumnsInOrder @('Resource Type', 'Name')

Generate a markdown table for all modules in path 'C:\dev\modules' with only the 'Resource Type' & 'Name' columns, sorted by 'Provider Namespace'

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\modules' -ColumnsInOrder @('Resource Type', 'Name') -SortByColumn 'Name'

Generate a markdown table for all modules in path 'C:\dev\modules' with only the 'Resource Type' & 'Name' columns, , sorted by 'Name'

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules' -RepositoryName 'ResourceModules' -Organization 'Azure' -ColumnsInOrder @('Name','TemplateType','Status','Deploy') -Environment 'GitHub'

Generate a markdown table for all modules in path 'C:\dev\modules' with only the 'Name', 'TemplateType', 'Status'  &'Deploy' columns, sorted by 'Name' for GitHub

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules' -RepositoryName 'ResourceModules' -Organization 'CARML' -ProjectName 'ResourceModules' -Environment 'ADO' -ColumnsInOrder @('Name', 'TemplateType', 'Status', 'Deploy')

Generate a markdown table for all modules in path 'C:\dev\modules' with only the 'Name', 'TemplateType', 'Status' & 'Deploy' columns, sorted by 'Name' for Azure DevOps
#>
function Get-ModulesAsMarkdownTable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy', 'Status')]
        [string[]] $ColumnsInOrder = @('Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy'),

        [Parameter(Mandatory = $false)]
        [ValidateSet('Name', 'ProviderNamespace')]
        [string] $SortByColumn = 'ProviderNamespace',

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $true)]
        [string] $Organization,

        [Parameter(Mandatory)]
        [ValidateSet('GitHub', 'ADO')]
        [string] $Environment,

        [Parameter(Mandatory = $false)]
        [string] $ProjectName = ''
    )

    # Load external functions
    $utilitiesRoot = (Get-Item -Path $PSScriptRoot).Parent.Parent
    . (Join-Path $utilitiesRoot 'tools' 'helper' 'Get-PipelineStatusUrl.ps1')
    . (Join-Path $utilitiesRoot 'pipelines' 'sharedScripts' 'helper' 'Get-SpecsAlignedResourceName.ps1')

    # Header
    # ------
    $headerRow = '|'
    foreach ($column in $ColumnsInOrder) {
        switch ($column) {
            'Name' { $headerRow += ' Name |' }
            'ProviderNamespace' { $headerRow += ' Provider namespace |' }
            'ResourceType' { $headerRow += ' Resource Type |' }
            'TemplateType' { $headerRow += ' Bicep |' }
            'Deploy' { $headerRow += ' Deploy |' }
            'Status' { $headerRow += ' Status |' }
            Default {
                Write-Warning "Column [$column] not existing. Available are: [Name|ProviderNamespace|ResourceType|TemplateType|Deploy|Status]"
            }
        }
    }

    $headerSubRow = '|'
    for ($index = 0; $index -lt $ColumnsInOrder.Count; $index++) {
        $headerSubRow += ' - |'
    }

    # Content
    # -------
    $output = [System.Collections.ArrayList]@()
    if ($topLevelFolders = Get-ChildItem -Path $Path -Depth 0 -Directory -Exclude '.*' -Force) {
        $topLevelFolders = $topLevelFolders.FullName | Sort-Object
    }

    $previousProvider = ''
    foreach ($topLevelFolder in $topLevelFolders) {

        $containedFolderPaths = (Get-ChildItem -Path $topLevelFolder -Directory -Recurse -Exclude @('.bicep', '.test') -Depth 0 -Force).FullName

        foreach ($containedFolderPath in $containedFolderPaths) {
            $containedFolderName = Split-Path $containedFolderPath -Leaf
            $concatedBase = $containedFolderPath.Replace((Split-Path $topLevelFolder -Parent), '').Substring(1)

            $provider = Split-Path $topLevelFolder -Leaf
            $specsAlignedResourceName = Get-SpecsAlignedResourceName -ResourceIdentifier ($concatedBase -replace '\\', '/')
            $specsAlignedProviderNamespace = $specsAlignedResourceName.Split('/')[0]
            $specsAlignedResourceType = $specsAlignedResourceName -replace "$specsAlignedProviderNamespace/", ''

            if (Measure-FolderHasNestedModule -path $containedFolderPath) {
                $recursiveSubServiceInputObject = @{
                    SubPath           = $containedFolderPath
                    ConcatedBase      = $concatedBase
                    Output            = $output
                    ProviderNamespace = $provider
                    ColumnsInOrder    = $ColumnsInOrder
                    RepositoryName    = $RepositoryName
                    SortByColumn      = $SortByColumn
                    Organization      = $Organization
                    Environment       = $Environment
                    ProjectName       = $ProjectName
                }
                $output = Get-ResolvedSubServiceRow @recursiveSubServiceInputObject
            } else {
                $row = @{}
                foreach ($column in $ColumnsInOrder) {
                    switch ($column) {
                        'Name' {
                            switch ($Environment) {
                                'ADO' {
                                    $row['Name'] = ('[{0}](https://dev.azure.com/{1}/{2}/_git/{3}?path=/modules/{4})' -f (Get-ResourceModuleName -path $containedFolderPath), $Organization, $ProjectName, $RepositoryName, $concatedBase.Replace('\', '/'))
                                }
                                'GitHub' {
                                    $row['Name'] = ('[{0}](https://github.com/{1}/{2}/tree/main/modules/{3})' -f (Get-ResourceModuleName -path $containedFolderPath), $Organization, $RepositoryName, $concatedBase.Replace('\', '/'))
                                }
                            }
                        }
                        'ProviderNamespace' {
                            if ($previousProvider -eq $specsAlignedProviderNamespace -and $SortByColumn -ne 'Name') {
                                $row['ProviderNamespace'] += ''
                            } else {
                                $row['ProviderNamespace'] += "``$specsAlignedProviderNamespace``"
                                $previousProvider = $specsAlignedProviderNamespace
                            }
                        }
                        'ResourceType' {
                            switch ($Environment) {
                                'ADO' {
                                    $row['ResourceType'] = ('[{0}](https://dev.azure.com/{1}/{2}/_git/{3}?path=/modules/{4})' -f $specsAlignedResourceType, $Organization, $ProjectName, $RepositoryName, $concatedBase.Replace('\', '/'))
                                }
                                'GitHub' {
                                    $row['ResourceType'] += ('[{0}](https://github.com/{1}/{2}/tree/main/modules/{3})' -f $specsAlignedResourceType, $Organization, $RepositoryName, $concatedBase.Replace('\', '/'))
                                }
                            }

                        }
                        'TemplateType' {
                            $row['TemplateType'] += Get-TypeColumnString -path $containedFolderPath
                        }
                        'Deploy' {
                            $row['Deploy'] += Get-DeployToAzureUrl -path $containedFolderPath -RepositoryName $RepositoryName -Organization $Organization
                        }
                        'Status' {
                            $statusInputObject = @{
                                RepositoryName     = $RepositoryName
                                Organization       = $Organization
                                Environment        = $Environment
                                ProjectName        = $ProjectName
                                PipelineFileName   = (((('ms.{0}.{1}.yml' -f $provider, $containedFolderName) -replace '-', '') -replace '\\', '/') -replace '/', '.').ToLower()
                                PipelineFolderPath = $Environment -eq 'GitHub' ? (Join-Path '.github' 'workflows') : (Join-Path '.azuredevops' 'modulePipelines')
                            }
                            $row['Status'] += Get-PipelineStatusUrl @statusInputObject
                        }
                        Default {
                            Write-Warning "Column [$column] not existing. Available are: [Name|ProviderNamespace|ResourceType|TemplateType|Deploy|Status]"
                        }
                    }
                }

                $null = $output += $row
            }
        }
    }

    # Validate order
    if ($SortByColumn -eq 'Name') {
        $output = $output | Sort-Object -Property 'Name'
    }

    # Build result set
    $table = [System.Collections.ArrayList]@(
        $headerRow,
        $headerSubRow
    )
    foreach ($rowColumns in $output) {
        $rowString = '|'
        foreach ($column in $ColumnsInOrder) {
            $rowString += ' {0} |' -f $rowColumns[$column]
        }
        $table += $rowString
    }

    return $table
}
