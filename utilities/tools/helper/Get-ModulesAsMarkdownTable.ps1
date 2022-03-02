#region Helper functions
<#
.SYNOPSIS
Generate the status URL for GitHub module action workflows

.DESCRIPTION
Generate the status URL for GitHub module action workflows
E.g.  # [![AnalysisServices: Servers](https://github.com/Azure/ResourceModules/actions/workflows/ms.analysisservices.servers.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.analysisservices.servers.yml)

.PARAMETER name
Mandatory. The name of the module to create the url for

.PARAMETER provider
Mandatory. The provider of the module to create the url for

.PARAMETER RepositoryName
Mandatory. The repository to create the url for

.PARAMETER Organization
Mandatory. The Organization the repository is hosted in to create the url for

.EXAMPLE
Get-PipelineStatusUrl -name 'servers' -provider 'Microsoft.AnalysisServices' -RepositoryName 'ResourceModules' -Organization 'Azure'

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
        [string] $RepositoryName,

        [Parameter(Mandatory)]
        [string] $Organization,

        [Parameter(Mandatory)]
        [ValidateSet('GitHub', 'ADO')]
        [string]$Environment,

        [Parameter(Mandatory = $false)]
        [string]$ProjectName = ''
    )


    $shortProvider = $provider.Replace('Microsoft.', 'MS.')
    $pipelineFileName = ('{0}.{1}.yml' -f $shortProvider, $name).Replace('\', '/').Replace('/', '.').ToLower()
    switch ($Environment) {
        'ADO' {
            $pipelineFileUri = ".azuredevops/modulePipelines/$pipelineFileName"
            $pipelineName = (Get-Content -Path $pipelineFileUri)[0].TrimStart('name:').Replace('"', '').Trim()
            $pipelineFileGitUri = ('https://dev.azure.com/{0}/{1}/_apis/build/status/{2}?branchName=main' -f $Organization, $Projectname, $pipelineName.Replace("'", '')) -replace ' ', '%20'

            # Note: Badge name is automatically the pipeline name
            return ('[![{0}]({1})]({1})' -f $pipelineName, $pipelineFileGitUri).Replace('\', '/')
        }
        'GitHub' {
            $pipelineFileUri = ".github/workflows/$pipelineFileName"
            $pipelineName = (Get-Content -Path $pipelineFileUri)[0].TrimStart('name:').Replace('"', '').Trim()
            $pipelineFileGitUri = 'https://github.com/{0}/{1}/actions/workflows/{2}' -f $Organization, $RepositoryName, $pipelineFileName
            # Note: Badge name is automatically the pipeline name
            return ('[![{0}]({1}/badge.svg)]({1})' -f $pipelineName, $pipelineFileGitUri).Replace('\', '/')
        }
    }
}

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

    if (-not (Test-Path -Path "$Path\deploy.json")) {
        Write-Warning "ARM Template in path [$Path\deploy.json] not found. Unable to generate 'Deploy to Azure' button."
        return ''
    }

    $baseUrl = '[![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/'
    $templateUri = 'https://raw.githubusercontent.com/{0}/{1}/main/{2}/deploy.json' -f $Organization, $RepositoryName, ($Path -split "\\$RepositoryName\\")[1]

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
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    if (-not (Test-Path "$Path/readme.md")) {
        Write-Warning "No [readme.md] found in folder [$Path]"
        return ''
    }

    $moduleReadMeContent = Get-Content -Path "$Path/readme.md"
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
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    $moduleFiles = Get-ChildItem -Path $Path -File -Force

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
A module is identified by folders that do not contain module-specific folders such as '.parameters'.
In other words, a module would contain a folder with e.g. a '.parameters' folder and would hence not count towards the hierarchy of parent folders.

.PARAMETER path
Mandatory. The path to search in.

.EXAMPLE
Measure-FolderHasNestedModule -path 'C:\dev\ApiManagement'

Check if the path 'C:\dev\ApiManagement' contains any number of nested modules
#>
function Measure-FolderHasNestedModule {

    [CmdletBinding()]
    [OutputType('System.Boolean')]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    # Get all folder paths that exist in the given path as long as they are not '.bicep' or '.parameters' folders
    # This works as long as the folder structure is consistent (e.g. no empty folders are created etc.)
    $rawFoundFolders = Get-ChildItem $Path -Directory -Recurse -Exclude @('.bicep', '.parameters') -Force
    $foundFolders = $rawFoundFolders | Where-Object { (Get-ChildItem $_.FullName -Directory -Depth 0 -Include '.parameters' -Force).count -gt 0 }
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
> Get-ResolvedSubServiceRow -subPath 'C:\dev\Microsoft.ApiManagement\serviceResources' -concatedBase "Microsoft.ApiManagement\serviceResources" -output @() -provider 'Microsoft.ApiManagement' -ColumnsInOrder @('Name','ProviderNamespace') -SortByColumn 'Name'

Adds a hashtable like  @{ Name = 'API Management'; 'Provider Namespace' = `Microsoft.ApiManagement` }. As the specified column for sorting is 'Name', the 'Provider Namespace' will be added to each entry.
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
        [string]$Environment,

        [Parameter(Mandatory = $false)]
        [string]$ProjectName = ''
    )

    $rawSubFolders = Get-ChildItem -Path $subPath -Directory -Recurse -Exclude @('.bicep', '.parameters') -Force
    # Only consider those folders that have their own parameters, i.e. are top-level modules and not child-resource modules
    $subFolders = $rawSubFolders | Where-Object { (Get-ChildItem $_.FullName -Directory -Depth 0 -Include '.parameters' -Force).count -gt 0 }

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
                            $row['Name'] = ('[{0}](https://dev.azure.com/{1}/{2}/_git/{3}?path=/arm/{4})' -f (Get-ResourceModuleName -path $subfolder), $Organization, $ProjectName, $RepositoryName, $relativePath.Replace('\', '/'))
                        }
                        'GitHub' {
                            $row['Name'] = ('[{0}](https://github.com/{1}/{2}/tree/main/arm/{3})' -f (Get-ResourceModuleName -path $subfolder), $Organization, $RepositoryName, $relativePath.Replace('\', '/'))
                        }
                    }

                }
                'ProviderNamespace' {
                    # If we don't sort by provider, we have to add the provider to each row to ensure readability of each row
                    if ($SortByColumn -eq 'Name') {
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
                    switch ($Environment) {
                        'ADO' {
                            $row['ResourceType'] = ('[{0}](https://dev.azure.com/{1}/{2}/_git/{3}?path=/arm/{4})' -f $subName, $Organization, $ProjectName, $RepositoryName, $relativePath.Replace('\', '/'))
                        }
                        'GitHub' {
                            $row['ResourceType'] = ('[{0}](https://github.com/{1}/{2}/tree/main/arm/{3})' -f $subName, $Organization, $RepositoryName, $relativePath.Replace('\', '/'))
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
                    $row['Status'] += Get-PipelineStatusUrl -name $subName -provider $provider -RepositoryName $RepositoryName -Organization $Organization
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

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\Modules'

Generate a markdown table for all modules in path 'C:\dev\Modules' with all default columns, sorted by 'Provider Namespace'

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\Modules' -ColumnsInOrder @('Resource Type', 'Name')

Generate a markdown table for all modules in path 'C:\dev\Modules' with only the 'Resource Type' & 'Name' columns, sorted by 'Provider Namespace'

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\Modules' -ColumnsInOrder @('Resource Type', 'Name') -SortByColumn 'Name'

Generate a markdown table for all modules in path 'C:\dev\Modules' with only the 'Resource Type' & 'Name' columns, , sorted by 'Name'

.EXAMPLE
Get-ModulesAsMarkdownTable -path 'C:\dev\ip\Azure-Modules\ResourceModules\arm' -RepositoryName 'ResourceModules' -Organization 'Azure' -ColumnsInOrder @('Name','TemplateType','Status','Deploy')

Generate a markdown table for all modules in path 'C:\dev\Modules' with only the 'Name','TemplateType','Status' &'Deploy' columns, sorted by 'Name'
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
        [string]$Environment,

        [Parameter(Mandatory = $false)]
        [string]$ProjectName = ''
    )

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
    if ($topLevelFolders = Get-ChildItem -Path $Path -Depth 1 -Filter 'Microsoft.*' -Force) {
        $topLevelFolders = $topLevelFolders.FullName | Sort-Object
    }

    $previousProvider = ''
    foreach ($topLevelFolder in $topLevelFolders) {
        $provider = Split-Path $topLevelFolder -Leaf

        $containedFolders = Get-ChildItem -Path $topLevelFolder -Directory -Recurse -Exclude @('.bicep', '.parameters') -Depth 0 -Force

        foreach ($containedFolder in $containedFolders.FullName) {
            $containedFolderName = (Split-Path $containedFolder -Leaf)
            $concatedBase = $containedFolder.Replace((Split-Path $topLevelFolder -Parent), '').Substring(1)

            if (Measure-FolderHasNestedModule -path $containedFolder) {
                $recursiveSubServiceInputObject = @{
                    subPath        = $containedFolder
                    concatedBase   = $concatedBase
                    output         = $output
                    provider       = $provider
                    ColumnsInOrder = $ColumnsInOrder
                    RepositoryName = $RepositoryName
                    SortByColumn   = $SortByColumn
                    Organization   = $Organization
                    Environment    = $Environment
                    ProjectName    = $ProjectName
                }
                $output = Get-ResolvedSubServiceRow @recursiveSubServiceInputObject
            } else {
                $row = @{}
                foreach ($column in $ColumnsInOrder) {
                    switch ($column) {
                        'Name' {
                            switch ($Environment) {
                                'ADO' {
                                    $row['Name'] = ('[{0}](https://dev.azure.com/{1}/{2}/_git/{3}?path=/arm/{4})' -f (Get-ResourceModuleName -path $containedFolder), $Organization, $ProjectName, $RepositoryName, $concatedBase.Replace('\', '/'))
                                }
                                'GitHub' {
                                    $row['Name'] = ('[{0}](https://github.com/{1}/{2}/tree/main/arm/{3})' -f (Get-ResourceModuleName -path $containedFolder), $Organization, $RepositoryName, $concatedBase.Replace('\', '/'))
                                }
                            }
                        }
                        'ProviderNamespace' {
                            if ($previousProvider -eq $provider -and $SortByColumn -ne 'Name') {
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
                            switch ($Environment) {
                                'ADO' {
                                    $row['ResourceType'] = ('[{0}](https://dev.azure.com/{1}/{2}/_git/{3}?path=/arm/{4})' -f (Get-ResourceModuleName -path $containedFolder), $Organization, $ProjectName, $RepositoryName, $concatedBase.Replace('\', '/'))
                                }
                                'GitHub' {
                                    $row['ResourceType'] += ('[{0}](https://github.com/{1}/{2}/tree/main/arm/{3})' -f $containedFolderName, $Organization, $RepositoryName, $concatedBase.Replace('\', '/'))
                                }
                            }

                        }
                        'TemplateType' {
                            $row['TemplateType'] += Get-TypeColumnString -path $containedFolder
                        }
                        'Deploy' {
                            $row['Deploy'] += Get-DeployToAzureUrl -path $containedFolder -RepositoryName $RepositoryName -Organization $Organization
                        }
                        'Status' {
                            $row['Status'] += Get-PipelineStatusUrl -name $containedFolderName -provider $provider -RepositoryName $RepositoryName -Organization $Organization -Environment $Environment -ProjectName $ProjectName
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
