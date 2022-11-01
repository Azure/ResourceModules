<#
.SYNOPSIS
Expand the given module/resource block content with details about contained params/properties

.DESCRIPTION
Expand the given module/resource block content with details about contained params/properties

.PARAMETER DeclarationBlock
Mandatory. The declaration block to expand upon. If available, the object will get the 2 new properties 'topLevelElements' & 'nestedElements'

.PARAMETER NestedType
Mandatory. The key word that indicates nested-elements. Can be 'params' or 'properties'

.EXAMPLE
Expand-DeploymentBlock -DeclarationBlock @{ startIndex = 173; endIndex = 183; content = @( 'resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {', '  name: name', '  location: location', (..)) } -NestedType 'properties'
#>
function Expand-DeploymentBlock {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $DeclarationBlock,

        [Parameter(Mandatory = $true)]
        [ValidateSet('properties', 'params')]
        [string] $NestedType
    )

    $topLevelIndent = Get-LineIndentation -Line $DeclarationBlock.content[1]
    $relevantProperties = $DeclarationBlock.content | Where-Object { (Get-LineIndentation $_) -eq $topLevelIndent -and $_ -notlike "*$($NestedType): {*" -and $_ -like '*:*' }
    $topLevelElementNames = $relevantProperties | ForEach-Object { ($_ -split ':')[0].Trim() }

    ###########################################
    ##   Collect specification information   ##
    ###########################################
    switch ($NestedType) {
        'properties' {
            $declarationElem = $declarationBlock.content[0] -split ' '
            $DeclarationBlock['name'] = $declarationElem[1]
            $DeclarationBlock['type'] = ($declarationElem[2] -split '@')[0].Trim("'")
            $DeclarationBlock['version'] = (($declarationElem[2] -split '@')[1])[0..9] -join '' # The date always has 10 characters
            break
        }
        'params' {
            $declarationElem = $declarationBlock.content[0] -split ' '
            $DeclarationBlock['name'] = $declarationElem[1]
            $DeclarationBlock['path'] = $declarationElem[2].Trim("'")
            break
        }
    }

    ####################################
    ##   Collect top level elements   ##
    ####################################
    $topLevelElements = @()
    foreach ($topLevelElementName in $topLevelElementNames) {

        # Find start index of element
        $relativeElementStartIndex = 1
        for ($index = $relativeElementStartIndex; $index -lt $DeclarationBlock.content.Count; $index++) {
            if ($DeclarationBlock.content[$index] -match ("^\s{$($topLevelIndent)}$($topLevelElementName):.+$" )) {
                $relativeElementStartIndex = $index
                break
            }
        }

        # Find end index of element
        $isPropertyOrClosing = "^\s{$($topLevelIndent)}\w+:.+$|^}$"
        if ($DeclarationBlock.content[$index + 1] -notmatch $isPropertyOrClosing) {
            # If the next line is not another element/property/param, it's a multi-line declaration
            $relativeElementEndIndex = $relativeElementStartIndex
            while ($DeclarationBlock.content[($relativeElementEndIndex + 1)] -notmatch $isPropertyOrClosing) {
                $relativeElementEndIndex++
            }
        } else {
            $relativeElementEndIndex = $relativeElementStartIndex
        }

        # Build result
        $topLevelElements += @{
            name    = $topLevelElementName
            content = $DeclarationBlock.content[$relativeElementStartIndex..$relativeElementEndIndex]
        }
    }

    $DeclarationBlock['topLevelElements'] = $topLevelElements

    #################################
    ##   Collect nested elements   ##
    #################################
    if (($DeclarationBlock.content | Where-Object { $_ -match "^\s*$($NestedType): \{\s*$" }).count -gt 0) {

        # Find start index of nested block
        # --------------------------------
        $propertiesStartIndex = 1
        for ($index = $propertiesStartIndex; $index -lt $DeclarationBlock.content.Count; $index++) {
            if ($DeclarationBlock.Content[$index] -match "^\s*$($NestedType): \{\s*$") {
                $propertiesStartIndex = $index
                break
            }
        }

        # Find end index of nested block
        # ------------------------------
        $propertiesEndIndex = $propertiesStartIndex
        for ($index = $propertiesEndIndex; $index -lt $DeclarationBlock.content.Count; $index++) {
            if ((Get-LineIndentation -Line $DeclarationBlock.Content[$index]) -eq $topLevelIndent -and $DeclarationBlock.Content[$index].Trim() -eq '}') {
                $propertiesEndIndex = $index
                break
            }
        }

        # Process nested block
        # --------------------
        if ($DeclarationBlock.content[$propertiesStartIndex] -like '*{*}*' -or $DeclarationBlock.content[$propertiesStartIndex + 1].Trim() -eq '}') {
            # Empty properties block. Can be skipped.
            $DeclarationBlock['nestedElements'] = @()
        } else {
            $nestedIndent = Get-LineIndentation -Line $DeclarationBlock.content[($propertiesStartIndex + 1)]
            $relevantNestedProperties = $DeclarationBlock.content[($propertiesStartIndex + 1) .. ($propertiesEndIndex - 1)] | Where-Object { (Get-LineIndentation $_) -eq $nestedIndent -and $_ -match '^\s*\w+:.*' }
            $nestedPropertyNames = $relevantNestedProperties | ForEach-Object { ($_ -split ':')[0].Trim() }

            # Collect full data block
            $nestedElements = @()
            foreach ($nestedPropertyName in $nestedPropertyNames) {

                # Find start index of poperty
                $relativeElementStartIndex = 1
                for ($index = $relativeElementStartIndex; $index -lt $DeclarationBlock.content.Count; $index++) {
                    if ($DeclarationBlock.content[$index] -match ("^\s{$($nestedIndent)}$($nestedPropertyName):.+$" )) {
                        $relativeElementStartIndex = $index
                        break
                    }
                }

                # Find end index of poperty
                $isPropertyOrClosing = "^\s{$($nestedIndent)}\w+:.+$|^\s{$($topLevelIndent)}}$"
                if ($DeclarationBlock.content[$index + 1] -notmatch $isPropertyOrClosing) {
                    # If the next line is not another element/property/param, it's a multi-line declaration
                    $relativeElementEndIndex = $relativeElementStartIndex
                    while ($DeclarationBlock.content[($relativeElementEndIndex + 1)] -notmatch $isPropertyOrClosing) {
                        $relativeElementEndIndex++
                    }
                } else {
                    $relativeElementEndIndex = $relativeElementStartIndex
                }

                # Build result
                $nestedElements += @{
                    name    = $nestedPropertyName
                    content = $DeclarationBlock.content[$relativeElementStartIndex..$relativeElementEndIndex]
                }
            }

            $DeclarationBlock['nestedElements'] = $nestedElements
        }
    }
}
