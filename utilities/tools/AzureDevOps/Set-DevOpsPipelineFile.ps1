
<#
.SYNOPSIS
Generate all module pipeline files for Azure DevOps based on the ones currently implement for GitHub workflows

.DESCRIPTION
Generate all module pipeline files for Azure DevOps based on the ones currently implement for GitHub workflows
Note: The parameter file refernces are fetched from the actual module folder. Hence the list may diviate from what is specified in the corrsponding GitHub workflow.

.PARAMETER DevOpsPipelineFolderPath
Optional. The path where the Azure DevOps pipelines should be stored
Defaults to: '.azuredevops/modulePipelines'

.PARAMETER DevOpsPipelineTemplatePath
Optional. The path to the Azure DevOps pipeline template file.
Defaults to: './devOpsPipelineTemplate.yml'

Should contain the tokens (<...>) to be replaced.
Currently supported are:
- pipelineName
- removeFlag
- versionFlag
- pipelineFileName
- relativeModuleFolderPath
- pipelineParamterPaths (should be set behind the 'deploymentBlocks: <...>')
- relativePathOfRemovalScript (should bet set right under the removal template)

.PARAMETER GitHubWorkflowFolderPath
Optional. The path to the GitHub workflows folder to crawl from
Defaults to: '.github/workflows'

.EXAMPLE
Set-DevOpsPipelineFile

