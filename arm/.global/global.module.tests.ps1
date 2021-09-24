#Requires -Version 7

param (
    [array] $moduleFolderPaths = ((Get-Childitem (Split-Path (Get-Location) -Parent) -Recurse -Directory).FullName | Where-Object {
        (Get-Childitem $_ -File -Depth 0 -Include @('deploy.json', 'deploy.bicep')).Count -gt 0
        })
)

$script:RGdeployment = "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"
$script:Subscriptiondeployment = "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#"
$script:MGdeployment = "https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#"
$script:Tenantdeployment = "https://schema.management.azure.com/schemas/2019-08-01/tenantDeploymentTemplate.json#"
$script:moduleFolderPaths = $moduleFolderPaths

$locationTestExceptions = @( "AzureNetappFiles", "TrafficManager", "PrivateDnsZones", "ManagementGroups")
$script:folderPathsToScanExcludeRG = $moduleFolderPaths | Where-Object { (Split-Path $_ -Leaf) -notin $locationTestExceptions }

foreach ($moduleFolderPath in $moduleFolderPaths) {
    $templateFiles = (Get-ChildItem -Path $moduleFolderPath -Include @('deploy.json', 'deploy.bicep') -Depth 0).Name
    if ($templateFiles -contains 'deploy.bicep' -and $templateFiles -notcontains 'deploy.json') {
        Write-Verbose "Generate ARM file for [$moduleFolderPath]"
        az bicep build -f (Join-Path $moduleFolderPath 'deploy.bicep')
    }
}

Describe "File/folder tests" -Tag Modules {

    Context "General module folder tests" {

        $moduleFolderTestCases = [System.Collections.ArrayList] @()
        foreach ($folderPath in $moduleFolderPaths) {

            $moduleFolderTestCases += @{
                moduleFolderName = Split-Path $folderPath -Leaf
                moduleFolderPath = $folderPath
            }
        }

        It "[<moduleFolderName>] Module should contain a [deploy.json/deploy.bicep] file" -TestCases $moduleFolderTestCases {
            param( [string] $folderPath )
            $hasARM = (Test-Path (Join-Path -Path $moduleFolderPath 'deploy.json'))
            $hasBicep = (Test-Path (Join-Path -Path $moduleFolderPath 'deploy.bicep'))
            ($hasARM -or $hasBicep) | Should -Be $true
        }

        It "[<moduleFolderName>] Module should contain a [readme.md] file" -TestCases $moduleFolderTestCases {
            param( [string] $folderPath )
            (Test-Path (Join-Path -Path $moduleFolderPath 'readme.md')) | Should -Be $true
        }

        It "[<moduleFolderName>] Module should contain a [parameters] folder" -TestCases $moduleFolderTestCases {
            param( [string] $folderPath )
            (Test-Path (Join-Path -Path $moduleFolderPath 'parameters')) | Should -Be $true
        }
    }

    Context "parameters folder" {

        $parameterFolderTestCases = [System.Collections.ArrayList] @()
        $FilepathParamJsonFolder = @()
        foreach ($folderPath in $moduleFolderPaths) {
            $ParameterFilecount = Get-ChildItem -Path (Join-Path -Path $folderPath \parameters\)
            if ($ParameterFilecount.count -eq 0) {
                $FilepathParamJsonFolder += Get-ChildItem -Path $folderPath
            }
            else {
                $FilepathParamJsonFolder += Get-ChildItem -Path (Join-Path -Path $folderPath 'parameters')
            }

        }
        foreach ($File in $FilepathParamJsonFolder) {
            if ($File.Directory.Name -eq "parameters") {
                $directoryPath = $File.DirectoryName
                $modulePath = Split-Path -Parent -Path $directoryPath
                $moduleName = Split-Path $modulePath -Leaf
                $parameterFolderTestCases += @{
                    moduleFolderName   = $moduleName
                    moduleFolderPath   = $modulePath
                    parametersFileName = $File.Name
                    fileContent        = $File.FullName
                }
            }
            else {
                if ($File.Name -eq "parameters") {
                    $missingModulePath = (Split-Path -Parent -Path $File.FullName)
                    $missingModuleName = Split-Path $missingModulePath -Leaf
                    $parameterFolderTestCases += @{
                        moduleFolderName   = $missingModuleName
                        moduleFolderPath   = $missingModulePath
                        parametersFileName = "MissingFile"
                        fileContent        = $null
                    }
                }
            }
        }



        It "[<moduleFolderName>] folder should contain one or more *parameters.json files" -TestCases $parameterFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $parametersFileName,
                $fileContent
            )
            $parametersFileName | Should -BeLike "*parameters.json"
        }

        It "[<moduleFolderName>] *parameters.json files in the parameters folder should not be empty" -TestCases $parameterFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $parametersFileName,
                $fileContent
            )
            (Get-Content $fileContent) | Should -Not -Be $null
        }

        It "[<moduleFolderName>] *parameters.json files in the parameters folder should be valid JSON" -TestCases $parameterFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $parametersFileName,
                $fileContent
            )
            $TemplateContent = Get-Content $fileContent -Raw -ErrorAction SilentlyContinue
            $TemplateContent | ConvertFrom-Json -ErrorAction SilentlyContinue | Should -Not -Be $Null
            Test-Path $fileContent -PathType Leaf -Include '*.json' | Should -Be $true
        }

    }
}

