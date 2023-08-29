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
Update-RoleAssignmentListInner -ProviderNamespace 'key-vault' -ResourceType 'vault'

Update nested_roleassignments.bicep template for module [key-vault/vault] with latest available Role Definitions
#>
function Update-RoleAssignmentListInner {

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
        $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent
        $modulesPath = Join-Path $repoRootPath 'modules'
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

        ##################################
        ##  Create array of file names  ##
        ##################################
        $filesToProcess = @()
        if ("$ProviderNamespace/$ResourceType" -eq 'authorization/role-assignment') {
            # for the module 'authorization/role-assignment' looking recursiverly for
            # all 'main.bicep' files in the module folder
            Set-Location $modulesPath
            $searchFile = Join-Path $modulesPath 'authorization' 'role-assignment' '**' 'main.bicep'
            $rbacPathList = Get-ChildItem -Path $searchFile -Recurse
            foreach ($item in $rbacPathList) {
                $FullFilePath = $item.FullName
                $relativeFilePath = ((Get-Item $FullFilePath | Resolve-Path -Relative) -replace '\\', '/') -replace '\.\/', ''
                $filesToProcess += $relativeFilePath
            }
        } else {
            # for all other modules adding 'nested_roleAssignments.bicep' file only
            $filesToProcess += Join-Path $ProviderNamespace $ResourceType '.bicep' $fileNameToUpdate
        }

        #############################
        ##  Processing files array ##
        #############################
        foreach ($fileToProcess in $filesToProcess) {
            # Get existing content
            $content = Get-Content $fileToProcess -Raw

            # Update Content
            $newContent = ($nestedRoles | Out-String).TrimEnd()
            $content = ($content -replace '(?ms)^\s+var builtInRoleNames = {.*?}', $newContent).TrimEnd()
            if ($PSCmdlet.ShouldProcess("File in path [$fileToProcess]", 'Update')) {
                Set-Content -Path $fileToProcess -Value $content -Force -Encoding 'utf8'
            }
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
Update-RoleAssignmentList

Update all nested_roleassignments.bicep found in the library with latest available Role Definitions

.EXAMPLE
Update-RoleAssignmentList -ProviderNamespace 'key-vault' -ResourceType 'vault'

Update nested_roleassignments.bicep template for module [key-vault/vault] with latest available Role Definitions
#>
function Update-RoleAssignmentList {

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
                $null = Update-RoleAssignmentListInner -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType -Verbose
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
                    $null = Update-RoleAssignmentListInner -ProviderNamespace $provider -ResourceType $type -Verbose
                }
            }
            # also updating the roles in the [authorization/role-assignment] module,
            # which needs to be triggered separately, as the roles are not stored in the nested_roleAssignments.bicep
            # and therefore it's not detected by the search
            if ($PSCmdlet.ShouldProcess('Role Assignments for module [authorization/role-assignment]', 'Update')) {
                $null = Update-RoleAssignmentListInner -ProviderNamespace 'authorization' -ResourceType 'role-assignment' -Verbose
            }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
