<#
.SYNOPSIS
Create/Update a CARML module based on the latest API information available

.DESCRIPTION
Create/Update a CARML module based on the latest API information available.
NOTE: As we query some data from Azure, you must be connected to an Azure Context to use this function

.PARAMETER ProviderNamespace
Mandatory. The provider namespace to query the data for

.PARAMETER ResourceType
Mandatory. The resource type to query the data for

.PARAMETER ExcludeChildren
Optional. Don't include child resource types in the result


.PARAMETER IncludePreview
Mandatory. Include preview API versions

.PARAMETER KeepArtifacts
Optional. Skip the removal of downloaded/cloned artifacts (e.g. the API-Specs repository). Useful if you want to run the function multiple times in a row.

.EXAMPLE
Invoke-REST2CARML -ProviderNamespace 'Microsoft.Keyvault' -ResourceType 'vaults'

Generate/Update a CARML module for [Microsoft.Keyvault/vaults]

.EXAMPLE
Invoke-REST2CARML -ProviderNamespace 'Microsoft.AVS' -ResourceType 'privateClouds' -Verbose -KeepArtifacts

Generate/Update a CARML module for [Microsoft.AVS/privateClouds] and do not delete any downloaded/cloned artifact.

.EXAMPLE
Invoke-REST2CARML -ProviderNamespace 'Microsoft.Keyvault' -ResourceType 'vaults' -KeepArtifacts

Generate/Update a CARML module for [Microsoft.Keyvault/vaults] and do not delete any downloaded/cloned artifact.

.EXAMPLE
Invoke-AzureApiCrawler -ProviderNamespace 'Microsoft.Storage' -ResourceType 'storageAccounts/blobServices/containers' -Verbose -KeepArtifacts

Generate/Update a CARML module for [Microsoft.Storage/storageAccounts/blobServices/containers] and do not delete any downloaded/cloned artifact.
#>
function Invoke-REST2CARML {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [switch] $ExcludeChildren,

        [Parameter(Mandatory = $false)]
        [switch] $IncludePreview,

        [Parameter(Mandatory = $false)]
        [switch] $KeepArtifacts
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
        Write-Verbose ('Processing module [{0}/{1}]' -f $ProviderNamespace, $ResourceType) -Verbose
    }

    process {

        ############################################
        ##   Extract module data from API specs   ##
        ############################################

        $apiSpecsInputObject = @{
            ProviderNamespace = $ProviderNamespace
            ResourceType      = $ResourceType
            ExcludeChildren   = $ExcludeChildren
            IncludePreview    = $IncludePreview
            KeepArtifacts     = $KeepArtifacts
        }
        $moduleData = Get-AzureApiSpecsData @apiSpecsInputObject

        ############################
        ##   Set module content   ##
        ############################
        foreach ($moduleDataBlock in ($moduleData | Sort-Object -Property 'Identifier')) {
            # Sort shortest to longest path
            $moduleTemplateInputObject = @{
                FullResourceType = $moduleDataBlock.identifier
                JSONFilePath     = $moduleDataBlock.metadata.jsonFilePath
                UrlPath          = $moduleDataBlock.metadata.urlPath
                ModuleData       = $moduleDataBlock.data
            }
            if ($PSCmdlet.ShouldProcess(('Module [{0}] files' -f $moduleDataBlock.identifier), 'Create/Update')) {
                Set-Module @moduleTemplateInputObject
            }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
