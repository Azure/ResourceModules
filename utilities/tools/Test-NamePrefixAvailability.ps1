<#
.SYNOPSIS
Test if a given name prefix token placeholder is already taken

.DESCRIPTION
Test if a given name prefix token placeholder is already taken. Tests resource names by their actual value in the parameter files

.PARAMETER namePrefix
Parameter description

.PARAMETER Tokens
Optional. A hashtable parameter that contains tokens to be replaced in the paramter files

.EXAMPLE
$inputObject = @{
    NamePrefix = 'carml'
    Tokens     = @{
        Location          = 'westeurope'
        ResourceGroupName = 'validation-rg'
        SubscriptionId    = '00000000-0000-0000-0000-000000000000'
        ManagementGroupId = '00000000-0000-0000-0000-000000000000'
        RemoveDeployment  = $false
        deploymentSpId    = '00000000-0000-0000-0000-000000000000'
    }
}
Test-NamePrefixAvailability @inputObject

Test if namePrefix 'carml' is available.
#>
function Test-NamePrefixAvailability {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $namePrefix,

        [Parameter(Mandatory = $false)]
        [Psobject] $Tokens = @{}
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper Scripts
        . (Join-Path $PSScriptRoot '../pipelines/tokensReplacement/Convert-TokensInFileList.ps1')
        $root = (Get-Item $PSScriptRoot).Parent.Parent.FullName
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
        $parameterFiles = (Get-ChildItem -Path $root -Recurse -Filter '*.json').FullName | ForEach-Object { $_.Replace('\', '/') }
        $parameterFiles = $parameterFiles | Where-Object { $_ -match '(?:{0}).*parameters\.json' -f ($relevantResourceTypes -join '|' -replace '/', '\/+') }

        # Replace parameter file tokens
        # -----------------------------

        # Tokens in settings.yml
        $GlobalVariablesObject = Get-Content -Path (Join-Path $PSScriptRoot '..\..\settings.yml') | ConvertFrom-Yaml -ErrorAction Stop | Select-Object -ExpandProperty variables

        # Construct Token Configuration Input
        $tokenConfiguration = @{
            FilePathList = $parameterFiles
            Tokens       = @{}
            TokenPrefix  = $GlobalVariablesObject | Select-Object -ExpandProperty tokenPrefix
            TokenSuffix  = $GlobalVariablesObject | Select-Object -ExpandProperty tokenSuffix
        }

        # Add local (source control) tokens
        foreach ($localToken in ($GlobalVariablesObject.Keys | ForEach-Object { if ($PSItem.contains('localToken_')) { $PSItem } })) {
            $tokenConfiguration.Tokens[$localToken.Replace('localToken_', '', 'OrdinalIgnoreCase')] = $GlobalVariablesObject.$localToken
        }

        try {
            # Invoke Token Replacement Functionality and Convert Tokens in Parameter Files
            $null = Convert-TokensInFileList @tokenConfiguration


            # Extract Parameter Names
            # -----------------------
            $storageAccountFiles = $parameterFiles | Where-Object { $_ -match 'Microsoft.Storage/storageAccounts' }
            $storageAccountNames = $storageAccountFiles | ForEach-Object { (ConvertFrom-Json (Get-Content $_ -Raw)).parameters.name.value } | Where-Object { $null -ne $_ }

            $keyVaultFiles = $parameterFiles | Where-Object { $_ -match 'Microsoft.KeyVault/vaults' }
            $keyVaultNames = $keyVaultFiles | ForEach-Object { (ConvertFrom-Json (Get-Content $_ -Raw)).parameters.name.value } | Where-Object { $null -ne $_ }

            $acrFiles = $parameterFiles | Where-Object { $_ -match 'Microsoft.ContainerRegistry/registries' }
            $acrNames = $acrFiles | ForEach-Object { (ConvertFrom-Json (Get-Content $_ -Raw)).parameters.name.value } | Where-Object { $null -ne $_ }

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
        } catch {
            Write-Error $_
        } finally {
            # Restore parameter files
            # -----------------------
            Write-Verbose 'Restoring Tokens'
            $null = Convert-TokensInFileList @tokenConfiguration -SwapValueWithName $true
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
