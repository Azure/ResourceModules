BeforeAll {
    $rootPath = Get-Location
    $armFolderPath = Join-Path $rootPath 'arm'
    $toolsPath = Join-Path $rootPath 'utilities' 'tools'

    $bicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.Name -like '*.bicep' }).Count
    $nestedBicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.Name -like 'nested_*bicep' }).Count
    $deployBicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.Name -match 'deploy.bicep' }).Count
    $deployParentBicepFilesCount = (Get-ChildItem -Recurse $armFolderPath -Depth 2 | Where-Object { $_.Name -match 'deploy.bicep' }).Count

    $workflowFolderPath = Join-Path $rootPath '.github' 'workflows'
    $workflowFiles = Get-ChildItem -Path $workflowFolderPath -Filter 'ms.*.yml' -File -Force
}

Describe 'Test default behavior' -Tag 'Default' {

    BeforeAll {
        $workflowFilesToChange = 0
        foreach ($workFlowFile in $workflowFiles) {
            foreach ($line in (Get-Content -Path $workFlowFile.FullName)) {
                if ($line.Contains('deploy.bicep')) {
                    $workflowFilesToChange = $workflowFilesToChange + 1
                    break
                }
            }
        }
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

    It 'all workflow files are updated' {
        $workflowFilesUpdated = 0

        foreach ($workFlowFile in $workflowFiles) {
            $content = Get-Content -Path $workFlowFile.FullName

            foreach ($line in $content) {
                if ($line.Contains('deploy.json')) {
                    $workflowFilesUpdated = $workflowFilesUpdated + 1
                    break
                }
            }
        }

        $workflowFilesUpdated | Should -Be $workflowFilesToChange
    }

    AfterAll {
        # Set test suite to blank
        git clean -fd
        git reset --hard
    }
}

Describe 'Test flag to including children' -Tag 'ConvertChildren' {

    BeforeAll {
        $workflowFilesToChange = 0
        foreach ($workFlowFile in $workflowFiles) {
            foreach ($line in (Get-Content -Path $workFlowFile.FullName)) {
                if ($line.Contains('deploy.bicep')) {
                    $workflowFilesToChange = $workflowFilesToChange + 1
                    break
                }
            }
        }
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

    It 'all workflow files are updated' {
        $workflowFilesUpdated = 0

        foreach ($workFlowFile in $workflowFiles) {
            $content = Get-Content -Path $workFlowFile.FullName

            foreach ($line in $content) {
                if ($line.Contains('deploy.json')) {
                    $workflowFilesUpdated = $workflowFilesUpdated + 1
                    break
                }
            }
        }

        Write-Verbose "$workflowFilesUpdated workflow file(s) updated"
        $workflowFilesUpdated | Should -Be $workflowFilesToChange
    }

    AfterAll {
        # Set test suite to blank
        git clean -fd
        git reset --hard
    }
}

Describe 'Test flag not to remove bicep files' -Tag 'SkipBicepCleanup' {

    BeforeAll {
        $workflowFilesToChange = 0
        foreach ($workFlowFile in $workflowFiles) {
            foreach ($line in (Get-Content -Path $workFlowFile.FullName)) {
                if ($line.Contains('deploy.bicep')) {
                    $workflowFilesToChange = $workflowFilesToChange + 1
                    break
                }
            }
        }
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

    It 'all workflow files are updated' {
        $workflowFilesUpdated = 0

        foreach ($workFlowFile in $workflowFiles) {
            foreach ($line in (Get-Content -Path $workFlowFile.FullName)) {
                if ($line.Contains('deploy.json')) {
                    $workflowFilesUpdated = $workflowFilesUpdated + 1
                    break
                }
            }
        }
        $workflowFilesUpdated | Should -Be $workflowFilesToChange
    }

    AfterAll {
        # Set test suite to blank
        git clean -fd
        git reset --hard
    }
}

Describe 'Test flag to skip the cleanup of metadata in ARM files' -Tag 'SkipMetadataCleanup' {

    BeforeAll {
        $workflowFilesToChange = 0
        foreach ($workFlowFile in $workflowFiles) {
            foreach ($line in (Get-Content -Path $workFlowFile.FullName)) {
                if ($line.Contains('deploy.bicep')) {
                    $workflowFilesToChange = $workflowFilesToChange + 1
                    break
                }
            }
        }
        . "$toolsPath\ConvertTo-ARMTemplate.ps1" -Path $rootPath -SkipMetadataCleanup
    }

    It 'all deploy.bicep files are converted to deploy.json' {
        $deployJsonFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match 'deploy.json' }).Count
        $deployJsonFilesCount | Should -Be $deployParentBicepFilesCount
    }

    It 'all bicep files are removed' {
        $bicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match '.*.bicep' }).Count
        $bicepFilesCount | Should -Be 0
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

    It 'all workflow files are updated' {
        $workflowFilesUpdated = 0

        foreach ($workFlowFile in $workflowFiles) {
            foreach ($line in (Get-Content -Path $workFlowFile.FullName)) {
                if ($line.Contains('deploy.json')) {
                    $workflowFilesUpdated = $workflowFilesUpdated + 1
                    break
                }
            }
        }
        $workflowFilesUpdated | Should -Be $workflowFilesToChange
    }

    AfterAll {
        # Set test suite to blank
        git clean -fd
        git reset --hard
    }
}

Describe 'Test flag to skip GitHub workflow updates' -Tag 'SkipWorkflowUpdate' {

    BeforeAll {
        $workflowFilesToChange = 0
        foreach ($workFlowFile in $workflowFiles) {
            foreach ($line in (Get-Content -Path $workFlowFile.FullName)) {
                if ($line.Contains('deploy.bicep')) {
                    $workflowFilesToChange = $workflowFilesToChange + 1
                    break
                }
            }
        }
        . "$toolsPath\ConvertTo-ARMTemplate.ps1" -Path $rootPath -SkipWorkflowUpdate
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
            $content = Get-Content -Path $deployJsonFile.FullName -Raw
            $TemplateObject = $content | ConvertFrom-Json

            if ([bool]($TemplateObject.PSobject.Properties.name -match 'metadata')) {
                $metadataFound = $true;
                break;
            }
        }

        $metadataFound | Should -Be $false
    }

    It 'all workflow files are not' {
        $workflowFilesUpdated = 0

        foreach ($workFlowFile in $workflowFiles) {
            foreach ($line in (Get-Content -Path $workFlowFile.FullName)) {
                if ($line.Contains('deploy.json')) {
                    $workflowFilesUpdated = $workflowFilesUpdated + 1
                    break
                }
            }
        }
        $workflowFilesUpdated | Should -Be 0
    }
}
