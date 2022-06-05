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
                $moduleFolderName,
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
                $moduleFolderName,
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
                } elseIf (Test-Path (Join-Path $moduleFolderPath 'deploy.json')) {
                    $templateFilePath = Join-Path $moduleFolderPath 'deploy.json'
                    $templateContent = Get-Content $templateFilePath -Raw | ConvertFrom-Json -AsHashtable
                } else {
                    throw "No template file found in folder [$moduleFolderPath]"
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
            }
        }

        It '[<moduleFolderName>] Readme.md file should not be empty' -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $readMeContent
            )
            $readMeContent | Should -Not -Be $null
        }

        It '[<moduleFolderName>] Readme.md file should contain the these titles in order: Resource Types, Parameters, Outputs' -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $readMeContent
            )

            $ReadmeHTML = ($readMeContent | ConvertFrom-Markdown -ErrorAction SilentlyContinue).Html

            $Heading2Order = @('Resource Types', 'parameters', 'Outputs')
            $Headings2List = @()
            foreach ($H in $ReadmeHTML) {
                if ($H.Contains('<h2')) {
                    $StartingIndex = $H.IndexOf('>') + 1
                    $EndIndex = $H.LastIndexof('<')
                    $headings2List += ($H.Substring($StartingIndex, $EndIndex - $StartingIndex))
                }
            }

            $differentiatingItems = $Heading2Order | Where-Object { $Headings2List -notcontains $_ }
            $differentiatingItems.Count | Should -Be 0 -Because ('list of heading titles missing in the ReadMe file [{0}] should be empty' -f ($differentiatingItems -join ','))
        }

        It '[<moduleFolderName>] Resources section should contain all resources from the template file' -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $templateContent,
                $readMeContent
            )

            # Get ReadMe data
            $resourcesSectionStartIndex = 0
            while ($readMeContent[$resourcesSectionStartIndex] -notlike '*# Resource Types' -and -not ($resourcesSectionStartIndex -ge $readMeContent.count)) {
                $resourcesSectionStartIndex++
            }

            $resourcesTableStartIndex = $resourcesSectionStartIndex + 1
            while ($readMeContent[$resourcesTableStartIndex] -notlike '*|*' -and -not ($resourcesTableStartIndex -ge $readMeContent.count)) {
                $resourcesTableStartIndex++
            }

            $resourcesTableEndIndex = $resourcesTableStartIndex + 2
            while ($readMeContent[$resourcesTableEndIndex] -like '|*' -and -not ($resourcesTableEndIndex -ge $readMeContent.count)) {
                $resourcesTableEndIndex++
            }

            $ReadMeResourcesList = [System.Collections.ArrayList]@()
            for ($index = $resourcesTableStartIndex + 2; $index -lt $resourcesTableEndIndex; $index++) {
                $ReadMeResourcesList += $readMeContent[$index].Split('|')[1].Replace('`', '').Trim()
            }

            # Get template data
            $templateResources = (Get-NestedResourceList -TemplateFileContent $templateContent | Where-Object {
                    $_.type -notin @('Microsoft.Resources/deployments') -and $_ }).type | Select-Object -Unique

            # Compare
            $differentiatingItems = $templateResources | Where-Object { $ReadMeResourcesList -notcontains $_ }
            $differentiatingItems.Count | Should -Be 0 -Because ("list of template resources missing from the ReadMe's list [{0}] should be empty" -f ($differentiatingItems -join ','))
        }

        It '[<moduleFolderName>] Resources section should not contain more resources as in the template file' -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $templateContent,
                $readMeContent
            )

            # Get ReadMe data
            $resourcesSectionStartIndex = 0
            while ($readMeContent[$resourcesSectionStartIndex] -notlike '*# Resource Types' -and -not ($resourcesSectionStartIndex -ge $readMeContent.count)) {
                $resourcesSectionStartIndex++
            }

            $resourcesTableStartIndex = $resourcesSectionStartIndex + 1
            while ($readMeContent[$resourcesTableStartIndex] -notlike '*|*' -and -not ($resourcesTableStartIndex -ge $readMeContent.count)) {
                $resourcesTableStartIndex++
            }

            $resourcesTableEndIndex = $resourcesTableStartIndex + 2
            while ($readMeContent[$resourcesTableEndIndex] -like '|*' -and -not ($resourcesTableEndIndex -ge $readMeContent.count)) {
                $resourcesTableEndIndex++
            }

            $ReadMeResourcesList = [System.Collections.ArrayList]@()
            for ($index = $resourcesTableStartIndex + 2; $index -lt $resourcesTableEndIndex; $index++) {
                $ReadMeResourcesList += $readMeContent[$index].Split('|')[1].Replace('`', '').Trim()
            }

            # Get template data
            $templateResources = (Get-NestedResourceList -TemplateFileContent $templateContent | Where-Object {
                    $_.type -notin @('Microsoft.Resources/deployments') -and $_ }).type | Select-Object -Unique

            # Compare
            $differentiatingItems = $templateResources | Where-Object { $ReadMeResourcesList -notcontains $_ }
            $differentiatingItems.Count | Should -Be 0 -Because ("list of resources in the ReadMe's list [{0}] not in the template file should be empty" -f ($differentiatingItems -join ','))
        }

        It '[<moduleFolderName>] parameters section should contain a table with these column names in order: Parameter Name, Type, Default Value, Possible values, Description' -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $readMeContent
            )

            $ReadmeHTML = ($readMeContent | ConvertFrom-Markdown -ErrorAction SilentlyContinue).Html
            $ParameterHeadingOrder = @('Parameter Name', 'Type', 'Default Value', 'Allowed Values', 'Description')
            $ComparisonFlag = 0
            $Headings = @(@())
            foreach ($H in $ReadmeHTML) {
                if ($H.Contains('<h')) {
                    $StartingIndex = $H.IndexOf('>') + 1
                    $EndIndex = $H.LastIndexof('<')
                    $Headings += , (@($H.Substring($StartingIndex, $EndIndex - $StartingIndex), $ReadmeHTML.IndexOf($H)))
                }
            }
            $HeadingIndex = $Headings | Where-Object { $_ -eq 'parameters' }
            if ($HeadingIndex -eq $null) {
                Write-Verbose "[parameters section should contain a table with these column names in order: Parameter Name, Type, Default Value, Possible values, Description] Error At ($moduleFolderName)" -Verbose
                $true | Should -Be $false
            }
            $ParameterHeadingsList = $ReadmeHTML[$HeadingIndex[1] + 2].Replace('<p>|', '').Replace('|</p>', '').Split('|').Trim()
            if (Compare-Object -ReferenceObject $ParameterHeadingOrder -DifferenceObject $ParameterHeadingsList -SyncWindow 0) {
                $ComparisonFlag = $ComparisonFlag + 1
            }
            ($ComparisonFlag -gt 2) | Should -Be $false
        }

        It '[<moduleFolderName>] parameters section should contain all parameters from the template file' -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $templateContent,
                $readMeContent
            )

            # Get Template data
            $parameters = $templateContent.parameters.Keys

            # Get ReadMe data
            ## Get section start index
            $parametersSectionStartIndex = 0
            while ($readMeContent[$parametersSectionStartIndex] -notlike '*# Parameters' -and -not ($parametersSectionStartIndex -ge $readMeContent.count)) {
                $parametersSectionStartIndex++
            }
            Write-Verbose ("Start row of the parameters section in the readme: $parametersSectionStartIndex")

            if ($parametersSectionStartIndex -ge $readMeContent.count) {
                throw 'Parameters section is missing in the Readme. Please add and re-run the tests.'
            }

            ## Get section end index
            $parametersSectionEndIndex = $parametersSectionStartIndex + 1
            while ($readMeContent[$parametersSectionEndIndex] -notlike '*# *' -and -not ($parametersSectionEndIndex -ge $readMeContent.count)) {
                $parametersSectionEndIndex++
            }
            Write-Verbose ("End row of the parameters section in the readme: $parametersSectionEndIndex")

            ## Iterate over all parameter tables
            $parametersList = [System.Collections.ArrayList]@()
            $sectionIndex = $parametersSectionStartIndex
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
                $moduleFolderName,
                $readMeContent
            )

            # Get ReadMe data
            $outputsSectionStartIndex = 0
            while ($readMeContent[$outputsSectionStartIndex] -notlike '*# Outputs' -and -not ($outputsSectionStartIndex -ge $readMeContent.count)) {
                $outputsSectionStartIndex++
            }

            $outputsTableStartIndex = $outputsSectionStartIndex + 1
            while ($readMeContent[$outputsTableStartIndex] -notlike '*|*' -and -not ($outputsTableStartIndex -ge $readMeContent.count)) {
                $outputsTableStartIndex++
            }

            $outputsTableHeader = $readMeContent[$outputsTableStartIndex].Split('|').Trim() | Where-Object { -not [String]::IsNullOrEmpty($_) }

            # Test
            $expectedOutputsTableOrder = @('Output Name', 'Type')
            $differentiatingItems = $expectedOutputsTableOrder | Where-Object { $outputsTableHeader -notcontains $_ }
            $differentiatingItems.Count | Should -Be 0 -Because ('list of "Outputs" table columns missing in the ReadMe file [{0}] should be empty' -f ($differentiatingItems -join ','))
        }

        It '[<moduleFolderName>] Output section should contain all outputs defined in the template file' -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $templateContent,
                $readMeContent
            )

            # Get ReadMe data
            $outputsSectionStartIndex = 0
            while ($readMeContent[$outputsSectionStartIndex] -notlike '*# Outputs' -and -not ($outputsSectionStartIndex -ge $readMeContent.count)) {
                $outputsSectionStartIndex++
            }

            $outputsTableStartIndex = $outputsSectionStartIndex + 1
            while ($readMeContent[$outputsTableStartIndex] -notlike '*|*' -and -not ($outputsTableStartIndex -ge $readMeContent.count)) {
                $outputsTableStartIndex++
            }

            $outputsTableEndIndex = $outputsTableStartIndex + 2
            while ($readMeContent[$outputsTableEndIndex] -like '|*' -and -not ($outputsTableEndIndex -ge $readMeContent.count)) {
                $outputsTableEndIndex++
            }

            $ReadMeoutputsList = [System.Collections.ArrayList]@()
            for ($index = $outputsTableStartIndex + 2; $index -lt $outputsTableEndIndex; $index++) {
                $ReadMeoutputsList += $readMeContent[$index].Split('|')[1].Replace('`', '').Trim()
            }

            # Template data
            $expectedOutputs = $templateContent.outputs.Keys

            # Test
            $differentiatingItems = $expectedOutputs | Where-Object { $ReadMeoutputsList -notcontains $_ }
            $differentiatingItems.Count | Should -Be 0 -Because ('list of template outputs missing in the ReadMe file [{0}] should be empty' -f ($differentiatingItems -join ','))

            $differentiatingItems = $ReadMeoutputsList | Where-Object { $expectedOutputs -notcontains $_ }
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
            $fileHashBefore -eq $fileHashAfter | Should -Be $true -Because 'The file hashes before and after applying the Set-ModuleReadMe function should be identical'
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
                } elseIf (Test-Path (Join-Path $moduleFolderPath 'deploy.json')) {
                    $templateFilePath = Join-Path $moduleFolderPath 'deploy.json'
                    $templateContent = Get-Content $templateFilePath -Raw | ConvertFrom-Json -AsHashtable
                } else {
                    throw "No template file found in folder [$moduleFolderPath]"
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
                $moduleFolderName,
                $templateContent
            )
            $templateContent | Should -Not -Be $null
        }

        It '[<moduleFolderName>] Template schema version should be the latest' -TestCases $deploymentFolderTestCases {
            # the actual value changes depending on the scope of the template (RG, subscription, MG, tenant) !!
            # https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-syntax
            param(
                $moduleFolderName,
                $templateContent
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
                $moduleFolderName,
                $templateContent
            )
            $Schemaverion = $templateContent.'$schema'
            ($Schemaverion.Substring(0, 5) -eq 'https') | Should -Be $true
        }

        It '[<moduleFolderName>] All apiVersion properties should be set to a static, hard-coded value' -TestCases $deploymentFolderTestCases {
            #https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-best-practices
            param(
                $moduleFolderName,
                $templateContent
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
                $moduleFolderName,
                $templateContent
            )
            $templateContent.Keys | Should -Contain '$schema'
            $templateContent.Keys | Should -Contain 'contentVersion'
            $templateContent.Keys | Should -Contain 'resources'
        }

        It '[<moduleFolderName>] If delete lock is implemented, the template should have a lock parameter with the default value of [NotSpecified]' -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $templateContent
            )
            if ($lock = $templateContent.parameters.lock) {
                $lock.Keys | Should -Contain 'defaultValue'
                $lock.defaultValue | Should -Be 'NotSpecified'
            }
        }

        It '[<moduleFolderName>] Parameter names should be camel-cased (no dashes or underscores and must start with lower-case letter)' -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $templateContent
            )

            if (-not $templateContent.parameters) {
                # Skip test
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
                $moduleFolderName,
                $templateContent
            )

            if (-not $templateContent.variables) {
                # Skip test
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
                $moduleFolderName,
                $templateContent
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
                $moduleFolderName,
                $templateContent
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
                $moduleFolderName,
                $templateContent
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
                $templateContent,
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
                $templateContent,
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
                $moduleFolderName,
                $templateContent
            )

            $outputs = $templateContent.outputs.Keys
            $outputs | Should -Contain 'name'
        }

        It '[<moduleFolderName>] Resource ID output should exist' -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $templateContent
            )

            $outputs = $templateContent.outputs.Keys
            $outputs | Should -Contain 'resourceId'
        }

        It "[<moduleFolderName>] parameters' description should start with a one word category starting with a capital letter, followed by a dot, a space and the actual description text ending with a dot." -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $templateContent
            )

            if (-not $templateContent.parameters) {
                # Skip test
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
                $moduleFolderName,
                $templateContent
            )

            if (-not $templateContent.parameters) {
                # Skip test
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
                $moduleFolderName,
                $templateContent
            )

            if (-not $templateContent.outputs) {
                # Skip test
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
    foreach ($moduleFolderPath in $moduleFolderPathsFiltered) {

        $moduleFolderName = $moduleFolderPath.Replace('\', '/').Split('/arm/')[1]

        # For runtime purposes, we cache the compiled template in a hashtable that uses a formatted relative module path as a key
        $moduleFolderPathKey = $moduleFolderPath.Split('arm')[1].Replace('\', '/').Trim('/').Replace('/', '-')
        if (-not ($convertedTemplates.Keys -contains $moduleFolderPathKey)) {
            if (Test-Path (Join-Path $moduleFolderPath 'deploy.bicep')) {
                $templateFilePath = Join-Path $moduleFolderPath 'deploy.bicep'
                $templateContent = az bicep build --file $templateFilePath --stdout --no-restore | ConvertFrom-Json -AsHashtable
            } elseIf (Test-Path (Join-Path $moduleFolderPath 'deploy.json')) {
                $templateFilePath = Join-Path $moduleFolderPath 'deploy.json'
                $templateContent = Get-Content $templateFilePath -Raw | ConvertFrom-Json -AsHashtable
            } else {
                throw "No template file found in folder [$moduleFolderPath]"
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
            $moduleName,
            $resourceType,
            $TargetApi,
            $ProviderNamespace,
            $AvailableApiVersions
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
