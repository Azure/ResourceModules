<#
.SYNOPSIS
Create/Update a CARML module based on the latest API information available

.DESCRIPTION
Create/Update a CARML module based on the latest API information available.
NOTE: As we query some data from Azure, you must be connected to an Azure Context to use this function

.PARAMETER FullResourceType
Mandatory. The full resource type including the provider namespace to query the data for (e.g., Microsoft.Storage/storageAccounts)

.PARAMETER ExcludeChildren
Optional. Don't include child resource types in the result

.PARAMETER IncludePreview
Mandatory. Include preview API versions

.PARAMETER KeepArtifacts
Optional. Skip the removal of downloaded/cloned artifacts (e.g. the API-Specs repository). Useful if you want to run the function multiple times in a row.

.EXAMPLE
Invoke-REST2CARML -FullResourceType 'Microsoft.Keyvault/vaults'

Generate/Update a CARML module for [Microsoft.Keyvault/vaults]

.EXAMPLE
Invoke-REST2CARML -FullResourceType 'Microsoft.AVS/privateClouds' -Verbose -KeepArtifacts

Generate/Update a CARML module for [Microsoft.AVS/privateClouds] and do not delete any downloaded/cloned artifact.

.EXAMPLE
Invoke-REST2CARML -FullResourceType 'Microsoft.Keyvault/vaults' -KeepArtifacts

Generate/Update a CARML module for [Microsoft.Keyvault/vaults] and do not delete any downloaded/cloned artifact.

.EXAMPLE
Invoke-AzureApiCrawler -FullResourceType 'Microsoft.Storage/storageAccounts/blobServices/containers' -Verbose -KeepArtifacts

Generate/Update a CARML module for [Microsoft.Storage/storageAccounts/blobServices/containers] and do not delete any downloaded/cloned artifact.
#>
function Invoke-REST2CARML {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType,

        [Parameter(Mandatory = $false)]
        [switch] $ExcludeChildren,

        [Parameter(Mandatory = $false)]
        [switch] $IncludePreview,

        [Parameter(Mandatory = $false)]
        [switch] $KeepArtifacts
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
        Write-Verbose ('Processing module [{0}]' -f $FullResourceType) -Verbose
    }

    process {

        ############################################
        ##   Extract module data from API specs   ##
        ############################################

        $apiSpecsInputObject = @{
            FullResourceType = $FullResourceType
            ExcludeChildren  = $ExcludeChildren
            IncludePreview   = $IncludePreview
            KeepArtifacts    = $KeepArtifacts
        }
        $fullModuleData = Get-AzureAPISpecsData @apiSpecsInputObject

        ############################
        ##   Set module content   ##
        ############################
        foreach ($identifier in ($fullModuleData.Keys | Sort-Object)) {
            # Sort shortest to longest path
            $moduleTemplateInputObject = @{
                FullResourceType = $identifier
                JSONFilePath     = $fullModuleData[$identifier].metadata.jsonFilePath
                UrlPath          = $fullModuleData[$identifier].metadata.urlPath
                ModuleData       = $fullModuleData[$identifier].data
                FullModuleData   = $fullModuleData
            }
            if ($PSCmdlet.ShouldProcess(('Module [{0}] files' -f $identifier), 'Create/Update')) {
                Set-Module @moduleTemplateInputObject
            }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
