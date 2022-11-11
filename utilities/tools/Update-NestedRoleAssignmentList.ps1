<#
.SYNOPSIS
Update latest available Role Definitions in nested_roleassignments.bicep template for the given ProviderNamespace and ResourceType

.DESCRIPTION
Update latest available Role Definitions in nested_roleassignments.bicep template for the given ProviderNamespace and ResourceType

.PARAMETER ProviderNamespace
Mandatory. The Provider Namespace to fetch the role definitions for

.PARAMETER ResourceType
Mandatory. The ResourceType to fetch the role definitions for

.EXAMPLE
Update-NestedRoleAssignmentListInner -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'

Update nested_roleassignments.bicep template for [Microsoft.KeyVault/vaults] module with latest available Role Definitions
#>
function Update-NestedRoleAssignmentListInner {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
        # Load Get RoleAssignments List
        $utilitiesFolderPath = Split-Path $PSScriptRoot -Parent
        . (Join-Path $utilitiesFolderPath 'tools' 'Get-RoleAssignmentList')
        $fileNameToUpdate = 'nested_roleAssignments.bicep'
    }

    process {

        #################
        ##  Get Roles  ##
        #################
        $roles = (Get-RoleAssignmentList -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType).bicepFormat
        $roles = $roles | ForEach-Object { "  $_" }
        $nestedRoles = [System.Collections.ArrayList]@(
            '',
            'var builtInRoleNames = {',
            $roles,
            '}'
        )

        #######################
        ##  Get old content  ##
        #######################
        $pathToFile = Join-Path $ProviderNamespace $ResourceType '.bicep' $fileNameToUpdate
        $content = Get-Content $pathToFile -Raw

        #####################
        ##  Update Conent  ##
        #####################
        $newContent = ($nestedRoles | Out-String).TrimEnd()
        $content = ($content -replace '(?ms)^\s+var builtInRoleNames = {.*?}', $newContent).TrimEnd()
        if ($PSCmdlet.ShouldProcess("File in path [$pathToFile]", 'Update')) {
            Set-Content -Path $pathToFile -Value $content -Force -Encoding 'utf8'
        }

        # Return arrays
        return $roles
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}

<#
.SYNOPSIS
Update latest available Role Definitions in nested_roleassignments.bicep template

.DESCRIPTION
Update latest available Role Definitions in nested_roleassignments.bicep template for the given ProviderNamespace and ResourceType if specified,
otherwise perform the update to the entire library

.PARAMETER ProviderNamespace
Optional. The Provider Namespace to fetch the role definitions for

.PARAMETER ResourceType
Optional. The ResourceType to fetch the role definitions for

.EXAMPLE
Update-NestedRoleAssignmentList

Update all nested_roleassignments.bicep found in the library with latest available Role Definitions

.EXAMPLE
Update-NestedRoleAssignmentList -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'

Update nested_roleassignments.bicep template for [Microsoft.KeyVault/vaults] module with latest available Role Definitions
#>
function Update-NestedRoleAssignmentList {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $false)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $false)]
        [string] $ResourceType
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
        $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent
        $modulesPath = Join-Path $repoRootPath 'modules'
        $fileNameToUpdate = 'nested_roleAssignments.bicep'
    }

    process {
        if (-not [String]::IsNullOrEmpty($ProviderNamespace) -and -not [String]::IsNullOrEmpty($ResourceType)) {
            ########################################
            ## Update RBAC roles for single module #
            ########################################
            if ($PSCmdlet.ShouldProcess("Role Assignments for module [$ProviderNamespace/$ResourceType]", 'Update')) {
                $null = Update-NestedRoleAssignmentListInner -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType -Verbose
            }
        } else {
            ############################################
            ## Update RBAC roles for the whole library #
            ############################################
            Set-Location $modulesPath
            $searchFile = Join-Path $modulesPath '**' $fileNameToUpdate
            $rbacPathList = Get-ChildItem -Path $searchFile -Recurse
            foreach ($item in $rbacPathList) {
                $FullFilePath = $item.FullName
                $relativeFilePath = ((Get-Item $FullFilePath | Resolve-Path -Relative) -replace '\\', '/') -replace '\.\/', ''
                $stringToReplace = (Join-Path '/.bicep' $fileNameToUpdate) -replace '\\', '/'
                $relativeDirectoryPath = $relativeFilePath.Replace($stringToReplace, '')
                $provider, $type = $relativeDirectoryPath -split '\/', 2

                if ($PSCmdlet.ShouldProcess("Role Assignments for module [$relativeDirectoryPath]", 'Update')) {
                    $null = Update-NestedRoleAssignmentListInner -ProviderNamespace $provider -ResourceType $type -Verbose
                }
            }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}

Update-NestedRoleAssignmentList
