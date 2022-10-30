function Resolve-ExistingTemplateContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath
    )

    if (-not (Test-Path $TemplateFilePath)) {
        return
    }

    $templateContent = Get-Content -Path $TemplateFilePath

    ############################
    ##   Extract Parameters   ##
    ############################
    $existingParameterBlocks = Read-DeclarationBlock -DeclarationContent $templateContent -DeclarationType 'param'

    ###########################
    ##   Extract Variables   ##
    ###########################
    $existingVariableBlocks = Read-DeclarationBlock -DeclarationContent $templateContent -DeclarationType 'var'

    ###########################
    ##   Extract Resources   ##
    ###########################
    $existingResourceBlocks = Read-DeclarationBlock -DeclarationContent $templateContent -DeclarationType 'resource'

    #########################
    ##   Extract Modules   ##
    #########################
    $existingModuleBlocks = Read-DeclarationBlock -DeclarationContent $templateContent -DeclarationType 'module'

    #########################
    ##   Extract Outputs   ##
    #########################
    $existingOutputBlocks = Read-DeclarationBlock -DeclarationContent $templateContent -DeclarationType 'output'

    return @{
        parameters = $existingParameterBlocks
        variables  = $existingVariableBlocks
        resources  = $existingResourceBlocks
        modules    = $existingModuleBlocks
        outputs    = $existingOutputBlocks
    }
}
Resolve-ExistingTemplateContent -TemplateFilePath 'C:\dev\ip\Azure-ResourceModules\ResourceModules\modules\Microsoft.Storage\storageAccounts\deploy.bicep'
