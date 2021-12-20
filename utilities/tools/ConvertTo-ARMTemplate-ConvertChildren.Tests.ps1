param (
    [string] $repoPath = (Split-Path -Path (Split-Path -Path (Get-Location).toString() -Parent) -Parent)
)

Describe 'Convert bicep files to ARM' {
    BeforeAll {
        $rootPath = Get-Item -Path $repoPath | Select-Object -ExpandProperty 'FullName'
        $armFolderPath = Join-Path -Path $rootPath -ChildPath 'arm'
        $toolsPath = Join-Path -Path $rootPath -ChildPath 'utilities\tools'

        Write-Host $repoPath
        Write-Host $rootPath

        $deployBicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match 'deploy.bicep' }).Count
        $nestedBicepFilesCount = (Get-ChildItem -Recurse $armFolderPath | Where-Object { $_.FullName -match 'nested_.*bicep' }).Count

        Write-Host "$deployBicepFilesCount deploy.bicep file(s) found"
        Write-Host "$nestedBicepFilesCount nested bicep file(s) found"

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

        Write-Host "$workflowFilesToChange workflow files need to change"

        Write-Host 'run ConvertTo-ARMTemplate script'
        . "$toolsPath\ConvertTo-ARMTemplate.ps1" -Path $rootPath -ConvertChildren
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

        Write-Host "$workflowFilesUpdated workflow file(s) updated"
        $workflowFilesUpdated | Should -Be $workflowFilesToChange
    }
}
