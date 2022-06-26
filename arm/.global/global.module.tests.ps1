#Requires -Version 7

param (
    [Parameter(Mandatory = $false)]
    [array] $moduleFolderPaths = ((Get-ChildItem (Split-Path $PSScriptRoot -Parent) -Recurse -Directory -Force).FullName | Where-Object {
        (Get-ChildItem $_ -File -Depth 0 -Include @('deploy.json', 'deploy.bicep') -Force).Count -gt 0
        }),

    # Tokens to test for (i.e. their value should not be used in the parameter files, but their placeholder)
    [Parameter(Mandatory = $false)]
    [hashtable] $enforcedTokenList = @{}
)

$script:RepoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$script:Settings = Get-Content -Path (Join-Path $PSScriptRoot '..\..\settings.json') | ConvertFrom-Json -AsHashtable
$script:RGdeployment = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
$script:Subscriptiondeployment = 'https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#'
$script:MGdeployment = 'https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#'
$script:Tenantdeployment = 'https://schema.management.azure.com/schemas/2019-08-01/tenantDeploymentTemplate.json#'
$script:moduleFolderPaths = $moduleFolderPaths
$script:enforcedTokenList = $enforcedTokenList

# For runtime purposes, we cache the compiled template in a hashtable that uses a formatted relative module path as a key
$script:convertedTemplates = @{}

# Shared exception messages
$script:bicepTemplateCompilationFailedException = "Unable to compile the deploy.bicep template's content. This can happen if there is an error in the template. Please check if you can run the command `az bicep build --file {0} --stdout | ConvertFrom-Json -AsHashtable`." # -f $templateFilePath
$script:jsonTemplateLoadFailedException = "Unable to load the deploy.json template's content. This can happen if there is an error in the template. Please check if you can run the command `Get-Content {0} -Raw | ConvertFrom-Json -AsHashtable`." # -f $templateFilePath
$script:templateNotFoundException = 'No template file found in folder [{0}]' # -f $moduleFolderPath

# Import any helper function used in this test script
Import-Module (Join-Path $PSScriptRoot 'shared\helper.psm1') -Force

