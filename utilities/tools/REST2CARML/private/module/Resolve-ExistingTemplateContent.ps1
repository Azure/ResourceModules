<#
.SYNOPSIS
Get details about all parameters, variables, resources, modules & outputs in the given template

.DESCRIPTION
Get details about all parameters, variables, resources, modules & outputs in the given template. Depending on the type of declaration, you further get information like names, types, nested properties, etc.

.PARAMETER TemplateFilePath
Mandatory. The path of the template to extract the data from.

.EXAMPLE
Resolve-ExistingTemplateContent -TemplateFilePath 'C:/dev/Microsoft.Storage/storageAccounts/deploy.bicep'

Get all the requested information from the template in path 'C:/dev/Microsoft.Storage/storageAccounts/deploy.bicep'. Returns an object like:

Name                           Value
----                           -----
outputs                        {resourceId, name, resourceGroupName, primaryBlobEndpoint…}
modules                        {System.Collections.Hashtable, System.Collections.Hashtable, System.Collections.Hashtable, System.Collections.Hashtable…}
variables                      {diagnosticsMetrics, supportsBlobService, supportsFileService, identityType…}
resources                      {System.Collections.Hashtable, System.Collections.Hashtable, System.Collections.Hashtable, System.Collections.Hashtable…}
parameters                     {name, location, roleAssignments, systemAssignedIdentity…}

And if you drill down, for resources an array like:

