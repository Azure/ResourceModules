function Test-NamePrefixAvailability {

    param(
        [Parameter(Mandatory = $true)]
        [string] $namePrefix
    )

    if (-not (Get-AzContext)) {
        Write-Warning 'In order to execute this function you must be logged into Azure. Initiating...'
        Connect-AzAccount
    }

    $prefixAvailable = $true

    # Build names
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
Test-NamePrefixAvailability
