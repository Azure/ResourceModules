# TEST FILE for script [ConvertTo-ARMTemplate.ps1]

# Variables are used but not detected as they are not inside the same block
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param ()

BeforeAll {
    # Define paths
    $rootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent.FullName
    $modulesFolderPath = Join-Path $rootPath 'modules'
    $toolsPath = Join-Path $rootPath 'utilities' 'tools'

    # Load function
    . (Join-Path $toolsPath 'ConvertTo-ARMTemplate.ps1')

    # Collect original files
    $bicepFilesCount = (Get-ChildItem -Recurse $modulesFolderPath | Where-Object { $_.Name -like '*.bicep' }).Count
    $nestedBicepFilesCount = (Get-ChildItem -Recurse $modulesFolderPath | Where-Object { $_.Name -like 'nested_*bicep' }).Count
    $allBicepDeployFilesCount = (Get-ChildItem -Recurse $modulesFolderPath | Where-Object { $_.Name -match 'deploy.bicep' }).Count
    $bicepTestFilesCount = (Get-ChildItem -Recurse $modulesFolderPath | Where-Object { $_.Name -match 'deploy.test.bicep' }).Count
    $topLevelBicepDeployFilesCount = (Get-ChildItem -Recurse $modulesFolderPath -Depth 2 | Where-Object { $_.Name -match 'deploy.bicep' }).Count
    $allBicepFilesCount = $nestedBicepFilesCount + $allBicepDeployFilesCount + $bicepTestFilesCount

    # GitHub Workflows
    $moduleWorkflowFiles = Get-ChildItem -Path (Join-Path $rootPath '.github' 'workflows') -Filter 'ms.*.yml' -File
    $originalModuleWorkflowWithBicep = 0
    foreach ($workFlowFile in $moduleWorkflowFiles) {
        foreach ($line in (Get-Content -Path $workFlowFile.FullName)) {
            if ($line -like '*.bicep*') {
                $originalModuleWorkflowWithBicep += 1
                break
            }
        }
    }
}

Describe 'Test default behavior' -Tag 'Default' {

    BeforeAll {
        ConvertTo-ARMTemplate -Path $rootPath -Verbose -RunSynchronous
    }

    It 'All [<topLevelBicepDeployFilesCount>] top-level [deploy.bicep] files are converted to [deploy.json]' {
        $deployJsonFilesCount = (Get-ChildItem -Recurse $modulesFolderPath | Where-Object { $_.FullName -match 'deploy.json' }).Count
        $deployJsonFilesCount | Should -Be $topLevelBicepDeployFilesCount
    }

    It 'All [<bicepTestFilesCount>] [deploy.test.bicep] files are converted to [deploy.test.json]' {
        $deployJsonFilesCount = (Get-ChildItem -Recurse $modulesFolderPath | Where-Object { $_.FullName -match 'deploy.test.json' }).Count
        $deployJsonFilesCount | Should -Be $bicepTestFilesCount
    }

    It 'All bicep files are removed' {
        $actualBicepFilesCount = (Get-ChildItem -Recurse $modulesFolderPath | Where-Object { $_.FullName -match '.*.bicep' }).Count
        $actualBicepFilesCount | Should -Be 0
    }

    It 'All json files have metadata removed' {
        $releveantJSONFiles = (Get-ChildItem -Recurse $modulesFolderPath).FullName | Where-Object { $_ -match '.+(deploy.json|deploy.test.json)$' }

        $metadataFound = $false

        foreach ($deployJsonFile in $deployJsonFiles) {
            $TemplateObject = Get-Content -Path $deployJsonFile -Raw | ConvertFrom-Json -AsHashtable

            if ([bool]($TemplateObject.Keys -contains 'metadata')) {
                $metadataFound = $true
                break
            }
        }

        $metadataFound | Should -Be $false
    }

    It 'All [<originalModuleWorkflowWithBicep>] GitHub workflow files are updated' {
        $moduleWorkflowFilesUpdated = 0

        foreach ($workFlowFile in $moduleWorkflowFiles) {
            foreach ($line in (Get-Content -Path $workFlowFile.FullName)) {
                if ($line -like '*templateFilePath:*.json*') {
                    $moduleWorkflowFilesUpdated += 1
                    break
                }
            }
        }
        $moduleWorkflowFilesUpdated | Should -Be $originalModuleWorkflowWithBicep
    }
}

