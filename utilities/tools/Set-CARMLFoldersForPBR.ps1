<#
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

.NOTES
This script should only be run AFTER the 'Microsoft.' provider namespace prefix was removed.
Identifiers such as 'DBforPostgreSQL' becomes 'd-bfor-postgre-s-q-l' which should probably be manually reverted to 'db-for-postgre-sql'.
#>
function Set-CARMLFoldersForPBR {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModulesFolderPath
    )

    $relevantFolderPaths = (Get-ChildItem -Path $ModulesFolderPath -Recurse -Directory).FullName | Where-Object {
        $_ -notlike '*.bicep*' -and
        $_ -notlike '*.shared*' -and
        $_ -notlike '*.test*'
    } | Sort-Object -Descending

    foreach ($folderPath in $relevantFolderPaths) {

        $folderName = Split-Path $folderPath -Leaf

        if ($folderName -cmatch '[A-Z]+') {
            # Has upper case characters
            # Explanation:
            # (?<!^): This is a negative lookbehind assertion that ensures the match is not at the beginning of the string. This is used to exclude the first character from being replaced.
            # ([A-Z]): This captures any uppercase letter from A to Z using parentheses.
            $newName = $folderName -creplace '(?<!^)([A-Z])', '-$1'
        } else {
            # No upper case characters
            $newName = $folderName
        }

        $newName = $newName.ToLower()

        # Replace the name if the new name is not the same as the old
        if ($newName -ine $folderName) {
            if ($PSCmdlet.ShouldProcess(('Folder [{0}] to [{1}]' -f ((Split-Path $folderPath -Leaf)), $newName), 'Update')) {
                $null = Rename-Item -Path $folderPath -NewName $newName -Force
            }
        }
    }
}
