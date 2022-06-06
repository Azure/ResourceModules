# Load used functions
$repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent.FullName

. (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-NestedResourceList.ps1')
. (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')
