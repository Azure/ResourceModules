
<#
.SYNOPSIS
Get hash of the ARM deployment JSON template using only 'resources' tag

.DESCRIPTION
Get hash of the ARM deployment JSON template using only 'resources' tag

.PARAMETER TemplatePath
Required. Path to the ARM JSON template

.EXAMPLE
Get-TemplateHash -TemplatePath .\deploy.json

#>

function Get-TemplateHash {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $TemplatePath
    )

    try {
        $templateContent = Get-Content $TemplatePath -Raw | ConvertFrom-Json -Depth 100
        # if no resouces tag, quit
        if ($templateContent.resources.Count -eq 0) {
            return ''
        }

        # remove all except resouces tag
        foreach ($property in $templateContent.PSObject.Properties) {
            if ($property.Name.ToLower() -ne 'resources') {
                $templateContent.PSObject.Properties.Remove($property.Name)
            }
        }
        # rrder resources properties alphabetically
        $templateContent.resources = $templateContent.resources | Select-Object ($templateContent.resources | Get-Member -MemberType NoteProperty).Name

        # create temp file and esport
        $tmpPath = Join-Path $PSScriptRoot ('HASH-{0}.json' -f (New-Guid))
        $templateContent | ConvertTo-Json -Depth 100 | Out-File $tmpPath

        # create hash
        $azHash = (Get-FileHash -Path $tmpPath -Algorithm SHA256).Hash

        return $azHash
    } catch {
        throw $_
    } finally {
        # Remove temp files
        if ((-not [String]::IsNullOrEmpty($tmpPath)) -and (Test-Path $tmpPath)) {
            Remove-Item -Path $tmpPath -Force
        }
    }
}

Export-ModuleMember -Function 'Get-TemplateHash'
