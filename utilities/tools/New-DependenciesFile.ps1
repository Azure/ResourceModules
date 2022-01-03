#region helper
<#
.SYNOPSIS
Update the GitHub workflow file to leverage the generated dependency file(s)

.DESCRIPTION
Update the GitHub workflow file to leverage the generated dependency file(s)

.PARAMETER RepoRoot
Mandatory. The path to the root of the current repository.

.PARAMETER ModuleName
Mandatory. The name of the module. E.g. 'virtualMachines'

.PARAMETER rgPatternEnvName
Mandatory. The name of the resource group pattern environment variable to add to the pipeline (e.g. 'rgPattern')

.PARAMETER rgPattern
Mandatory. The value for the [rgPatternEnvName] environment variable that is the naming format of the resource group to deploy into (e.g. 'test-ms.compute-virtualMachines-{0}-rg')

.PARAMETER ProviderNameShort
Mandatory. The short version of the provider namespace to operate in (e.g. 'ms.compute')

.EXAMPLE
Set-GitHubWorkflow -RepoRoot 'C:/resourceModules' -ModuleName 'virtualMachines' -RgPatternEnvName 'rgPattern' -RgPattern 'test-ms.compute-virtualMachines-{0}-rg' -ProviderNameShort 'ms.compute'

Update the GitHub workflow to leverage the dependency file(s) by adding the provided resource group pattern environment variable
#>
function Set-GitHubWorkflow {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string] $RepoRoot,

        [Parameter(Mandatory = $true)]
        [string] $ModuleName,

        [Parameter(Mandatory = $true)]
        [string] $RgPatternEnvName,

        [Parameter(Mandatory = $true)]
        [string] $RgPattern,

        [Parameter(Mandatory = $true)]
        [string] $ProviderNameShort
    )

    $gitHubWorkflowFilePath = (Join-Path $RepoRoot '.github' 'workflows' ('{0}.{1}.yml' -f $ProviderNameShort, $ModuleName)).ToLower()
    if (-not (Test-Path $gitHubWorkflowFilePath)) {
        throw "GitHub workflow file in path [$gitHubWorkflowFilePath] not found."
    }

    # Process content
    # ---------------
    # Env
    # ---
    $workflowContent = Get-Content $gitHubWorkflowFilePath
    # Find 'env:' section index
    $envIndex = 0

    while ($workflowContent[$envIndex] -notlike 'env:*' -and $envIndex -lt $workflowContent.count) {
        $envIndex++
    }
    if ($envIndex -ge $workflowContent.count) {
        throw "[env] section not found in workflow file [$gitHubWorkflowFilePath]"
    }

    # Find end of 'env:' section index
    $envEndIndex = $envIndex + 1
    while ($workflowContent[$envEndIndex] -notlike 'jobs:*' -and $envEndIndex -lt $workflowContent.count) {
        $envEndIndex++
    }
    if ($envEndIndex -ge $workflowContent.count) {
        throw "[jobs] section not found in workflow file [$gitHubWorkflowFilePath]"
    }

    $RgPatternExists = $false
    for ($index = $envIndex + 1; $index -le $envEndIndex; $index++) {
        if (-not [String]::IsNullOrEmpty($workflowContent[$index]) -and $workflowContent[$index].Split(':')[0].Trim() -eq $RgPatternEnvName) {
            # Rg pattern already in file. Updating
            $workflowContent[$index] = "{0}: '{1}'" -f $workflowContent[$index].Split(':')[0], $RgPattern
            $RgPatternExists = $true
            break
        }
    }
    if (-not $RgPatternExists) {
        # Rg pattern not yet in file. Adding new
        $newLine = "  {0}: '{1}'" -f $RgPatternEnvName, $RgPattern
        $workflowContent = $workflowContent[0..$envIndex] + @($newLine) + $workflowContent[($envIndex + 1)..$workflowContent.Count]
    }

    # Deploy
    # ------
    $rgRefIndex = $envEndIndex
    while ($workflowContent[$rgRefIndex] -notlike '*resourceGroupName:*' -and $rgRefIndex -lt $workflowContent.count) {
        $rgRefIndex++
    }
    if ($rgRefIndex -ge $workflowContent.count) {
        throw "[resourceGroupName] deploy job parameter not found in workflow file [$gitHubWorkflowFilePath]"
    }
    $workflowContent[($rgRefIndex)] = "{0}: '{1}'" -f $workflowContent[$rgRefIndex].Split(':')[0], '${{ format(env.rgPattern, matrix.parameterFilePaths) }}'

    # Save result
    if ($PSCmdlet.ShouldProcess("Workflow file [$gitHubWorkflowFilePath]", 'Update')) {
        $null = Set-Content -Path $gitHubWorkflowFilePath -Value $workflowContent -Force
    }
}

