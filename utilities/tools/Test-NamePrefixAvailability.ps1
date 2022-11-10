<#
.SYNOPSIS
Test if a given name prefix token placeholder is already taken

.DESCRIPTION
Test if a given name prefix token placeholder is already taken. Tests resource names by their actual value in the parameter files

.PARAMETER namePrefix
Parameter description

.PARAMETER serviceShort
A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.

.PARAMETER Tokens
Optional. A hashtable parameter that contains tokens to be replaced in the paramter files

.EXAMPLE
$inputObject = @{
    NamePrefix = 'carml'
    ServiceShort = ''
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

        [Parameter(Mandatory = $true)]
        [string] $serviceShort,

        [Parameter(Mandatory = $false)]
        [Psobject] $Tokens = @{}
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper Scripts
        $repoRoot = (Get-Item $PSScriptRoot).Parent.Parent.FullName
        . (Join-Path $repoRoot 'utilities' 'pipelines' 'tokensReplacement' 'Convert-TokensInFileList.ps1')
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

        $storageAccountNames = @()
        $containerRegistryNames = @()
        $keyVaultNames = @()


        foreach ($relevantResourceType in $relevantResourceTypes) {
            switch ($relevantResourceType) {
                'Microsoft.Storage/storageAccounts' {
                    $filter = 'storageAccountName:'
                }
                'Microsoft.ContainerRegistry/registries' {
                    $filter = 'registryName:'
                }
                'Microsoft.KeyVault/vaults' {
                    $filter = 'keyVaultName:'
                }
                Default { Write-Error 'I dont like you.' }
            }

            $parameterFiles = (Get-ChildItem -Path $repoRoot -Recurse -Filter 'deploy.test.bicep').FullName | ForEach-Object { $_.Replace('\', '/') }
            foreach ($parameterFile in $parameterFiles) {
                $temp = $null

                # determine if entry is of one of the resourceTypes using the filter variable
                $temp = Get-Content -Path $parameterFile | ForEach-Object {
                    if ($_ -match "$filter\s'") { $_ }
                }
                if ($temp) {
                    $temp = $temp.Split($filter)
                    $temp = $temp | Where-Object { $_ -match '\S' } # replace empty lines in array

                    # trim the entry and replace placeholder values
                    $temp = $temp.Replace("'", '') # remove trailing quotes
                    $temp = $temp.Replace('<<namePrefix>>', $namePrefix)
                    $temp = $temp.Replace('${serviceShort}', $serviceShort)
                    $temp = $temp.Replace(' ', '') # remove trailing whitespaces

                    # drop entries which generate its name during runtime (e.g. via uniqueString function in bicep)
                    if ($temp -match 'uniqueString') {
                        continue
                    }

                    # add entry to resourcetype-specific list
                    switch ($filter) {
                        'storageAccountName:' { $storageAccountNames += $temp }
                        'registryName:' { $containerRegistryNames += $temp }
                        'keyVaultName:' { $keyVaultNames += $temp }
                        Default {}
                    }
                }
            }
        }

        $storageAccountNames = $storageAccountNames | Select-Object -Unique
        $containerRegistryNames = $containerRegistryNames | Select-Object -Unique
        $keyVaultNames = $keyVaultNames | Select-Object -Unique

        try {

            # Extract Parameter Names
            # -----------------------
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
