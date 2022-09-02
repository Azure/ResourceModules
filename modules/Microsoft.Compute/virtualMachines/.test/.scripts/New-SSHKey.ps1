param(
    [string] $SSHKeyName,
    [string] $ResourceGroupName
)

if (-not ($sshKey = Get-AzSshKey -ResourceGroupName $ResourceGroupName | Where-Object { $_.Name -eq $SSHKeyName })) {
    Write-Verbose "No SSH key [$SSHKeyName] found in Resource Group [$ResourceGroupName]. Generating new." -Verbose
    $null = ssh-keygen -f generated -N (Get-Random -Maximum 99999)
    $publicKey = Get-Content 'generated.pub'
    # $privateKey = cat generated | Out-String
} else {
    Write-Verbose "SSH key [$SSHKeyName] found in Resource Group [$ResourceGroupName]. Returning." -Verbose
    $publicKey = $sshKey.publicKey
}

# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    publicKey = $publicKey
}
