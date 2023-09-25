<#
.SYNOPSIS
Set the test files for the given Resource Type identifier (i.e., the Azure DevOps pipeline & GitHub workflow files)

.DESCRIPTION
Set the test files for the given Resource Type identifier (i.e., the Azure DevOps pipeline & GitHub workflow files)

.PARAMETER FullResourceType
Mandatory. The complete ResourceType identifier to add the test files for (e.g. 'Microsoft.Storage/storageAccounts').

.EXAMPLE
Set-ModuleTestFile -FullResourceType 'Microsoft.KeyVault/vaults'

Set the test files for the resource type identifier 'Microsoft.KeyVault/vaults'
#>
function Set-ModuleTestFile {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
        $moduleRootPath = Join-Path $script:repoRoot 'modules' $FullResourceType
    }

    process {
        # Create module files
        # -------------------
        ## .test files
        @(
            (Join-Path $moduleRootPath '.test' 'common' 'deploy.test.bicep')
            (Join-Path $moduleRootPath '.test' 'min' 'deploy.test.bicep')
        ) | ForEach-Object {
            if (-not (Test-Path $_)) {
                if ($PSCmdlet.ShouldProcess(('File [{0}]' -f ($_ -replace ($script:repoRoot -replace '\\', '\\'), '')), 'Create')) {
                    $null = New-Item -Path $_ -ItemType 'File' -Force
                }
            } else {
                Write-Verbose "File [$_] already exists."
            }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
