<#
.SYNOPSIS
Clone a given repository to a folder by the given name in the module's 'temp' folder

.DESCRIPTION
Clone a given repository to a folder by the given name in the module's 'temp' folder

.PARAMETER RepoUrl
Mandatory. The git clone URL of the repository to clone.

.PARAMETER RepoName
Mandatory. The name of the repository to download

.EXAMPLE
Copy-CustomRepository -RepoUrl 'https://github.com/Azure/azure-rest-api-specs.git' -RepoName 'azure-rest-api-specs'
#>
function Copy-CustomRepository {


    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $RepoUrl,

        [Parameter(Mandatory = $true)]
        [string] $RepoName
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
        $initialLocation = (Get-Location).Path
    }

    process {
        # Clone repository
        ## Create temp folder
        if (-not (Test-Path $script:temp)) {
            $null = New-Item -Path $script:temp -ItemType 'Directory'
        }
        ## Switch to temp folder
        Set-Location $script:temp

        ## Clone repository into temp folder
        if (-not (Test-Path (Join-Path $script:temp $repoName))) {
            git clone --depth=1 --single-branch --branch=main --filter=tree:0 $repoUrl
        } else {
            Write-Verbose "Repository [$repoName] already cloned"
        }

        Set-Location $initialLocation
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }

}
