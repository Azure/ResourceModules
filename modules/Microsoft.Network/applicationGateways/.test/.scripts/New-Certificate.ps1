param(
    [string] $KeyVaultName,
    [string] $CertName
)

if (-not ($certificate = Get-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -ErrorAction 'Stop')) {
    $policyInputObject = @{
        SecretContentType = 'application/x-pkcs12'
        SubjectName       = 'CN=fabrikam.com'
        IssuerName        = 'Self'
        ValidityInMonths  = 12
        ReuseKeyOnRenewal = $true
    }
    $certPolicy = New-AzKeyVaultCertificatePolicy @policyInputObject

    $null = Add-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -CertificatePolicy $certPolicy
    Write-Verbose ('Initated creation of certificate [{0}] in key vault [{1}]' -f $CertName, $KeyVaultName) -Verbose

    while (-not (Get-AzKeyVaultCertificateOperation -VaultName $KeyVaultName -Name $CertName).Status -eq 'completed') {
        Write-Verbose 'Waiting 10 seconds for certificate creation' -Verbose
        Start-Sleep 10
    }

    Write-Verbose 'Certificate created' -Verbose

    $certificate = Get-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -ErrorAction 'Stop'
}

# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    secretUrl = $certificate.SecretId
}
