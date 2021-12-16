Describe 'Convert bicep files to ARM' {
    BeforeAll {
        $bicepFilesCount = (Get-ChildItem -Recurse '.\' | Where-Object { $_.FullName -match 'deploy.bicep' }).Count
        # run converion script
        #.\ConvertTo-ARMTemplate.ps1
    }

    It 'all bicep files are converted to ARM' {
        $jsonFilesCount = (Get-ChildItem -Recurse '.\' | Where-Object { $_.FullName -match 'deploy.json' }).Count
        $bicepFilesCount | Should -Be $jsonFilesCount
    }

    It 'all bicep files are converted to ARM' {
        $jsonFilesCount = (Get-ChildItem -Recurse '.\' | Where-Object { $_.FullName -match 'deploy.json' }).Count
        $bicepFilesCount | Should -Be $jsonFilesCount
    }
}
