Describe 'Convert bicep files to ARM' {
    BeforeAll {
        # $rootPath = Get-Item -Path $Path | Select-Object -ExpandProperty 'FullName'
        # $armFolderPath = Join-Path -Path $rootPath -ChildPath 'arm'
        # $toolsPath = Join-Path -Path $rootPath -ChildPath 'utilities\tools'

        $armFolderPath = 'C:\Users\rahalan\repos\internal\ResourceModules\arm'

        $deployBicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match 'deploy.bicep' }).Count
        # $nestedBicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match 'nested_.*bicep' }).Count

        Write-Host "$deployBicepFilesCount deploy.bicep file(s) found"
        # Write-Host "$nestedBicepFilesCount nested bicep file(s) found"

        $workflowFolderPath = 'C:\Users\rahalan\repos\internal\ResourceModules\.github\workflows'
        $workflowFiles = Get-ChildItem -Path $workflowFolderPath -Filter 'ms.*.yml' -File -Force
        $workflowFilesToChange = 0

        foreach ($workFlowFile in $workflowFiles) {
            $content = Get-Content -Path $workFlowFile.FullName

            foreach ($line in $content) {
                if ($line.Contains('deploy.bicep')) {
                    $workflowFilesToChange = $workflowFilesToChange + 1
                    break
                }
            }
        }

        Write-Host "$workflowFilesToChange workflow files need to change"

        Write-Host 'run ConvertTo-ARMTemplate script'
        # .\utilities\tools\ConvertTo-ARMTemplate.ps1 -Path 'C:\Users\rahalan\repos\internal\ResourceModules' -ConvertChildren
    }

    It 'all deploy.bicep files are converted to deploy.json' {
        $deployJsonFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match 'deploy.json' }).Count
        Write-Host "$deployJsonFilesCount deploy.json file(s) found"
        $deployJsonFilesCount | Should -Be $deployBicepFilesCount
    }

    It 'all bicep files are removed' {
        $bicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match '.*.bicep' }).Count
        Write-Host "$bicepFilesCount bicep file(s) found"
        $bicepFilesCount | Should -Be 0
    }

    # $workflowFolderPath = Join-Path -Path $rootPath -ChildPath '.github\workflows'
    # $workflowFiles = Get-ChildItem -Path $workflowFolderPath -Filter 'ms.*.yml' -File -Force
}
