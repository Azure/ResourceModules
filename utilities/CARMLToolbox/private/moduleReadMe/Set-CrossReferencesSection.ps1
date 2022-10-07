<#
.SYNOPSIS
Add module references (cross-references) to the module's readme

.DESCRIPTION
Add module references (cross-references) to the module's readme. This includes both local (i.e., file path), as well as remote references (e.g., ACR)

.PARAMETER ModuleRoot
Mandatory. The file path to the module's root

.PARAMETER FullModuleIdentifier
Mandatory. The full identifier of the module (i.e., ProviderNamespace + ResourceType)

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Cross-referenced modules'

.EXAMPLE
Set-CrossReferencesSection -ModuleRoot 'C:/Microsoft.KeyVault/vaults' -FullModuleIdentifier 'Microsoft.KeyVault/vaults' -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)
Update the given readme file's 'Cross-referenced modules' section based on the given template file content
#>
function Set-CrossReferencesSection {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleRoot,

        [Parameter(Mandatory = $true)]
        [string] $FullModuleIdentifier,

        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Cross-referenced modules'
    )

    # Process content
    $SectionContent = [System.Collections.ArrayList]@(
        'This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).',
        '',
        '| Reference | Type |',
        '| :-- | :-- |'
    )

    $dependencies = (Get-CrossReferencedModuleList)[$FullModuleIdentifier]

    if ($dependencies.Keys -contains 'localPathReferences' -and $dependencies['localPathReferences']) {
        foreach ($reference in ($dependencies['localPathReferences'] | Sort-Object)) {
            $SectionContent += ("| ``{0}`` | {1} |" -f $reference, 'Local reference')
        }
    }

    if ($dependencies.Keys -contains 'remoteReferences' -and $dependencies['remoteReferences']) {
        foreach ($reference in ($dependencies['remoteReferences'] | Sort-Object)) {
            $SectionContent += ("| ``{0}`` | {1} |" -f $reference, 'Remote reference')
        }
    }

    if ($SectionContent.Count -eq 4) {
        # No content was added, adding placeholder
        $SectionContent = @('_None_')

    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new output content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $SectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'none'
    }
    return $updatedFileContent
}
