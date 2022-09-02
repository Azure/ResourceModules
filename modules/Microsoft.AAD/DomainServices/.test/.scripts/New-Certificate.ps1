param(
    [string] $KeyVaultName,
    [string] $ResourceGroupName,
    [string] $CertPWSecretName,
    [string] $CertSecretName
)

# Generate values
$password = ConvertTo-SecureString -String (New-Guid).Guid.SubString(0, 19) -AsPlainText -Force

$certInputObject = @{
    Subject           = 'CN=*.{0}.onmicrosoft.com' -f 'contoso'
    DnsName           = '*.{0}.onmicrosoft.com' -f 'contoso'
    CertStoreLocation = 'cert:\LocalMachine\My'
    KeyExportPolicy   = 'Exportable'
    Provider          = 'Microsoft Enhanced RSA and AES Cryptographic Provider'
    NotAfter          = (Get-Date).AddMonths(3)
    HashAlgorithm     = 'SHA256'
}
$rawCert = New-SelfSignedCertificate @certInputObject
Export-PfxCertificate -Cert ('Cert:\localmachine\my\' + $rawCert.Thumbprint) -FilePath "$home/aadds.pfx" -Password $password -Force
$rawCertByteStream = Get-Content "$home/aadds.pfx" -AsByteStream
$pfxCertificate = ConvertTo-SecureString -String ([System.Convert]::ToBase64String($rawCertByteStream)) -AsPlainText -Force

# Set values
@(
    @{ name = $CertPWSecretName; secretValue = $password }
    @{ name = $CertSecretName; secretValue = $pfxCertificate }
) | ForEach-Object {
    $null = Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $_.name -SecretValue $_.secretValue
    Write-Verbose ('Added secret [{0}] to key vault [{1}]' -f $_.name, $keyVaultName) -Verbose
}