Describe 'File/folder tests' -Tag Modules {

    Context 'General module folder tests' {

        $moduleFolderTestCases = [System.Collections.ArrayList] @()
        foreach ($moduleFolderPath in $moduleFolderPaths) {
            $moduleFolderTestCases += @{
                moduleFolderName = $moduleFolderPath.Replace('\', '/').Split('/arm/')[1]
                moduleFolderPath = $moduleFolderPath
                isTopLevelModule = $moduleFolderPath.Replace('\', '/').Split('/arm/')[1].Split('/').Count -eq 2 # <provider>/<resourceType>
            }
        }

        if (Test-Path (Join-Path $repoRoot '.github')) {
            It '[<moduleFolderName>] Module should have a GitHub workflow' -TestCases ($moduleFolderTestCases | Where-Object { $_.isTopLevelModule }) {

                param(
                    [string] $moduleFolderName,
                    [string] $moduleFolderPath
                )

                $workflowsFolderName = Join-Path $RepoRoot '.github' 'workflows'
                $workflowFileName = '{0}.yml' -f $moduleFolderName.Replace('\', '/').Replace('/', '.').Replace('Microsoft', 'ms').ToLower()
                $workflowPath = Join-Path $workflowsFolderName $workflowFileName
                Test-Path $workflowPath | Should -Be $true -Because "path [$workflowPath] should exist."
            }
        }

        if (Test-Path (Join-Path $repoRoot '.azuredevops')) {
            It '[<moduleFolderName>] Module should have an Azure DevOps pipeline' -TestCases ($moduleFolderTestCases | Where-Object { $_.isTopLevelModule }) {

                param(
                    [string] $moduleFolderName,
                    [string] $moduleFolderPath
                )

                $pipelinesFolderName = Join-Path $RepoRoot '.azuredevops' 'modulePipelines'
                $pipelineFileName = '{0}.yml' -f $moduleFolderName.Replace('\', '/').Replace('/', '.').Replace('Microsoft', 'ms').ToLower()
                $pipelinePath = Join-Path $pipelinesFolderName $pipelineFileName
                Test-Path $pipelinePath | Should -Be $true -Because "path [$pipelinePath] should exist."
            }
        }

        It '[<moduleFolderName>] Module should contain a [deploy.json/deploy.bicep] file' -TestCases $moduleFolderTestCases {

            param( [string] $moduleFolderPath )

            $hasARM = (Test-Path (Join-Path -Path $moduleFolderPath 'deploy.json'))
            $hasBicep = (Test-Path (Join-Path -Path $moduleFolderPath 'deploy.bicep'))
            ($hasARM -or $hasBicep) | Should -Be $true
        }

        It '[<moduleFolderName>] Module should contain a [readme.md] file' -TestCases $moduleFolderTestCases {

            param( [string] $moduleFolderPath )
            (Test-Path (Join-Path -Path $moduleFolderPath 'readme.md')) | Should -Be $true
        }

        It '[<moduleFolderName>] Module should contain a [.parameters] folder' -TestCases ($moduleFolderTestCases | Where-Object { $_.isTopLevelModule }) {

            param( [string] $moduleFolderPath )
            Test-Path (Join-Path -Path $moduleFolderPath '.parameters') | Should -Be $true
        }

        It '[<moduleFolderName>] Module should contain a [version.json] file' -TestCases $moduleFolderTestCases {

            param( [string] $moduleFolderPath )
            (Test-Path (Join-Path -Path $moduleFolderPath 'version.json')) | Should -Be $true
        }
    }

    Context '.parameters folder' {

        $folderTestCases = [System.Collections.ArrayList]@()
        foreach ($moduleFolderPath in $moduleFolderPaths) {
            if (Test-Path (Join-Path $moduleFolderPath '.parameters')) {
                $folderTestCases += @{
                    moduleFolderName = $moduleFolderPath.Replace('\', '/').Split('/arm/')[1]
                    moduleFolderPath = $moduleFolderPath
                }
            }
        }

        It '[<moduleFolderName>] folder should contain one or more *parameters.json files' -TestCases $folderTestCases {

            param(
                [string] $moduleFolderName,
                $moduleFolderPath
            )
            $parameterFolderPath = Join-Path $moduleFolderPath '.parameters'
            (Get-ChildItem $parameterFolderPath -Filter '*parameters.json' -Force).Count | Should -BeGreaterThan 0
        }

        $parameterFolderFilesTestCases = [System.Collections.ArrayList] @()
        foreach ($moduleFolderPath in $moduleFolderPaths) {
            $parameterFolderPath = Join-Path $moduleFolderPath '.parameters'
            if (Test-Path $parameterFolderPath) {
                foreach ($parameterFile in (Get-ChildItem $parameterFolderPath -Filter '*parameters.json' -Force)) {
                    $parameterFolderFilesTestCases += @{
                        moduleFolderName  = $moduleFolderPath.Replace('\', '/').Split('/arm/')[1]
                        parameterFilePath = $parameterFile.FullName
                    }
                }
            }
        }

        It '[<moduleFolderName>] *parameters.json files in the .parameters folder should be valid json' -TestCases $parameterFolderFilesTestCases {

            param(
                [string] $moduleFolderName,
                $parameterFilePath
            )
            (Get-Content $parameterFilePath) | ConvertFrom-Json
        }
    }
}

Describe 'Readme tests' -Tag Readme {

    Context 'Readme content tests' {

        $readmeFolderTestCases = [System.Collections.ArrayList] @()
        foreach ($moduleFolderPath in $moduleFolderPaths) {

            # For runtime purposes, we cache the compiled template in a hashtable that uses a formatted relative module path as a key
            $moduleFolderPathKey = $moduleFolderPath.Split('arm')[1].Replace('\', '/').Trim('/').Replace('/', '-')
            if (-not ($convertedTemplates.Keys -contains $moduleFolderPathKey)) {
                if (Test-Path (Join-Path $moduleFolderPath 'deploy.bicep')) {
                    $templateFilePath = Join-Path $moduleFolderPath 'deploy.bicep'
                    $templateContent = az bicep build --file $templateFilePath --stdout --no-restore | ConvertFrom-Json -AsHashtable

                    if (-not $templateContent) {
                        throw ($bicepTemplateCompilationFailedException -f $templateFilePath)
                    }
                } elseIf (Test-Path (Join-Path $moduleFolderPath 'deploy.json')) {
                    $templateFilePath = Join-Path $moduleFolderPath 'deploy.json'
                    $templateContent = Get-Content $templateFilePath -Raw | ConvertFrom-Json -AsHashtable

                    if (-not $templateContent) {
                        throw ($jsonTemplateLoadFailedException -f $templateFilePath)
                    }
                } else {
                    throw ($templateNotFoundException -f $moduleFolderPath)
                }
                $convertedTemplates[$moduleFolderPathKey] = @{
                    templateFilePath = $templateFilePath
                    templateContent  = $templateContent
                }
            } else {
                $templateContent = $convertedTemplates[$moduleFolderPathKey].templateContent
                $templateFilePath = $convertedTemplates[$moduleFolderPathKey].templateFilePath
            }

            $readmeFolderTestCases += @{
                moduleFolderName = $moduleFolderPath.Replace('\', '/').Split('/arm/')[1]
                moduleFolderPath = $moduleFolderPath
                templateContent  = $templateContent
                templateFilePath = $templateFilePath
                readMeFilePath   = Join-Path -Path $moduleFolderPath 'readme.md'
                readMeContent    = Get-Content (Join-Path -Path $moduleFolderPath 'readme.md')
                isTopLevelModule = $moduleFolderPath.Replace('\', '/').Split('/arm/')[1].Split('/').Count -eq 2 # <provider>/<resourceType>
            }
        }

        It '[<moduleFolderName>] Readme.md file should not be empty' -TestCases $readmeFolderTestCases {

            param(
                [string] $moduleFolderName,
                [object[]] $readMeContent
            )
            $readMeContent | Should -Not -Be $null
        }

        It '[<moduleFolderName>] Readme.md file should contain these sections in order: Navigation, Resource Types, Parameters, Outputs, Deployment examples' -TestCases $readmeFolderTestCases {

            param(
                [string] $moduleFolderName,
                [object[]] $readMeContent,
                [boolean] $isTopLevelModule
            )

            $expectedHeadersInOrder = @('Navigation', 'Resource types', 'Parameters', 'Outputs')

            if ($isTopLevelModule) {
                # Only top-level modules have parameter files and hence deployment examples
                $expectedHeadersInOrder += 'Deployment examples'
            }

            $actualHeadersInOrder = $readMeContent | Where-Object { $_ -like '#*' } | ForEach-Object { ($_ -replace '#', '').TrimStart() }

            $filteredActuals = $actualHeadersInOrder | Where-Object { $expectedHeadersInOrder -contains $_ }

            $missingHeaders = $expectedHeadersInOrder | Where-Object { $actualHeadersInOrder -notcontains $_ }
            $missingHeaders.Count | Should -Be 0 -Because ('the list of missing headers [{0}] should be empty' -f ($missingHeaders -join ','))

            $filteredActuals | Should -Be $expectedHeadersInOrder -Because 'the headers should exist in the expected order'
        }

        It '[<moduleFolderName>] Resources section should contain all resources from the template file' -TestCases $readmeFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent,
                [object[]] $readMeContent
            )

            # Get ReadMe data
            $tableStartIndex, $tableEndIndex = Get-TableStartAndEndIndex -ReadMeContent $readMeContent -MarkdownSectionIdentifier '*# Resource Types'

            $ReadMeResourcesList = [System.Collections.ArrayList]@()
            for ($index = $tableStartIndex + 2; $index -lt $tableEndIndex; $index++) {
                $ReadMeResourcesList += $readMeContent[$index].Split('|')[1].Replace('`', '').Trim()
            }

            # Get template data
            $templateResources = (Get-NestedResourceList -TemplateFileContent $templateContent | Where-Object {
                    $_.type -notin @('Microsoft.Resources/deployments') -and $_ }).type | Select-Object -Unique

            # Compare
            $differentiatingItems = $templateResources | Where-Object { $ReadMeResourcesList -notcontains $_ }
            $differentiatingItems.Count | Should -Be 0 -Because ("list of template resources missing from the ReadMe's list [{0}] should be empty" -f ($differentiatingItems -join ','))
        }

        It '[<moduleFolderName>] Resources section should not contain more resources than the template file' -TestCases $readmeFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent,
                [object[]] $readMeContent
            )

            # Get ReadMe data
            $tableStartIndex, $tableEndIndex = Get-TableStartAndEndIndex -ReadMeContent $readMeContent -MarkdownSectionIdentifier '*# Resource Types'

            $ReadMeResourcesList = [System.Collections.ArrayList]@()
            for ($index = $tableStartIndex + 2; $index -lt $tableEndIndex; $index++) {
                $ReadMeResourcesList += $readMeContent[$index].Split('|')[1].Replace('`', '').Trim()
            }

            # Get template data
            $templateResources = (Get-NestedResourceList -TemplateFileContent $templateContent | Where-Object {
                    $_.type -notin @('Microsoft.Resources/deployments') -and $_ }).type | Select-Object -Unique

            # Compare
            $differentiatingItems = $templateResources | Where-Object { $ReadMeResourcesList -notcontains $_ }
            $differentiatingItems.Count | Should -Be 0 -Because ("list of resources in the ReadMe's list [{0}] not in the template file should be empty" -f ($differentiatingItems -join ','))
        }

        It '[<moduleFolderName>] Parameters section should contain a table for each existing parameter category in the following order: Required, Conditional, Optional, Generated' -TestCases $readmeFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent,
                [object[]] $readMeContent
            )

            $expectColumnsInOrder = @('Required', 'Conditional', 'Optional', 'Generated')

            ## Get all descriptions
            $descriptions = $templateContent.parameters.Values.metadata.description

            ## Get the module parameter categories
            $expectedParamCategories = $descriptions | ForEach-Object { $_.Split('.')[0] } | Select-Object -Unique # Get categories in template
            $expectedParamCategoriesInOrder = $expectColumnsInOrder | Where-Object { $_ -in $expectedParamCategories } # add required ones in order
            $expectedParamCategoriesInOrder += $expectedParamCategories | Where-Object { $_ -notin $expectColumnsInOrder } # add non-required ones after

            $actualParamCategories = $readMeContent | Select-String -Pattern '^\*\*(.+) parameters\*\*$' -AllMatches | ForEach-Object { $_.Matches.Groups[1].Value } # get actual in readme

            $actualParamCategories | Should -Be $expectedParamCategoriesInOrder
        }

        It '[<moduleFolderName>] parameter tables should provide columns in the following order: Parameter Name, Type, Default Value, Allowed Values, Description. Each column should be present unless empty for all the rows.' -TestCases $readmeFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent,
                [object[]] $readMeContent
            )

            ## Get all descriptions
            $descriptions = $templateContent.parameters.Values.metadata.description

            ## Get the module parameter categories
            $paramCategories = $descriptions | ForEach-Object { $_.Split('.')[0] } | Select-Object -Unique

            foreach ($paramCategory in $paramCategories) {

                # Filter to relevant items
                [array] $categoryParameters = $templateContent.parameters.Values | Where-Object { $_.metadata.description -like "$paramCategory. *" } | Sort-Object -Property 'Name' -Culture 'en-US'

                # Check properties for later reference
                $shouldHaveDefault = $categoryParameters.defaultValue.count -gt 0
                $shouldHaveAllowed = $categoryParameters.allowedValues.count -gt 0

                $expectedColumnsInOrder = @('Parameter Name', 'Type')
                if ($shouldHaveDefault) { $expectedColumnsInOrder += @('Default Value') }
                if ($shouldHaveAllowed) { $expectedColumnsInOrder += @('Allowed Values') }
                $expectedColumnsInOrder += @('Description')

                $readMeCategoryIndex = $readMeContent | Select-String -Pattern "^\*\*$paramCategory parameters\*\*$" | ForEach-Object { $_.LineNumber }
                $readmeCategoryColumns = ($readMeContent[$readMeCategoryIndex] -split '\|') | ForEach-Object { $_.Trim() } | Where-Object { -not [String]::IsNullOrEmpty($_) }

                $readmeCategoryColumns | Should -Be $expectedColumnsInOrder
            }
        }

        It '[<moduleFolderName>] Parameters section should contain all parameters from the template file' -TestCases $readmeFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent,
                [object[]] $readMeContent
            )

            # Get Template data
            $parameters = $templateContent.parameters.Keys

            # Get ReadMe data
            ## Get section start index
            $sectionStartIndex = Get-MarkdownSectionStartIndex -ReadMeContent $readMeContent -MarkdownSectionIdentifier '*# Parameters'

            if ($sectionStartIndex -ge $readMeContent.count) {
                throw 'Parameters section is missing in the Readme. Please add and re-run the tests.'
            }

            $parametersSectionEndIndex = Get-MarkdownSectionEndIndex -ReadMeContent $readMeContent -SectionStartIndex $sectionStartIndex

            ## Iterate over all parameter tables
            $parametersList = [System.Collections.ArrayList]@()
            $sectionIndex = $sectionStartIndex
            while ($sectionIndex -lt $parametersSectionEndIndex) {
                ### Get table start index
                $parametersTableStartIndex = $sectionIndex
                while ($readMeContent[$parametersTableStartIndex] -notlike '*|*' -and -not ($parametersTableStartIndex -ge $readMeContent.count)) {
                    $parametersTableStartIndex++
                }
                Write-Verbose ("[loop] Start row of the parameter table: $parametersTableStartIndex")

                ### Get table end index
                $parametersTableEndIndex = $parametersTableStartIndex + 2 # Header row + table separator row
                while ($readMeContent[$parametersTableEndIndex] -like '*|*' -and -not ($parametersTableEndIndex -ge $readMeContent.count)) {
                    $parametersTableEndIndex++
                }
                Write-Verbose ("[loop] End row of the parameter table: $parametersTableEndIndex")

                for ($tableIndex = $parametersTableStartIndex + 2; $tableIndex -lt $parametersTableEndIndex; $tableIndex++) {
                    $parametersList += $readMeContent[$tableIndex].Split('|')[1].Replace('`', '').Trim()
                }
                $sectionIndex = $parametersTableEndIndex + 1
            }

            # Test
            $differentiatingItems = $parameters | Where-Object { $parametersList -notcontains $_ }
            $differentiatingItems.Count | Should -Be 0 -Because ('list of template parameters missing in the ReadMe file [{0}] should be empty' -f ($differentiatingItems -join ','))
        }

        It '[<moduleFolderName>] Outputs section should contain a table with these column names in order: Output Name, Type' -TestCases $readmeFolderTestCases {

            param(
                [string] $moduleFolderName,
                $readMeContent
            )

            $tableStartIndex, $tableEndIndex = Get-TableStartAndEndIndex -ReadMeContent $readMeContent -MarkdownSectionIdentifier '*# Outputs'

            $outputsTableHeader = $readMeContent[$tableStartIndex].Split('|').Trim() | Where-Object { -not [String]::IsNullOrEmpty($_) }

            # Test
            $expectedOutputsTableOrder = @('Output Name', 'Type')
            $differentiatingItems = $expectedOutputsTableOrder | Where-Object { $outputsTableHeader -notcontains $_ }
            $differentiatingItems.Count | Should -Be 0 -Because ('list of "Outputs" table columns missing in the ReadMe file [{0}] should be empty' -f ($differentiatingItems -join ','))
        }

        It '[<moduleFolderName>] Output section should contain all outputs defined in the template file' -TestCases $readmeFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent,
                [object[]] $readMeContent
            )

            # Get ReadMe data
            $tableStartIndex, $tableEndIndex = Get-TableStartAndEndIndex -ReadMeContent $readMeContent -MarkdownSectionIdentifier '*# Outputs'

            $ReadMeOutputsList = [System.Collections.ArrayList]@()
            for ($index = $tableStartIndex + 2; $index -lt $tableEndIndex; $index++) {
                $ReadMeOutputsList += $readMeContent[$index].Split('|')[1].Replace('`', '').Trim()
            }

            # Template data
            $expectedOutputs = $templateContent.outputs.Keys

            # Test
            $differentiatingItems = $expectedOutputs | Where-Object { $ReadMeOutputsList -notcontains $_ }
            $differentiatingItems.Count | Should -Be 0 -Because ('list of template outputs missing in the ReadMe file [{0}] should be empty' -f ($differentiatingItems -join ','))

            $differentiatingItems = $ReadMeOutputsList | Where-Object { $expectedOutputs -notcontains $_ }
            $differentiatingItems.Count | Should -Be 0 -Because ('list of excess template outputs defined in the ReadMe file [{0}] should be empty' -f ($differentiatingItems -join ','))
        }

        It '[<moduleFolderName>] Set-ModuleReadMe script should not apply any updates' -TestCases $readmeFolderTestCases {

            param(
                [string] $moduleFolderName,
                [string] $templateFilePath,
                [hashtable] $templateContent,
                [string] $readMeFilePath
            )

            # Get current hash
            $fileHashBefore = (Get-FileHash $readMeFilePath).Hash

            # Load function
            . (Join-Path $repoRoot 'utilities' 'tools' 'Set-ModuleReadMe.ps1')

            # Apply update with already compiled template content
            Set-ModuleReadMe -TemplateFilePath $templateFilePath -TemplateFileContent $templateContent

            # Get hash after 'update'
            $fileHashAfter = (Get-FileHash $readMeFilePath).Hash

            # Compare
            $filesAreTheSame = $fileHashBefore -eq $fileHashAfter
            if (-not $filesAreTheSame) {
                $diffReponse = git diff
                Write-Warning ($diffReponse | Out-String) -Verbose
            }
            $filesAreTheSame | Should -Be $true -Because 'The file hashes before and after applying the Set-ModuleReadMe function should be identical'
        }
    }
}

