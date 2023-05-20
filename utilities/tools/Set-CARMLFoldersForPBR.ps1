﻿<#
.SYNOPSIS
Re-format the name of every CARML module to match the requirements of the Public Bicep Registry

.DESCRIPTION
The names are formatted as per the following rules:
- Add a '-' prefix to every upper-case character
- Make the entire name lower case

For example, it re-formats
- 'AppConfiguration\configurationStores\keyValues\deploy.bicep'
to
- app-configuration\configuration-stores\key-values\deploy.bicep

.PARAMETER ModulesFolderPath
Mandatory. The path to the modules who's folder names should be converted.

.EXAMPLE
Set-CARMLFoldersForPBR -ModulesFolderPath 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules'

Convert all folders in path 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules'

.EXAMPLE
Set-CARMLFoldersForPBR -ResourceProviderPath 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules\KeyVault'

Convert all folders in path 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules\KeyVault' included

.NOTES
This script should only be run AFTER the 'Microsoft.' provider namespace prefix was removed.
Identifiers such as 'DBforPostgreSQL' becomes 'd-bfor-postgre-s-q-l' which should probably be manually reverted to 'db-for-postgre-sql'.
#>
function Set-CARMLFoldersForPBR {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModulesFolderPath,

        [Parameter(Mandatory = $false)]
        [string] $ResourceProviderPath = '',

        [Parameter(Mandatory = $true)]
        [string] $WorkflowsPath,

        [Parameter(Mandatory = $true)]
        [string] $PipelinesPath
    )

    $specialConversionHash = @{
        DBforPostgreSQL = "db-for-postgre-sql";
        SQL = "sql"
    }

    # Get all module folder names
    if ($ResourceProviderPath -ne '') {
        $relevantFolderPaths = (Get-ChildItem -Path $ResourceProviderPath -Recurse -Directory).FullName | Where-Object {
            $_ -notlike '*.bicep*' -and
            $_ -notlike '*.shared*' -and
            $_ -notlike '*.test*'
        }
        $relevantFolderPaths += $ResourceProviderPath
    } else {
        $relevantFolderPaths = (Get-ChildItem -Path $ModulesFolderPath -Recurse -Directory).FullName | Where-Object {
            $_ -notlike '*.bicep*' -and
            $_ -notlike '*.shared*' -and
            $_ -notlike '*.test*'
        }
    }
    $relevantFolderPaths | Sort-Object -Descending

    # Iterate on all folder names
    foreach ($folderPath in $relevantFolderPaths) {

        # Convert each folder name to its kebab-case
        $folderName = Split-Path $folderPath -Leaf

        # (?<!^): This is a negative lookbehind assertion that ensures the match is not at the beginning of the string. This is used to exclude the first character from being replaced.
        # ([A-Z]): This captures any uppercase letter from A to Z using parentheses.
        $newName = ($folderName -creplace '(?<!^)([A-Z])', '-$1').ToLower()
        $newName = $newName.substring(0,1).tolower() + $newName.substring(1)

        Write-Verbose ("$folderName $newName") -Verbose

        # Replace the name if the new name is not the same as the old
        if ($newName -ine $folderName) {
            if ($PSCmdlet.ShouldProcess(('Folder [{0}] to [{1}]' -f ((Split-Path $folderPath -Leaf)), $newName), 'Update')) {
                $null = Rename-Item -Path $folderPath -NewName $newName -Force
            }
        }

        # Replace local module references in files across the whole library

        # Get file paths
        $filePaths=(Get-ChildItem -Path $ModulesFolderPath -Recurse | Select-String "$folderName.*main.bicep" -List | Select Path).Path

        # Iterate on all files
        foreach ($filePath in $filePaths) {
            # Replace content
            Write-Verbose ("   $filePath") -Verbose
            (Get-Content $filePath) -creplace "(/|')($folderName)/(.*main.bicep)", "`$1$newName/`$3" | Set-Content $filePath
        }

        # Replace local module references in workflows

        # Get file paths
        $workflowsfilePaths=(Get-ChildItem -Path $WorkflowsPath -Recurse | Select-String "modules.*$folderName" -List | Select Path).Path

        # Iterate on all files
        foreach ($workflowsfilePath in $workflowsfilePaths) {
            # Replace content
            Write-Verbose ("   $workflowsfilePath") -Verbose
            (Get-Content $workflowsfilePath) -creplace "(modules.*)/($folderName)", "`$1/$newName" | Set-Content $workflowsfilePath
        }

        # Replace local module references in ado pipelines

        # Get file paths
        $pipelinesfilePaths=(Get-ChildItem -Path $PipelinesPath -Recurse | Select-String "modules.*$folderName" -List | Select Path).Path

        # Iterate on all files
        foreach ($pipelinesfilePath in $pipelinesfilePaths) {
            # Replace content
            Write-Verbose ("   $pipelinesfilePath") -Verbose
            (Get-Content $pipelinesfilePath) -creplace "(modules.*)/($folderName)", "`$1/$newName" | Set-Content $pipelinesfilePath
        }
    }
}
