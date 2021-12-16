Describe 'Convert bicep files to ARM' {
    BeforeAll {
        $repoRootPath = '.\..\..\'
        $deployBicepFilesCount = (Get-ChildItem -Recurse $repoRootPath | Where-Object { $_.FullName -match 'deploy.bicep' }).Count
        $nestedBicepFilesCount = (Get-ChildItem -Recurse $repoRootPath | Where-Object { $_.FullName -match 'nested*.bicep' }).Count
        Write-Host "$deployBicepFilesCount deploy.bicep file(s) found"
        Write-Host "$nestedBicepFilesCount nested bicep file(s) found"
        Write-Host 'run ConvertTo-ARMTemplate script'
        .\ConvertTo-ARMTemplate.ps1 -Path $repoRootPath
    }

    It 'all deploy bicep files are converted to ARM' {
        $deployJsonFilesCount = (Get-ChildItem -Recurse $repoRootPath | Where-Object { $_.FullName -match 'deploy.json' }).Count
        Write-Host "$deployJsonFilesCount deploy.json file(s) found"
        $deployBicepFilesCount | Should -Be $deployJsonFilesCount
    }

    It 'all nested bicep files are removed' {
        $nestedBicepFilesCount = (Get-ChildItem -Recurse $repoRootPath | Where-Object { $_.FullName -match 'nested*.bicep' }).Count
        Write-Host "$nestedBicepFilesCount nested bicep file(s) found"
        $nestedBicepFilesCount | Should -Be 0
    }
}
