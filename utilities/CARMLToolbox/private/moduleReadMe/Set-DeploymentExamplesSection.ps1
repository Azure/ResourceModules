<#
.SYNOPSIS
Generate 'Deployment examples' for the ReadMe out of the parameter files currently used to test the template

.DESCRIPTION
Generate 'Deployment examples' for the ReadMe out of the parameter files currently used to test the template

.PARAMETER ModuleRoot
Mandatory. The file path to the module's root

.PARAMETER FullModuleIdentifier
Mandatory. The full identifier of the module (i.e., ProviderNamespace + ResourceType)

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Deployment examples'

.PARAMETER addJson
Optional. A switch to control whether or not to add a ARM-JSON-Parameter file example. Defaults to true.

.PARAMETER addBicep
Optional. A switch to control whether or not to add a Bicep deployment example. Defaults to true.

.EXAMPLE
Set-DeploymentExamplesSection -ModuleRoot 'C:/Microsoft.KeyVault/vaults' -FullModuleIdentifier 'Microsoft.KeyVault/vaults' -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Deployment Examples' section based on the given template file content
#>
function Set-DeploymentExamplesSection {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleRoot,

        [Parameter(Mandatory = $true)]
        [string] $FullModuleIdentifier,

        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory = $true)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [bool] $addJson = $true,

        [Parameter(Mandatory = $false)]
        [bool] $addBicep = $true,

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Deployment examples'
    )

    # Process content
    $SectionContent = [System.Collections.ArrayList]@(
        'The following module usage examples are retrieved from the content of the files hosted in the module''s `.test` folder.',
        '   >**Note**: The name of each example is based on the name of the file from which it is taken.',
        '',
        '   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.',
        ''
    )

    # Get resource type and make first letter upper case. Requires manual handling as ToTitleCase lowercases everything but the first letter
    $providerNamespace = ($fullModuleIdentifier.Split('/')[0] -split '\.' | ForEach-Object { $_.Substring(0, 1).ToUpper() + $_.Substring(1) }) -join '.'
    $resourceType = $fullModuleIdentifier.Split('/')[1]
    $resourceTypeUpper = $resourceType.Substring(0, 1).ToUpper() + $resourceType.Substring(1)

    $FullModuleIdentifier = "$providerNamespace/$resourceType"

    $testFilePaths = Get-ModuleTestFileList -ModulePath $moduleRoot | ForEach-Object { Join-Path $moduleRoot $_ }

    $RequiredParametersList = $TemplateFileContent.parameters.Keys | Where-Object { $TemplateFileContent.parameters[$_].Keys -notcontains 'defaultValue' } | Sort-Object

    ############################
    ##   Process test files   ##
    ############################
    $pathIndex = 1
    foreach ($testFilePath in $testFilePaths) {

        # Read content
        $rawContentArray = Get-Content -Path $testFilePath
        $rawContent = Get-Content -Path $testFilePath -Encoding 'utf8' | Out-String

        # Format example header
        if ((Split-Path (Split-Path $testFilePath -Parent) -Leaf) -ne '.test') {
            $exampleTitle = Split-Path (Split-Path $testFilePath -Parent) -Leaf
        } else {
            $exampleTitle = ((Split-Path $testFilePath -LeafBase) -replace '\.', ' ') -replace ' parameters', ''
        }
        $textInfo = (Get-Culture -Name 'en-US').TextInfo
        $exampleTitle = $textInfo.ToTitleCase($exampleTitle)
        $SectionContent += @(
            '<h3>Example {0}: {1}</h3>' -f $pathIndex, $exampleTitle
        )

        ## ----------------------------------- ##
        ##   Handle by type (Bicep vs. JSON)   ##
        ## ----------------------------------- ##
        if ((Split-Path $testFilePath -Extension) -eq '.bicep') {

            # ------------------------- #
            #   Prepare Bicep to JSON   #
            # ------------------------- #

            # [1/6] Search for the relevant parameter start & end index
            $bicepTestStartIndex = ($rawContentArray | Select-String ("^module testDeployment '..\/.*deploy.bicep' = {$") | ForEach-Object { $_.LineNumber - 1 })[0]

            $bicepTestEndIndex = $bicepTestStartIndex
            do {
                $bicepTestEndIndex++
            } while ($rawContentArray[$bicepTestEndIndex] -ne '}')

            $rawBicepExample = $rawContentArray[$bicepTestStartIndex..$bicepTestEndIndex]

            # [2/6] Replace placeholders
            $serviceShort = ([regex]::Match($rawContent, "(?m)^param serviceShort string = '(.+)'\s*$")).Captures.Groups[1].Value

            $rawBicepExampleString = ($rawBicepExample | Out-String)
            $rawBicepExampleString = $rawBicepExampleString -replace '\$\{serviceShort\}', $serviceShort
            $rawBicepExampleString = $rawBicepExampleString -replace '\$\{namePrefix\}', '' # Replacing with empty to not expose prefix and avoid potential deployment conflicts
            $rawBicepExampleString = $rawBicepExampleString -replace '(?m):\s*location\s*$', ': ''<location>'''

            # [3/6] Format header, remove scope property & any empty line
            $rawBicepExample = $rawBicepExampleString -split '\n'
            $rawBicepExample[0] = "module $resourceType './$FullModuleIdentifier/deploy.bicep' = {"
            $rawBicepExample = $rawBicepExample | Where-Object { $_ -notmatch 'scope: *' } | Where-Object { -not [String]::IsNullOrEmpty($_) }

            # [4/6] Extract param block
            $rawBicepExampleArray = $rawBicepExample -split '\n'
            $moduleDeploymentPropertyIndent = ([regex]::Match($rawBicepExampleArray[1], '^(\s+).*')).Captures.Groups[1].Value.Length
            $paramsStartIndex = ($rawBicepExampleArray | Select-String ("^[\s]{$moduleDeploymentPropertyIndent}params:[\s]*\{") | ForEach-Object { $_.LineNumber - 1 })[0] + 1
            if ($rawBicepExampleArray[$paramsStartIndex].Trim() -ne '}') {
                # Handle case where param block is empty
                $paramsEndIndex = ($rawBicepExampleArray[($paramsStartIndex + 1)..($rawBicepExampleArray.Count)] | Select-String "^[\s]{$moduleDeploymentPropertyIndent}\}" | ForEach-Object { $_.LineNumber - 1 })[0] + $paramsStartIndex
                $paramBlock = ($rawBicepExampleArray[$paramsStartIndex..$paramsEndIndex] | Out-String).TrimEnd()
            } else {
                $paramBlock = ''
                $paramsEndIndex = $paramsStartIndex
            }

            # [5/6] Convert Bicep parameter block to JSON parameter block to enable processing
            $conversionInputObject = @{
                BicepParamBlock = $paramBlock
            }
            $paramsInJSONFormat = ConvertTo-FormattedJSONParameterObject @conversionInputObject

            # [6/6] Convert JSON parameters back to Bicep and order & format them
            $conversionInputObject = @{
                JSONParameters         = $paramsInJSONFormat
                RequiredParametersList = $RequiredParametersList
            }
            $bicepExample = ConvertTo-FormattedBicep @conversionInputObject

            # --------------------- #
            #   Add Bicep example   #
            # --------------------- #
            if ($addBicep) {

                if ([String]::IsNullOrEmpty($paramBlock)) {
                    # Handle case where param block is empty
                    $formattedBicepExample = $rawBicepExample[0..($paramsStartIndex - 1)] + $rawBicepExample[($paramsEndIndex)..($rawBicepExample.Count)]
                } else {
                    $formattedBicepExample = $rawBicepExample[0..($paramsStartIndex - 1)] + ($bicepExample -split '\n') + $rawBicepExample[($paramsEndIndex + 1)..($rawBicepExample.Count)]
                }

                $SectionContent += @(
                    '',
                    '<details>'
                    ''
                    '<summary>via Bicep module</summary>'
                    ''
                    '```bicep',
                    ($formattedBicepExample | ForEach-Object { "$_" }).TrimEnd(),
                    '```',
                    '',
                    '</details>',
                    '<p>'
                )
            }

            # -------------------- #
            #   Add JSON example   #
            # -------------------- #
            if ($addJson) {

                # [1/2] Get all parameters from the parameter object and order them recursively
                $orderingInputObject = @{
                    ParametersJSON         = $paramsInJSONFormat | ConvertTo-Json -Depth 99
                    RequiredParametersList = $RequiredParametersList
                }
                $orderedJSONExample = Build-OrderedJSONObject @orderingInputObject

                # [2/2] Create the final content block
                $SectionContent += @(
                    '',
                    '<details>'
                    ''
                    '<summary>via JSON Parameter file</summary>'
                    ''
                    '```json',
                    $orderedJSONExample.Trim()
                    '```',
                    '',
                    '</details>',
                    '<p>'
                )
            }
        } else {
            # ------------------------- #
            #   Prepare JSON to Bicep   #
            # ------------------------- #

            $rawContentHashtable = $rawContent | ConvertFrom-Json -Depth 99 -AsHashtable -NoEnumerate

            # First we need to check if we're dealing with classic JSON-Parameter file, or a deployment test file (which contains resource deployments & parameters)
            $isParameterFile = $rawContentHashtable.'$schema' -like '*deploymentParameters*'
            if (-not $isParameterFile) {
                # Case 1: Uses deployment test file (instead of parameter file).
                # [1/3]  Need to extract parameters. The target is to get an object which 1:1 represents a classic JSON-Parameter file (aside from KeyVault references)
                $testResource = $rawContentHashtable.resources | Where-Object { $_.name -like '*-test-*' }

                # [2/3] Build the full ARM-JSON parameter file
                $jsonParameterContent = [ordered]@{
                    '$schema'      = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
                    contentVersion = '1.0.0.0'
                    parameters     = $testResource.properties.parameters
                }
                $jsonParameterContent = ($jsonParameterContent | ConvertTo-Json -Depth 99).TrimEnd()

                # [3/3]  Remove 'externalResourceReferences' that are generated for Bicep's 'existing' resource references. Removing them will make the file more readable
                $jsonParameterContentArray = $jsonParameterContent -split '\n'
                foreach ($row in ($jsonParameterContentArray | Where-Object { $_ -like '*reference(extensionResourceId*' })) {
                    $expectedValue = ([regex]::Match($row, '.+\[reference\(extensionResourceId.+\.(.+)\.value\]"')).Captures.Groups[1].Value
                    $toReplaceValue = ([regex]::Match($row, '"(\[reference\(extensionResourceId.+)"')).Captures.Groups[1].Value

                    $jsonParameterContent = $jsonParameterContent.Replace($toReplaceValue, ('<{0}>' -f $expectedValue))
                }
            } else {
                # Case 2: Uses ARM-JSON parameter file
                $jsonParameterContent = $rawContent.TrimEnd()
            }

            # --------------------- #
            #   Add Bicep example   #
            # --------------------- #
            if ($addBicep) {

                # [1/5] Get all parameters from the parameter object
                $JSONParametersHashTable = (ConvertFrom-Json $jsonParameterContent -AsHashtable -Depth 99).parameters

                # [2/5] Handle the special case of Key Vault secret references (that have a 'reference' instead of a 'value' property)
                # [2.1] Find all references and split them into managable objects
                $keyVaultReferences = $JSONParametersHashTable.Keys | Where-Object { $JSONParametersHashTable[$_].Keys -contains 'reference' }

                if ($keyVaultReferences.Count -gt 0) {
                    $keyVaultReferenceData = @()
                    foreach ($reference in $keyVaultReferences) {
                        $resourceIdElem = $JSONParametersHashTable[$reference].reference.keyVault.id -split '/'
                        $keyVaultReferenceData += @{
                            subscriptionId    = $resourceIdElem[2]
                            resourceGroupName = $resourceIdElem[4]
                            vaultName         = $resourceIdElem[-1]
                            secretName        = $JSONParametersHashTable[$reference].reference.secretName
                            parameterName     = $reference
                        }
                    }
                }

                # [2.2] Remove any duplicates from the referenced key vaults and build 'existing' Key Vault references in Bicep format from them.
                #        Also, add a link to the corresponding Key Vault 'resource' to each identified Key Vault secret reference
                $extendedKeyVaultReferences = @()
                $counter = 0
                foreach ($reference in ($keyVaultReferenceData | Sort-Object -Property 'vaultName' -Unique)) {
                    $counter++
                    $extendedKeyVaultReferences += @(
                        "resource kv$counter 'Microsoft.KeyVault/vaults@2019-09-01' existing = {",
                    ("  name: '{0}'" -f $reference.vaultName),
                    ("  scope: resourceGroup('{0}','{1}')" -f $reference.subscriptionId, $reference.resourceGroupName),
                        '}',
                        ''
                    )

                    # Add attribute for later correct reference
                    $keyVaultReferenceData | Where-Object { $_.vaultName -eq $reference.vaultName } | ForEach-Object {
                        $_['vaultResourceReference'] = "kv$counter"
                    }
                }

                # [3/5] Remove the 'value' property from each parameter
                #      If we're handling a classic ARM-JSON parameter file that includes replacing all 'references' with the link to one of the 'existing' Key Vault resources
                if ((ConvertFrom-Json $rawContent -Depth 99).'$schema' -like '*deploymentParameters*') {
                    # If handling a classic parameter file
                    $JSONParameters = (ConvertFrom-Json $rawContent -Depth 99 -AsHashtable -NoEnumerate).parameters
                    $JSONParametersWithoutValue = @{}
                    foreach ($parameterName in $JSONParameters.psbase.Keys) {
                        $keysOnLevel = $JSONParameters[$parameterName].Keys
                        if ($keysOnLevel.count -eq 1 -and $keysOnLevel -eq 'value') {
                            $JSONParametersWithoutValue[$parameterName] = $JSONParameters[$parameterName]['value']
                        } else {
                            # replace key vault references
                            $matchingTuple = $keyVaultReferenceData | Where-Object { $_.parameterName -eq $parameterName }
                            $JSONParametersWithoutValue[$parameterName] = "{0}.getSecret('{1}')" -f $matchingTuple.vaultResourceReference, $matchingTuple.secretName
                        }
                    }
                } else {
                    # If handling a test deployment file
                    $JSONParametersWithoutValue = @{}
                    foreach ($parameter in $JSONParametersHashTable.Keys) {
                        $JSONParametersWithoutValue[$parameter] = $JSONParametersHashTable.$parameter.value
                    }
                }

                # [4/5] Convert the JSON parameters to a Bicep parameters block
                $conversionInputObject = @{
                    JSONParameters         = $JSONParametersWithoutValue
                    RequiredParametersList = $null -ne $RequiredParametersList ? $RequiredParametersList : @()
                }
                $bicepExample = ConvertTo-FormattedBicep @conversionInputObject

                # [5/5] Create the final content block: That means
                # - the 'existing' Key Vault resources
                # - a 'module' header that mimics a module deployment
                # - all parameters in Bicep format
                $SectionContent += @(
                    '',
                    '<details>'
                    ''
                    '<summary>via Bicep module</summary>'
                    ''
                    '```bicep',
                    $extendedKeyVaultReferences,
                    "module $resourceType './$FullModuleIdentifier/deploy.bicep' = {"
                    "  name: '`${uniqueString(deployment().name)}-$resourceTypeUpper'"
                    '  params: {'
                    $bicepExample.TrimEnd(),
                    '  }'
                    '}'
                    '```',
                    '',
                    '</details>'
                    '<p>'
                )
            }

            # -------------------- #
            #   Add JSON example   #
            # -------------------- #
            if ($addJson) {

                # [1/2] Get all parameters from the parameter object and order them recursively
                $orderingInputObject = @{
                    ParametersJSON         = (($jsonParameterContent | ConvertFrom-Json).parameters | ConvertTo-Json -Depth 99)
                    RequiredParametersList = $null -ne $RequiredParametersList ? $RequiredParametersList : @()
                }
                $orderedJSONExample = Build-OrderedJSONObject @orderingInputObject

                # [2/2] Create the final content block
                $SectionContent += @(
                    '',
                    '<details>',
                    '',
                    '<summary>via JSON Parameter file</summary>',
                    '',
                    '```json',
                    $orderedJSONExample.TrimEnd(),
                    '```',
                    '',
                    '</details>'
                    '<p>'
                )
            }
        }

        $SectionContent += @(
            ''
        )

        $pathIndex++
    }

    ######################
    ##   Built result   ##
    ######################
    if ($SectionContent) {
        if ($PSCmdlet.ShouldProcess('Original file with new template references content', 'Merge')) {
            return Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $SectionContent -SectionStartIdentifier $SectionStartIdentifier
        }
    } else {
        return $ReadMeFileContent
    }
}
