<#
.SYNOPSIS
This Function Helps with Testing A Module Locally

.DESCRIPTION
This Function Helps with Testing A Module Locally. Use this Function To perform Pester Testing for a Module and then attempting to deploy it. It Also allows you to use your own
subscription ID, Principal ID, tenant ID and other parameters that need to be tokenized.

.PARAMETER ParameterFilePath
Mandatory. The Path to the Parameter File that contains tokens to be replaced.

.PARAMETER DefaultParameterFileTokens
Optional. An object containing the default parameter file tokens that are always available.

.PARAMETER LocalCustomParameterFileTokens
Optional. An object containing the local parameter file tokens to be injected for replacement

.PARAMETER TokensKeyVaultName
Optional. A string for the Key Vault Name that contains the remote tokens

.PARAMETER TokensKeyVaultSubscriptionId
Optional. A string for the subscription ID where the Key Vault exists

.PARAMETER TokensKeyVaultSecretNamePrefix
Optional. A string for the prefix that can be used to filter for secrets in an Azure key Vault

.PARAMETER TokenPrefix
Required. The prefix used to identify a token in the parameter file (i.e. <<)

.PARAMETER TokenSuffix
Required. The suffix used to identify a token in the parameter file (i.e. >>)

.PARAMETER OtherCustomParameterFileTokens
Optional. An object containing other optional tokens that are to be replaced in the parameter file (used for testing)

.PARAMETER RestoreTokens
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

        [parameter(Mandatory = $false, ParameterSetName = 'RemoteTokens')]
        [string]$TokensKeyVaultName,

        [parameter(Mandatory = $false, ParameterSetName = 'RemoteTokens')]
        [string]$TokensKeyVaultSubscriptionId,

        [parameter(Mandatory = $false, ParameterSetName = 'RemoteTokens')]
        [string]$TokensKeyVaultSecretNamePrefix = '*',

        [parameter(Mandatory = $true)]
        [string]$TokenPrefix,

        [parameter(Mandatory = $true)]
        [string]$TokenSuffix,

        [parameter(Mandatory = $false)]
        [psobject]$OtherCustomParameterFileTokens,

        [parameter(Mandatory = $false)]
        [bool]$RestoreTokens = $false,

        [parameter(Mandatory = $false)]
        [string]$OutputDirectory
    )

    begin {
        # Load used funtions
        . (Join-Path $PSScriptRoot './helper/Convert-TokensInFileList.ps1')
        . (Join-Path $PSScriptRoot './helper/Get-RemoteCustomParameterFileTokens.ps1')
        $AllCustomParameterFileTokens = @()
    }

    process {
        ## Get Local Custom Parameter File Tokens (Should not Contain Sensitive Information)
        Write-Verbose "Found $($LocalCustomParameterFileTokens.Count) Local Custom Tokens in Settings File"
        $AllCustomParameterFileTokens += ($LocalCustomParameterFileTokens | Select-Object -Property Name, Value)
        ## Get Remote Custom Parameter File Tokens (Should Not Contain Sensitive Information if being passed to regular strings)
        if ($TokensKeyVaultName -and $TokensKeyVaultSubscriptionId) {
            ## Prepare Input for Remote Tokens
            $RemoteTokensInput = @{
                TokensKeyVaultName             = $TokensKeyVaultName
                SubscriptionId                 = $TokensKeyVaultSubscriptionId
                TokensKeyVaultSecretNamePrefix = $TokensKeyVaultSecretNamePrefix
            }
            $RemoteCustomParameterFileTokens = Get-RemoteCustomParameterFileTokens @RemoteTokensInput -ErrorAction SilentlyContinue
            ## Add Tokens to All Custom Parameter File Tokens
            if (!$RemoteCustomParameterFileTokens) {
                Write-Verbose 'No Remote Custom Parameter File Tokens Detected'
            } else {
                Write-Verbose "Found $($RemoteCustomParameterFileTokens.Count) Remote Custom Tokens in Key Vault"
                $AllCustomParameterFileTokens += $RemoteCustomParameterFileTokens
            }
        }
        # Combine All Input Token Types, Remove Duplicates and Only Select Name, Value if they contain other unrequired properties
        Write-Verbose ('Combining All Parameter File Tokens and Removing Duplicates')
        $AllCustomParameterFileTokens = $DefaultParameterFileTokens + $LocalCustomParameterFileTokens + $RemoteCustomParameterFileTokens |
            ForEach-Object { [PSCustomObject]$PSItem } |
            Sort-Object Name -Unique |
            Select-Object -Property Name, Value |
            Where-Object { $null -ne $PSitem.Name -and $null -ne $PSitem.Value }

        # Other Custom Parameter File Tokens (Can be used for testing)
        if ($OtherCustomParameterFileTokens) {
            $AllCustomParameterFileTokens += $OtherCustomParameterFileTokens | ForEach-Object { [PSCustomObject]$PSItem }
        }
        Write-Verbose ("All Parameter File Tokens Count: '$($AllCustomParameterFileTokens.Count)'")
        # Apply Prefix and Suffix to Tokens and Prepare Object for Conversion
        Write-Verbose ("Applying Token Prefix '$TokenPrefix' and Token Suffix '$TokenSuffix' To All Parameter File Tokens")
        foreach ($ParameterFileToken in $AllCustomParameterFileTokens) {
            $ParameterFileToken.Name = -join ($TokenPrefix, $ParameterFileToken.Name, $TokenSuffix)
        }
        # Convert Tokens in Parameter Files
        Write-Verbose 'Invoking Convert-TokensInFileList'
        try {
            # Prepare Input to Token Converter Function
            $ConvertTokenListFunctionInput = @{
                Paths             = $ParameterFilePath
                TokensReplaceWith = $AllCustomParameterFileTokens
                RestoreTokens     = $RestoreTokens
            }
            if ($OutputDirectory) {
                $ConvertTokenListFunctionInput += @{OutputDirectory = $OutputDirectory }
            }
            # Convert Tokens in the File
            Convert-TokensInFileList @ConvertTokenListFunctionInput
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
