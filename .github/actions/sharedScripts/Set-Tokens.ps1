

function Set-Tokens {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        [psobject]$DefaultTokens,

        [parameter(Mandatory = $false)]
        [psobject]$CustomLocalTokens,

        [parameter(Mandatory = $false)]
        [psobject]$CustomRemoteTokens
    )

    begin {

    }

    process {
        # Load used funtions
        . 'utilities/tools/Convert-TokensInFileList.ps1'
        . 'utilities/tools/Get-ParameterFileTokens.ps1'

        # Initialize Default Parameter File Tokens
        $DefaultParameterFileTokens = @(
            @{ Replace = '<<resourceGroupName>>'; With = '${{ inputs.resourceGroupName }}' }
        ) | ForEach-Object { [PSCustomObject]$PSItem }

        # Get Custom Parameter File Tokens (Local and Remote-If Key Vault Provided)
        $ConvertTokensFunctionsInput = @{
            SubscriptionId                 = '${{ inputs.subscriptionId }}'
            LocalCustomParameterFileTokens = $Settings.parameterFileTokens.localCustomParameterFileTokens.tokens
            TokenKeyVaultSecretNamePrefix  = $Settings.parameterFileTokens.remoteCustomParameterFileTokens.keyVaultSecretNamePrefix
        }
        if ('${{ env.PLATFORM_KEYVAULT }}') {
            $ConvertTokensFunctionsInput += @{ TokenKeyVaultName = '${{ env.PLATFORM_KEYVAULT }}' }
        }
        $CustomParameterFileTokens = Get-ParameterFileTokens @ConvertTokensFunctionsInput -Verbose

        # Combine All Parameter File Tokens
        $AllParameterFileTokens = $DefaultParameterFileTokens + $CustomParameterFileTokens | ForEach-Object { [PSCustomObject]$PSItem }

        # Convert Tokens in Parameter Files
        Write-Verbose 'Invoking Convert-TokensInFileList'
        Convert-TokensInFileList -Paths '${{ inputs.parameterFilePath }}' -TokensReplaceWith $AllParameterFileTokens
    }

    end {

    }
}
