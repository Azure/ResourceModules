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

.PARAMETER IncludePreview
Mandatory. Include preview API versions

.PARAMETER KeepArtifacts
Optional. Skip the removal of downloaded/cloned artifacts (e.g. the API-Specs repository). Useful if you want to run the function multiple times in a row.

.EXAMPLE
Invoke-REST2CARML -ProviderNamespace 'Microsoft.Keyvault' -ResourceType 'vaults'

Generate/Update a CARML module for [Microsoft.Keyvault/vaults]

.EXAMPLE
Invoke-REST2CARML -ProviderNamespace 'Microsoft.Keyvault' -ResourceType 'vaults' -KeepArtifacts

Generate/Update a CARML module for [Microsoft.Keyvault/vaults] and do not download any downloaded/cloned artifact.
#>
function Invoke-REST2CARML {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [switch] $IncludePreview,

        [Parameter(Mandatory = $false)]
        [switch] $KeepArtifacts
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load used functions
        . (Join-Path $PSScriptRoot 'Get-ServiceSpecPathData.ps1')
        . (Join-Path $PSScriptRoot 'Resolve-ModuleData.ps1')
        . (Join-Path $PSScriptRoot 'Set-ModuleFileStructure.ps1')
        . (Join-Path $PSScriptRoot 'Set-Module.ps1')

        Write-Verbose ('Processing module [{0}/{1}]' -f $ProviderNamespace, $ResourceType) -Verbose

        $initialLocation = (Get-Location).Path
    }

    process {

        #########################################
        ##   Temp Clone API Specs Repository   ##
        #########################################

        $repoUrl = 'https://github.com/Azure/azure-rest-api-specs.git'
        $repoName = Split-Path $repoUrl -LeafBase
        $tempFolderName = 'temp'
        $tempFolderPath = Join-Path $PSScriptRoot $tempFolderName

        # Clone repository
        ## Create temp folder
        if (-not (Test-Path $tempFolderPath)) {
            $null = New-Item -Path $tempFolderPath -ItemType 'Directory'
        }
        ## Switch to temp folder
        Set-Location $tempFolderPath

        ## Clone repository into temp folder
        if (-not (Test-Path (Join-Path $tempFolderPath $repoName))) {
            git clone --depth=1 --single-branch --branch=main --filter=tree:0 $repoUrl
        } else {
            Write-Verbose "Repository [$repoName] already cloned"
        }

        Set-Location $initialLocation

        try {
            ###########################
            ##   Fetch module data   ##
            ###########################
            $getPathDataInputObject = @{
                ProviderNamespace = $ProviderNamespace
                ResourceType      = $ResourceType
                RepositoryPath    = Join-Path $tempFolderPath $repoName
                IncludePreview    = $IncludePreview
            }
            $pathData = Get-ServiceSpecPathData @getPathDataInputObject

            $resolveInputObject = @{
                JSONFilePath = $pathData.jsonFilePath
                JSONKeyPath  = $pathData.jsonKeyPath
                ResourceType = $ResourceType
            }
            $moduleData = Resolve-ModuleData @resolveInputObject

            ###########################################
            ##   Generate initial module structure   ##
            ###########################################
            if ($PSCmdlet.ShouldProcess(('Module [{0}/{1}] structure' -f $ProviderNamespace, $ResourceType), 'Create/Update')) {
                # TODO: Consider child modules. BUT be aware that pipelines are only generated for the top-level resource
                Set-ModuleFileStructure -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType
            }

            ############################
            ##   Set module content   ##
            ############################
            $moduleTemplateInputObject = @{
                ProviderNamespace = $ProviderNamespace
                ResourceType      = $ResourceType
                JSONFilePath      = $pathData.jsonFilePath
                JSONKeyPath       = $pathData.jsonKeyPath
                ModuleData        = $moduleData
            }
            if ($PSCmdlet.ShouldProcess(('Module [{0}/{1}] files' -f $ProviderNamespace, $ResourceType), 'Create/Update')) {
                Set-Module @moduleTemplateInputObject
            }

        } catch {
            throw $_
        } finally {
            ##########################
            ##   Remove Artifacts   ##
            ##########################
            if (-not $KeepArtifacts) {
                Write-Verbose "Deleting folder [$tempFolderPath]"
                $null = Remove-Item $tempFolderPath -Recurse -Force
            }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}

# Invoke-REST2CARML -ProviderNamespace 'Microsoft.Storage' -ResourceType 'storageAccounts' -Verbose -KeepArtifacts
Invoke-REST2CARML -ProviderNamespace 'Microsoft.AVS' -ResourceType 'privateClouds' -Verbose -KeepArtifacts