<#
.SYNOPSIS
Update the Azure DevOps pipeline file to leverage the generated dependency file(s)

.DESCRIPTION
Update the Azure DevOps pipeline file to leverage the generated dependency file(s)

.PARAMETER RepoRoot
Mandatory. The path to the root of the current repository.

.PARAMETER ModuleName
Mandatory. The name of the module. E.g. 'virtualMachines'

.PARAMETER rgPatternEnvName
Mandatory. The name of the resource group pattern environment variable to add to the pipeline (e.g. 'rgPattern')

.PARAMETER rgPattern
Mandatory. The value for the [rgPatternEnvName] environment variable that is the naming format of the resource group to deploy into (e.g. 'test-ms.compute-virtualMachines-{0}-rg')

.PARAMETER ProviderNameShort
Mandatory. The short version of the provider namespace to operate in (e.g. 'ms.compute')

.EXAMPLE
Set-AzureDevOpsPipeline -RepoRoot 'C:/resourceModules' -ModuleName 'virtualMachines' -RgPatternEnvName 'rgPattern' -RgPattern 'test-ms.compute-virtualMachines-{0}-rg' -ProviderNameShort 'ms.compute'

Update the Azure DevOps pipeline to leverage the dependency file(s) by adding the provided resource group pattern environment variable
#>
function Set-AzureDevOpsPipeline {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string] $RepoRoot,

        [Parameter(Mandatory = $true)]
        [string] $ModuleName,

        [Parameter(Mandatory = $true)]
        [string] $RgPatternEnvName,

        [Parameter(Mandatory = $true)]
        [string] $RgPattern,

        [Parameter(Mandatory = $true)]
        [string] $ProviderNameShort
    )

    $azureDevOpsPipelineFilePath = Join-Path $RepoRoot '.azuredevops' 'modulePipelines' ('{0}.{1}.yml' -f $ProviderNameShort, $ModuleName)
    if (-not (Test-Path $azureDevOpsPipelineFilePath)) {
        throw "Azure DevOps pipeline file in path [$azureDevOpsPipelineFilePath] not found."
    }

    # Process content
    # ---------------
    # Variables
    # ---------
    $pipelineContent = Get-Content $azureDevOpsPipelineFilePath
    # Find 'variables:' section index
    $variablesIndex = 0

    while ($pipelineContent[$variablesIndex] -notlike 'variables:*' -and $variablesIndex -lt $pipelineContent.count) {
        $variablesIndex++
    }
    if ($variablesIndex -ge $pipelineContent.count) {
        throw "[variables] section not found in pipeline file [$azureDevOpsPipelineFilePath]"
    }

    # Find end of 'variables:' section index
    $variablesEndIndex = $variablesIndex + 1
    while (-not [String]::IsNullOrEmpty($pipelineContent[$variablesEndIndex + 1]) -and $pipelineContent[$variablesEndIndex + 1] -notlike 'stages:*' -and $variablesEndIndex -lt $pipelineContent.count) {
        $variablesEndIndex++
    }
    if ($variablesEndIndex -ge $pipelineContent.count) {
        throw "[stages] section not found in pipeline file [$azureDevOpsPipelineFilePath]"
    }

    $RgPatternExists = $false
    for ($index = $variablesIndex + 1; $index -le $variablesEndIndex; $index++) {
        if (-not [String]::IsNullOrEmpty($pipelineContent[$index]) -and $pipelineContent[$index] -like "*$RgPatternEnvName*") {
            # Rg pattern already in file. Updating
            $pipelineContent[$index + 1] = "{0}: '{1}'" -f $pipelineContent[$index + 1].Split(':')[0], $RgPattern
            $RgPatternExists = $true
            break
        }
    }
    if (-not $RgPatternExists) {
        # Rg pattern not yet in file. Adding new
        $newLineName = "  - name: '{0}'" -f $RgPatternEnvName
        $newLineValue = "    value: '{0}'" -f $RgPattern
        $pipelineContent = $pipelineContent[0..$variablesEndIndex] + @($newLineName, $newLineValue) + $pipelineContent[($variablesEndIndex + 1)..$pipelineContent.Count]
    }

    # Deploy
    # ------
    $deploymentBlocksStartIndex = $variablesEndIndex
    while ($pipelineContent[$deploymentBlocksStartIndex] -notlike '*deploymentBlocks:*' -and $deploymentBlocksStartIndex -lt $pipelineContent.count) {
        $deploymentBlocksStartIndex++
    }
    if ($deploymentBlocksStartIndex -ge $pipelineContent.count) {
        throw "[deploymentBlocks] deploy job parameter not found in workflow file [$azureDevOpsPipelineFilePath]"
    }

    # Add resource group name parameter to each deployment block
    $deploymentBlocksListIndex = $deploymentBlocksStartIndex + 1
    while ($pipelineContent[$deploymentBlocksListIndex] -notlike '*- stage:*' -and $deploymentBlocksListIndex -lt $pipelineContent.count) {
        if ($pipelineContent[$deploymentBlocksListIndex] -like '*- path:*') {
            # process individual deployment block
            $blockEndindex = $deploymentBlocksListIndex
            while (-not [String]::IsNullOrEmpty($pipelineContent[$blockEndindex + 1]) -and $pipelineContent[$blockEndindex + 1] -notlike '*- path:*' -and $blockEndindex -lt $pipelineContent.count) {
                $blockEndindex++
            }

            # Process dpeloyment block
            $resourceGroupNameValueExists = $false
            $parameterFileName = Split-Path $pipelineContent[$deploymentBlocksListIndex].Split(':')[1].Trim() -Leaf
            $resourceGroupNameValue = "`${{ format(variables.rgPattern, '$parameterFileName') }}"
            for ($index = $deploymentBlocksListIndex; $index -le $blockEndindex; $index++) {
                if (-not [String]::IsNullOrEmpty($pipelineContent[$index]) -and $pipelineContent[$index] -like '*resourceGroupName:*') {
                    # ResourceGroupName parameter already in block. Updating
                    $pipelineContent[$index] = '{0}: {1}' -f $pipelineContent[$index].Split(':')[0], $resourceGroupNameValue
                    $resourceGroupNameValueExists = $true
                    break
                }
            }
            if (-not $resourceGroupNameValueExists) {
                # ResourceGroupName parameter not yet in block. Adding new
                $newLine = '              resourceGroupName: {0}' -f $resourceGroupNameValue
                $pipelineContent = $pipelineContent[0..$blockEndindex] + @($newLine) + $pipelineContent[($blockEndindex + 1)..$pipelineContent.Count]
            }
        }

        $deploymentBlocksListIndex++
    }

    # Save result
    if ($PSCmdlet.ShouldProcess("Pipeline file [$azureDevOpsPipelineFilePath]", 'Update')) {
        $null = Set-Content -Path $azureDevOpsPipelineFilePath -Value $pipelineContent -Force
    }
}