Describe 'Deployment template tests' -Tag Template {

    Context 'Deployment template tests' {

        $deploymentFolderTestCases = [System.Collections.ArrayList] @()
        foreach ($moduleFolderPath in $moduleFolderPaths) {

            # For runtime purposes, we cache the compiled template in a hashtable that uses a formatted relative module path as a key
            $moduleFolderPathKey = $moduleFolderPath.Split('arm')[1].Replace('\', '/').Trim('/').Replace('/', '-')
            if (-not ($convertedTemplates.Keys -contains $moduleFolderPathKey)) {
                if (Test-Path (Join-Path $moduleFolderPath 'deploy.bicep')) {
                    $templateFilePath = Join-Path $moduleFolderPath 'deploy.bicep'
                    $templateContent = az bicep build --file $templateFilePath --stdout --no-restore | ConvertFrom-Json -AsHashtable

                    if (-not $templateContent) {
                        throw ($bicepTemplateCompilationFailedException -f $templateFilePath)
                    }
                } elseIf (Test-Path (Join-Path $moduleFolderPath 'deploy.json')) {
                    $templateFilePath = Join-Path $moduleFolderPath 'deploy.json'
                    $templateContent = Get-Content $templateFilePath -Raw | ConvertFrom-Json -AsHashtable

                    if (-not $templateContent) {
                        throw ($jsonTemplateLoadFailedException -f $templateFilePath)
                    }
                } else {
                    throw ($templateNotFoundException -f $moduleFolderPath)
                }
                $convertedTemplates[$moduleFolderPathKey] = @{
                    templateFilePath = $templateFilePath
                    templateContent  = $templateContent
                }
            } else {
                $templateContent = $convertedTemplates[$moduleFolderPathKey].templateContent
                $templateFilePath = $convertedTemplates[$moduleFolderPathKey].templateFilePath
            }

            # Parameter file test cases
            $parameterFileTestCases = @()
            $templateFile_Parameters = $templateContent.parameters
            $TemplateFile_AllParameterNames = $templateFile_Parameters.Keys | Sort-Object
            $TemplateFile_RequiredParametersNames = ($templateFile_Parameters.Keys | Where-Object { -not $templateFile_Parameters[$_].ContainsKey('defaultValue') }) | Sort-Object

            if (Test-Path (Join-Path $moduleFolderPath '.parameters')) {
                $ParameterFilePaths = (Get-ChildItem (Join-Path -Path $moduleFolderPath -ChildPath '.parameters' -AdditionalChildPath '*parameters.json') -Recurse -Force).FullName
                foreach ($ParameterFilePath in $ParameterFilePaths) {
                    $parameterFile_AllParameterNames = ((Get-Content $ParameterFilePath) | ConvertFrom-Json -AsHashtable).parameters.Keys | Sort-Object
                    $parameterFileTestCases += @{
                        parameterFile_Path                   = $ParameterFilePath
                        parameterFile_Name                   = Split-Path $ParameterFilePath -Leaf
                        parameterFile_AllParameterNames      = $parameterFile_AllParameterNames
                        templateFile_AllParameterNames       = $TemplateFile_AllParameterNames
                        templateFile_RequiredParametersNames = $TemplateFile_RequiredParametersNames
                        tokenSettings                        = $Settings.parameterFileTokens
                    }
                }
            }

            # Test file setup
            $deploymentFolderTestCases += @{
                moduleFolderName       = $moduleFolderPath.Replace('\', '/').Split('/arm/')[1]
                templateContent        = $templateContent
                templateFilePath       = $templateFilePath
                parameterFileTestCases = $parameterFileTestCases
            }
        }

        It '[<moduleFolderName>] the template file should not be empty' -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )
            $templateContent | Should -Not -Be $null
        }

        It '[<moduleFolderName>] Template schema version should be the latest' -TestCases $deploymentFolderTestCases {
            # the actual value changes depending on the scope of the template (RG, subscription, MG, tenant) !!
            # https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-syntax
            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )

            $Schemaverion = $templateContent.'$schema'
            $SchemaArray = @()
            if ($Schemaverion -eq $RGdeployment) {
                $SchemaOutput = $true
            } elseIf ($Schemaverion -eq $Subscriptiondeployment) {
                $SchemaOutput = $true
            } elseIf ($Schemaverion -eq $MGdeployment) {
                $SchemaOutput = $true
            } elseIf ($Schemaverion -eq $Tenantdeployment) {
                $SchemaOutput = $true
            } else {
                $SchemaOutput = $false
            }
            $SchemaArray += $SchemaOutput
            $SchemaArray | Should -Not -Contain $false
        }

        It '[<moduleFolderName>] Template schema should use HTTPS reference' -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )
            $Schemaverion = $templateContent.'$schema'
            ($Schemaverion.Substring(0, 5) -eq 'https') | Should -Be $true
        }

        It '[<moduleFolderName>] All apiVersion properties should be set to a static, hard-coded value' -TestCases $deploymentFolderTestCases {
            #https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-best-practices
            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )
            $ApiVersion = $templateContent.resources.apiVersion
            $ApiVersionArray = @()
            foreach ($API in $ApiVersion) {
                if ($API.Substring(0, 2) -eq '20') {
                    $ApiVersionOutput = $true
                } elseIf ($API.substring(1, 10) -eq 'parameters') {
                    # An API version should not be referenced as a parameter
                    $ApiVersionOutput = $false
                } elseIf ($API.substring(1, 10) -eq 'variables') {
                    # An API version should not be referenced as a variable
                    $ApiVersionOutput = $false
                } else {
                    $ApiVersionOutput = $false
                }
                $ApiVersionArray += $ApiVersionOutput
            }
            $ApiVersionArray | Should -Not -Contain $false
        }

        It '[<moduleFolderName>] the template file should contain required elements: schema, contentVersion, resources' -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )
            $templateContent.Keys | Should -Contain '$schema'
            $templateContent.Keys | Should -Contain 'contentVersion'
            $templateContent.Keys | Should -Contain 'resources'
        }

        It '[<moduleFolderName>] If delete lock is implemented, the template should have a lock parameter with the default value of ['''']' -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )
            if ($lock = $templateContent.parameters.lock) {
                $lock.Keys | Should -Contain 'defaultValue'
                $lock.defaultValue | Should -Be ''
            }
        }

        It '[<moduleFolderName>] Parameter names should be camel-cased (no dashes or underscores and must start with lower-case letter)' -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )

            if (-not $templateContent.parameters) {
                Set-ItResult -Skipped -Because 'the module template has no parameters.'
                return
            }

            $CamelCasingFlag = @()
            $Parameter = $templateContent.parameters.Keys
            foreach ($Param in $Parameter) {
                if ($Param.substring(0, 1) -cnotmatch '[a-z]' -or $Param -match '-' -or $Param -match '_') {
                    $CamelCasingFlag += $false
                } else {
                    $CamelCasingFlag += $true
                }
            }
            $CamelCasingFlag | Should -Not -Contain $false
        }

        It '[<moduleFolderName>] Variable names should be camel-cased (no dashes or underscores and must start with lower-case letter)' -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )

            if (-not $templateContent.variables) {
                Set-ItResult -Skipped -Because 'the module template has no variables.'
                return
            }

            $CamelCasingFlag = @()
            $Variable = $templateContent.variables.Keys

            foreach ($Variab in $Variable) {
                if ($Variab.substring(0, 1) -cnotmatch '[a-z]' -or $Variab -match '-') {
                    $CamelCasingFlag += $false
                } else {
                    $CamelCasingFlag += $true
                }
            }
            $CamelCasingFlag | Should -Not -Contain $false
        }

        It '[<moduleFolderName>] Output names should be camel-cased (no dashes or underscores and must start with lower-case letter)' -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )
            $CamelCasingFlag = @()
            $Outputs = $templateContent.outputs.Keys

            foreach ($Output in $Outputs) {
                if ($Output.substring(0, 1) -cnotmatch '[a-z]' -or $Output -match '-' -or $Output -match '_') {
                    $CamelCasingFlag += $false
                } else {
                    $CamelCasingFlag += $true
                }
            }
            $CamelCasingFlag | Should -Not -Contain $false
        }

        It '[<moduleFolderName>] CUA ID deployment should be present in the template' -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )
            $enableDefaultTelemetryFlag = @()
            $Schemaverion = $templateContent.'$schema'
            if ((($Schemaverion.Split('/')[5]).Split('.')[0]) -eq (($RGdeployment.Split('/')[5]).Split('.')[0])) {
                if (($templateContent.resources.type -ccontains 'Microsoft.Resources/deployments' -and $templateContent.resources.condition -like "*[parameters('enableDefaultTelemetry')]*") -or ($templateContent.resources.resources.type -ccontains 'Microsoft.Resources/deployments' -and $templateContent.resources.resources.condition -like "*[parameters('enableDefaultTelemetry')]*")) {
                    $enableDefaultTelemetryFlag += $true
                } else {
                    $enableDefaultTelemetryFlag += $false
                }
            }
            $enableDefaultTelemetryFlag | Should -Not -Contain $false
        }

        It "[<moduleFolderName>] The Location should be defined as a parameter, with the default value of 'resourceGroup().Location' or global for ResourceGroup deployment scope" -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )
            $LocationFlag = $true
            $Schemaverion = $templateContent.'$schema'
            if ((($Schemaverion.Split('/')[5]).Split('.')[0]) -eq (($RGdeployment.Split('/')[5]).Split('.')[0])) {
                $Locationparamoutputvalue = $templateContent.parameters.location.defaultValue
                $Locationparamoutput = $templateContent.parameters.Keys
                if ($Locationparamoutput -contains 'Location') {
                    if ($Locationparamoutputvalue -eq '[resourceGroup().Location]' -or $Locationparamoutputvalue -eq 'global') {
                        $LocationFlag = $true
                    } else {

                        $LocationFlag = $false
                    }
                    $LocationFlag | Should -Contain $true
                }
            }
        }

        It '[<moduleFolderName>] Location output should be returned for resources that use it' -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent,
                [string] $templateFilePath
            )

            $outputs = $templateContent.outputs

            $primaryResourceType = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').split('/arm/')[1]
            $primaryResourceTypeResource = $templateContent.resources | Where-Object { $_.type -eq $primaryResourceType }

            if ($primaryResourceTypeResource.keys -contains 'location' -and $primaryResourceTypeResource.location -ne 'global') {
                # If the main resource has a location property, an output should be returned too
                $outputs.keys | Should -Contain 'location'

                # It should further reference the location property of the primary resource and not e.g. the location input parameter
                $outputs.location.value | Should -Match $primaryResourceType
            }
        }

        It '[<moduleFolderName>] Resource Group output should exist for resources that are deployed into a resource group scope' -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent,
                [string] $templateFilePath
            )

            $outputs = $templateContent.outputs.Keys
            $deploymentScope = Get-ScopeOfTemplateFile -TemplateFilePath $templateFilePath

            if ($deploymentScope -eq 'resourceGroup') {
                $outputs | Should -Contain 'resourceGroupName'
            }
        }

        It '[<moduleFolderName>] Resource name output should exist' -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent,
                $templateFilePath
            )

            # check if module contains a 'primary' resource we could draw a name from
            $moduleResourceType = (Split-Path (($templateFilePath -replace '\\', '/') -split '/arm/')[1] -Parent) -replace '\\', '/'
            if ($templateContent.resources.type -notcontains $moduleResourceType) {
                Set-ItResult -Skipped -Because 'the module template has no primary resource to fetch a name from.'
                return
            }

            # Otherwise test for standard outputs
            $outputs = $templateContent.outputs.Keys
            $outputs | Should -Contain 'name'
        }

        It '[<moduleFolderName>] Resource ID output should exist' -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent,
                $templateFilePath
            )

            # check if module contains a 'primary' resource we could draw a name from
            $moduleResourceType = (Split-Path (($templateFilePath -replace '\\', '/') -split '/arm/')[1] -Parent) -replace '\\', '/'
            if ($templateContent.resources.type -notcontains $moduleResourceType) {
                Set-ItResult -Skipped -Because 'the module template has no primary resource to fetch a resource ID from.'
                return
            }

            # Otherwise test for standard outputs
            $outputs = $templateContent.outputs.Keys
            $outputs | Should -Contain 'resourceId'
        }

        It "[<moduleFolderName>] parameters' description should start with a one word category starting with a capital letter, followed by a dot, a space and the actual description text ending with a dot." -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )

            if (-not $templateContent.parameters) {
                Set-ItResult -Skipped -Because 'the module template has no parameters.'
                return
            }

            $incorrectParameters = @()
            $templateParameters = $templateContent.parameters.Keys
            foreach ($parameter in $templateParameters) {
                $data = ($templateContent.parameters.$parameter.metadata).description
                if ($data -notmatch '(?s)^[A-Z][a-zA-Z]+\. .+\.$') {
                    $incorrectParameters += $parameter
                }
            }
            $incorrectParameters | Should -BeNullOrEmpty
        }

        It "[<moduleFolderName>] Conditional parameters' description should contain 'Required if' followed by the condition making the parameter required." -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )

            if (-not $templateContent.parameters) {
                Set-ItResult -Skipped -Because 'the module template has no parameters.'
                return
            }

            $incorrectParameters = @()
            $templateParameters = $templateContent.parameters.Keys
            foreach ($parameter in $templateParameters) {
                $data = ($templateContent.parameters.$parameter.metadata).description
                switch -regex ($data) {
                    '^Conditional. .*' {
                        if ($data -notmatch '.*\. Required if .*') {
                            $incorrectParameters += $parameter
                        }
                    }
                }
            }
            $incorrectParameters | Should -BeNullOrEmpty
        }

        It "[<moduleFolderName>] outputs' description should start with a capital letter and contain text ending with a dot." -TestCases $deploymentFolderTestCases {

            param(
                [string] $moduleFolderName,
                [hashtable] $templateContent
            )

            if (-not $templateContent.outputs) {
                Set-ItResult -Skipped -Because 'the module template has no outputs.'
                return
            }

            $incorrectOutputs = @()
            $templateOutputs = $templateContent.outputs.Keys
            foreach ($output in $templateOutputs) {
                $data = ($templateContent.outputs.$output.metadata).description
                if ($data -notmatch '(?s)^[A-Z].+\.$') {
                    $incorrectOutputs += $output
                }
            }
            $incorrectOutputs | Should -BeNullOrEmpty
        }

        # PARAMETER Tests
        It '[<moduleFolderName>] All parameters in parameters files exist in template file (deploy.json)' -TestCases $deploymentFolderTestCases {
            param (
                [hashtable[]] $parameterFileTestCases
            )

            foreach ($parameterFileTestCase in $parameterFileTestCases) {
                $parameterFile_AllParameterNames = $parameterFileTestCase.parameterFile_AllParameterNames
                $templateFile_AllParameterNames = $parameterFileTestCase.templateFile_AllParameterNames

                $nonExistentParameters = $parameterFile_AllParameterNames | Where-Object { $templateFile_AllParameterNames -notcontains $_ }
                $nonExistentParameters.Count | Should -Be 0 -Because ('no parameter in the parameter file should not exist in the template file. Found excess items: [{0}]' -f ($nonExistentParameters -join ', '))
            }
        }

        It '[<moduleFolderName>] All required parameters in template file (deploy.json) should exist in parameters files' -TestCases $deploymentFolderTestCases {
            param (
                [hashtable[]] $parameterFileTestCases
            )

            foreach ($parameterFileTestCase in $parameterFileTestCases) {
                $TemplateFile_RequiredParametersNames = $parameterFileTestCase.TemplateFile_RequiredParametersNames
                $parameterFile_AllParameterNames = $parameterFileTestCase.parameterFile_AllParameterNames

                $missingParameters = $templateFile_RequiredParametersNames | Where-Object { $parameterFile_AllParameterNames -notcontains $_ }
                $missingParameters.Count | Should -Be 0 -Because ('no required parameters in the template file should be missing in the parameter file. Found missing items: [{0}]' -f ($missingParameters -join ', '))
            }
        }
    }

    Context 'Parameter file token tests' {

        # Parameter file test cases
        $parameterFileTokenTestCases = @()

        foreach ($moduleFolderPath in $moduleFolderPaths) {
            if (Test-Path (Join-Path $moduleFolderPath '.parameters')) {
                $ParameterFilePaths = (Get-ChildItem (Join-Path -Path $moduleFolderPath -ChildPath '.parameters' -AdditionalChildPath '*parameters.json') -Recurse -Force).FullName
                foreach ($ParameterFilePath in $ParameterFilePaths) {
                    foreach ($token in $enforcedTokenList.Keys) {
                        $parameterFileTokenTestCases += @{
                            parameterFilePath = $ParameterFilePath
                            parameterFileName = Split-Path $ParameterFilePath -Leaf
                            tokenSettings     = $Settings.parameterFileTokens
                            tokenName         = $token
                            tokenValue        = $enforcedTokenList[$token]
                            moduleFolderName  = $moduleFolderPath.Replace('\', '/').Split('/arm/')[1]
                        }
                    }
                }
            }
        }

        It '[<moduleFolderName>] [Tokens] Parameter file [<parameterFileName>] should not contain the plain value for token [<tokenName>] guid' -TestCases $parameterFileTokenTestCases {
            param (
                [string] $parameterFilePath,
                [string] $parameterFileName,
                [hashtable] $tokenSettings,
                [string] $tokenName,
                [string] $tokenValue,
                [string] $moduleFolderName
            )
            $ParameterFileTokenName = -join ($tokenSettings.tokenPrefix, $tokenName, $tokenSettings.tokenSuffix)
            $ParameterFileContent = Get-Content -Path $parameterFilePath

            $incorrectReferencesFound = $ParameterFileContent | Select-String -Pattern $tokenValue -AllMatches
            if ($incorrectReferencesFound.Matches) {
                $incorrectReferencesFound.Matches.Count | Should -Be 0 -Because ('Parameter file should not contain the [{0}] value, instead should reference the token value [{1}]. Please check the {2} lines: [{3}]' -f $tokenName, $ParameterFileTokenName, $incorrectReferencesFound.Matches.Count, ($incorrectReferencesFound.Line.Trim() -join ",`n"))
            }
        }
    }
}

Describe "API version tests [All apiVersions in the template should be 'recent']" -Tag ApiCheck {

    $testCases = @()
    $ApiVersions = Get-AzResourceProvider -ListAvailable
    foreach ($moduleFolderPath in $moduleFolderPaths) {

        $moduleFolderName = $moduleFolderPath.Replace('\', '/').Split('/arm/')[1]

        # For runtime purposes, we cache the compiled template in a hashtable that uses a formatted relative module path as a key
        $moduleFolderPathKey = $moduleFolderPath.Split('arm')[1].Replace('\', '/').Trim('/').Replace('/', '-')
        if (-not ($convertedTemplates.Keys -contains $moduleFolderPathKey)) {
            if (Test-Path (Join-Path $moduleFolderPath 'deploy.bicep')) {
                $templateFilePath = Join-Path $moduleFolderPath 'deploy.bicep'
                $templateContent = az bicep build --file $templateFilePath --stdout --no-restore | ConvertFrom-Json -AsHashtable

                if (-not $templateContent) {
                    throw ($bicepTemplateCompilationFailedException -f $templateFilePath)
                }
            } elseIf (Test-Path (Join-Path $moduleFolderPath 'deploy.json')) {
                $templateFilePath = Join-Path $moduleFolderPath 'deploy.json'
                $templateContent = Get-Content $templateFilePath -Raw | ConvertFrom-Json -AsHashtable

                if (-not $templateContent) {
                    throw ($jsonTemplateLoadFailedException -f $templateFilePath)
                }
            } else {
                throw ($templateNotFoundException -f $moduleFolderPath)
            }
            $convertedTemplates[$moduleFolderPathKey] = @{
                templateFilePath = $templateFilePath
                templateContent  = $templateContent
            }
        } else {
            $templateContent = $convertedTemplates[$moduleFolderPathKey].templateContent
            $templateFilePath = $convertedTemplates[$moduleFolderPathKey].templateFilePath
        }

        $nestedResources = Get-NestedResourceList -TemplateFileContent $templateContent | Where-Object {
            $_.type -notin @('Microsoft.Resources/deployments') -and $_
        } | Select-Object 'Type', 'ApiVersion' -Unique | Sort-Object Type

        foreach ($resource in $nestedResources) {

            switch ($resource.type) {
                { $PSItem -like '*diagnosticsettings*' } {
                    $testCases += @{
                        moduleName           = $moduleFolderName
                        resourceType         = 'diagnosticsettings'
                        ProviderNamespace    = 'Microsoft.insights'
                        TargetApi            = $resource.ApiVersion
                        AvailableApiVersions = $ApiVersions
                    }
                    break
                }
                { $PSItem -like '*locks' } {
                    $testCases += @{
                        moduleName           = $moduleFolderName
                        resourceType         = 'locks'
                        ProviderNamespace    = 'Microsoft.Authorization'
                        TargetApi            = $resource.ApiVersion
                        AvailableApiVersions = $ApiVersions
                    }
                    break
                }
                { $PSItem -like '*roleAssignments' } {
                    $testCases += @{
                        moduleName           = $moduleFolderName
                        resourceType         = 'roleassignments'
                        ProviderNamespace    = 'Microsoft.Authorization'
                        TargetApi            = $resource.ApiVersion
                        AvailableApiVersions = $ApiVersions
                    }
                    break
                }
                { $PSItem -like '*privateEndpoints' } {
                    $testCases += @{
                        moduleName           = $moduleFolderName
                        resourceType         = 'privateEndpoints'
                        ProviderNamespace    = 'Microsoft.Network'
                        TargetApi            = $resource.ApiVersion
                        AvailableApiVersions = $ApiVersions
                    }
                    break
                }
                Default {
                    $ProviderNamespace, $rest = $resource.Type.Split('/')
                    $testCases += @{
                        moduleName           = $moduleFolderName
                        resourceType         = $rest -join '/'
                        ProviderNamespace    = $ProviderNamespace
                        TargetApi            = $resource.ApiVersion
                        AvailableApiVersions = $ApiVersions
                    }
                    break
                }
            }
        }
    }

    It 'In [<moduleName>] used resource type [<resourceType>] should use one of the recent API version(s). Currently using [<TargetApi>]' -TestCases $TestCases {

        param(
            [string] $moduleName,
            [string] $resourceType,
            [string] $TargetApi,
            [string] $ProviderNamespace,
            [object[]] $AvailableApiVersions
        )

        $namespaceResourceTypes = ($AvailableApiVersions | Where-Object { $_.ProviderNamespace -eq $ProviderNamespace }).ResourceTypes
        $resourceTypeApiVersions = ($namespaceResourceTypes | Where-Object { $_.ResourceTypeName -eq $resourceType }).ApiVersions

        if (-not $resourceTypeApiVersions) {
            Write-Warning ('[API Test] We are currently unable to determine the available API versions for resource type [{0}/{1}]' -f $ProviderNamespace, $resourceType)
            continue
        }

        # We allow the latest 5 including previews (in case somebody wants to use preview), or the latest 3 non-preview
        $approvedApiVersions = @()
        $approvedApiVersions += $resourceTypeApiVersions | Select-Object -First 5
        $approvedApiVersions += $resourceTypeApiVersions | Where-Object { $_ -notlike '*-preview' } | Select-Object -First 3
        ($approvedApiVersions | Select-Object -Unique) | Should -Contain $TargetApi
    }
}
