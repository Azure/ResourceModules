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
nestedElements                 {mode, template}
topLevelElements               name

startIndex                     185
endIndex                       188
content                        {resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = if (!empty(cMKKeyVaultResourceId)) {,   name: last(split(cMKKeyVaultResourceId, '/')),   scope: resourc…
topLevelElements               {name, scope}

startIndex                     190
endIndex                       240
content                        {resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {,   name: name,   location: location,   kind: storageAccountKind…}
nestedElements                 {encryption, accessTier, supportsHttpsTrafficOnly, isHnsEnabled…}
topLevelElements               {name, location, kind, sku…}

startIndex                     242
endIndex                       252
content                        {resource storageAccount_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId))…
nestedElements                 {storageAccountId, workspaceId, eventHubAuthorizationRuleId, eventHubName…}
topLevelElements               {name, scope}

startIndex                     254
endIndex                       261
content                        {resource storageAccount_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {,   name: '${storageAccount.name}-${lock}-lock',   Elements: {,     level: any(lock)…
nestedElements                 {level, notes}
topLevelElements               {name, scope}
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
        Expand-DeploymentBlock -DeclarationBlock $block -NestedType 'properties'
    }

    #########################
    ##   Extract Modules   ##
    #########################
    $existingModuleBlocks = Read-DeclarationBlock -DeclarationContent $templateContent -DeclarationType 'module'

    # Analyze content
    foreach ($block in $existingModuleBlocks) {
        Expand-DeploymentBlock -DeclarationBlock $block -NestedType 'params'
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
