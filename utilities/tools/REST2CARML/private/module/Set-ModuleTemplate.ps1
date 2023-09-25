<#
.SYNOPSIS
Update the module's primary template (deploy.bicep) as per the provided module data.

.DESCRIPTION
Update the module's primary template (deploy.bicep) as per the provided module data.

.PARAMETER FullResourceType
Mandatory. The complete ResourceType identifier to update the template for (e.g. 'Microsoft.Storage/storageAccounts').

.PARAMETER ModuleData
Mandatory. The module data (e.g. parameters) to add to the template.

.PARAMETER FullModuleData
Mandatory. The full stack of module data of all modules included in the original invocation. May be used for parent-child references.

.PARAMETER JSONFilePath
Mandatory. The service specification file to process.

.PARAMETER UrlPath
Mandatory. The API Path in the JSON specification file to process

.EXAMPLE
Set-ModuleTemplate -FullResourceType 'Microsoft.KeyVault/vaults' -ModuleData @{ parameters = @(...); resource = @(...); (...) } -JSONFilePath '(...)/resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json' -UrlPath '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}' -FullModuleData @(@{ parameters = @(...); resource = @(...); (...) }, @{...})

Update the module [Microsoft.KeyVault/vaults] with the provided module data.
#>
function Set-ModuleTemplate {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType,

        [Parameter(Mandatory = $true)]
        [array] $ModuleData,

        [Parameter(Mandatory = $true)]
        [hashtable] $FullModuleData,

        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath,

        [Parameter(Mandatory = $true)]
        [string] $UrlPath
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        #####################
        ##   Collect Data   #
        #####################
        #region data

        $templateFilePath = Join-Path $script:repoRoot 'modules' $FullResourceType 'deploy.bicep'
        $providerNamespace = ($FullResourceType -split '/')[0]
        $resourceType = $FullResourceType -replace "$providerNamespace/", ''

        # Existing template (if any)
        $existingTemplateContent = Resolve-ExistingTemplateContent -TemplateFilePath $templateFilePath

        # Collect child-resource information
        $linkedChildren = Get-LinkedChildModuleList -FullModuleData $FullModuleData -FullResourceType $FullResourceType

        # Collect parent resources to use for parent type references
        $typeElem = $FullResourceType -split '/'
        if ($typeElem.Count -gt 2) {
            $parentResourceTypes = $typeElem[1..($typeElem.Count - 2)]
        } else {
            $parentResourceTypes = @()
        }

        # Get the singular version of the current resource type for proper naming
        $resourceTypeSingular = ((Get-ResourceTypeSingularName -ResourceType $resourceType) -split '/')[-1]
        #endregion

        #############
        ##  SCOPE  ##
        #############
        $targetScope = Get-TargetScope -UrlPath $UrlPath

        $templateContent = ($targetScope -ne 'resourceGroup') ? @(
            "targetScope = '{0}'" -f $targetScope,
            ''
        ) : @()

        ##################
        ##  PARAMETERS  ##
        ##################
        #region parameters

        $parametersInputObject = @{
            ModuleData       = $ModuleData
            FullModuleData   = $FullModuleData
            FullResourceType = $FullResourceType
        }
        if ($ExistingTemplateContent.Count -gt 0) {
            $parametersInputObject['ExistingTemplateContent'] = $ExistingTemplateContent
        }
        if ($ParentResourceTypes.Count -gt 0) {
            $parametersInputObject['ParentResourceTypes'] = $ParentResourceTypes
        }
        if ($LinkedChildren.Keys.Count -gt 0) {
            $parametersInputObject['LinkedChildren'] = $LinkedChildren
        }
        $templateContent += Get-TemplateParametersContent @parametersInputObject

        #endregion

        #################
        ##  VARIABLES  ##
        #################
        #region variables
        # Add a space in between the new section and the previous one in case no space exists
        if (-not [String]::IsNullOrEmpty($templateContent[-1])) {
            $templateContent += ''
        }

        $variablesInputObject = @{
            ModuleData = $ModuleData
        }
        if ($ExistingTemplateContent.Count -gt 0) {
            $variablesInputObject['ExistingTemplateContent'] = $ExistingTemplateContent
        }
        $templateContent += Get-TemplateVariablesContent @variablesInputObject
        #endregion

        ###################
        ##  DEPLOYMENTS  ##
        ###################
        #region resources & modules

        # Add a space in between the new section and the previous one in case no space exists
        if (-not [String]::IsNullOrEmpty($templateContent[-1])) {
            $templateContent += ''
        }

        $resourcesInputObject = @{
            FullResourceType     = $FullResourceType
            ResourceType         = $ResourceType
            ResourceTypeSingular = $ResourceTypeSingular
            ModuleData           = $ModuleData
            FullModuleData       = $FullModuleData
        }
        if ($ExistingTemplateContent.Count -gt 0) {
            $resourcesInputObject['ExistingTemplateContent'] = $ExistingTemplateContent
        }
        if ($ParentResourceTypes.Count -gt 0) {
            $resourcesInputObject['ParentResourceTypes'] = $ParentResourceTypes
        }
        if ($LinkedChildren.Keys.Count -gt 0) {
            $resourcesInputObject['LinkedChildren'] = $LinkedChildren
        }
        $templateContent += Get-TemplateDeploymentsContent @resourcesInputObject
        #endregion

        #######################################
        ##  Create template outputs section  ##
        #######################################
        #region outputs

        # Add a space in between the new section and the previous one in case no space exists
        if (-not [String]::IsNullOrEmpty($templateContent[-1])) {
            $templateContent += ''
        }

        $outputsInputObject = @{
            ResourceType         = $ResourceType
            ResourceTypeSingular = $ResourceTypeSingular
            TargetScope          = $TargetScope
            ModuleData           = $ModuleData
        }
        if ($ExistingTemplateContent.Count -gt 0) {
            $outputsInputObject['ExistingTemplateContent'] = $ExistingTemplateContent
        }
        $templateContent += Get-TemplateOutputContent @outputsInputObject
        #endregion

        ############################
        ##  Update template file  ##
        ############################

        # Update file
        # -----------
        Set-Content -Path $templateFilePath -Value ($templateContent | Out-String).TrimEnd() -Force
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
