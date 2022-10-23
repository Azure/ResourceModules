<#
.SYNOPSIS
Recursively resolve the given API Specs Parameter until it is no '$ref' to another parameter anymore

.DESCRIPTION
Recursively resolve the given API Specs Parameter until it is no '$ref' to another parameter anymore. Returns both the resolved parameter as well as the 'Specification'-Data it is hosted in (as it could be a different file). 

.PARAMETER JSONFilePath
Mandatory. The service specification file to process.

.PARAMETER SpecificationData
Mandatory. The specification data contain in the given API Specs file

.PARAMETER Parameter
Mandatory. The parameter reference of the API Specs file to process

.EXAMPLE
Resolve-SpecPropertyReference -JSONFilePath '(...)/resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json' -SpecificationData @{ paths = @{(..)}; definititions = @{(..)}; (..) } -Parameter @{ '$ref' = (..); description = '..' }

Resolve the given parameter.
#>
function Resolve-SpecPropertyReference {

    param(
        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath,

        [Parameter()]
        [hashtable] $SpecificationData,

        [Parameter()]
        [hashtable] $Parameter
    )

    
    $specDefinitions = $specificationData.definitions
    $specParameters = $specificationData.parameters

    if ($Parameter.Keys -contains '$ref') { 

        switch ($Parameter.'$ref') {
            { $PSItem -like '#/definitions/*' } {
                $refObject = $specDefinitions[(Split-Path $Parameter.'$ref' -Leaf)]

                $inputObject = @{
                    JSONFilePath      = $JSONFilePath
                    SpecificationData = $SpecificationData
                    Parameter         = $refObject
                }
                return Resolve-SpecPropertyReference @inputObject                
            }
            { $PSItem -like '#/parameters/*' } {
                throw "Parameter references not handled yet."

                $refObject = $specParameters[(Split-Path $Parameter.'$ref' -Leaf)]

                if ($refObject.readOnly) {
                    break
                }

                $inputObject = @{
                    JSONFilePath      = $JSONFilePath
                    SpecificationData = $SpecificationData
                    Parameter         = $refObject
                }
                return Resolve-SpecPropertyReference @inputObject
            }
            { $PSItem -like '*.*' } {
                # FilePath
                $filePath = Resolve-Path (Join-Path (Split-Path $JSONFilePath -Parent) ($Parameter.'$ref' -split '#')[0])
                $fileContent = Get-Content -Path $filePath | ConvertFrom-Json -AsHashtable
`               $identifier = Split-Path $Parameter.'$ref' -Leaf

                $inputObject = @{
                    JSONFilePath      = $JSONFilePath
                    SpecificationData = $fileContent
                    Parameter         = $fileContent.definitions[$identifier]
                }
                return Resolve-SpecPropertyReference @inputObject
            }
        }
    }
    else {
        return @{
            parameter         = $Parameter
            specificationData = $SpecificationData
        }
    }
}