<#
.SYNOPSIS
This Function Helps with Testing A Module Locally

.DESCRIPTION
This Function aggregates all the different token types (Default and Local) and then passes them to the Convert Tokens Script to replace tokens in a parameter file

.PARAMETER ParameterFilePath
Mandatory. The Path to the Parameter File that contains tokens to be replaced.

.PARAMETER DefaultParameterFileTokens
Optional. An object containing the default parameter file tokens that are always available.

.PARAMETER LocalCustomParameterFileTokens
Optional. An object containing the local parameter file tokens to be injected for replacement

.PARAMETER TokenPrefix
Mandatory. The prefix used to identify a token in the parameter file (i.e. <<)

.PARAMETER TokenSuffix
Mandatory. The suffix used to identify a token in the parameter file (i.e. >>)

.PARAMETER OtherCustomParameterFileTokens
Optional. An object containing other optional tokens that are to be replaced in the parameter file (used for testing)

.PARAMETER SwapValueWithName
Optional. A boolean that enables the search for the original value and replaces it with a token. Used to revert configuration. Default is false

.PARAMETER OutputDirectory
Optional. A string for a custom output directory of the modified parameter file

.NOTES
- Make sure you provide the right information in the objects that contain tokens. This is in the form of
 @(
        @{ Name = 'deploymentSpId'; Value = '12345678-1234-1234-1234-123456789123' }
        @{ Name = 'tenantId'; Value = '12345678-1234-1234-1234-123456789123' }

- Ensure you have the ability to perform the deployment operations using your account
- If providing TokenKeyVaultName parameter, ensure you have read access to secrets in the key vault to be able to retrieve the tokens.
#>

function Convert-TokensInParameterFile {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$ParameterFilePath,

        [parameter(Mandatory = $false)]
        [psobject]$DefaultParameterFileTokens,

        [parameter(Mandatory = $false)]
        [psobject]$LocalCustomParameterFileTokens,

        [parameter(Mandatory = $true)]
        [string]$TokenPrefix,

        [parameter(Mandatory = $true)]
        [string]$TokenSuffix,

        [parameter(Mandatory = $false)]
        [psobject]$OtherCustomParameterFileTokens,

        [parameter(Mandatory = $false)]
        [bool]$SwapValueWithName = $false,

        [parameter(Mandatory = $false)]
        [string]$OutputDirectory
    )

    begin {
        # Load used funtions
        . (Join-Path $PSScriptRoot './helper/Convert-TokenInFile.ps1')
        $AllCustomParameterFileTokens = @()
    }

    process {
        Write-Verbose "Default Tokens Count: ($($DefaultParameterFileTokens.Count)) Tokens (From Input Parameter)"
        ## Get Local Custom Parameter File Tokens (Should not Contain Sensitive Information)
        Write-Verbose "Local Custom Tokens Count: ($($LocalCustomParameterFileTokens.Count)) Tokens (From Settings File)"
        $AllCustomParameterFileTokens += ($LocalCustomParameterFileTokens | Select-Object -Property Name, Value)
        # Combine All Input Token Types, Remove Duplicates and Only Select Name, Value if they contain other unrequired properties
        $AllCustomParameterFileTokens = $DefaultParameterFileTokens + $LocalCustomParameterFileTokens |
            ForEach-Object { [PSCustomObject]$PSItem } |
            Sort-Object Name -Unique |
            Select-Object -Property Name, Value |
            Where-Object { $null -ne $PSitem.Name -and $null -ne $PSitem.Value }

        # Other Custom Parameter File Tokens (Can be used for testing)
        if ($OtherCustomParameterFileTokens) {
            $AllCustomParameterFileTokens += $OtherCustomParameterFileTokens | ForEach-Object { [PSCustomObject]$PSItem }
        }
        Write-Verbose ("All Parameter File Tokens Count: ($($AllCustomParameterFileTokens.Count))")
        # Apply Prefix and Suffix to Tokens and Prepare Object for Conversion
        Write-Verbose ("Applying Token Prefix '$TokenPrefix' and Token Suffix '$TokenSuffix'")
        foreach ($ParameterFileToken in $AllCustomParameterFileTokens) {
            $ParameterFileToken.Name = -join ($TokenPrefix, $ParameterFileToken.Name, $TokenSuffix)
        }
        # Convert Tokens in Parameter Files
        try {
            # Prepare Input to Token Converter Function
            $ConvertTokenListFunctionInput = @{
                FilePath             = $ParameterFilePath
                TokenNameValueObject = $AllCustomParameterFileTokens
                SwapValueWithName    = $SwapValueWithName
            }
            if ($OutputDirectory) {
                $ConvertTokenListFunctionInput += @{OutputDirectory = $OutputDirectory }
            }
            # Convert Tokens in the File
            Convert-TokenInFile @ConvertTokenListFunctionInput
            $ConversionStatus = $true
        } catch {
            $ConversionStatus = $false
            Write-Verbose $_.Exception.Message -Verbose
        }
    }
    end {
        Write-Verbose "Token Replacement Status: $ConversionStatus"
        return [bool]$ConversionStatus
    }
}
