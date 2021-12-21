# TEST FILE for script [ConvertTo-ARMTemplate.ps1]

# Variables are used but not detected as they are not inside the same block
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param ()

BeforeAll {
    $rootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent.FullName
    $armFolderPath = Join-Path $rootPath 'arm'
    $toolsPath = Join-Path $rootPath 'utilities' 'tools'

    $bicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.Name -like '*.bicep' }).Count
    $nestedBicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.Name -like 'nested_*bicep' }).Count
    $deployBicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.Name -match 'deploy.bicep' }).Count
    $deployParentBicepFilesCount = (Get-ChildItem -Recurse $armFolderPath -Depth 2 | Where-Object { $_.Name -match 'deploy.bicep' }).Count

    # GitHub Workflows
    $moduleWorkflowFiles = Get-ChildItem -Path (Join-Path $rootPath '.github' 'workflows') -Filter 'ms.*.yml' -File
    $originalModuleWorkflowWithBicep = 0
    foreach ($workFlowFile in $moduleWorkflowFiles) {
        foreach ($line in (Get-Content -Path $workFlowFile.FullName)) {
            if ($line.Contains('*.bicep')) {
                $originalModuleWorkflowWithBicep += 1
                break
            }
        }
    }

    # Azure DevOps pipelines
    $adoModulePipelineFiles = Get-ChildItem -Path (Join-Path $rootPath '.azuredevops' 'modulePipelines') -Filter 'ms.*.yml' -File
    $originalModulePipelinesWithBicep = 0
    foreach ($adoModulePipelineFile in $adoModulePipelineFiles) {
        foreach ($line in (Get-Content -Path $adoModulePipelineFile.FullName)) {
            if ($line.Contains('*.bicep')) {
                $originalModulePipelinesWithBicep += 1
                break
            }
        }
    }
}

Describe 'Test default behavior' -Tag 'Default' {

    BeforeAll {
        . "$toolsPath\ConvertTo-ARMTemplate.ps1" -Path $rootPath
    }

    It 'all deploy.bicep files are converted to deploy.json' {
        $deployJsonFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match 'deploy.json' }).Count
        $deployJsonFilesCount | Should -Be $deployParentBicepFilesCount
    }

    It 'all bicep files are removed' {
        $bicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match '.*.bicep' }).Count
        $bicepFilesCount | Should -Be 0
    }

    It 'all json files have metadata removed' {
        $deployJsonFiles = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match 'deploy.json' })
        $metadataFound = $false

        foreach ($deployJsonFile in $deployJsonFiles) {
            $TemplateObject = Get-Content -Path $deployJsonFile.FullName -Raw | ConvertFrom-Json

            if ([bool]($TemplateObject.PSobject.Properties.name -match 'metadata')) {
                $metadataFound = $true;
                break;
            }
        }

        $metadataFound | Should -Be $false
    }

    It 'all pipeline files are updated' {
        $moduleWorkflowFilesUpdated = 0

        foreach ($workFlowFile in $moduleWorkflowFiles) {
            $content = Get-Content -Path $workFlowFile.FullName

            foreach ($line in $content) {
                if ($line.Contains('deploy.json')) {
                    $moduleWorkflowFilesUpdated += 1
                    break
                }
            }
        }

        $moduleWorkflowFilesUpdated | Should -Be $originalModuleWorkflowWithBicep
    }

    AfterAll {
        # Set test suite to blank
        git clean -fd
        git reset --hard
    }
}

Describe 'Test flag to including children' -Tag 'ConvertChildren' {

    BeforeAll {
        . "$toolsPath\ConvertTo-ARMTemplate.ps1" -Path $rootPath -ConvertChildren
    }

    It 'all deploy.bicep files are converted to deploy.json' {
        $deployJsonFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match 'deploy.json' }).Count
        $deployJsonFilesCount | Should -Be $deployBicepFilesCount
    }

    It 'all bicep files are removed' {
        $bicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match '.*.bicep' }).Count
        $bicepFilesCount | Should -Be 0
    }

    It 'all json files have metadata removed' {
        $deployJsonFiles = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match 'deploy.json' })
        $metadataFound = $false

        foreach ($deployJsonFile in $deployJsonFiles) {
            $TemplateObject = Get-Content -Path $deployJsonFile.FullName -Raw | ConvertFrom-Json

            if ([bool]($TemplateObject.PSobject.Properties.name -match 'metadata')) {
                $metadataFound = $true;
                break;
            }
        }

        $metadataFound | Should -Be $false
    }

    It 'All GitHub workflow files are updated' {
        $moduleWorkflowFilesUpdated = 0

        foreach ($workFlowFile in $moduleWorkflowFiles) {
            $content = Get-Content -Path $workFlowFile.FullName

            foreach ($line in $content) {
                if ($line.Contains('deploy.json')) {
                    $moduleWorkflowFilesUpdated += 1
                    break
                }
            }
        }
        $moduleWorkflowFilesUpdated | Should -Be $originalModuleWorkflowWithBicep
    }

    It 'All Azure DevOps pipeline files are changed' {
        $modulePipelineFileUpdated = 0

        foreach ($pipelineFile in $adoModulePipelineFiles) {
            foreach ($line in (Get-Content -Path $pipelineFile.FullName)) {
                if ($line.Contains('deploy.json')) {
                    $modulePipelineFileUpdated += 1
                    break
                }
            }
        }
        $modulePipelineFileUpdated | Should -Be $originalModulePipelinesWithBicep
    }

    AfterAll {
        # Set test suite to blank
        git clean -fd
        git reset --hard
    }
}

Describe 'Test skip flags' -Tag 'Skip' {

    BeforeAll {
        . "$toolsPath\ConvertTo-ARMTemplate.ps1" -Path $rootPath -SkipBicepCleanUp
    }

    It 'all deploy.bicep files are converted to deploy.json' {
        $deployJsonFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match 'deploy.json' }).Count
        $deployJsonFilesCount | Should -Be $deployParentBicepFilesCount
    }

    It 'all bicep files are still there' {
        $bicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match '.*.bicep' }).Count
        $bicepFilesCount | Should -Be $bicepFilesCount
    }

    It 'all json files still have metadata' {
        $deployJsonFiles = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match 'deploy.json' })
        $metadataFound = $false

        foreach ($deployJsonFile in $deployJsonFiles) {
            $content = Get-Content -Path $deployJsonFile.FullName -Raw
            $TemplateObject = $content | ConvertFrom-Json

            if ([bool]($TemplateObject.PSobject.Properties.name -match 'metadata')) {
                $metadataFound = $true;
                break;
            }
        }
        $metadataFound | Should -Be $true
    }

    It 'No GH workflow files are changed' {
        $moduleWorkflowFilesUpdated = 0

        foreach ($workFlowFile in $moduleWorkflowFiles) {
            foreach ($line in (Get-Content -Path $workFlowFile.FullName)) {
                if ($line.Contains('deploy.json')) {
                    $moduleWorkflowFilesUpdated += 1
                    break
                }
            }
        }
        $moduleWorkflowFilesUpdated | Should -Be 0
    }

    It 'No Azure DevOps pipeline files are changed' {
        $modulePipelineFileUpdated = 0

        foreach ($pipelineFile in $adoModulePipelineFiles) {
            foreach ($line in (Get-Content -Path $pipelineFile.FullName)) {
                if ($line.Contains('deploy.json')) {
                    $modulePipelineFileUpdated += 1
                    break
                }
            }
        }
        $modulePipelineFileUpdated | Should -Be 0
    }

    AfterAll {
        # Set test suite to blank
        git clean -fd
        git reset --hard
    }
}
