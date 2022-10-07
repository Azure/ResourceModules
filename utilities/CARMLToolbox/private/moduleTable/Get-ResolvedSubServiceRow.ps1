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
