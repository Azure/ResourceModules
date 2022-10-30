function Resolve-ExistingTemplateContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath
    )

    if (-not (Test-Path $TemplateFilePath)) {
        return
    }

    $existingTemplateContent = Get-Content -Path $TemplateFilePath

    $existingParametersBlock = @()
    $existingVariablesBlock = @()
    $existingdeploymentBlock = @()
    $existingOutputsBlock = @()
}
