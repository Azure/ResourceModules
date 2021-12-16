Describe 'Convert bicep files to ARM' {
    BeforeAll {
        $deployBicepFilesCount = (Get-ChildItem -Recurse '.\' | Where-Object { $_.FullName -match 'deploy.bicep' }).Count
        $nestedBicepFilesCount = (Get-ChildItem -Recurse '.\' | Where-Object { $_.FullName -match 'nested*.bicep' }).Count
        Write-Verbose "$deployBicepFilesCount deploy.bicep file(s) found"
        Write-Verbose "$nestedBicepFilesCount nested bicep file(s) found"
        Write-Verbose 'run ConvertTo-ARMTemplate script'
        .\ConvertTo-ARMTemplate.ps1 -Path '.\..\..\'
    }

    It 'all deploy bicep files are converted to ARM' {
        $jsonFilesCount = (Get-ChildItem -Recurse '.\' | Where-Object { $_.FullName -match 'deploy.json' }).Count
        $deployBicepFilesCount | Should -Be $jsonFilesCount
    }

    It 'all nested bicep files are removed' {
        $nestedBicepFilesCount = (Get-ChildItem -Recurse '.\' | Where-Object { $_.FullName -match 'nested*.bicep' }).Count
        $nestedBicepFilesCount | Should -Be 0
    }
}