<#
.SYNOPSIS
Update or add a dependency template for a given parameter file

.DESCRIPTION
Update or add a dependency template for a given parameter file on a best effort basis.

.PARAMETER RepoRoot
Mandatory. The path to the root of the current repository.

.PARAMETER ProviderName
Mandatory. The name of the provider namespace to process

.PARAMETER moduleName
Mandatory. The resource type of the module to process

.PARAMETER parameterFilePath
Mandatory. The path the the parameter file to generate the dependency file for

.EXAMPLE
Set-DependencyTemplate -RepoRoot 'C:/resourceModules' -ProviderName 'Microsoft.Compute' -moduleName 'virtualMachines' -ParameterFilePath 'C:/resourceModules/arm/Microsoft.Compute/VirtualMachines/virtualMachines/min.parameters.json'

Update or create a dependency template for the parmeter file 'min.parameter.json' for module 'Microsoft.Compute/virtualMachines'
#>
function Set-DependencyTemplate {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $RepoRoot,

        [Parameter(Mandatory = $true)]
        [string] $ProviderName,

        [Parameter(Mandatory = $true)]
        [string] $ModuleName,

        [Parameter(Mandatory = $true)]
        [string] $ParameterFilePath
    )

    $templatesDirectory = Join-Path $RepoRoot 'utilities' 'pipelines' 'moduleDependencies' $ProviderName $ModuleName
    $TemplateFilePath = Join-Path $templatesDirectory ('{0}.bicep' -f (Split-Path $ParameterFilePath -LeafBase))

    # Check exected folder
    if (-not (Test-Path $templatesDirectory)) {
        $null = New-Item $templatesDirectory -ItemType 'Directory' -Force
    }

    # Check file iteself
    if (-not (Test-Path $TemplateFilePath)) {
        $initialContent = Get-Content -Path (Join-Path $PSScriptRoot 'dependencyFileSource' 'bootstrap.bicep') -Raw
        $null = New-Item $TemplateFilePath -ItemType 'File' -Value $initialContent -Force
    }

    [array]$dependencyFileContent = Get-Content -Path $TemplateFilePath

    # Process IDs
    # -----------
    $specifiedIds = ((Get-Content -Path $ParameterFilePath | Select-String -Pattern '"(/subscriptions/.*)"').Matches.Groups.Value | ForEach-Object { $_.Replace('"', '') }) | Select-Object -Unique

    foreach ($specifiedId in $specifiedIds) {

        $templateContentInputObject = @{
            originalContent   = $dependencyFileContent
            parameterFilePath = $ParameterFilePath
            moduleName        = $ModuleName
            providerName      = $ProviderName
        }

        switch ($specifiedId) {
            { $PSItem -like '*/Microsoft.ManagedIdentity/UserAssignedIdentities/*' } {
                if (-not (Test-IsModuleContained -ResourceTypeToSeachFor 'Microsoft.ManagedIdentity/UserAssignedIdentities' -ContentToSearchIn $dependencyFileContent)) {
                    $newContent = Get-Content -Path (Join-Path $PSScriptRoot 'dependencyFileSource' 'managedIdentity.bicep')
                    $dependencyFileContent = Add-TemplateContent @templateContentInputObject -newContent $newContent
                }
                break
            }
            { $PSItem -like '*/Microsoft.Storage/StorageAccounts/*' } {
                if (-not (Test-IsModuleContained -ResourceTypeToSeachFor 'Microsoft.Storage/StorageAccounts' -ContentToSearchIn $dependencyFileContent)) {
                    $newContent = Get-Content -Path (Join-Path $PSScriptRoot 'dependencyFileSource' 'storageAccount.bicep')
                    $dependencyFileContent = Add-TemplateContent @templateContentInputObject -newContent $newContent
                }
                break
            }
            { $PSItem -like '*/Microsoft.OperationalInsights/Workspaces/*' } {
                if (-not (Test-IsModuleContained -ResourceTypeToSeachFor 'Microsoft.OperationalInsights/Workspaces' -ContentToSearchIn $dependencyFileContent)) {
                    $newContent = Get-Content -Path (Join-Path $PSScriptRoot 'dependencyFileSource' 'logAnalytics.bicep')
                    $dependencyFileContent = Add-TemplateContent @templateContentInputObject -newContent $newContent
                }
                break
            }
            { $PSItem -like '*/Microsoft.EventHub/namespaces/*' } {
                if (-not (Test-IsModuleContained -ResourceTypeToSeachFor 'Microsoft.EventHub/namespaces' -ContentToSearchIn $dependencyFileContent)) {
                    $newContent = Get-Content -Path (Join-Path $PSScriptRoot 'dependencyFileSource' 'eventHubNamespace.bicep')
                    $dependencyFileContent = Add-TemplateContent @templateContentInputObject -newContent $newContent
                }
                break
            }
            { $PSItem -like '*/Microsoft.Network/virtualNetworks/*' } {
                if (-not (Test-IsModuleContained -ResourceTypeToSeachFor 'Microsoft.Network/virtualNetworks' -ContentToSearchIn $dependencyFileContent)) {
                    $newContent = Get-Content -Path (Join-Path $PSScriptRoot 'dependencyFileSource' 'virtualNetwork.bicep')
                    $dependencyFileContent = Add-TemplateContent @templateContentInputObject -newContent $newContent
                }
                break
            }
        }
    }

    Set-Content $TemplateFilePath -Value $dependencyFileContent
}

