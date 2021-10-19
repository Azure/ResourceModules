#region Helper functions
<#
.SYNOPSIS
Generate the status Url for GitHub module action workflows

.DESCRIPTION
Generate the status Url for GitHub module action workflows
E.g.  # [![AnalysisServices: Servers](https://github.com/Azure/ResourceModules/actions/workflows/ms.analysisservices.servers.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.analysisservices.servers.yml)

.PARAMETER name
Mandatory. The name of the module to create the url for

.PARAMETER provider
Mandatory. The provider of the module to create the url for

.PARAMETER repositoryName
Mandatory. The repository to create the url for

.PARAMETER organization
Mandatory. The organization the repository is hosted in to create the url for

.EXAMPLE
Get-PipelineStatusUrl -name 'servers' -provider 'Microsoft.AnalysisServices' -repositoryName 'ResourceModules' -organization 'Azure'

Generate a status badge url for the 'service' module of the 'Microsoft.AnalysisServices' provider in repo 'Azure/ResourceModules'
#>
function Get-PipelineStatusUrl {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $name,

        [Parameter(Mandatory)]
        [string] $provider,

        [Parameter(Mandatory)]
        [string] $repositoryName,

        [Parameter(Mandatory)]
        [string] $organization
    )

    $shortProvider = $provider.Replace('Microsoft.', 'MS.')
    $pipelineFileName = ('{0}.{1}.yml' -f $shortProvider, $name).Replace('\', '/').Replace('/', '.').ToLower()
    $pipelineFileUri = ".github/workflows/$pipelineFileName"

    $pipelineName = (Get-Content -Path $pipelineFileUri)[0].TrimStart('name:').Replace('"', '').Trim()

    $pipelineFileGitUri = 'https://github.com/{0}/{1}/actions/workflows/{2}' -f $organization, $repositoryName, $pipelineFileName

    # Note: Bade name is automatically the pipeline name
    return ('[![{0}]({1}/badge.svg)]({1})' -f $pipelineName, $pipelineFileGitUri).Replace('\', '/')
}

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

.PARAMETER Organization
Mandatory. The name of the organization the code resides in

.EXAMPLE
Get-DeployToAzureUrl -path 'C:\Modules\MyModule' -repositoryName 'Modules' -organization 'Azure'

Generate an 'Deploy to Azure' button for module 'MyModule'
#>
function Get-DeployToAzureUrl {


    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $path,

        [Parameter(Mandatory)]
        [string] $repositoryName,

        [Parameter(Mandatory)]
        [string] $organization
    )

    if (-not (Test-Path -Path "$path\deploy.json")) {
        Write-Warning "ARM Template in path [$path\deploy.json] not found. Unable to generate 'Deploy to Azure' button."
        return ''
    }

    $baseUrl = '[![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/'
    $templateUri = 'https://raw.githubusercontent.com/{0}/{1}/main/{2}/deploy.json' -f $organization, $repositoryName, ($path -split "\\$repositoryName\\")[1]

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
        return ''
    }

    $moduleReadMeContent = Get-Content -Path "$path/readme.md"
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

    $outputString = ''

    # if ($moduleFiles.Name -contains 'deploy.json') {
    #     # ARM exists
    #     $outputString += ":heavy_check_mark:/"
    # }
    # else {
    #     $outputString += " /"
    # }

    if ($moduleFiles.Name -contains 'deploy.bicep') {
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
A module is identified by folders that do not contain module-specific folders such as 'parameters'.
In other words, a module would contain a folder with e.g. a 'parameters' folder and would hence not count towards the hierarchy of parent folders.

.PARAMETER path
Mandatory. The path to search in.

.EXAMPLE
Measure-FolderHasNestedModule -path 'C:\dev\ApiManagement'

Check if the path 'C:\dev\ApiManagement' contains any number of nested modules
#>
function Measure-FolderHasNestedModule {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $path
    )

    # Get all folder paths that exist in the given path as long as they are not '.bicep' or 'parameters' folders
    # This works as long as the folder structure is consistent (e.g. no empty folders are created etc.)
    $foundFolders = (Get-ChildItem $path -Directory -Recurse -Exclude @('.bicep', 'parameters')).fullName
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

.PARAMETER columnsInOrder
Mandatory. The set of columns to add to the table in the order you expect them in the table.
Available are 'Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy' & 'Status'

.PARAMETER sortByColumn
Mandatory. The column to sort the table by.
Can be either 'Name' or 'ProviderNamespace'

.PARAMETER RepositoryName
Mandatory. The name of the repository the code resides in

.PARAMETER Organization
Mandatory. The name of the organization the code resides in

.EXAMPLE
> Get-ResolvedSubServiceRow -subPath 'C:\dev\Microsoft.ApiManagement\serviceResources' -concatedBase "Microsoft.ApiManagement\serviceResources" -output @() -provider 'Microsoft.ApiManagement' -columnsInOrder @('Name','ProviderNamespace') -sortByColumn 'Name'

Adds a hashtable like  @{ Name = 'Api Management'; 'Provider Namespace' = `Microsoft.ApiManagement` }. As the specified column for sorting is 'Name', the 'Provider Namespace' will be added to each entry.
#>
function Get-ResolvedSubServiceRow {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $subPath,

        [Parameter(Mandatory)]
        [string] $concatedBase,

        [Parameter(Mandatory)]
        [System.Collections.ArrayList] $output,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string] $provider,

        [Parameter(Mandatory)]
        [ValidateSet('Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy', 'Status')]
        [string[]] $columnsInOrder,

        [Parameter(Mandatory)]
        [ValidateSet('Name', 'ProviderNamespace')]
        [string] $sortByColumn,

        [Parameter(Mandatory = $true)]
        [string] $repositoryName,

        [Parameter(Mandatory = $true)]
        [string] $organization
    )

    $subFolders = Get-ChildItem -Path $subPath -Directory -Recurse -Exclude @('.bicep', 'parameters')

    foreach ($subfolder in $subFolders.FullName) {

        $subFolderName = (Split-Path $subfolder -Leaf)

        $relativePath = Join-Path $concatedBase $subFolderName
        $subName = $relativePath.Replace('\', '/').Replace("$provider/", '').Replace('Resources/', '/')

        $row = @{}
        foreach ($column in $columnsInOrder) {
            switch ($column) {
                'Name' {
                    $row['Name'] = ('[{0}](https://github.com/{1}/{2}/tree/main/arm/{3})' -f (Get-ResourceModuleName -path $subfolder), $organization, $repositoryName, $relativePath.Replace('\', '/'))
                }
                'ProviderNamespace' {
                    # If we don't sort by provider, we have to add the provider to each row to ensure readability of each row
                    if ($sortByColumn -eq 'Name') {
                        if ($provider -like 'Microsoft.*') {
                            # Shorten Microsoft to save some space
                            $shortProvider = 'MS.{0}' -f ($provider.TrimStart('Microsoft.'))
                            $row['ProviderNamespace'] += "``$shortProvider``"
                        } else {
                            $row['ProviderNamespace'] += "``$provider``"
                        }
                    } else {
                        $row['ProviderNamespace'] = ''
                    }
                }
                'ResourceType' {
                    $row['ResourceType'] = ('[{0}](https://github.com/{1}/{2}/tree/main/arm/{3})' -f $subName, $organization, $repositoryName, $relativePath.Replace('\', '/'))

                }
                'TemplateType' {
                    $row['TemplateType'] += Get-TypeColumnString -path $subfolder
                }
                'Deploy' {
                    $row['Deploy'] += Get-DeployToAzureUrl -path $subfolder -repositoryName $repositoryName -organization $organization
                }
                'Status' {
                    $row['Status'] += Get-PipelineStatusUrl -name $subName -provider $provider -repositoryName $repositoryName -organization $organization
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
Available are 'Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy' & 'Status'
If no value is provided, all are added

.PARAMETER sortByColumn
Optional. The column to sort the table by.
Can be either 'Name' or 'ProviderNamespace'
If no value is provided it defaults to 'ProviderNamespace'

.PARAMETER RepositoryName
Mandatory. The name of the repository the code resides in

.PARAMETER Organization
Mandatory. The name of the organization the code resides in

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\Modules'

Generate a markdown table for all modules in path 'C:\dev\Modules' with all default columns, sorted by 'Provider Namespace'

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\Modules' -columnsInOrder @('Resource Type', 'Name')

Generate a markdown table for all modules in path 'C:\dev\Modules' with only the 'Resource Type' & 'Name' columns, sorted by 'Provider Namespace'

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\Modules' -columnsInOrder @('Resource Type', 'Name') -sortByColumn 'Name'

Generate a markdown table for all modules in path 'C:\dev\Modules' with only the 'Resource Type' & 'Name' columns, , sorted by 'Name'

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\ip\Azure-Modules\ResourceModules\arm' -repositoryName 'ResourceModules' -organization 'Azure' -columnsInOrder @('Name','TemplateType','Status','Deploy')

Generate a markdown table for all modules in path 'C:\dev\Modules' with only the 'Name','TemplateType','Status' &'Deploy' columns, sorted by 'Name'
#>
function Get-ModulesAsMarkdownTable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $path,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy', 'Status')]
        [string[]] $columnsInOrder = @('Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy'),

        [Parameter(Mandatory = $false)]
        [ValidateSet('Name', 'ProviderNamespace')]
        [string] $sortByColumn = 'ProviderNamespace',

        [Parameter(Mandatory = $true)]
        [string] $repositoryName,

        [Parameter(Mandatory = $true)]
        [string] $organization
    )

    # Header
    # ------
    $headerRow = '|'
    foreach ($column in $columnsInOrder) {
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
    for ($index = 0; $index -lt $columnsInOrder.Count; $index++) {
        $headerSubRow += ' - |'
    }

    # Content
    # -------
    $output = [System.Collections.ArrayList]@()
    if ($topLevelFolders = Get-ChildItem -Path $path -Depth 1 -Filter 'Microsoft.*') {
        $topLevelFolders = $topLevelFolders.FullName | Sort-Object
    }

    $previousProvider = ''
    foreach ($topLevelFolder in $topLevelFolders) {
        $provider = Split-Path $topLevelFolder -Leaf

        $containedFolders = Get-ChildItem -Path $topLevelFolder -Directory -Recurse -Exclude @('.bicep', 'parameters') -Depth 0

        foreach ($containedFolder in $containedFolders.FullName) {
            $containedFolderName = (Split-Path $containedFolder -Leaf)
            $concatedBase = $containedFolder.Replace((Split-Path $topLevelFolder -Parent), '').Substring(1)

            if (Measure-FolderHasNestedModule -path $containedFolder) {
                $recursiveSubServiceInputObject = @{
                    subPath        = $containedFolder
                    concatedBase   = $concatedBase
                    output         = $output
                    provider       = $provider
                    columnsInOrder = $columnsInOrder
                    repositoryName = $repositoryName
                    sortByColumn   = $sortByColumn
                    organization   = $organization
                }
                $output = Get-ResolvedSubServiceRow @recursiveSubServiceInputObject
            } else {
                $row = @{}

                foreach ($column in $columnsInOrder) {
                    switch ($column) {
                        'Name' {
                            $row['Name'] = ('[{0}](https://github.com/{1}/{2}/tree/main/arm/{3})' -f (Get-ResourceModuleName -path $containedFolder), $organization, $repositoryName, $concatedBase.Replace('\', '/'))
                        }
                        'ProviderNamespace' {
                            if ($previousProvider -eq $provider -and $sortByColumn -ne 'Name') {
                                $row['ProviderNamespace'] += ''
                            } else {
                                if ($provider -like 'Microsoft.*') {
                                    # Shorten Microsoft to save some space
                                    $shortProvider = 'MS.{0}' -f ($provider.TrimStart('Microsoft.'))
                                    $row['ProviderNamespace'] += "``$shortProvider``"
                                } else {
                                    $row['ProviderNamespace'] += "``$provider``"
                                }
                                $previousProvider = $provider
                            }
                        }
                        'ResourceType' {
                            $row['ResourceType'] += ('[{0}](https://github.com/{1}/{2}/tree/main/arm/{3})' -f $containedFolderName, $organization, $repositoryName, $concatedBase.Replace('\', '/'))
                        }
                        'TemplateType' {
                            $row['TemplateType'] += Get-TypeColumnString -path $containedFolder
                        }
                        'Deploy' {
                            $row['Deploy'] += Get-DeployToAzureUrl -path $containedFolder -repositoryName $repositoryName -organization $organization
                        }
                        'Status' {
                            $row['Status'] += Get-PipelineStatusUrl -name $containedFolderName -provider $provider -repositoryName $repositoryName -organization $organization
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
    if ($sortByColumn -eq 'Name') {
        $output = $output | Sort-Object -Property 'Name'
    }

    # Build result set
    $table = [System.Collections.ArrayList]@(
        $headerRow,
        $headerSubRow
    )
    foreach ($rowColumns in $output) {
        $rowString = '|'
        foreach ($column in $columnsInOrder) {
            $rowString += ' {0} |' -f $rowColumns[$column]
        }
        $table += $rowString
    }

    return $table
}