Generate all Azure DevOps pipeline files in the default DevOps pipeline folder based on the workflows files in the default workflows folder based on the provided default template
#>
function Set-DevOpsPipelineFile {


    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $DevOpsPipelineFolderPath = (Join-Path (Split-Path (Split-Path (Split-Path $PSScriptRoot))) '.azuredevops' 'modulePipelines'),

        [Parameter(Mandatory = $false)]
        [string] $DevOpsPipelineTemplatePath = (Join-Path $PSScriptRoot 'src' 'devOpsPipelineTemplate.yml'),

        [Parameter(Mandatory = $false)]
        [string] $GitHubWorkflowFolderPath = (Join-Path (Split-Path (Split-Path (Split-Path $PSScriptRoot))) '.github' 'workflows')
    )

    #######################
    ##  General details  ##
    #######################
    $repoRoot = Split-Path (Split-Path $GitHubWorkflowFolderPath)

    ######################################
    ##  Fetch details for all workflows  #
    ######################################
    $foundDetails = [System.Collections.ArrayList]@()
    $moduleWorkflows = Get-ChildItem -Path $GitHubWorkflowFolderPath -Filter 'ms.*'
    foreach ($workflowPath in $moduleWorkflows.FullName) {

        $workFlowContent = Get-Content $workflowPath

        ## Fetch Pipeline Name
        ## ===================
        $PipelineName = $workFlowContent[0].Split('name: ')[1].Replace("'", '').Replace(': ', ' - ')

        ## Fetch Remove Deployment Flag
        ## ============================
        $removeParamIndex = 0
        for ($removeParamIndex = 0; $removeParamIndex -lt $workFlowContent.Count; $removeParamIndex++) {
            if ($workFlowContent[$removeParamIndex] -match 'removeDeployment:') {
                break
            }
        }
        $removeFlag = $workFlowContent[$removeParamIndex + 4].Split(':')[1].Replace("'", '').Trim()

        ## Fetch Version Flag
        ## ==================
        $versionParamIndex = 0
        for ($versionParamIndex = 0; $versionParamIndex -lt $workFlowContent.Count; $versionParamIndex++) {
            if ($workFlowContent[$versionParamIndex] -match 'customVersion:') {
                break
            }
        }
        $versionFlag = $workFlowContent[$versionParamIndex + 3].Split(':')[1].Replace("'", '').Trim()

        ## Fetch Pipeline File Name
        ## ========================
        $PipelineFileName = Split-Path $workflowPath -Leaf

        ## Fetch Relative Module Folder Path
        ## =================================
        $relativePathVarIndex = 0
        for ($relativePathVarIndex = 0; $relativePathVarIndex -lt $workFlowContent.Count; $relativePathVarIndex++) {
            if ($workFlowContent[$relativePathVarIndex] -match 'modulePath: ') {
                break
            }
        }
        $RelativeModuleFolderPath = $workFlowContent[$relativePathVarIndex].Split(':')[1].Replace("'", '').Trim()

        ## Fetch Pipeline Parameter Paths
        ## ==============================
        $moduleParameterFiles = Get-ChildItem (Join-Path $repoRoot $RelativeModuleFolderPath '.parameters')
        $PipelineParamterFileNames = $moduleParameterFiles | Split-Path -Leaf

        ## Fetch optional removal script path
        ## ==================================
        $relativePathRemovalIndex = 0
        for ($relativePathRemovalIndex = 0; $relativePathRemovalIndex -lt $workFlowContent.Count; $relativePathRemovalIndex++) {
            if ($workFlowContent[$relativePathRemovalIndex] -match 'relativePathOfRemovalScript: ') {
                break
            }
        }
        if ($relativePathRemovalIndex -ne $workFlowContent.Count) {
            $relativePathOfRemovalScript = $workFlowContent[$relativePathRemovalIndex].Split(':')[1].Trim()
        } else {
            $relativePathOfRemovalScript = ''
        }

        ## Build Result Set
        ## ================
        $foundDetails += @{
            PipelineName                = $PipelineName
            removeFlag                  = $removeFlag
            versionFlag                 = $versionFlag
            PipelineFileName            = $PipelineFileName
            RelativeModuleFolderPath    = $RelativeModuleFolderPath
            PipelineParamterFileNames   = $PipelineParamterFileNames
            relativePathOfRemovalScript = $relativePathOfRemovalScript
        }
    }
    ###############
    ##   PRINT   ##
    ###############
    Write-Verbose ($foundDetails | ConvertTo-Json | ConvertFrom-Json | Format-Table | Out-String)

    ############################
    ##  Create Dev Ops Files  ##
    ############################
    foreach ($tokenSet in $foundDetails) {
        $newFilePath = Join-Path $DevOpsPipelineFolderPath $tokenSet.PipelineFileName

        if (-not (Test-Path $newFilePath)) {
            if ($PSCmdlet.ShouldProcess("New file in path [$newFilePath]", 'Create')) {
                $null = New-Item -Path $newFilePath -ItemType 'File'
            }
        }

        $newFileContent = Get-Content -Path $DevOpsPipelineTemplatePath -Raw

        foreach ($key in $tokenSet.Keys) {
            switch ($key) {
                'PipelineParamterFileNames' {
                    $formattedParamFiles = $tokenSet[$key] | ForEach-Object { '            - path: $(modulePath)/.parameters/{0}' -f $_ }
                    $targetString = "`n{0}" -f ($formattedParamFiles -join "`n")
                    $newFileContent = $newFileContent.Replace('<PipelineParamterPaths>', $targetString)
                }
                'relativePathOfRemovalScript' {
                    if (-not [String]::IsNullOrEmpty($tokenSet[$key])) {
                        $formattedRemovelParameter = "parameters:`n          relativePathOfRemovalScript: {0}" -f $tokenSet[$key]
                        $newFileContent = $newFileContent.Replace('<relativePathOfRemovalScript>', $formattedRemovelParameter)
                    } else {
                        $newFileContent = $newFileContent.Replace('<relativePathOfRemovalScript>', '')
                    }
                }
                Default {
                    $newFileContent = $newFileContent.Replace("<$key>", $tokenSet[$key])
                }
            }
        }

        if ($PSCmdlet.ShouldProcess("Content in file [$newFilePath]", 'Set')) {
            $null = Set-Content -Path $newFilePath -Value $newFileContent.TrimEnd() -Force
        }
    }
}
