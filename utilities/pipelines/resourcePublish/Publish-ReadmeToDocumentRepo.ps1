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
        [string] $BicepRegistryUrl,

        [Parameter(Mandatory)]
        [string] $TemplateSpecsUrl
    )

    Set-NewReadmeVersion -Path $ReadMeFilePath -Version $ModuleVersion

    Write-Host 'Bicep registry:' $BicepRegistryUrl
    Write-Host 'Template specs:' $TemplateSpecsUrl

}
