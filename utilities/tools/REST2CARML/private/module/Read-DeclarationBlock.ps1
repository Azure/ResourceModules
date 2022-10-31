<#
.SYNOPSIS
Find all instances of a Bicep delcaration block (e.g. 'param') in the given template file

.DESCRIPTION
Find all instances of a Bicep delcaration block (e.g. 'param') in the given template file. Returns an array of all ocurrences, including their content, start- & end-index

.PARAMETER DeclarationContent
Mandatory. The Bicep template content to search in

.PARAMETER DeclarationType
Mandatory. The declaration type to search for. Can be 'param', 'var', 'resource', 'module', or 'output'

.EXAMPLE
Read-DeclarationBlock -DeclarationContent @('targetScope = 'subscription', '', '@description('Some Description'), param description string, '', (..)) -DeclarationType 'param

Get all 'param' declaration blocks of the given declaration content.
#>
function Read-DeclarationBlock {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [object[]] $DeclarationContent,

        [Parameter(Mandatory = $true)]
        [ValidateSet('param', 'var', 'resource', 'module', 'output')]
        [string] $DeclarationType
    )

    ######################################################################################################################################
    ##   Define which key-words indicate a new declaration (depending on whether you'd move up in the template, or down line by line)   ##
    ######################################################################################################################################

    # Any keyword when moving from the current line up to indicate that it's a new declaration
    $newLogicIdentifiersUp = @(
        '^targetScope.+$',
        '^param .+$',
        '^var .+$',
        '^resource .+$',
        '^module .+$',
        '^output .+$',
        '^//.*$'
        '^\s*$'
    )
    # Any keyword when moving from the current line down to indicate that it's a new declaration
    $newLogicIdentifiersDown = @(
        '^param .+$',
        '^var .+$',
        '^resource .+$',
        '^module .+$',
        '^output .+$',
        '^//.*$',
        '^@.+$'#,
        #'^\s*$'
    )

    #########################################
    ##   Find all indexes to investigate   ##
    #########################################
    $existingBlocks = @()

    $declarationIndexes = @()
    for ($index = 0; $index -lt $DeclarationContent.Count; $index++) {
        if ($DeclarationContent[$index] -like "$DeclarationType *") {
            $declarationIndexes += $index
        }
    }

    ########################################################################################################################
    ##   Process each found index and find its element's start- & end-index (i.e., where its declaration starts & ends)   ##
    ########################################################################################################################
    foreach ($declarationIndex in $declarationIndexes) {
        switch ($DeclarationType) {
            { $PSItem -in @('param') } {
                # Let's go 'up' until the declarations end
                $declarationStartIndex = $declarationIndex
                while ($DeclarationContent[$declarationStartIndex] -eq $DeclarationContent[$declarationIndex] -or (($newLogicIdentifiersUp | Where-Object { $DeclarationContent[$declarationStartIndex] -match $_ }).Count -eq 0 -and $declarationStartIndex -ne 0)) {
                    $declarationStartIndex--
                }
                # Logic always counts one too far
                $declarationStartIndex++

                # The declaration line is always the last line of the block
                $declarationEndIndex = $declarationIndex
                while ($DeclarationContent[$declarationEndIndex] -eq $DeclarationContent[$declarationIndex] -or (($newLogicIdentifiersDown | Where-Object { $DeclarationContent[$declarationEndIndex] -match $_ }).Count -eq 0 -and $declarationEndIndex -ne $DeclarationContent.Count)) {
                    $declarationEndIndex++
                }
                # Logic always counts one too far
                $declarationEndIndex--
                break
            }
            { $PSItem -in @('output') } {
                # Let's go 'up' until the declarations end
                $declarationStartIndex = $declarationIndex
                while ($DeclarationContent[$declarationStartIndex] -eq $DeclarationContent[$declarationIndex] -or (($newLogicIdentifiersUp | Where-Object { $DeclarationContent[$declarationStartIndex] -match $_ }).Count -eq 0 -and $declarationStartIndex -ne 0)) {
                    $declarationStartIndex--
                }
                # Logic always counts one too far
                $declarationStartIndex++

                # The declaration line is always the last line of the block
                $declarationEndIndex = $declarationIndex
                break
            }
            { $PSItem -in @('var', 'resource', 'module') } {
                # The declaration line is always the first line of the block
                $declarationStartIndex = $declarationIndex

                # Let's go 'down' until the var declarations end
                $declarationEndIndex = $declarationIndex
                while ($DeclarationContent[$declarationEndIndex] -eq $DeclarationContent[$declarationIndex] -or (($newLogicIdentifiersDown | Where-Object { $DeclarationContent[$declarationEndIndex] -match $_ }).Count -eq 0 -and $declarationEndIndex -ne $DeclarationContent.Count)) {
                    $declarationEndIndex++
                }
                # Logic always counts one too far
                $declarationEndIndex--
                break
            }
        }

        # Trim empty lines from the end
        while ([String]::IsNullOrEmpty($templateContent[$declarationEndIndex])) {
            $declarationEndIndex--
        }

        $existingBlocks += @{
            content    = $templateContent[$declarationStartIndex .. $declarationEndIndex]
            startIndex = $declarationStartIndex
            endIndex   = $declarationEndIndex
        }
    }

    return $existingBlocks
}
