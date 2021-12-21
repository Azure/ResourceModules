Describe 'Convert bicep files to ARM' {
    BeforeAll {
        $rootPath = Get-Location
        $armFolderPath = Join-Path -Path $rootPath -ChildPath 'arm'
        $toolsPath = Join-Path -Path $rootPath -ChildPath 'utilities\tools'

        $deployBicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.Name -match 'deploy.bicep' }).Count
        $nestedBicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.Name -like 'nested_*bicep' }).Count

        Write-Verbose "$deployBicepFilesCount deploy.bicep file(s) found"
        Write-Verbose "$nestedBicepFilesCount nested bicep file(s) found"

        $workflowFolderPath = Join-Path -Path $rootPath -ChildPath '.github\workflows'
        $workflowFiles = Get-ChildItem -Path $workflowFolderPath -Filter 'ms.*.yml' -File -Force
        $workflowFilesToChange = 0

        foreach ($workFlowFile in $workflowFiles) {
            $content = Get-Content -Path $workFlowFile.FullName -Raw

            foreach ($line in $content) {
                if ($line.Contains('deploy.bicep')) {
                    $workflowFilesToChange = $workflowFilesToChange + 1
                    break
                }
            }
        }

        Write-Verbose "$workflowFilesToChange workflow files need to change"

        Write-Verbose 'run ConvertTo-ARMTemplate script'
        . "$toolsPath\ConvertTo-ARMTemplate.ps1" -Path $rootPath -SkipMetadataCleanup
    }

    It 'all deploy.bicep files are converted to deploy.json' {
        $deployJsonFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match 'deploy.json' }).Count
        Write-Verbose "$deployJsonFilesCount deploy.json file(s) found"
        $deployJsonFilesCount | Should -Be $deployBicepFilesCount
    }

    It 'all bicep files are removed' {
        $bicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match '.*.bicep' }).Count
        Write-Verbose "$bicepFilesCount bicep file(s) found"
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
}