Describe "Readme tests" -Tag Readme {
    Context "Readme content tests" {

        $readmeFolderTestCases = [System.Collections.ArrayList] @()
        foreach ($folderPath in $moduleFolderPaths) {
            $readmeFolderTestCases += @{
                moduleFolderName = Split-Path $folderPath -Leaf
                moduleFolderPath = $folderPath
                fileContent      = (Join-Path -Path $folderPath \readme.md)
            }
        }


        It "[<moduleFolderName>] Readme.md file should not be empty" -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            (Get-Content $fileContent) | Should -Not -Be $null
        }

        It "[<moduleFolderName>] Readme.md file should contain the these Heading2 titles in order: Resource Types, parameters, Outputs, Considerations, Additional resources" -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateReadme = Get-Content ($fileContent) -ErrorAction SilentlyContinue
            $ReadmeHTML = ($TemplateReadme  | ConvertFrom-Markdown -ErrorAction SilentlyContinue).Html
            $Headings = @(@())
            foreach ($H in $ReadmeHTML) {
                if ($H.Contains("<h")) {
                    $StartingIndex = $H.IndexOf(">") + 1
                    $EndIndex = $H.LastIndexof("<")
                    $Headings += , (@($H.Substring($StartingIndex, $EndIndex - $StartingIndex), $ReadmeHTML.IndexOf($H)))
                }
            }
            $Heading2Order = @("Resource Types", "parameters", "Outputs", "Considerations", "Additional resources")
            $Headings2List = @()
            foreach ($H in $ReadmeHTML) {
                if ($H.Contains("<h2")) {
                    $StartingIndex = $H.IndexOf(">") + 1
                    $EndIndex = $H.LastIndexof("<")
                    $headings2List += ($H.Substring($StartingIndex, $EndIndex - $StartingIndex))
                }
            }
            (Compare-Object -ReferenceObject $Heading2Order -DifferenceObject $Headings2List) | Should -Be $null
        }

        It "[<moduleFolderName>] Resources section should contain all resources from the template file" -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateReadme = Get-Content ($fileContent) -ErrorAction SilentlyContinue
            $TemplateARM = Get-Content (Join-Path -Path $moduleFolderPath \deploy.json) -Raw -ErrorAction SilentlyContinue
            $ReadmeHTML = ($TemplateReadme  | ConvertFrom-Markdown -ErrorAction SilentlyContinue).Html
            $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            $ResourceTypes = @()
            $ResourceTypes += $Template.resources.type
            $ResourceTypesChild = $Template.resources.resources.type
            $ResourceTypesInline = $Template.resources.properties.template.resources.type
            $ResourceTypes += $ResourceTypesChild
            $ResourceTypes += $ResourceTypesInline
            $ResourceTypes = $ResourceTypes | Sort-object -Unique
            $Headings = @(@())
            foreach ($H in $ReadmeHTML) {
                if ($H.Contains("<h")) {
                    $StartingIndex = $H.IndexOf(">") + 1
                    $EndIndex = $H.LastIndexof("<")
                    $Headings += , (@($H.Substring($StartingIndex, $EndIndex - $StartingIndex), $ReadmeHTML.IndexOf($H)))
                }
            }
            $HeadingIndex = $Headings | Where-Object { $_ -eq "Resource Types" }
            if ($HeadingIndex -eq $null) {
                Write-Verbose "Error during test [Resources section should contain all resources from the template file] at ($moduleFolderName)" -Verbose
                $true | Should -Be $false
            }
            $ResourcesList = @()
            for ($j = $HeadingIndex[1] + 4; $ReadmeHTML[$j] -ne ""; $j++) {
                $ResourcesList += $ReadmeHTML[$j].Replace(" ", "").Replace("<p>|<code>", "").Replace("|</p>", "").Replace("</code>", "").Split("|")[0].Trim()
            }
            $differentiatingItems = $ResourceTypes | Where-Object { $ResourcesList -notcontains $_ }
            $differentiatingItems.Count | Should -Be 0 -Because ("list of template resources missing from the ReadMe's list [{0}] should be empty" -f $differentiatingItems -join ',')
        }

        It "[<moduleFolderName>] Resources section should not contain more resources as in the template file" -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateReadme = Get-Content ($fileContent) -ErrorAction SilentlyContinue
            $TemplateARM = Get-Content (Join-Path -Path $moduleFolderPath \deploy.json) -Raw -ErrorAction SilentlyContinue
            $ReadmeHTML = ($TemplateReadme  | ConvertFrom-Markdown -ErrorAction SilentlyContinue).Html
            $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            $ResourceTypes = @()
            $ResourceTypes += $Template.resources.type
            $ResourceTypesChild = $Template.resources.resources.type
            $ResourceTypesInline = $Template.resources.properties.template.resources.type
            $ResourceTypes += $ResourceTypesChild
            $ResourceTypes += $ResourceTypesInline
            $ResourceTypes = $ResourceTypes | Sort-object -Unique
            $Headings = @(@())
            foreach ($H in $ReadmeHTML) {
                if ($H.Contains("<h")) {
                    $StartingIndex = $H.IndexOf(">") + 1
                    $EndIndex = $H.LastIndexof("<")
                    $Headings += , (@($H.Substring($StartingIndex, $EndIndex - $StartingIndex), $ReadmeHTML.IndexOf($H)))
                }
            }
            $HeadingIndex = $Headings | Where-Object { $_ -eq "Resource Types" }
            if ($HeadingIndex -eq $null) {
                Write-Verbose "Error during test [Resources section should not contain more resources as in the template file] at ($moduleFolderName)" -Verbose
                $true | Should -Be $false
            }
            $ResourcesList = @()
            for ($j = $HeadingIndex[1] + 4; $ReadmeHTML[$j] -ne ""; $j++) {
                $ResourcesList += $ReadmeHTML[$j].Replace(" ", "").Replace("<p>|<code>", "").Replace("|</p>", "").Replace("</code>", "").Split("|")[0].Trim()
            }
            $differentiatingItems = $ResourcesList | Where-Object { $ResourceTypes -notcontains $_ }
            $differentiatingItems.Count | Should -Be 0 -Because ("list of resources in the ReadMe's list [{0}] not in the template file should be empty" -f $differentiatingItems -join ',')
        }

        It "[<moduleFolderName>] parameters section should contain a table with these column names in order: Parameter Name, Type, Description, Default Value, Possible values" -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateReadme = Get-Content ($fileContent) -ErrorAction SilentlyContinue
            $ReadmeHTML = ($TemplateReadme  | ConvertFrom-Markdown -ErrorAction SilentlyContinue).Html
            $ParameterHeadingOrder = @("Parameter Name", "Type", "Default Value", "Possible values", "Description")
            $ParameterHeadingOrderNewVersion = @("Parameter Name", "Type", "Description", "DefaultValue", "Allowed Values")
            $ParameterHeadingOrderLatestVersion = @("Parameter Name", "Type", "Description", "DefaultValue", "Possible values")
            $ComparisonFlag = 0
            $Headings = @(@())
            foreach ($H in $ReadmeHTML) {
                if ($H.Contains("<h")) {
                    $StartingIndex = $H.IndexOf(">") + 1
                    $EndIndex = $H.LastIndexof("<")
                    $Headings += , (@($H.Substring($StartingIndex, $EndIndex - $StartingIndex), $ReadmeHTML.IndexOf($H)))
                }
            }
            $HeadingIndex = $Headings | Where-Object { $_ -eq "parameters" }
            if ($HeadingIndex -eq $null) {
                Write-Verbose "[parameters section should contain a table with these column names in order: Parameter Name, Type, Description, Default Value, Possible values] Error At ($moduleFolderName)" -Verbose
                $true | Should -Be $false
            }
            $ParameterHeadingsList = $ReadmeHTML[$HeadingIndex[1] + 2].Replace("<p>|", "").Replace("|</p>", "").Split("|").Trim()
            if (Compare-Object -ReferenceObject $ParameterHeadingOrder -DifferenceObject $ParameterHeadingsList -SyncWindow 0) {
                $ComparisonFlag = $ComparisonFlag + 1
            }
            if (Compare-Object -ReferenceObject $ParameterHeadingOrderNewVersion -DifferenceObject $ParameterHeadingsList -SyncWindow 0) {
                $ComparisonFlag = $ComparisonFlag + 1
            }
            if (Compare-Object -ReferenceObject $ParameterHeadingOrderLatestVersion -DifferenceObject $ParameterHeadingsList -SyncWindow 0) {
                $ComparisonFlag = $ComparisonFlag + 1
            }
            ($ComparisonFlag -gt 2) | Should -Be $false
        }

        It "[<moduleFolderName>] parameters section should contain all parameters from the deploy.json file" -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateReadme = Get-Content ($fileContent) -ErrorAction SilentlyContinue
            $TemplateARM = Get-Content (Join-Path -Path $moduleFolderPath \deploy.json) -Raw -ErrorAction SilentlyContinue
            $ReadmeHTML = ($TemplateReadme  | ConvertFrom-Markdown -ErrorAction SilentlyContinue).Html
            $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            ##get param from deploy.json
            $parameters = Get-Member -InputObject $Template.parameters -MemberType NoteProperty
            $Headings = @(@())
            foreach ($H in $ReadmeHTML) {
                if ($H.Contains("<h")) {
                    $StartingIndex = $H.IndexOf(">") + 1
                    $EndIndex = $H.LastIndexof("<")
                    $Headings += , (@($H.Substring($StartingIndex, $EndIndex - $StartingIndex), $ReadmeHTML.IndexOf($H)))
                }
            }
            ##get param from readme.md
            $HeadingIndex = $Headings | Where-Object { $_ -eq "parameters" }
            if ($HeadingIndex -eq $null) {
                Write-Verbose "[parameters section should contain all parameters from the deploy.json file] Error At ($moduleFolderName)" -Verbose
                $true | Should -Be $false
            }
            $parametersList = @()
            for ($j = $HeadingIndex[1] + 4; $ReadmeHTML[$j] -ne ""; $j++) {
                $parametersList += $ReadmeHTML[$j].Replace("<p>| <code>", "").Replace("|</p>", "").Replace("</code>", "").Split("|")[0].Trim()
            }
            (Compare-Object -ReferenceObject $parameters.Name -DifferenceObject $parametersList) | Should -Be $null
        }

        It "[<moduleFolderName>] Outputs section should contain a table with these column names in order: Output Name, Value, Type" -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateReadme = Get-Content ($fileContent) -ErrorAction SilentlyContinue
            $ReadmeHTML = ($TemplateReadme  | ConvertFrom-Markdown -ErrorAction SilentlyContinue).Html
            $Headings = @(@())
            foreach ($H in $ReadmeHTML) {
                if ($H.Contains("<h")) {
                    $StartingIndex = $H.IndexOf(">") + 1
                    $EndIndex = $H.LastIndexof("<")
                    $Headings += , (@($H.Substring($StartingIndex, $EndIndex - $StartingIndex), $ReadmeHTML.IndexOf($H)))
                }
            }
            $OutputHeadingOrder = @("Output Name", "Type", "Description")
            $HeadingIndex = $Headings | Where-Object { $_ -eq "Outputs" }
            if ($HeadingIndex -eq $null) {
                Write-Verbose "[Outputs section should contain a table with these column names in order: Output Name, Type, Description] Error At ($moduleFolderName)" -Verbose
                $true | Should -Be $false
            }
            $OutputHeadingsList = $ReadmeHTML[$HeadingIndex[1] + 2].Replace("<p>|", "").Replace("|</p>", "").Split("|").Trim()
            (Compare-Object -ReferenceObject $OutputHeadingOrder -DifferenceObject $OutputHeadingsList -SyncWindow 0) | Should -Be $null
        }

        It "[<moduleFolderName>] Output section should contain all outputs defined in the deploy.json file" -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateReadme = Get-Content ($fileContent) -ErrorAction SilentlyContinue
            $TemplateARM = Get-Content (Join-Path -Path $moduleFolderPath \deploy.json) -Raw -ErrorAction SilentlyContinue
            $ReadmeHTML = ($TemplateReadme  | ConvertFrom-Markdown -ErrorAction SilentlyContinue).Html
            $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            $Headings = @(@())
            foreach ($H in $ReadmeHTML) {
                if ($H.Contains("<h")) {
                    $StartingIndex = $H.IndexOf(">") + 1
                    $EndIndex = $H.LastIndexof("<")
                    $Headings += , (@($H.Substring($StartingIndex, $EndIndex - $StartingIndex), $ReadmeHTML.IndexOf($H)))
                }
            }
            $Outputs = Get-Member -InputObject $Template.outputs -MemberType NoteProperty
            $HeadingIndex = $Headings | Where-Object { $_ -eq "Outputs" }
            if ($HeadingIndex -eq $null) {
                Write-Verbose "[Output section should contain all outputs defined in the deploy.json file] Error At ($moduleFolderName)" -Verbose
                $true | Should -Be $false
            }
            $OutputsList = @()
            for ($j = $HeadingIndex[1] + 4; $ReadmeHTML[$j] -ne ""; $j++) {
                $OutputsList += $ReadmeHTML[$j].Replace("<p>| <code>", "").Replace("|</p>", "").Replace("</code>", "").Split("|")[0].Trim()
            }
            (Compare-Object -ReferenceObject $Outputs.Name -DifferenceObject $OutputsList) | Should -Be $null
        }

        It "[<moduleFolderName>] Additional resources section should contain at least one bullet point with a reference" -TestCases $readmeFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateReadme = Get-Content ($fileContent) -ErrorAction SilentlyContinue
            $ReadmeHTML = ($TemplateReadme  | ConvertFrom-Markdown -ErrorAction SilentlyContinue).Html
            $Headings = @(@())
            foreach ($H in $ReadmeHTML) {
                if ($H.Contains("<h")) {
                    $StartingIndex = $H.IndexOf(">") + 1
                    $EndIndex = $H.LastIndexof("<")
                    $Headings += , (@($H.Substring($StartingIndex, $EndIndex - $StartingIndex), $ReadmeHTML.IndexOf($H)))
                }
            }
            $HeadingIndex = $Headings | Where-Object { $_ -eq "Additional resources" }
            if ($HeadingIndex -eq $null) {
                Write-Verbose "[Additional resources section should contain at least one bullet point with a reference] Error At ($moduleFolderName)" -Verbose
                $true | Should -Be $false
            }
            $StartIndex = $HeadingIndex[1] + 2
            ($ReadmeHTML[$StartIndex].Contains("<li>")) | Should -Be $true
            ($ReadmeHTML[$StartIndex].Contains("href")) | Should -Be $true
        }

    }
}