Describe 'Test flag to including children' -Tag 'ConvertChildren' {

    BeforeAll {
        ConvertTo-ARMTemplate -Path $rootPath -ConvertChildren -Verbose -RunSynchronous
    }

    It 'All [<allBicepDeployFilesCount>] [deploy.bicep] files are converted to [deploy.json]' {
        $deployJsonFilesCount = (Get-ChildItem -Recurse $modulesFolderPath | Where-Object { $_.FullName -match 'deploy.json' }).Count
        $deployJsonFilesCount | Should -Be $allBicepDeployFilesCount
    }

    It 'All [<bicepTestFilesCount>] [deploy.test.bicep] files are converted to [deploy.test.json]' {
        $deployJsonFilesCount = (Get-ChildItem -Recurse $modulesFolderPath | Where-Object { $_.FullName -match 'deploy.test.json' }).Count
        $deployJsonFilesCount | Should -Be $bicepTestFilesCount
    }

    It 'All bicep files are removed' {
        $actualBicepFilesCount = (Get-ChildItem -Recurse $modulesFolderPath | Where-Object { $_.FullName -match '.*.bicep' }).Count
        $actualBicepFilesCount | Should -Be 0
    }

    It 'All json files have metadata removed' {
        $releveantJSONFiles = (Get-ChildItem -Recurse $modulesFolderPath).FullName | Where-Object { $_ -match '.+(deploy.json|deploy.test.json)$' }

        $metadataFound = $false

        foreach ($deployJsonFile in $deployJsonFiles) {
            $TemplateObject = Get-Content -Path $deployJsonFile -Raw | ConvertFrom-Json -AsHashtable

            if ([bool]($TemplateObject.Keys -contains 'metadata')) {
                $metadataFound = $true
                break
            }
        }

        $metadataFound | Should -Be $false
    }

    It 'All [<originalModuleWorkflowWithBicep>] GitHub workflow files are updated' {
        $moduleWorkflowFilesUpdated = 0

        foreach ($workFlowFile in $moduleWorkflowFiles) {
            foreach ($line in (Get-Content -Path $workFlowFile.FullName)) {
                if ($line -like '*templateFilePath:*.json*') {
                    $moduleWorkflowFilesUpdated += 1
                    break
                }
            }
        }
        $moduleWorkflowFilesUpdated | Should -Be $originalModuleWorkflowWithBicep
    }
}

Describe 'Test flags that skip logic' -Tag 'Skip' {

    BeforeAll {
        ConvertTo-ARMTemplate -Path $rootPath -SkipBicepCleanUp -SkipMetadataCleanup -SkipPipelineUpdate -Verbose -RunSynchronous
    }

    It 'All [<allBicepDeployFilesCount>] deploy.bicep files are converted to deploy.json' {
        $deployJsonFilesCount = (Get-ChildItem -Recurse $modulesFolderPath | Where-Object { $_.FullName -match 'deploy.json' }).Count
        $deployJsonFilesCount | Should -Be $topLevelBicepDeployFilesCount
    }

    It 'All [<allBicepFilesCount>] bicep files are still there' {
        $actualBicepFilesCount = (Get-ChildItem -Recurse $modulesFolderPath | Where-Object { $_.FullName -match '.*.bicep' }).Count
        $actualBicepFilesCount | Should -Be ($nestedBicepFilesCount + $allBicepDeployFilesCount + $bicepTestFilesCount)
    }

    It 'All json files still have metadata' {
        $deployJsonFiles = (Get-ChildItem -Recurse $modulesFolderPath | Where-Object { $_.FullName -match 'deploy.json' })
        $metadataFound = $false

        foreach ($deployJsonFile in $deployJsonFiles) {
            $content = Get-Content -Path $deployJsonFile.FullName -Raw
            $TemplateObject = $content | ConvertFrom-Json -AsHashtable

            if ([bool]($TemplateObject.Keys -contains 'metadata')) {
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
                if ($line -like '*templateFilePath:*.json*') {
                    $moduleWorkflowFilesUpdated += 1
                    break
                }
            }
        }
        $moduleWorkflowFilesUpdated | Should -Be 0
    }
}
