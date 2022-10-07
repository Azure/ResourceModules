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
Get-ModulesAsMarkdownTable -path 'C:\dev\ip\Azure-Modules\ResourceModules\modules' -RepositoryName 'ResourceModules' -Organization 'Azure' -ColumnsInOrder @('Name','TemplateType','Status','Deploy')

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

        $containedFolders = Get-ChildItem -Path $topLevelFolder -Directory -Recurse -Exclude @('.bicep', '.test') -Depth 0 -Force

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
                                    $row['Name'] = ('[{0}](https://dev.azure.com/{1}/{2}/_git/{3}?path=/modules/{4})' -f (Get-ResourceModuleName -path $containedFolder), $Organization, $ProjectName, $RepositoryName, $concatedBase.Replace('\', '/'))
                                }
                                'GitHub' {
                                    $row['Name'] = ('[{0}](https://github.com/{1}/{2}/tree/main/modules/{3})' -f (Get-ResourceModuleName -path $containedFolder), $Organization, $RepositoryName, $concatedBase.Replace('\', '/'))
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
                                    $row['ResourceType'] = ('[{0}](https://dev.azure.com/{1}/{2}/_git/{3}?path=/modules/{4})' -f (Get-ResourceModuleName -path $containedFolder), $Organization, $ProjectName, $RepositoryName, $concatedBase.Replace('\', '/'))
                                }
                                'GitHub' {
                                    $row['ResourceType'] += ('[{0}](https://github.com/{1}/{2}/tree/main/modules/{3})' -f $containedFolderName, $Organization, $RepositoryName, $concatedBase.Replace('\', '/'))
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
