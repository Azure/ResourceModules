<#
.SYNOPSIS
Get a properly formatted 'Deploy to Azure' button for the template in the given path

.DESCRIPTION
Get a properly formatted 'Deploy to Azure' button for the template in the given path
NOTE: This function requires that the Repository lives inside the 'Azure' Organization

.PARAMETER path
Mandatory. The path to the module to generate the url for

.PARAMETER RepositoryName
Mandatory. The name of the repository the content is included in.

.PARAMETER Organization
Mandatory. The name of the Organization the code resides in

.EXAMPLE
Get-DeployToAzureUrl -path 'C:\Modules\MyModule' -RepositoryName 'Modules' -Organization 'Azure'

Generate an 'Deploy to Azure' button for module 'MyModule'
#>
function Get-DeployToAzureUrl {


    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $RepositoryName,

        [Parameter(Mandatory)]
        [string] $Organization
    )

    if (-not (Test-Path -Path "$Path\deploy.json")) {
        Write-Warning "ARM Template in path [$Path\deploy.json] not found. Unable to generate 'Deploy to Azure' button."
        return ''
    }

    $baseUrl = '[![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/'
    $templateUri = 'https://raw.githubusercontent.com/{0}/{1}/main/{2}/deploy.json' -f $Organization, $RepositoryName, ($Path -split "\\$RepositoryName\\")[1]

    return ('{0}{1}>)' -f $baseUrl, ([System.Web.HttpUtility]::UrlEncode($templateUri)))
}
