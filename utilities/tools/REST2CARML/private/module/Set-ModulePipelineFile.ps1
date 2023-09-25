<#
.SYNOPSIS
Set the required pipeline files for the given Resource Type identifier (i.e., the Azure DevOps pipeline & GitHub workflow files)

.DESCRIPTION
Set the required pipeline files for the given Resource Type identifier (i.e., the Azure DevOps pipeline & GitHub workflow files)

.PARAMETER FullResourceType
Mandatory. The complete ResourceType identifier to add the files for (e.g. 'Microsoft.Storage/storageAccounts').

.EXAMPLE
Set-ModulePipelineFile -FullResourceType 'Microsoft.KeyVault/vaults'

Set the pipeline/workflow files for the resource type identifier 'Microsoft.KeyVault/vaults'
#>
function Set-ModulePipelineFile {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType
    )

    $ProviderNamespace = ($FullResourceType -split '/')[0]
    $ResourceType = $FullResourceType -replace "$ProviderNamespace/", ''

    # Tokens to replace in files
    $tokens = @{
        providerNamespace            = $ProviderNamespace
        shortProviderNamespacePascal = ($ProviderNamespace -split '\.')[-1].substring(0, 1).toupper() + ($ProviderNamespace -split '\.')[-1].substring(1)
        shortProviderNamespaceLower  = ($ProviderNamespace -split '\.')[-1].ToLower()
        resourceType                 = $ResourceType
        resourceTypePascal           = $ResourceType.substring(0, 1).toupper() + $ResourceType.substring(1)
        resourceTypeLower            = $ResourceType.ToLower()
    }

    # Create/Update DevOps files
    # --------------------------
    ## GitHub
    $automationFileName = ('ms.{0}.{1}.yml' -f ($ProviderNamespace -split '\.')[-1], $ResourceType).ToLower()
    $gitHubWorkflowYAMLPath = Join-Path $script:repoRoot '.github' 'workflows' $automationFileName
    $workflowFileContent = Get-Content (Join-Path $script:src 'gitHubWorkflowTemplateFile.yml') -Raw
    $workflowFileContent = Set-TokenValuesInArray -Content $workflowFileContent -Tokens $tokens
    if (-not (Test-Path $gitHubWorkflowYAMLPath)) {
        if ($PSCmdlet.ShouldProcess("GitHub Workflow file [$automationFileName]", 'Create')) {
            $null = New-Item $gitHubWorkflowYAMLPath -ItemType 'File' -Value $workflowFileContent.TrimEnd()
        }
    } else {
        if ($PSCmdlet.ShouldProcess("GitHub Workflow file [$automationFileName]", 'Update')) {
            $null = Set-Content -Path $gitHubWorkflowYAMLPath -Value $workflowFileContent.TrimEnd()
        }
    }

    ## Azure DevOps
    $azureDevOpsPipelineYAMLPath = Join-Path $script:repoRoot '.azuredevops' 'modulePipelines' $automationFileName
    $pipelineFileContent = Get-Content (Join-Path $script:src 'azureDevOpsPipelineTemplateFile.yml') -Raw
    $pipelineFileContent = Set-TokenValuesInArray -Content $pipelineFileContent -Tokens $tokens
    if (-not (Test-Path $azureDevOpsPipelineYAMLPath)) {
        if ($PSCmdlet.ShouldProcess("GitHub Workflow file [$automationFileName]", 'Create')) {
            $null = New-Item $azureDevOpsPipelineYAMLPath -ItemType 'File' -Value $pipelineFileContent.TrimEnd()
        }
    } else {
        if ($PSCmdlet.ShouldProcess("GitHub Workflow file [$automationFileName]", 'Update')) {
            $null = Set-Content -Path $azureDevOpsPipelineYAMLPath -Value $pipelineFileContent.TrimEnd()
        }
    }
}
