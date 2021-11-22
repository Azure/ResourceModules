<#
.SYNOPSIS
This script gets tokens from an Azure Vault that are defined as secrets, so that it can be swapped at runtime

.DESCRIPTION
This script gets tokens from an Azure Vault that are defined as secrets. The returned object consists of Secret Name and Secret Value in the form of (Name/Value)

.PARAMETER SubscriptionId
Mandatory. The Azure subscription containing the key vault.

.PARAMETER KeyVaultName
Mandatory. The name of the Key Vault. It will be used to find a Key Vault that contains Tokens (Secrets).

.PARAMETER SecretContentType
Mandatory. An identifier used to filter for the Tokens (Secret) in Key Vault using the ContentType Property (i.e. myTokenContentType)

.EXAMPLE
Get-TokenFromKeyVault -KeyVaultName 'contoso-kv' -SubscriptionId '1234-1234'12345678-1234-123456789101' -SecretContentType 'myTokenContentType'

#>
function Get-TokenFromKeyVault {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]$KeyVaultName,

        [parameter(Mandatory)]
        [string]$SubscriptionId,

        [parameter(Mandatory)]
        [string]$SecretContentType
    )
    begin {
        ## Set Azure Context
        try {
            $Context = Get-AzContext -ListAvailable | Where-Object Subscription -Match $SubscriptionId
            if ($Context) {
                Write-Verbose('Setting Azure Context')
                $Context | Set-AzContext | Out-Null
            }
        } catch {
            throw $PSitem.Exception.Message
            return
        }
        $ReturnedTokens = @()
    }
    process {
        Write-Verbose "Finding Key Vault by Name: $KeyVaultName"
        ## Find Token Key Vault by Name
        $TokensKeyVault = Get-AzKeyVault -VaultName $KeyVaultName -ErrorAction SilentlyContinue
        # If no Key Vault exists. Exit
        if (!$TokensKeyVault) {
            Write-Verbose('No Tokens Key Vault Detected in the current Subscription Context')
            return
        }
        ## Get Tokens
        Write-Verbose "Getting Tokens using the Content Type: $($SecretContentType)"
        $Tokens = Get-AzKeyVaultSecret -VaultName $KeyVaultName -ErrorAction SilentlyContinue |
            Where-Object -Property ContentType -EQ "$($SecretContentType)"
        ## If no Tokens exist. Exit
        if (!$Tokens) {
            Write-Verbose("No Tokens Found In Key Vault ($KeyVaultName) or Principal does not have permissions to read it")
            return
        }
        ## Get Token Values and Add to the Returned Object
        $Tokens | ForEach-Object {
            $TokenName = $PSItem.Name
            $GetTokenInput = @{
                SecretName = $TokenName
                VaultName  = $KeyVaultName
            }
            $TokenValue = (Get-AzKeyVaultSecret @GetTokenInput -ErrorAction SilentlyContinue).SecretValue
            ## Add Token to Return Object
            $ReturnedTokens += [ordered]@{ Name = $TokenName; Value = $TokenValue }
        }
    }
    end {
        Write-Verbose("Returning ($($ReturnedTokens.count)) Tokens From Key Vault")
        return [psobject]$ReturnedTokens | ForEach-Object { [PSCustomObject]$PSItem }
    }
}