<#
.SYNOPSIS
Merge the given template content into the given target file based on their type (variable/module/output)

.DESCRIPTION
Merge the given template content into the given target file based on their type (variable/module/output).
If no variables section exists, it will be added

.PARAMETER originalContent
Mandatory. The content array to add data to

.PARAMETER newContent
Mandatory. The new content array to take the data from.
Different pieces of information (e.g. variables) should have a prefix header like:
- none for variables
- '// Modules //' for modules
- '// Outputs //' for outputs

.PARAMETER parameterFilePath
Optional. The path to the parameter file we're processing.
Required if the dependency-file does not yet have variables in it.
Will be used to generate a short service name as a resource identifier.

.PARAMETER moduleName
Optional. The name of the module we operate in.
Required if the dependency-file does not yet have variables in it.
Will be used to generate a short service name as a resource identifier.

.PARAMETER providerName
Optional. The name of the provider name space we operate in.
Required if the dependency-file does not yet have variables in it.
Will be used to generate a short service name as a resource identifier.

.EXAMPLE
$templateContentInputObject = @{
    originalContent   = @('targetScope = 'subscription', (...))
    newContent        = @('var myvar = { key = 'value' }', (...))
    parameterFilePath = 'C:/Microsoft.Compute/VirtualMachines/virtualMachines/min.parameters.json'
    moduleName        = 'virtualMachines'
    providerName      = 'Microsoft.Compute'
}
$dependencyFileContent = Add-TemplateContent @templateContentInputObject

Add the given new content @('var myvar = { key = 'value' }', (...)) to the file @('targetScope = 'subscription', (...)) split by their resource type. If no varialbes are pre-existing, a servicesShort name will be generated based on the remaining parameters.
#>
function Add-TemplateContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array] $originalContent,

        [Parameter(Mandatory = $true)]
        [array] $newContent,

        [Parameter(Mandatory = $false)]
        [string] $ParameterFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ModuleName,

        [Parameter(Mandatory = $false)]
        [string] $ProviderName
    )

    # Check if a variables section already exist
    if (-not ($originalContent | Select-String -Pattern '^var .* = {').Matches.Value) {
        # Add variables header & servicesShort
        $modulesSectionStart = $originalContent.IndexOf('// Deployments //') - 1
        $newVarContent = Get-Content -Path (Join-Path $PSScriptRoot 'dependencyFileSource' 'bootstrap_var.bicep')

        # inject proposed short
        $generatedName = Get-ServiceShort -moduleName $ModuleName -parameterFilePath $ParameterFilePath -providerName $ProviderName
        $newVarContent[1] = $newVarContent[1].Replace('<updateShort>', $generatedName)

        # set content
        $originalContent = $originalContent[0..($modulesSectionStart - 1)] + $newVarContent + @('') + $originalContent[$modulesSectionStart..($originalContent.Count)]
    }

    # Add variable(s)
    $newVariable = $newContent[0..($newContent.IndexOf('// Modules //') - 1)]
    $modulesSectionStart = $originalContent.IndexOf('// Deployments //') - 1
    $originalContent = $originalContent[0..($modulesSectionStart - 1)] + $newVariable + @('') + $originalContent[$modulesSectionStart..($originalContent.Count)]

    # Add module(s)
    $newModule = $newContent[($newContent.IndexOf('// Modules //') + 1)..($newContent.IndexOf('// Output //') - 1)]
    $outputsSectionStart = $originalContent.IndexOf('// Outputs //') - 1
    $originalContent = $originalContent[0..($outputsSectionStart - 1)] + $newModule + @('') + $originalContent[$outputsSectionStart..($originalContent.Count)]

    # Add output(s)
    $newOutput = $newContent[($newContent.IndexOf('// Output //') + 1)..($newContent.Count - 1)]
    $originalContent = $originalContent + $newOutput

    return $originalContent
}

