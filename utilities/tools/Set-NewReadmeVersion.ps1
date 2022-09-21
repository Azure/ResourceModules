function Set-NewReadmeVersion {

    [CmdletBinding(SupportsShouldProcess)]

    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Version
    )

    #Rename the File
    $newName = (Get-Item $Path).BaseName + "_" + $Version + (Get-Item $Path).Extension
    Rename-Item $Path $newName

    Write-Host "File renamed to: " $newName

}