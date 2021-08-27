function Get-RelevantDepth {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $path
    )

    if (-not ($relevantSubfolders = (Get-Childitem $path -Directory -Recurse -Exclude @('.bicep', 'parameters')).fullName)) {
        return
    }
    $santiziedPaths = $relevantSubfolders | ForEach-Object { $_.Replace($path, '') }

    $depths = $santiziedPaths | ForEach-Object { ($_.Split('\') | Measure-Object).Count - 1 }

    return ($depths | Measure-Object -Maximum).Maximum
}

function Get-ResolvedSubServiceRow {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $subPath,

        [Parameter(Mandatory)]
        [string] $concatedBase,

        [Parameter(Mandatory)]
        [string] $row,

        [Parameter(Mandatory)]
        [string] $provider
    )

    $subFolders = Get-ChildItem -Path $subPath -Directory -Recurse -Exclude @('.bicep', 'parameters')

    foreach ($subfolder in $subFolders.FullName) {
        $subFolderName = (Split-Path $subfolder -Leaf)

        if ((Get-RelevantDepth -path $subfolder) -gt 0) {
            $concatedBase = Join-Path $concatedBase $subFolderName
            $row += Get-ResolvedSubServiceRow -subPath $subfolder -concatedBase $concatedBase -row $row -provider $provider
        }
        else {
            $relativePath = Join-Path $concatedBase $subFolderName
            $subName = $relativePath.Replace("$provider\", '').Replace('_', '')
            $row += ('<p>[{0}](.\{1})' -f $subName, $relativePath) # $subfolder.Replace((Split-Path $subPath -Parent), '').Substring(1))
        }
    }

    return $row
}
function Get-ModulesAsMarkdownTable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $path = 'C:\dev\ip\Azure-Modules\Modules\arm'
    )

    $topLevelFolders = Get-ChildItem -Path $path -Depth 1 -Filter "Microsoft.*"

    $output = [System.Collections.ArrayList]@()

    $null = $output += "Resource provider namespace | Azure service"
    $null = $output += "--------------------------- | -------------"

    foreach ($topLevelFolder in $topLevelFolders.FullName) {
        $provider = Split-Path $topLevelFolder -Leaf
        $row = "| $provider | "

        $subFolders = Get-ChildItem -Path $topLevelFolder -Directory -Recurse -Exclude @('.bicep', 'parameters') -Depth 0

        foreach ($subfolder in $subFolders.FullName) {
            $subFolderName = (Split-Path $subfolder -Leaf)
            $concatedBase = $subfolder.Replace((Split-Path $topLevelFolder -Parent), '').Substring(1)

            if ((Get-RelevantDepth -path $subfolder) -gt 0) {
                $row = Get-ResolvedSubServiceRow -subPath $subfolder -concatedBase $concatedBase -row $row -provider $provider
            }
            else {
                $row += ('<p>[{0}]({1})' -f $subFolderName, $concatedBase)
            }
        }
        $null = $output += $row.Replace('\','/')
    }
    return $output
}