Describe "Deployment template tests" -Tag Template {

    Context "Deployment template tests" {

        $deploymentFolderTestCases = [System.Collections.ArrayList] @()
        $deploymentFolderTestCasesException = [System.Collections.ArrayList] @()
        foreach ($folderPath in $moduleFolderPaths) {

            # Parameter file test cases
            $parameterFileTestCases = @()
            $templateFile_Parameters = ((Get-Content (Join-Path $folderPath 'deploy.json')) | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties
            $TemplateFile_AllParameterNames = $templateFile_Parameters | Sort-Object -Property Name | ForEach-Object Name
            $TemplateFile_RequiredParametersNames = $templateFile_Parameters | Where-Object -FilterScript { -not ($_.Value.PSObject.Properties.Name -eq "defaultValue") } | Sort-Object -Property Name | ForEach-Object Name

            $ParameterFilePaths = (Get-ChildItem (Join-Path -Path $folderPath -ChildPath 'parameters' -AdditionalChildPath "*parameters.json") -Recurse).FullName
            foreach ($ParameterFilePath in $ParameterFilePaths) {
                $parameterFile_AllParameterNames = (Get-Content $ParameterFilePath | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties | Sort-Object -Property Name | ForEach-Object Name
                $parameterFileTestCases += @{
                    TemplateFileName                     = $TemplateFileName
                    parameterFile_Path                   = $ParameterFilePath
                    parameterFile_Name                   = Split-Path $ParameterFilePath -Leaf
                    parameterFile_AllParameterNames      = $parameterFile_AllParameterNames
                    templateFile_AllParameterNames       = $TemplateFile_AllParameterNames
                    templateFile_RequiredParametersNames = $TemplateFile_RequiredParametersNames
                }
            }

            # Test file setup
            $deploymentFolderTestCases += @{
                moduleFolderName       = Split-Path $folderPath -Leaf
                moduleFolderPath       = $folderPath
                fileContent            = (Join-Path -Path $folderPath 'deploy.json')
                parameterFileTestCases = $parameterFileTestCases
            }
        }
        foreach ($folderPath in $folderPathsToScanExcludeRG) {
            $deploymentFolderTestCasesException += @{
                moduleFolderNameException = Split-Path $folderPath -Leaf
                moduleFolderPathException = $folderPath
                fileContentException      = (Join-Path -Path $folderPath \deploy.json)
            }
        }

        It "[<moduleFolderName>] The deploy.json file should not be empty" -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            (Get-Content $fileContent) | Should -Not -Be $null
        }

        It "[<moduleFolderName>] The deploy.json file should be a valid JSON" -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateARM = Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue
            Test-Path $fileContent -PathType Leaf -Include '*.json' | Should -Be $true
            try {
                ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[The deploy.json file should be a valid JSON] Error at ($moduleFolderName)" -Verbose
                $false | Should -Be $true
                Continue
            }
        }

        It "[<moduleFolderName>] Template schema version should be the latest" -TestCases $deploymentFolderTestCases {
            # the actual value changes depending on the scope of the template (RG, subscription, MG, tenant) !!
            # https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-syntax
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateARM = Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue
            try {
                $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[Template schema version should be the latest] Json conversion Error at ($moduleFolderName)" -Verbose
                Continue
            }
            $Schemaverion = $Template.'$schema'
            $SchemaArray = @()
            if ($Schemaverion -eq $RGdeployment) {
                $SchemaOutput = $true
            }
            elseif ($Schemaverion -eq $Subscriptiondeployment) {
                $SchemaOutput = $true
            }
            elseif ($Schemaverion -eq $MGdeployment) {
                $SchemaOutput = $true
            }
            elseif ($Schemaverion -eq $Tenantdeployment) {
                $SchemaOutput = $true
            }
            else {
                $SchemaOutput = $false
            }
            $SchemaArray += $SchemaOutput
            $SchemaArray | Should -Not -Contain $false
        }

        It "[<moduleFolderName>] Template schema should use HTTPS reference" -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateARM = Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue
            try {
                $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[Template schema should use HTTPS reference] Json conversion Error at ($moduleFolderName)" -Verbose
                Continue
            }
            $Schemaverion = $Template.'$schema'
            ($Schemaverion.Substring(0, 5) -eq "https") | Should -Be $true
        }

        It "[<moduleFolderName>] All apiVersion properties should be set to a static, hard-coded value" -TestCases $deploymentFolderTestCases {
            #https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-best-practices
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateARM = Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue
            try {
                $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[All apiVersion properties should be set to a static, hard-coded value] Json conversion Error at ($moduleFolderName)" -Verbose
                Continue
            }
            $ApiVersion = $Template.resources.apiVersion
            $ApiVersionArray = @()
            foreach ($Api in $ApiVersion) {
                if ($Api.Substring(0, 2) -eq '20') {
                    $ApiVersionOutput = $true
                }
                elseif ($Api.substring(1, 10) -eq "parameters") {
                    $ApiVersionOutput = $false
                }
                else {
                    $ApiVersionOutput = $false
                }
                $ApiVersionArray += $ApiVersionOutput
            }
            $ApiVersionArray | Should -Not -Contain $false
        }

        It "[<moduleFolderName>] The deploy.json file should contain required elements: schema, contentVersion, resources" -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateProperties = (Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue | ConvertFrom-Json -ErrorAction SilentlyContinue) | Get-Member -MemberType NoteProperty | Sort-Object -Property Name | ForEach-Object Name
            $TemplateProperties | Should -Contain '$schema'
            $TemplateProperties | Should -Contain 'contentVersion'
            $TemplateProperties | Should -Contain 'resources'
        }

        It "Tagging should be implemented - if the resource type supports them" {
        }

        It "Delete lock should be implemented - if the resource type supports it" {
        }

        It "[<moduleFolderName>] If delete lock is implemented, the template should have a lockForDeletion parameter with the default value of false" -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateARM = Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue
            try {
                $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[If delete lock is implemented, the template should have a lockForDeletion parameter with the default value of false] Json conversion Error at ($moduleFolderName)" -Verbose
                Continue
            }
            $LockTypeFlag = $true
            $ChildResourceType = $Template.resources.resources.type
            $ParentResourceType = $Template.resources.type
            $LockForDeletion = $Template.parameters.lockForDeletion.defaultValue
            if (($ChildResourceType -like "*providers/locks" -or $ParentResourceType -like "*providers/locks") -and $LockForDeletion -ne $false) {
                $LockTypeFlag = $false
            }
            $LockTypeFlag | Should -Contain $true
        }

        It "[<moduleFolderName>] If delete lock is implemented, it should have a deployment condition with the value of parameters('lockForDeletion')" -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateARM = Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue
            try {
                $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[If delete lock is implemented, it should have a deployment condition with the value of parameters('lockForDeletion')] Json conversion Error at ($moduleFolderName)" -Verbose
                Continue
            }
            $LockFlag = @()
            $ChildDeletelock = $Template.resources.resources.type
            $ParentDeletelock = $Template.resources.type
            $ChildDeletelockCondition = $Template.resources.resources.condition
            $ParentDeletelockCondition = $Template.resources.condition
            if ($ChildDeletelock -like "*providers/locks" -and $ChildDeletelockCondition -notcontains "[parameters('lockForDeletion')]") {
                $LockFlag += $false
            }
            elseif ($ParentDeletelock -like "*providers/locks" -and $ParentDeletelockCondition -notcontains "[parameters('lockForDeletion')]") {
                $LockFlag += $false
            }
            else {
                $LockFlag += $true
            }
            $LockFlag | Should -Not -Contain $false
        }

        It "Diagnostic logs & metrics should be implemented - if the resource type supports them" {
        }

        It "Resource level RBAC should be implemented - if the resource type supports it" {
        }

        It "[<moduleFolderName>] Parameter names should be camel-cased (no dashes or underscores and must start with lower-case letter)" -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateARM = Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue
            try {
                $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[Parameter names should be camel-cased (no dashes or underscores and must start with lower-case letter))] Json conversion Error at ($moduleFolderName)" -Verbose
                Continue
            }

            if (-not $Template.parameters) {
                $true | Should -Be $true
                return
            }

            $CamelCasingFlag = @()
            $Parameter = ($Template.parameters | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" }).Name
            foreach ($Param in $Parameter) {
                if ($Param.substring(0, 1) -cnotmatch '[a-z]' -or $Param -match '-' -or $Param -match '_') {
                    $CamelCasingFlag += $false
                }
                else {
                    $CamelCasingFlag += $true
                }
            }
            $CamelCasingFlag | Should -Not -Contain $false
        }

        It "[<moduleFolderName>] Variable names should be camel-cased (no dashes or underscores and must start with lower-case letter)" -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateARM = Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue
            try {
                $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[Variable names should be camel-cased (no dashes or underscores and must start with lower-case letter))] Json conversion Error at ($moduleFolderName)" -Verbose
                Continue
            }

            if (-not $Template.variables) {
                $true | Should -Be $true
                return
            }

            $CamelCasingFlag = @()
            $Variable = ($Template.variables | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" }).Name

            foreach ($Variab in $Variable) {
                if ($Variab.substring(0, 1) -cnotmatch '[a-z]' -or $Variab -match '-' -or $Variab -match '_') {
                    $CamelCasingFlag += $false
                }
                else {
                    $CamelCasingFlag += $true
                }
            }
            $CamelCasingFlag | Should -Not -Contain $false
        }

        It "[<moduleFolderName>] Output names should be camel-cased (no dashes or underscores and must start with lower-case letter)" -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateARM = Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue
            try {
                $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[Output names should be camel-cased (no dashes or underscores and must start with lower-case letter))] Json conversion Error at ($moduleFolderName)" -Verbose
                Continue
            }
            $CamelCasingFlag = @()
            $Outputs = ($Template.outputs | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" }).Name

            foreach ($Output in $Outputs) {
                if ($Output.substring(0, 1) -cnotmatch '[a-z]' -or $Output -match '-' -or $Output -match '_') {
                    $CamelCasingFlag += $false
                }
                else {
                    $CamelCasingFlag += $true
                }
            }
            $CamelCasingFlag | Should -Not -Contain $false
        }

        It "[<moduleFolderName>] CUA ID deployment should be present in the template" -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateARM = Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue
            try {
                $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[CUA ID deployment should be present in the template] Json conversion Error at ($moduleFolderName)" -Verbose
                Continue
            }
            $CuaIDFlag = @()
            $Schemaverion = $Template.'$schema'
            if ((($Schemaverion.Split('/')[5]).Split('.')[0]) -eq (($RGdeployment.Split('/')[5]).Split('.')[0])) {
                if (($Template.resources.type -ccontains "Microsoft.Resources/deployments" -and $Template.resources.condition -like "*[not(empty(parameters('cuaId')))]*") -or ($Template.resources.resources.type -ccontains "Microsoft.Resources/deployments" -and $Template.resources.resources.condition -like "*[not(empty(parameters('cuaId')))]*")) {
                    $CuaIDFlag += $true
                }
                else {
                    $CuaIDFlag += $false
                }
            }
            $CuaIDFlag | Should -Not -Contain $false
        }

        It "[<moduleFolderName>] The Location should be defined as a parameter, with the default value of 'resourceGroup().Location' or global for ResourceGroup deployment scope" -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateARM = Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue
            try {
                $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[The Location should be defined as a parameter, with the default value of 'resourceGroup().Location' or global for ResourceGroup deployment scope ] Json conversion Error at ($moduleFolderName)" -Verbose
                Continue
            }
            $LocationFlag = $true
            $Schemaverion = $Template.'$schema'
            if ((($Schemaverion.Split('/')[5]).Split('.')[0]) -eq (($RGdeployment.Split('/')[5]).Split('.')[0])) {
                $Locationparamoutputvalue = $Template.parameters.Location.defaultValue
                $Locationparamoutput = ($Template.parameters | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" }).Name
                if ($Locationparamoutput -contains "Location" -and ($Locationparamoutputvalue -eq "[resourceGroup().Location]" -or $Locationparamoutputvalue -eq "global")) {
                    $LocationFlag = $true
                }
                else {
                    $LocationFlag = $false
                }
                $LocationFlag | Should -Contain $true
            }
        }

        It "[<moduleFolderNameException>] All resources that have a Location property should refer to the Location parameter 'parameters('Location')'" -TestCases $deploymentFolderTestCasesException {
            param(
                $moduleFolderNameException,
                $moduleFolderPathException,
                $fileContentException
            )
            $TemplateARM = Get-Content ($fileContentException) -Raw -ErrorAction SilentlyContinue
            try {
                $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[All resources that have a Location property should refer to the Location parameter 'parameters('Location')'] Json conversion Error at ($moduleFolderPathException)" -Verbose
                Continue
            }
            $LocationParamFlag = @()
            $Locmandoutput = $Template.resources
            foreach ($Locmand in $Locmandoutput) {
                if (($Locmand | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" }).Name -contains "Location" -and $Locmand.Location -eq "[parameters('Location')]") {
                    $LocationParamFlag += $true
                }
                elseif (($Locmand | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" }).Name -notcontains "Location") {
                    $LocationParamFlag += $true
                }
                else {
                    $LocationParamFlag += $false
                }
                foreach ($Locm in $Locmand.resources) {
                    if (($Locm | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" }).Name -contains "Location" -and $Locm.Location -eq "[parameters('Location')]") {
                        $LocationParamFlag += $true
                    }
                    elseif (($Locm | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" }).Name -notcontains "Location") {
                        $LocationParamFlag += $true
                    }
                    else {
                        $LocationParamFlag += $false
                    }
                }
            }
            $LocationParamFlag | Should -Not -Contain $false
        }

        It "The template should not have empty lines" {
        }

        It "[<moduleFolderName>] Standard outputs should be provided (e.g. resourceName, resourceId, resouceGroupName" -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateARM = Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue
            try {
                $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[Standard outputs should be provided (e.g. resourceName, resourceId, resouceGroupName] Json conversion Error at ($moduleFolderName)" -Verbose
                Continue
            }

            $Stdoutput = ($Template.outputs | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" }).Name
            $i = 0
            $Schemaverion = $Template.'$schema'
            if ((($Schemaverion.Split('/')[5]).Split('.')[0]) -eq (($RGdeployment.Split('/')[5]).Split('.')[0])) {
                foreach ($Stdo in $Stdoutput) {
                    if ($Stdo -like "*Name*" -or $Stdo -like "*ResourceId*" -or $Stdo -like "*ResourceGroup*") {
                        $true | should -Be $true
                        $i = $i + 1
                    }
                }
                $i | Should -Not -BeLessThan 3
            }
            ElseIf ((($schemaverion.Split('/')[5]).Split('.')[0]) -eq (($Subscriptiondeployment.Split('/')[5]).Split('.')[0])) {
                $Stdoutput | Should -Not -BeNullOrEmpty
            }

        }

        It "[<moduleFolderName>] parameters' description shoud start either by 'Optional.' or 'Required.' or 'Generated.'" -TestCases $deploymentFolderTestCases {
            param(
                $moduleFolderName,
                $moduleFolderPath,
                $fileContent
            )
            $TemplateARM = Get-Content ($fileContent) -Raw -ErrorAction SilentlyContinue
            try {
                $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction SilentlyContinue
            }
            catch {
                Write-Verbose "[parameters' description shoud start either by 'Optional.' or 'Required.' or 'Generated.'] Json conversion Error at ($moduleFolderName)" -Verbose
                Continue
            }

            if (-not $Template.parameters) {
                $true | Should -Be $true
                return
            }

            $ParamDescriptionFlag = @()
            $Paramdescoutput = ($Template.parameters | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" }).Name
            foreach ($Param in $Paramdescoutput) {
                $Data = ($Template.parameters.$Param.metadata).description
                if ($Data -like "Optional. [a-zA-Z]*" -or $Data -like "Required. [a-zA-Z]*" -or $Data -like "Generated. [a-zA-Z]*") {
                    $true | should -Be $true
                    $ParamDescriptionFlag += $true
                }
                else {
                    $ParamDescriptionFlag += $false
                }
            }
            $ParamDescriptionFlag | Should -Not -Contain $false
        }

        # PARAMETER Tests
        It "All parameters in parameters files exist in template file (deploy.json)" -TestCases $deploymentFolderTestCases {
            param (
                [hashtable[]] $parameterFileTestCases
            )

            foreach ($parameterFileTestCase in $parameterFileTestCases) {
                $parameterFile_AllParameterNames = $parameterFileTestCase.parameterFile_AllParameterNames
                $templateFile_AllParameterNames = $parameterFileTestCase.templateFile_AllParameterNames

                $nonExistentParameters = $parameterFile_AllParameterNames | Where-Object { $templateFile_AllParameterNames -notcontains $_ }
                $nonExistentParameters.Count | Should -Be 0 -Because ("no parameter in the parameter file should not exist in the template file. Found excess items: [{0}]" -f ($nonExistentParameters -join ', '))
            }
        }

        It "All required parameters in template file (deploy.json) should exist in parameters files" -TestCases $deploymentFolderTestCases {
            param (
                [hashtable[]] $parameterFileTestCases
            )

            foreach ($parameterFileTestCase in $parameterFileTestCases) {
                $TemplateFile_RequiredParametersNames = $parameterFileTestCase.TemplateFile_RequiredParametersNames
                $parameterFile_AllParameterNames = $parameterFileTestCase.parameterFile_AllParameterNames

                $missingParameters = $templateFile_RequiredParametersNames | Where-Object { $parameterFile_AllParameterNames -notcontains $_ }
                $missingParameters.Count | Should -Be 0 -Because ("no required parameters in the template file should be missing in the parameter file. Found missing items: [{0}]" -f ($missingParameters -join ', '))
            }
        }
    }
}

Describe "Api version tests [All apiVersions in the template should be 'recent']" -Tag ApiCheck {
    $testCases = @()
    $ApiVersions = Get-AzResourceProvider -ListAvailable
    foreach ($TemplateLocation in $folderPathsToScanExcludeRG) {
        $moduleName = Split-Path $TemplateLocation -Leaf
        $TemplateARM = Get-Content (Join-Path -Path $TemplateLocation 'deploy.json') -Raw
        try {
            $Template = ConvertFrom-Json -InputObject $TemplateARM -ErrorAction 'SilentlyContinue'
        }
        catch {
            Write-Verbose "[All apiVersions in the template should be 'recent] Json conversion Error at ($LocatTemplateLocationion)" -Verbose
            Continue
        }

        $ApiVer = $Template.resources.apiVersion
        $ResourceType = $Template.resources.type
        for ($i = 0; $i -lt $ApiVer.count; $i++) {
            if ($ResourceType.Count -gt 1) {
                if ($ResourceType[$i].Split('/').Count -ne 2 -and $ResourceType[$i] -like '*diagnosticsettings*') {
                    $testCases += @{
                        moduleName           = $moduleName
                        resourceType         = 'diagnosticsettings'
                        ProviderNamespace    = 'Microsoft.insights'
                        TargetApi            = $ApiVer[$i]
                        AvailableApiVersions = $ApiVersions
                    }
                }
                elseif ($ResourceType[$i].Split('/').Count -ne 2 -and $ResourceType[$i] -like '*locks*') {
                    $testCases += @{
                        moduleName           = $moduleName
                        resourceType         = 'locks'
                        ProviderNamespace    = 'Microsoft.Authorization'
                        TargetApi            = $ApiVer[$i]
                        AvailableApiVersions = $ApiVersions
                    }
                }
                elseif ($ResourceType[$i].Split('/').Count -ne 2 -and $ResourceType[$i] -like '*roleAssignments*') {
                    $testCases += @{
                        moduleName           = $moduleName
                        resourceType         = 'roleassignments'
                        ProviderNamespace    = 'Microsoft.Authorization'
                        TargetApi            = $ApiVer[$i]
                        AvailableApiVersions = $ApiVersions
                    }
                }
                elseif ($ResourceType[$i] -notlike '*diagnosticsettings*' -and $ResourceType[$i] -notlike '*locks*' -and $ResourceType[$i] -notlike '*roleAssignments*' -and $ResourceType[$i].Split('/').Count -ne 2) {
                    # not handled
                }
                else {
                    $testCases += @{
                        moduleName           = $moduleName
                        resourceType         = $ResourceType[$i].Split('/')[1]
                        ProviderNamespace    = $ResourceType[$i].Split('/')[0]
                        TargetApi            = $ApiVer[$i]
                        AvailableApiVersions = $ApiVersions
                    }
                }
            }
            else {
                $testCases += @{
                    moduleName           = $moduleName
                    resourceType         = ($ResourceType.Split('/')[1])
                    ProviderNamespace    = $ResourceType.Split('/')[0]
                    TargetApi            = $ApiVer
                    AvailableApiVersions = $ApiVersions
                }
            }
        }
    }

    It "In [<moduleName>] used resource type [<resourceType>] should use on of the recent API version(s). Currently using [<TargetApi>]" -TestCases $TestCases {
        param(
            $moduleName,
            $resourceType,
            $TargetApi,
            $ProviderNamespace,
            $AvailableApiVersions
        )

        $namespaceResourceTypes = ($AvailableApiVersions | Where-Object { $_.ProviderNamespace -eq $ProviderNamespace }).ResourceTypes
        $resourceTypeApiVersions = ($namespaceResourceTypes | Where-Object { $_.ResourceTypeName -eq $resourceType }).ApiVersions
        $approvedApiVersions = $resourceTypeApiVersions | Where-Object { $_ -notlike "*-preview" } | Select-Object -First 5
        
        # NOTE: This is a workaround to account for the 'assumed' deployments version used by bicep when building an ARM template from a bicep file with modules in it
        # Ref: https://github.com/Azure/bicep/issues/3819
        if($resourceType -eq 'deployments') {
            $approvedApiVersions += '2019-10-01'
        }

        $approvedApiVersions | Should -Contain $TargetApi
    }
}