<#
.SYNOPSIS
Get a proposal for a parameter file specific short-name proposal

.DESCRIPTION
Get a proposal for a parameter file specific short-name proposal. This name can be used to generate a unique but specific name for deployed dependency services.
Handles the given parameters as follows:
- Provider Name: From the provider name remove 'Microsoft.' and if the rest has multiple elements in pascal case, use the first character of each, else create a substring of length 3.
    For example:
    - 'Microsoft.Compute' becomes 'com'
    - 'Microsoft.ContainerInstance' becomes 'ci'
- ModuleName: If it has multiple elements in pascal case, use the first character of each, else create a substring of length 3.
    For example:
    - 'virtualMachines' becomes 'vm'
    - 'servers' becomes 'ser'
- ParameterFilePath: From the files base name, if it has mutliple name prefix elements (aside from parameters.json, like 'win.min.parmameters.json') take a substring of length 3 each, otherwise use just a substring of the name.
    Fore example:
    - 'windows.min.parameters.json' becomes 'winmin'
    - 'parameters.json' becomes 'par'
The result each will be concated into one lowercase string.

.PARAMETER ProviderName
Mandatory. The service provider of the module to generate a name for (e.g. 'Microsoft.Compute/VirtualMachines').

.PARAMETER ModuleName
Mandatory. The name of the module to generate a name for (e.g. 'virtualMachines').

