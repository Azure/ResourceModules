<#
.SYNOPSIS
Extract all parameters from the given API spec parameter root

.DESCRIPTION
Extract all parameters from the given API spec parameter root (e.g., PUT parameters)

.PARAMETER JSONFilePath
Mandatory. The service specification file to process.

.PARAMETER SpecificationData
Mandatory. The source content to crawl for data.

.PARAMETER RelevantParamRoot
Mandatory. The array of root parameters to process (e.g., PUT parameters).

.PARAMETER UrlPath
Mandatory. The API Path in the JSON specification file to process

.PARAMETER ResourceType
Mandatory. The Resource Type to investigate

.EXAMPLE
Get-SpecsPropertiesAsParameterList -JSONFilePath '(...)/resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json' -RelevantParamRoot @(@{ $ref: "../(...)"}) '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}' -ResourceType 'vaults'

Fetch all parameters (e.g., PUT) from the KeyVault REST path.
#>
function Get-SpecsPropertiesAsParameterList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath,

        [Parameter(Mandatory = $true)]
        [array] $RelevantParamRoot,

        [Parameter(Mandatory = $true)]
        [string] $UrlPath,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType
    )

    $specificationData = Get-Content -Path $JSONFilePath -Raw | ConvertFrom-Json -AsHashtable
    $definitions = $specificationData.definitions
    $specParameters = $specificationData.parameters

    $templateData = @()

    $matchingPathObjectParametersRef = ($relevantParamRoot | Where-Object { $_.in -eq 'body' }).schema.'$ref'

    if (-not $matchingPathObjectParametersRef) {
        # If 'parameters' does not exist (as the API isn't consistent), we try the resource type instead
        $matchingPathObjectParametersRef = ($relevantParamRoot | Where-Object { $_.name -eq $ResourceType }).schema.'$ref'
    }
    if (-not $matchingPathObjectParametersRef) {
        # If even that doesn't exist (as the API is even more inconsistent), let's try a 'singular' resource type
        $matchingPathObjectParametersRef = ($relevantParamRoot | Where-Object { $_.name -eq ($ResourceType.Substring(0, $ResourceType.Length - 1)) }).schema.'$ref'
    }

    if ($matchingPathObjectParametersRef -like '*.*') {
        # if the reference directly points to another file
        $resolvedParameterRef = Resolve-SpecPropertyReference -JSONFilePath $JSONFilePath -SpecificationData $specificationData -Parameter @{ '$ref' = $matchingPathObjectParametersRef }

        # Overwrite data to process
        $specificationData = $resolvedParameterRef.specificationData
        $definitions = $specificationData.definitions
        $specParameters = $specificationData.parameters
    }

    # Get top-most parameters
    $outerParameters = $definitions[(Split-Path $matchingPathObjectParametersRef -Leaf)]

    # Handle resource name
    # --------------------
    # Note: The name can be specified in different locations like the PUT statement, but also in the spec's 'parameters' object as a reference
    # Case: The name in the url is also a parameter of the PUT statement
    $pathServiceName = (Split-Path $UrlPath -Leaf) -replace '{|}', ''
    if ($relevantParamRoot.name -contains $pathServiceName) {
        $param = $relevantParamRoot | Where-Object { $_.name -eq $pathServiceName }

        $parameterObject = @{
            level       = 0
            name        = 'name'
            type        = 'string'
            description = $param.description
            required    = $true
        }

        $parameterObject = Set-OptionalParameter -SourceParameterObject $param -TargetObject $parameterObject
    } else {
        # Case: The name is a ref in the spec's 'parameters' object. E.g., { "$ref": "#/parameters/BlobServicesName" }
        # For this, we need to find the correct ref, as there can be multiple
        $nonDefaultParameter = $relevantParamRoot.'$ref' | Where-Object { $_ -like '#/parameters/*' } | Where-Object { $specParameters[(Split-Path $_ -Leaf)].name -eq $pathServiceName }
        if ($nonDefaultParameter) {
            $param = $specParameters[(Split-Path $nonDefaultParameter -Leaf)]

            $parameterObject = @{
                level       = 0
                name        = 'name'
                type        = 'string'
                description = $param.description
                required    = $true
            }

            $parameterObject = Set-OptionalParameter -SourceParameterObject $param -TargetObject $parameterObject
        }
    }

    $templateData += $parameterObject

    # Process outer properties
    # ------------------------0
    foreach ($outerParameter in $outerParameters.properties.Keys | Where-Object { $_ -notin @('location') -and -not $outerParameters.properties[$_].readOnly } | Sort-Object ) {
        $innerParamInputObject = @{
            JSONFilePath              = $JSONFilePath
            Parameter                 = $outerParameters.properties[$outerParameter]
            SpecificationData         = $SpecificationData
            Level                     = 0
            Name                      = $outerParameter
            Parent                    = ''
            RequiredParametersOnLevel = $outerParameters.required
        }
        $templateData += Get-SpecsPropertyAsParameter @innerParamInputObject
    }

    # Special case: Location
    # The location parameter is not explicitely documented at this place (even though it should). It is however referenced as 'required' and must be included
    if ($outerParameters.required -contains 'location') {
        $parameterObject = @{
            level       = 0
            name        = 'location'
            type        = 'string'
            description = 'Location for all Resources.'
            required    = $false
            default     = ($UrlPath -like '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/*') ? 'resourceGroup().location' : 'deployment().location'
        }
        $templateData += $parameterObject
    }

    return $templateData
}
