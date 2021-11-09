

function Convert-TokensInParameterFile {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$ParameterFilePath,

        [parameter(Mandatory = $false)]
        [psobject]$DefaultParameterFileTokens,

        [parameter(Mandatory = $false)]
        [switch]$GetLocalCustomParameterFileTokens,

        [parameter(Mandatory = $false)]
        [psobject]$LocalCustomParameterFileTokens,

        [parameter(Mandatory = $false, ParameterSetName = 'RemoteTokens')]
        [switch]$GetRemoteCustomParameterFileTokens,

        [parameter(Mandatory = $false, ParameterSetName = 'RemoteTokens')]
        [string]$TokensKeyVaultName,

        [parameter(Mandatory = $false, ParameterSetName = 'RemoteTokens')]
        [string]$TokensKeyVaultSubscriptionId,

        [parameter(Mandatory = $false, ParameterSetName = 'RemoteTokens')]
        [string]$TokensKeyVaultSecretNamePrefix,

        [parameter(Mandatory = $true)]
        [string]$TokenPrefix,

        [parameter(Mandatory = $true)]
        [string]$TokenSuffix
    )

    begin {
        # Load used funtions
        . (Join-Path $PSScriptRoot '../..' 'utilities/tools/Convert-TokensInFileList.ps1')
        . (Join-Path $PSScriptRoot '../..' 'utilities/tools/Get-RemoteCustomParameterFileTokens.ps1')
        $AllCustomParameterFileTokens = @()
    }

    process {

        ## Get Local Custom Parameter File Tokens (Should not Contain Sensitive Information)
        if ($GetLocalCustomParameterFileTokens) {
            Write-Verbose "Found $($LocalCustomParameterFileTokens.Count) Local Custom Tokens in Settings File"
            if ($LocalCustomParameterFileTokens) {
                $AllCustomParameterFileTokens += $LocalCustomParameterFileTokens
            } else {
                Write-Verbose 'No Local Custom Parameter File Tokens Detected'
            }
        }

        ## Get Remote Custom Parameter File Tokens (Should Not Contain Sensitive Information if being passed to regular strings)
        if ($GetRemoteCustomParameterFileTokens) {
            if ($TokensKeyVaultName -and $TokensKeyVaultSubscriptionId) {
                ## Prepare Input for Remote Tokens
                $RemoteTokensInput = @{
                    TokensKeyVaultName = $TokensKeyVaultName
                    SubscriptionId     = $TokensKeyVaultSubscriptionId
                }
                ## If KeyVault Secret Prefix is used
                if ($TokensKeyVaultSecretNamePrefix) {
                    $RemoteTokensInput += @{ TokensKeyVaultSecretNamePrefix = $TokensKeyVaultSecretNamePrefix }
                }
                $RemoteCustomParameterFileTokens = Get-RemoteCustomParameterFileTokens @RemoteTokensInput -ErrorAction SilentlyContinue
                ## Add Tokens to All Custom Parameter File Tokens
                if ($RemoteCustomParameterFileTokens) {
                    Write-Verbose "Found $($RemoteCustomParameterFileTokens.Count) Remote Custom Tokens in Key Vault"
                    $AllCustomParameterFileTokens += $RemoteCustomParameterFileTokens
                } else {
                    Write-Verbose 'No Remote Custom Parameter File Tokens Detected'
                }
            }
        }
        # Combine All Input Token Types, Remove Duplicates and Only Select Name, Value if they contain other unrequired properties
        Write-Verbose ('Combining All Parameter File Tokens and Removing Duplicates')
        $AllCustomParameterFileTokens = $DefaultParameterFileTokens + $LocalCustomParameterFileTokens + $RemoteCustomParameterFileTokens |
            ForEach-Object { [PSCustomObject]$PSItem } |
            Sort-Object Name -Unique |
            Select-Object -Property Name, Value

        Write-Verbose ("All Parameter File Tokens Count: '$($AllCustomParameterFileTokens.Count)'")
        # Apply Prefix and Suffix to Tokens and Prepare Object for Conversion
        if ($AllCustomParameterFileTokens) {
            Write-Verbose ("Appling Token Prefix '$TokenPrefix' and Token Suffix '$TokenSuffix' To All Parameter File Tokens")
            foreach ($ParameterFileToken in $AllCustomParameterFileTokens) {
                $ParameterFileToken.Name = -join ($TokenPrefix, $ParameterFileToken.Name, $TokenSuffix)
            }

            Write-Verbose ($AllCustomParameterFileTokens | ConvertTo-Json | Out-String) -Verbose
            # Convert Tokens in Parameter Files
            Write-Verbose 'Invoking Convert-TokensInFileList'
            try {
                Convert-TokensInFileList -Paths $ParameterFilePath -TokensReplaceWith $AllCustomParameterFileTokens
                $ConversionStatus = $true
            } catch {
                $ConversionStatus = $false
            }
        }

    }
    end {
        return [bool]$ConversionStatus
    }
}