Name                           Value
----                           -----
startIndex                     173
endIndex                       183
content                        {resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {,   name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment…
nestedProperties               {mode, template}
topLevelProperties             name

startIndex                     185
endIndex                       188
content                        {resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = if (!empty(cMKKeyVaultResourceId)) {,   name: last(split(cMKKeyVaultResourceId, '/')),   scope: resourc…
topLevelProperties             {name, scope}

startIndex                     190
endIndex                       240
content                        {resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {,   name: name,   location: location,   kind: storageAccountKind…}
nestedProperties               {encryption, accessTier, supportsHttpsTrafficOnly, isHnsEnabled…}
topLevelProperties             {name, location, kind, sku…}

startIndex                     242
endIndex                       252
content                        {resource storageAccount_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId))…
nestedProperties               {storageAccountId, workspaceId, eventHubAuthorizationRuleId, eventHubName…}
topLevelProperties             {name, scope}

startIndex                     254
endIndex                       261
content                        {resource storageAccount_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {,   name: '${storageAccount.name}-${lock}-lock',   properties: {,     level: any(lock)…
nestedProperties               {level, notes}
topLevelProperties             {name, scope}
#>
function Resolve-ExistingTemplateContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
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

    # Analyze content
    foreach ($block in $existingParameterBlocks) {
        $block['name'] = (($block.content | Where-Object { $_ -like 'param *' }) -split ' ')[1]
        $block['type'] = (($block.content | Where-Object { $_ -like 'param *' }) -split ' ')[2]
    }

    ###########################
    ##   Extract Variables   ##
    ###########################
    $existingVariableBlocks = Read-DeclarationBlock -DeclarationContent $templateContent -DeclarationType 'var'

    # Analyze content
    foreach ($block in $existingVariableBlocks) {
        $block['name'] = (($block.content | Where-Object { $_ -like 'var *' }) -split ' ')[1]
    }

    ###########################
    ##   Extract Resources   ##
    ###########################
    $existingResourceBlocks = Read-DeclarationBlock -DeclarationContent $templateContent -DeclarationType 'resource'

    # Analyze content
    foreach ($block in $existingResourceBlocks) {

        $topLevelIndent = Get-LineIndentation -Line $block.content[1]
        $relevantProperties = $block.content | Where-Object { (Get-LineIndentation $_) -eq $topLevelIndent -and $_ -notlike '*properties: {*' -and $_ -like '*:*' }
        $topLevelPropertyNames = $relevantProperties | ForEach-Object { ($_ -split ':')[0].Trim() }

        # Collect full data block
        ## Top level properties
        $topLevelProperties = @()
        foreach ($topLevelPropertyName in $topLevelPropertyNames) {

            # Find start index of poperty
            $relativePropertyStartIndex = 1
            for ($index = $relativePropertyStartIndex; $index -lt $block.content.Count; $index++) {
                if ($block.content[$index] -match ("^\s{$($topLevelIndent)}$($topLevelPropertyName):.+$" )) {
                    $relativePropertyStartIndex = $index
                    break
                }
            }

            # Find end index of poperty
            $isPropertyOrClosing = "^\s{$($topLevelIndent)}\w+:.+$|^}$"
            if ($block.content[$index + 1] -notmatch $isPropertyOrClosing) {
                # If the next line is not another property, it's a multi-line declaration
                $relativePropertyEndIndex = $relativePropertyStartIndex
                while ($block.content[($relativePropertyEndIndex + 1)] -notmatch $isPropertyOrClosing) {
                    $relativePropertyEndIndex++
                }
            } else {
                $relativePropertyEndIndex = $relativePropertyStartIndex
            }

            # Build result
            $topLevelProperties += @{
                name    = $topLevelPropertyName
                content = $block.content[$relativePropertyStartIndex..$relativePropertyEndIndex]
            }
        }

        $block['topLevelProperties'] = $topLevelProperties

        ## Nested properties
        if (($block.content | Where-Object { $_ -match '^\s*properties: \{\s*$' }).count -gt 0) {
            $propertiesStartIndex = 1
            for ($index = $propertiesStartIndex; $index -lt $block.content.Count; $index++) {
                if ($block.Content[$index] -match '^\s*properties: \{\s*$') {
                    $propertiesStartIndex = $index
                    break
                }
            }

            $propertiesEndIndex = $propertiesStartIndex
            for ($index = $propertiesEndIndex; $index -lt $block.content.Count; $index++) {
                if ((Get-LineIndentation -Line $block.Content[$index]) -eq $topLevelIndent -and $block.Content[$index].Trim() -eq '}') {
                    $propertiesEndIndex = $index
                    break
                }
            }

            if ($block.content[$propertiesStartIndex] -like '*{*}*' -or $block.content[$propertiesStartIndex + 1].Trim() -eq '}') {
                # Empty properties block. Can be skipped
                $block['nestedProperties'] = @()
            } else {
                $nestedIndent = Get-LineIndentation -Line $block.content[($propertiesStartIndex + 1)]
                $relevantNestedProperties = $block.content[($propertiesStartIndex + 1) .. ($propertiesEndIndex - 1)] | Where-Object { (Get-LineIndentation $_) -eq $nestedIndent -and $_ -match '^\s*\w+:.*' }
                $nestedPropertyNames = $relevantNestedProperties | ForEach-Object { ($_ -split ':')[0].Trim() }

                # Collect full data block
                $nestedProperties = @()
                foreach ($nestedPropertyName in $nestedPropertyNames) {

                    # Find start index of poperty
                    $relativePropertyStartIndex = 1
                    for ($index = $relativePropertyStartIndex; $index -lt $block.content.Count; $index++) {
                        if ($block.content[$index] -match ("^\s{$($nestedIndent)}$($nestedPropertyName):.+$" )) {
                            $relativePropertyStartIndex = $index
                            break
                        }
                    }

                    # Find end index of poperty
                    $isPropertyOrClosing = "^\s{$($nestedIndent)}\w+:.+$|^\s{$($topLevelIndent)}}$"
                    if ($block.content[$index + 1] -notmatch $isPropertyOrClosing) {
                        # If the next line is not another property, it's a multi-line declaration
                        $relativePropertyEndIndex = $relativePropertyStartIndex
                        while ($block.content[($relativePropertyEndIndex + 1)] -notmatch $isPropertyOrClosing) {
                            $relativePropertyEndIndex++
                        }
                    } else {
                        $relativePropertyEndIndex = $relativePropertyStartIndex
                    }

                    # Build result
                    $nestedProperties += @{
                        name    = $nestedPropertyName
                        content = $block.content[$relativePropertyStartIndex..$relativePropertyEndIndex]
                    }
                }

                $block['nestedProperties'] = $nestedProperties
            }
        }
    }

    #########################
    ##   Extract Modules   ##
    #########################
    $existingModuleBlocks = Read-DeclarationBlock -DeclarationContent $templateContent -DeclarationType 'module'

    # Analyze content
    foreach ($block in $existingModuleBlocks) {

        $topLevelIndent = Get-LineIndentation -Line $block.content[1]
        $relevantProperties = $block.content | Where-Object { (Get-LineIndentation $_) -eq $topLevelIndent -and $_ -notlike '*params: {*' -and $_ -like '*:*' }
        $topLevelPropertyNames = $relevantProperties | ForEach-Object { ($_ -split ':')[0].Trim() }

        # Collect full data block
        ## Top level properties
        $block['topLevelProperties'] = @(
            @{
                name    = 'name'
                content = $block.content[1]
            }
        )
        ## Nested params
        # $block['params'] = $block.content[3..($block.content.count - 3)] | ForEach-Object { ($_ -split ':')[0].Trim() }
        if (($block.content | Where-Object { $_ -match '^\s*params: {\s*$' }).count -gt 0) {
            $paramsStartIndex = 1
            for ($index = $paramsStartIndex; $index -lt $block.content.Count; $index++) {
                if ($block.Content[$index] -match '^\s*params: {\s*$') {
                    $paramsStartIndex = $index
                    break
                }
            }

            $paramsEndIndex = $paramsStartIndex
            for ($index = $paramsEndIndex; $index -lt $block.content.Count; $index++) {
                if ((Get-LineIndentation -Line $block.Content[$index]) -eq $topLevelIndent -and $block.Content[$index].Trim() -eq '}') {
                    $paramsEndIndex = $index
                    break
                }
            }
            $paramsEndIndex

            if ($block.content[$paramsStartIndex] -like '*{*}*' -or $block.content[$paramsStartIndex + 1].Trim() -eq '}') {
                # Empty properties block. Can be skipped
                $block['nestedParams'] = @()
            } else {
                $nestedIndent = Get-LineIndentation -Line $block.content[($paramsStartIndex + 1)]
                $relevantNestedParams = $block.content[($paramsStartIndex + 1) .. ($paramsEndIndex - 1)] | Where-Object { (Get-LineIndentation $_) -eq $nestedIndent -and $_ -match '^\s*\w+:.*' }
                $nestedParamNames = $relevantNestedParams | ForEach-Object { ($_ -split ':')[0].Trim() }

                # Collect full data block
                $nestedparams = @()
                foreach ($nestedParamName in $nestedParamNames) {

                    # Find start index of poperty
                    $relativeParamStartIndex = 1
                    for ($index = $relativeParamStartIndex; $index -lt $block.content.Count; $index++) {
                        if ($block.content[$index] -match ("^\s{$($nestedIndent)}$($nestedParamName):.+$" )) {
                            $relativeParamStartIndex = $index
                            break
                        }
                    }

                    # Find end index of poperty
                    $isParamOrClosing = "^\s{$($nestedIndent)}\w+:.+$|^\s{$($topLevelIndent)}}$"
                    if ($block.content[$index + 1] -notmatch $isParamOrClosing) {
                        # If the next line is not another param, it's a multi-line declaration
                        $relativeParamEndIndex = $relativeParamStartIndex
                        while ($block.content[($relativeParamEndIndex + 1)] -notmatch $isParamOrClosing) {
                            $relativeParamEndIndex++
                        }
                    } else {
                        $relativeParamEndIndex = $relativeParamStartIndex
                    }

                    # Build result
                    $nestedParams += @{
                        name    = $nestedParamName
                        content = $block.content[$relativeParamStartIndex..$relativeParamEndIndex]
                    }
                }

                $block['nestedParams'] = $nestedParams
            }
        }
    }


    #########################
    ##   Extract Outputs   ##
    #########################
    $existingOutputBlocks = Read-DeclarationBlock -DeclarationContent $templateContent -DeclarationType 'output'

    foreach ($block in $existingOutputBlocks) {
        $block['name'] = (($block.content | Where-Object { $_ -like 'output *' }) -split ' ')[1]
        $block['type'] = (($block.content | Where-Object { $_ -like 'output *' }) -split ' ')[2]
    }


    #######################
    ##   Return result   ##
    #######################
    return @{
        parameters = $existingParameterBlocks
        variables  = $existingVariableBlocks
        resources  = $existingResourceBlocks
        modules    = $existingModuleBlocks
        outputs    = $existingOutputBlocks
    }
}
