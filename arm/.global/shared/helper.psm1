<#
.SYNOPSIS
Get a list of all resources (provider + service) in the given template content

.DESCRIPTION
Get a list of all resources (provider + service) in the given template content. Crawls through any children & nested deployment templates.

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.EXAMPLE
Get-NestedResourceList -TemplateFileContent @{ resource = @{}; ... }

Returns a list of all resources in the given template object
#>
function Get-NestedResourceList {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable] $TemplateContent
    )

    $res = @()
    $currLevelResources = @()
    if ($TemplateContent.resources) {
        $currLevelResources += $TemplateContent.resources
    }
    foreach ($resource in $currLevelResources) {
        $res += $resource

        if ($resource.type -eq 'Microsoft.Resources/deployments') {
            $res += Get-NestedResourceList -TemplateContent $resource.properties.template
        } else {
            $res += Get-NestedResourceList -TemplateContent $resource
        }
    }
    return $res
}