.PARAMETER ParameterFilePath
Mandatory. The path to the parameter file to generate the name for.

.EXAMPLE
Get-ServiceShort -providerName 'Microsoft.Compute/VirtualMachines' -moduleName 'virtualMachines' -parameterFilePath 'C:/Microsoft.Compute/VirtualMachines/virtualMachines/min.parameters.json'

Generates a short identifier for the given parameter. For example 'comvmwinmin'
#>
function Get-ServiceShort {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderName,

        [Parameter(Mandatory = $true)]
        [string] $ModuleName,

        [Parameter(Mandatory = $true)]
        [string] $ParameterFilePath
    )

    # process provider namespace
    [array]$providerParts = ($ProviderName.Split('.')[1] -creplace '([A-Z\W_]|\d+)(?<![a-z])', ' $&').Trim().Split(' ')
    $providerShort = ($providerParts.Count -gt 1) ? (($providerParts | ForEach-Object { $_.ToCharArray()[0] }) -join '').ToLower() : $providerParts.SubString(0, 3).ToLower()

    # process resource type
    [array]$resourceTypeParts = ($ModuleName -creplace '([A-Z\W_]|\d+)(?<![a-z])', ' $&').Trim().Split(' ')
    $resourceTypeShort = ($resourceTypeParts.Count -gt 1) ? (($resourceTypeParts | ForEach-Object { $_.ToCharArray()[0] }) -join '').ToLower() : $resourceTypeParts.SubString(0, 3).ToLower()

    # process parameter file name
    [array]$paramFileParts = (Split-Path $ParameterFilePath -LeafBase).Split('.')
    $prefixes = ($paramFileParts.Count -gt 1) ? ($paramFileParts[0..($paramFileParts.Count - 2)] | ForEach-Object { $_.Substring(0, 3) }) -join '' : $paramFileParts.SubString(0, 3).ToLower()

    # Build name
    return '{0}{1}{2}' -f $providerShort, $resourceTypeShort, $prefixes
}

<#
.SYNOPSIS
Test if the given resource type is already specified as a module deployment in the provided content array.

.DESCRIPTION
Test if the given resource type is already specified as a module deployment in the provided content array. Returns true or false.

.PARAMETER ResourceTypeToSeachFor
Mandatory. The resource type (e.g. storageAccounts) to search for.

.PARAMETER ContentToSearchIn
Mandatory. The content array to search in. Usually an array that contents the contents of a .bicep template.

.EXAMPLE
Test-IsModuleContained -ResourceTypeToSeachFor 'Microsoft.Network/virtualNetworks' -ContentToSearchIn @('targetscope = 'subscription', module vnet 'Microsoft.Network/virtualNetworks' '../deploy.bicep' = {...}')

