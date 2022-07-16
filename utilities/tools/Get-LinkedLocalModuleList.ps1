<#
.SYNOPSIS
Find any nested dependency recursively

.DESCRIPTION
Find any nested dependency recursively

.PARAMETER DependencyMap
Required. The map/dictionary/hashtable of dependencies to search in

.PARAMETER ResourceType
Required. The resource type to search any dependency for

.EXAMPLE
Resolve-DependencyList -DependencyMap @{ a = @('b','c'); b = @('d')} -ResourceType 'a'

Get an array of all dependencies of resource type 'a', as defined in the given DependencyMap. Would return @('b','c','d')
#>
function Resolve-DependencyList {

    [CmdletBinding()]
    param (
        [Parameter()]
        [hashtable] $DependencyMap,

        [Parameter()]
        [string] $ResourceType
    )

    $resolvedDependencies = @()
    if ($DependencyMap.Keys -contains $ResourceType) {
        $resolvedDependencies = $DependencyMap[$ResourceType]
        foreach ($dependency in $DependencyMap[$ResourceType]) {
            $resolvedDependencies += Resolve-DependencyList -DependencyMap $DependencyMap -ResourceType $dependency
        }
    }

    $resolvedDependencies = $resolvedDependencies | Select-Object -Unique

    return $resolvedDependencies
}

<#
.SYNOPSIS
Print a list of all local references for the modules in a given path

.DESCRIPTION
The result will be a list of all modules in the given path alongside their individual references to other modules in the folder structure

.PARAMETER Path
Optional. The path to search in. Defaults to the 'modules' folder

.PARAMETER Print
Optional. Instead of returning the dependency, print them to the terminal

.EXAMPLE
Get-LinkedLocalModuleList -Print

Invoke the function with the default path. Prints a list such as:

> The modules in path [C:\dev\ip\Azure-ResourceModules\ResourceModules\modules] have the following local folder dependencies:
>
> Resource: Microsoft.EventGrid/topics
> - Microsoft.Network/privateEndpoints
>
> Resource: Microsoft.Synapse/privateLinkHubs
> - Microsoft.Network/privateEndpoints

.EXAMPLE
Get-LinkedLocalModuleList -Path './Microsoft.Sql' -Print

Get only the references of the modules in folder path './Microsoft.Sql'

> The modules in path [..\..\modules\Microsoft.Sql\] have the following local folder dependencies:
>
> Resource: Microsoft.Sql/servers
> - Microsoft.Network/privateEndpoints
#>
function Get-LinkedLocalModuleList {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $Path = (Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'modules'),

        [Parameter(Mandatory = $false)]
        [switch] $Print
    )

    # Load used functions
    . (Join-Path $PSScriptRoot 'Get-LinkedModuleList.ps1')

    $allReferences = Get-LinkedModuleList -path $path

    $resultSet = [ordered]@{}

    foreach ($resourceType in ($allReferences.Keys | Sort-Object)) {
        $relevantLocalReferences = $allReferences[$resourceType].localPathReferences | Where-Object { $_ -match '^\.\..*$' }
        if ($relevantLocalReferences) {
            $relevantLocalReferences = $relevantLocalReferences | ForEach-Object {
                # remove deploy.bicep
                Split-Path $_ -Parent
            } | ForEach-Object {
                # remove leading path elements
                ($_ -replace '\\', '/') -match '^[\.\/]*(.+)$'
            } | ForEach-Object {
                # We have to differentate the case that the referenced resources is inside or outside the same provider namespace (e.g. '../publicIPAddresses')
                if ($matches[1] -like '*/*') {
                    # Reference outside of namespace
                    $matches[1]
                } else {
                    # Reference inside of namespace (-> we rebuild the namespace)
                    '{0}/{1}' -f (Split-Path $resourceType -Parent), $matches[1]
                }
            }
            $resultSet[$resourceType] = @() + $relevantLocalReferences
        }
    }

    # Add nested dependencies
    $resolvedResultSet = [ordered]@{}
    foreach ($resourceType in $resultSet.Keys) {
        $resolvedDependencies = $resultSet[$resourceType]
        foreach ($dependency in $resultSet[$resourceType]) {
            $resolvedDependencies += Resolve-DependencyList -DependencyMap $resultSet -ResourceType $resourceType
        }
        $resolvedResultSet[$resourceType] = $resolvedDependencies | Select-Object -Unique
    }
    $resultSet = $resolvedResultSet

    if ($Print) {
        Write-Verbose "The modules in path [$path] have the following local folder dependencies:" -Verbose
        foreach ($resourceType in $resultSet.Keys) {
            Write-Verbose '' -Verbose
            Write-Verbose "Resource: $resourceType" -Verbose
            $resultSet[$resourceType] | ForEach-Object {
                Write-Verbose "- $_" -Verbose
            }
        }
    } else {
        return $resultSet
    }
}
