[cmdletbinding()]
param()

# Load central config file; Config File can be referenced within module scope by $script:CONFIG
Write-Verbose 'Load Config'
$moduleConfigPath = Join-Path $PSScriptRoot 'ModuleConfig.psd1'
$script:CONFIG = Import-PowerShellDataFile -Path (Resolve-Path ($moduleConfigPath))

$script:repoRoot = (Get-Item $PSScriptRoot).Parent.Parent.FullName
$script:moduleRoot = $PSScriptRoot
$script:src = Join-Path $PSScriptRoot 'src'

Write-Verbose 'Import everything in sub folders public & private'
$functionFolders = @('public', 'private')
foreach ($folder in $functionFolders) {
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
    If (Test-Path -Path $folderPath) {
        Write-Verbose "Importing from $folder"
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1' -Recurse
        foreach ($function in $functions) {
            Write-Verbose ('  Importing [{0}]' -f $function.BaseName)
            . $function.FullName
        }
    }
}
$publicFunctions = (Get-ChildItem -Path "$PSScriptRoot\public" -Filter '*.ps1' -Recurse).BaseName
Export-ModuleMember -Function $publicFunctions