Search for resource type 'Microsoft.Network/virtualNetworks' in the given array. In this example it would return true.
#>
function Test-IsModuleContained {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceTypeToSeachFor,

        [Parameter(Mandatory = $true)]
        [array] $ContentToSearchIn
    )

    if (($ContentToSearchIn | Select-String -Pattern "^module.*$ResourceTypeToSeachFor.*\.bicep.*'").Matches.Value) {
        return $true
    }
    return $false
}
#endregion

<#
.SYNOPSIS
Generate an intial proposal of a dependency file (.bicep) for a given module.

.DESCRIPTION
Generate an intial proposal of a dependency file (.bicep) for a given module.
The function will generate the file on a best-efforts basis based on resourceIDs in the module's parameter file.
Files will be added to the 'utilities/pipelines/moduleDepenencies' folder as per their provider namespace & resource type.
The files will have the same name as their corresponding parameter file, but with a [.bicep] extension.

.PARAMETER TemplateFilePath
Mandatory. The template file path of the module to generate the dependency file(s) for.

.PARAMETER IncludeGitHubWorkflow
Optional. A switch to tell the function to also update the GitHub workflow file so that it leverages the dependency file(s).

.PARAMETER IncludeAzureDevOpsPipeline
Optional. A switch to tell the function to also update the Azure DevOps pipeline file so that it leverages the dependency file(s).

.EXAMPLE
New-DependenciesFile -TemplateFilePath 'C:\Microsoft.Compute\virtualMachines\deploy.bicep' -IncludeGitHubWorkflow

Generate new dependency files for all parameter files of module 'virtualMachines' and update the GitHub workflow pipeline accordingl
#>
function New-DependenciesFile {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [switch] $IncludeGitHubWorkflow,

        [Parameter(Mandatory = $false)]
        [switch] $IncludeAzureDevOpsPipeline
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }
    process {
        $modulePath = Split-Path $TemplateFilePath -Parent
        $ModuleName = Split-Path $modulePath -Leaf
        $ProviderName = Split-Path (Split-Path $modulePath -Parent) -Leaf
        $ProviderNameShort = $ProviderName.Replace('Microsoft', 'MS')
        $RepoRoot = $TemplateFilePath.Replace('\', '/').Split('/arm/')[0]
        $RgPatternEnvName = 'rgPattern'
        $RgPattern = @('test', $ProviderNameShort.ToLower(), $ModuleName, '{0}', 'rg') -join '-'

        # Handle Pipelines
        # ----------------
        if ($IncludeGitHubWorkflow) {
            $setGitHubWorkflowInputObject = @{
                RepoRoot          = $RepoRoot
                ModuleName        = $ModuleName
                RgPatternEnvName  = $RgPatternEnvName
                RgPattern         = $RgPattern
                ProviderNameShort = $ProviderNameShort
            }
            if ($PSCmdlet.ShouldProcess('GitHub workflow file', 'Update')) {
                Set-GitHubWorkflow @setGitHubWorkflowInputObject
            }
        }
        if ($IncludeAzureDevOpsPipeline) {
            $setAzureDevOpsPipelineInputObject = @{
                RepoRoot          = $RepoRoot
                ModuleName        = $ModuleName
                RgPatternEnvName  = $RgPatternEnvName
                RgPattern         = $RgPattern
                ProviderNameShort = $ProviderNameShort
            }
            if ($PSCmdlet.ShouldProcess('Azure DevOps pipeline file', 'Update')) {
                Set-AzureDevOpsPipeline @setAzureDevOpsPipelineInputObject
            }
        }

        # Handle dependency file
        # ----------------------
        $parameterFiles = Get-ChildItem (Join-Path $modulePath '.parameters') -Filter '*.json'
        foreach ($ParameterFilePath in $parameterFiles.FullName) {
            $dependencyTemplateInputObject = @{
                RepoRoot          = $RepoRoot
                ProviderName      = $ProviderName
                ModuleName        = $ModuleName
                ParameterFilePath = $ParameterFilePath
            }
            if ($PSCmdlet.ShouldProcess(('Dependency template for parameter file [{0}]' -f (Split-Path $ParameterFilePath -Leaf)), 'Set')) {
                Set-DependencyTemplate @dependencyTemplateInputObject
            }
        }

    }
    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
