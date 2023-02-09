param(
    [string]$resourceGroupName,
    [string]$keyName
)
$publicKey = (New-AzSshKey -ResourceGroupName $resourceGroupName -Name $keyName -WarningAction SilentlyContinue).publicKey
Remove-AzSshKey -ResourceGroupName $resourceGroupName -Name $keyName
Write-Output $publicKey
$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['pubKey'] = $publicKey
