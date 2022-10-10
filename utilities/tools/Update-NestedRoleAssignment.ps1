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
Update-NestedRoleAssignmentInner -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'

Update nested_roleassignments.bicep template for [Microsoft.KeyVault/vaults] module with latest available Role Definitions
#>
function Update-NestedRoleAssignmentInner {

    [CmdletBinding()]
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
        . (Join-Path $utilitiesFolderPath 'tools' 'Get-RoleAssignmentsList')
    }

    process {

        Write-Verbose "Updating Role Definitions for [$ProviderNamespace/$ResourceType]" -Verbose

        #################
        ##  Get Roles  ##
        #################
        $roles = (Get-RoleAssignmentsList -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType).bicepFormat
        $roles = $roles | ForEach-Object { "`t$_" }
        $nestedRoles = [System.Collections.ArrayList]@(
            '',
            'var builtInRoleNames = {',
            $roles,
            '}'
        )

        #######################
        ##  Get old content  ##
        #######################
        $pathToFile = Join-Path $ProviderNamespace $ResourceType '.bicep' 'nested_roleAssignments.bicep'
        $content = Get-Content $pathToFile -Raw

        #####################
        ##  Update Conent  ##
        #####################
        $newContent = ($nestedRoles | Out-String).TrimEnd()
        $content = ($content -replace '(?ms)^\s+var builtInRoleNames = {.*?}', $newContent).TrimEnd()
        Set-Content -Path $pathToFile -Value $content -Force -Encoding 'utf8'

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
Update-NestedRoleAssignment

Update all nested_roleassignments.bicep found in the library with latest available Role Definitions

.EXAMPLE
Update-NestedRoleAssignment -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'

Update nested_roleassignments.bicep template for [Microsoft.KeyVault/vaults] module with latest available Role Definitions
#>
function Update-NestedRoleAssignment {

    [CmdletBinding()]
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
        $FileToSearch = 'nested_roleAssignments.bicep'
    }

    process {
        if ($ProviderNamespace -and $ResourceType) {
            ########################################
            ## Update RBAC roles for single module #
            ########################################
            $null = Update-NestedRoleAssignmentInner -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType -Verbose
        } else {
            ############################################
            ## Update RBAC roles for the whole library #
            ############################################
            Set-Location $modulesPath
            $searchFile = Join-Path $modulesPath '**' $FileToSearch
            $rbacPathList = Get-ChildItem -Path $searchFile -Recurse
            foreach ($item in $rbacPathList) {
                $FullFilePath = $item.FullName
                $relativeFilePath = Get-Item $FullFilePath | Resolve-Path -Relative
                $relativeFilePath = $relativeFilePath -replace '\.\\', ''
                $relativeDirectoryPath = $relativeFilePath -replace '\\\.bicep\\nested_roleAssignments\.bicep', ''
                $provider, $type = $relativeDirectoryPath -split '\\', 2
                $null = Update-NestedRoleAssignmentInner -ProviderNamespace $provider -ResourceType $type -Verbose
            }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
