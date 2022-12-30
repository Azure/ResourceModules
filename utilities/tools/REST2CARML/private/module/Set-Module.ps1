<#
.SYNOPSIS
Update the module's files with the provided module data including added extension resources data.

.DESCRIPTION
Update the module's files with the provided module data including added extension resources data (i.e., RBAC, Diagnostic Settings, Private Endpoints, etc.).

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
Set-Module -FullResourceType 'Microsoft.KeyVault/vaults' -ModuleData @{ parameters = @(...); resource = @(...); (...) } -JSONFilePath '(...)/resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json' -UrlPath '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}' -FullModuleData @(@{ parameters = @(...); resource = @(...); (...) }, @{...})

Update the module [Microsoft.KeyVault/vaults] with the provided module data.
#>
function Set-Module {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType,

        [Parameter(Mandatory = $true)]
        [Hashtable] $ModuleData,

        [Parameter(Mandatory = $true)]
        [hashtable] $FullModuleData,

        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath,

        [Parameter(Mandatory = $true)]
        [string] $UrlPath
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        $moduleRootPath = Join-Path $script:repoRoot 'modules' $FullResourceType
        $providerNamespace = ($FullResourceType -split '/')[0]
        $resourceType = $FullResourceType -replace "$providerNamespace/", ''
        $templatePath = Join-Path $moduleRootPath 'deploy.bicep'
        $isTopLevelModule = ($FullResourceType -split '\/').Count -eq 2

        # Load external functions
        . (Join-Path $script:repoRoot 'utilities' 'tools' 'Set-ModuleReadMe.ps1')
    }

    process {
        ##########################################
        ##   Collection addtional information   ##
        ##########################################

        # RBAC
        if ($ModuleData.roleAssignmentOptions.Count -gt 0) {
            $rbacInputObject = @{
                ProviderNamespace = $ProviderNamespace
                RelevantRoles     = $ModuleData.roleAssignmentOptions
                ResourceType      = $ResourceType
                ModuleData        = $ModuleData
                ServiceApiVersion = Split-Path (Split-Path $JSONFilePath -Parent) -Leaf
            }
            Set-RoleAssignmentsModuleData @rbacInputObject
        }

        # Private Endpoints
        if ($ModuleData.supportsPrivateEndpoints) {
            $endpInputObject = @{
                ResourceType = $ResourceType
                ModuleData   = $ModuleData
            }
            Set-PrivateEndpointModuleData @endpInputObject
        }

        # Locks
        if ($ModuleData.supportsLocks) {
            $lockInputObject = @{
                ResourceType = $ResourceType
                ModuleData   = $ModuleData
            }
            Set-LockModuleData @lockInputObject
        }

        # Diagnostic Settings
        if ($ModuleData.diagnosticMetricsOptions.count -gt 0 -or $ModuleData.diagnosticLogsOptions.count -gt 0) {
            $diagInputObject = @{
                ResourceType             = $ResourceType
                DiagnosticMetricsOptions = $ModuleData.diagnosticMetricsOptions
                DiagnosticLogsOptions    = $ModuleData.diagnosticLogsOptions
                ModuleData               = $ModuleData
            }
            Set-DiagnosticModuleData @diagInputObject
        }

        #############################
        ##   Update Support Files   #
        #############################

        # Pipeline & test files (top-level module only)
        if ($isTopLevelModule) {
            Set-ModulePipelineFile -FullResourceType $FullResourceType
            Set-ModuleTestFile -FullResourceType $FullResourceType
        }

        # Module files
        $versionFilePath = Join-Path $moduleRootPath 'version.json'
        if (-not (Test-Path $versionFilePath)) {
            if ($PSCmdlet.ShouldProcess(('Version file [{0}]' -f ($versionFilePath -replace ($script:repoRoot -replace '\\', '\\'), '')), 'Create')) {
                $versionFileContent = Get-Content (Join-Path $script:src 'moduleVersion.json') -Raw
                $null = New-Item -Path $versionFilePath -ItemType 'File' -Value $versionFileContent -Force
            }
        } else {
            Write-Verbose ('Version file [{0}] already exists.' -f ("$providerNamespace{0}" -f ($versionFilePath -split $providerNamespace)[1]))
        }

        # Additional files as per API-Specs
        foreach ($fileDefinition in $ModuleData.additionalFiles) {
            $supportFilePath = Join-Path $ModuleRootPath $fileDefinition.relativeFilePath
            if (-not (Test-Path $supportFilePath)) {
                if ($PSCmdlet.ShouldProcess(('File [{0}].' -f (Split-Path $supportFilePath -Leaf)), 'Create')) {
                    $null = New-Item -Path $supportFilePath -ItemType 'File' -Value $fileDefinition.fileContent -Force
                }
            } else {
                if ($PSCmdlet.ShouldProcess(('File [{0}].' -f (Split-Path $supportFilePath -Leaf)), 'Update')) {
                    $null = Set-Content -Path $supportFilePath -Value $fileDefinition.fileContent -NoNewline # -NoNewLine added to achieve the same behavior on file creation and update
                }
            }
        }

        #############################
        ##   Update Template File   #
        #############################
        $moduleTemplateContentInputObject = @{
            FullResourceType = $FullResourceType
            ModuleData       = $ModuleData
            FullModuleData   = $FullModuleData
            JSONFilePath     = $JSONFilePath
            urlPath          = $UrlPath
        }
        Set-ModuleTemplate @moduleTemplateContentInputObject

        #############################
        ##   Update Module ReadMe   #
        #############################
        try {
            if ($PSCmdlet.ShouldProcess(('Module ReadMe [{0}]' -f (Join-Path (Split-Path $templatePath -Parent) 'readme.md')), 'Update')) {
                Set-ModuleReadMe -TemplateFilePath $templatePath -Verbose:$false
            }
        } catch {
            Write-Warning "Invocation of 'Set-ModuleReadMe' function for template in path [$templatePath] failed. Please review the template and re-run the command `Set-ModuleReadMe -TemplateFilePath '$templatePath'``"
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }

}
