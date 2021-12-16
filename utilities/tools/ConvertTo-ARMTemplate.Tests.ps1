Describe 'Convert bicep files to ARM' {
    BeforeAll {
        $repoRootPath = '.\..\..\arm\'
        $deployBicepFilesCount = (Get-ChildItem -Recurse $repoRootPath | Where-Object { $_.FullName -match 'deploy.bicep' }).Count
        $nestedBicepFilesCount = (Get-ChildItem -Recurse $repoRootPath | Where-Object { $_.FullName -match 'nested_.*bicep' }).Count
        Write-Host "$deployBicepFilesCount deploy.bicep file(s) found"
        Write-Host "$nestedBicepFilesCount nested bicep file(s) found"
        Write-Host 'run ConvertTo-ARMTemplate script'
        .\ConvertTo-ARMTemplate.ps1 -Path $repoRootPath
    }

    It 'all deploy.bicep files are converted to deploy.json' {
        $deployJsonFilesCount = (Get-ChildItem -Recurse $repoRootPath | Where-Object { $_.FullName -match 'deploy.json' }).Count
        Write-Host "$deployJsonFilesCount deploy.json file(s) found"
        $deployJsonFilesCount | Should -Be $deployBicepFilesCount
    }

    It 'all bicep files are removed' {
        $bicepFilesCount = (Get-ChildItem -Recurse $repoRootPath | Where-Object { $_.FullName -match '.*.bicep' }).Count
        Write-Host "$bicepFilesCount bicep file(s) found"
        $bicepFilesCount | Should -Be 0
    }
}
