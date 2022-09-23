function Set-NewReadmeVersion {

    [CmdletBinding(SupportsShouldProcess)]

    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Version
    )

    #Rename the File
    $newName = (Get-Item $Path).BaseName + '_' + $Version + (Get-Item $Path).Extension
    Rename-Item $Path $newName

    Write-Host 'File renamed to: ' $newName

}

function Publish-ReadmeToDocumentRepo {

    param(
        [Parameter(Mandatory)]
        [string] $ReadMeFilePath,

        [Parameter(Mandatory)]
        [string] $ModuleVersion,

        [Parameter(Mandatory)]
        [string] $wikiPath
    )

    Set-NewReadmeVersion -Path $ReadMeFilePath -Version $ModuleVersion
    Get-Location
    Get-ChildItem
    #####
    Set-Location $wikiPath

    Invoke-Git -Command 'fetch'
    Invoke-Git -Command 'checkout wikiMaster'

    #### PUT FILES INTO HERE
    New-Item -Name 'dummy.md' -ItemType File -Value 'Hello World'

    ## publishing md to wiki
    Write-Host '##############################'
    Write-Host 'Publishing...'
    Invoke-Git -Command "config user.email 'wikipublisher@carml.local'"
    Invoke-Git -Command "config user.name 'WIKI-Publisher'"
    Invoke-Git -Command 'add .'
    $msg = 'Wiki updated by pipeline'
    Invoke-Git -Command "commit -m `"$msg`"" -IgnoreExitCode
    Invoke-Git -Command 'push' #needs Contributor permissions in ADO Project Wiki

}

function Invoke-Git {
    param(
        [Parameter(Mandatory)]
        [string] $Command,
        [Parameter(Mandatory = $false)]
        [switch] $IgnoreExitCode
    )
    Write-Host -ForegroundColor Green "`nExecuting: git $Command"
    $output = Invoke-Expression "git $Command"
    if ($LASTEXITCODE -gt 0 -and $IgnoreExitCode -eq $false) {
        Throw "Error Encountered executing: 'git $Command '"
    } else {
        Write-Host $output
    }
}
