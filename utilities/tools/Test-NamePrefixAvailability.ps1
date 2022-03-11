
function ReplaceTokensInRelevantFiles {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $parameterFilePaths
    )

    # Replace parameter file tokens
    # -----------------------------

    # Default Tokens
    $ConvertTokensInputs = @{
        Tokens = @{
            subscriptionId    = $ValidateOrDeployParameters.SubscriptionId
            managementGroupId = $ValidateOrDeployParameters.ManagementGroupId
        }
    }

    #Add Other Parameter File Tokens (For Testing)
    if ($AdditionalTokens) {
        $ConvertTokensInputs.Tokens += $AdditionalTokens
    }

    # Tokens in settings.json
    $settingsFilePath = Join-Path (Get-Item $PSScriptRoot).Parent.Parent 'settings.json'
    if (Test-Path $settingsFilePath) {
        $Settings = Get-Content -Path $settingsFilePath -Raw | ConvertFrom-Json -AsHashtable
        $ConvertTokensInputs += @{
            TokenPrefix = $Settings.parameterFileTokens.tokenPrefix
            TokenSuffix = $Settings.parameterFileTokens.tokenSuffix
        }

        if ($Settings.parameterFileTokens.localTokens) {
            $tokenMap = @{}
            foreach ($token in $Settings.parameterFileTokens.localTokens) {
                $tokenMap += @{ $token.name = $token.value }
            }
            Write-Verbose ('Using local tokens [{0}]' -f ($tokenMap.Keys -join ', ')) -Verbose
            $ConvertTokensInputs.Tokens += $tokenMap
        }
    }

}
function Test-NamePrefixAvailability {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $namePrefix,

        [Parameter(Mandatory = $false)]
        [Psobject] $ValidateOrDeployParameters = @{},

        [Parameter(Mandatory = $false)]
        [hashtable] $AdditionalTokens = @{}
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper Scripts
        . (Join-Path $PSScriptRoot '../pipelines/tokensReplacement/Convert-TokensInFile.ps1')
    }
    process {

        $prefixAvailable = $true

        # Find Parameter Files
        # --------------------
        $relevantResourceTypes = @(
            'Microsoft.Storage/storageAccounts'
            'Microsoft.ContainerRegistry/registries'
            'Microsoft.KeyVault/vaults'
        )
        $root = (Get-Item $PSScriptRoot).Parent.Parent.FullName
        $parameterFiles = (Get-ChildItem -Path $root -Recurse -Filter '.json').FullName | ForEach-Object { $_.Replace('\', '/') }
        $parameterFiles = $parameterFiles | Where-Object { $_ -match '(?:{0}).*parameters\.json' -f ($relevantResourceTypes -join '|' -replace '/', '\/+') }

        if (Test-Path $dependencyParameterfilePath) {
            $parameterFiles += (Get-ChildItem -Path $dependencyParameterfilePath).FullName
        }

        # Replace parameter file tokens
        # -----------------------------


        # Extract Parameter Names
        # -----------------------

        $storageAccountNames = @(
      ('adp{0}azsafa001' -f $namePrefix),
      ('{0}azsax001' -f $namePrefix)
        )
        $keyVaultNames = @(
      ('adp-{0}-az-kv-x-001' -f $namePrefix),
      ('{0}-az-kvlt-x-001' -f $namePrefix)
        )
        $acrNames = @(
      ('adp{0}azacrx001' -f $namePrefix)
        )

        # $accessToken = Get-AzAccessToken

        $subscriptionId = (Get-AzContext).Subscription.Id

        # Storage
        Write-Host "`nCheck Storage Accounts" -ForegroundColor 'Cyan'
        Write-Host '======================' -ForegroundColor 'Cyan'
        foreach ($storageAccountName in $storageAccountNames) {
            $path = '/subscriptions/{0}/providers/Microsoft.Storage/checkNameAvailability?api-version=2021-04-01' -f $subscriptionId
            $requestInputObject = @{
                Method  = 'POST'
                Path    = $path
                Payload = @{
                    name = $storageAccountName
                    type = 'Microsoft.Storage/storageAccounts'
                } | ConvertTo-Json
            }
            $response = ((Invoke-AzRestMethod @requestInputObject).Content | ConvertFrom-Json)
            if ($response.nameAvailable) { Write-Host "=> The storage account name [$storageAccountName] is currently available" -ForegroundColor 'Green' }
            else {
                Write-Warning "=> Warning: The storage account name [$storageAccountName] is not available. Please try a different prefix."
                $prefixAvailable = $false
            }
        }

        # Key Vault
        Write-Host "`nChecking Key Vaults" -ForegroundColor 'Cyan'
        Write-Host '===================' -ForegroundColor 'Cyan'
        foreach ($keyVaultName in $keyVaultNames) {
            $path = '/subscriptions/{0}/providers/Microsoft.KeyVault/checkNameAvailability?api-version=2021-10-01' -f $subscriptionId
            $requestInputObject = @{
                Method  = 'POST'
                Path    = $path
                Payload = @{
                    name = $keyVaultName
                    type = 'Microsoft.KeyVault/vaults'
                } | ConvertTo-Json
            }
            $response = ((Invoke-AzRestMethod @requestInputObject).Content | ConvertFrom-Json)
            if ($response.nameAvailable) { Write-Host "=> The key vault name [$keyVaultName] is currently available" -ForegroundColor 'Green' }
            else {
                Write-Warning "=> Warning: The key vault name [$keyVaultName] is not available. Please try a different prefix."
                $prefixAvailable = $false
            }
        }

        # Azure Container Registry
        Write-Host "`nCheck Azure Container Registies" -ForegroundColor 'Cyan'
        Write-Host '==============================' -ForegroundColor 'Cyan'
        foreach ($acrName in $acrNames) {
            $path = '/subscriptions/{0}/providers/Microsoft.ContainerRegistry/checkNameAvailability?api-version=2019-05-01' -f $subscriptionId
            $requestInputObject = @{
                Method  = 'POST'
                Path    = $path
                Payload = @{
                    name = $acrName
                    type = 'Microsoft.ContainerRegistry/registries'
                } | ConvertTo-Json
            }
            $response = ((Invoke-AzRestMethod @requestInputObject).Content | ConvertFrom-Json)
            if ($response.nameAvailable) { Write-Host "=> The Azure container registry name [$acrName] is currently available" -ForegroundColor 'Green' }
            else {
                Write-Warning "=> Warning: The Azure container registry name [$acrName] is not available. Please try a different prefix."
                $prefixAvailable = $false
            }
        }

        Write-Host "`nRESULT" -ForegroundColor 'Cyan'
        Write-Host '======' -ForegroundColor 'Cyan'
        if (-not $prefixAvailable) {
            Write-Error "=> Prefix [$namePrefix] is not available for all resources. Please try a different one."
        } else {
            Write-Host "=> Prefix [$namePrefix] is available for all resources." -ForegroundColor 'Green'
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
