<#
.SYNOPSIS
Replace tokens like '<<ProviderNamespace>>' in the given file with an actual value

.DESCRIPTION
Replace tokens like '<<ProviderNamespace>>' in the given file with an actual value.

.PARAMETER Content
Mandatory. The content to update

.EXAMPLE
Set-TokenValuesInArray -Content "Hello <<shortProviderNamespaceLower>>-<<resourceTypePascal>>" -Tokens @{ shortProviderNamespaceLower = 'keyvault'; resourceTypePascal = 'Vaults' }

Update the provided content with different Provider Namespace & Resource Type token variant. Would return 'Hello keyvault-Vaults'
#>
function Set-TokenValuesInArray {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Content,

        [Parameter(Mandatory = $true)]
        [hashtable] $Tokens
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {

        foreach ($token in $tokens.Keys) {
            $content = $content -replace "<<$token>>", $tokens[$token]
        }

        return $content
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
