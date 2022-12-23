param(
    [string] $KeyVaultName,
    [string] $ResourceGroupName,
    [string] $CertPWSecretName,
    [string] $CertSecretName
)

$password = ConvertTo-SecureString -String "$ResourceGroupName/$KeyVaultName/$CertSecretName" -AsPlainText -Force

# Install open-ssl if not available
apt-get install openssl

# Generate certificate
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout './privateKey.key' -out './certificate.crt' -subj '/CN=*.contoso.onmicrosoft.com/O=contoso/C=US'

# Sign certificate
openssl pkcs12 -export -out 'aadds.pfx' -inkey './privateKey.key' -in './certificate.crt' -passout pass:$password

# Convert certificate to string
$rawCertByteStream = Get-Content './aadds.pfx' -AsByteStream
Write-Verbose 'Convert to secure string' -Verbose
$pfxCertificate = ConvertTo-SecureString -String ([System.Convert]::ToBase64String($rawCertByteStream)) -AsPlainText -Force

# Set values
@(
    @{ name = $CertPWSecretName; secretValue = $password }
    @{ name = $CertSecretName; secretValue = $pfxCertificate }
) | ForEach-Object {
    $null = Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $_.name -SecretValue $_.secretValue
    Write-Verbose ('Added secret [{0}] to key vault [{1}]' -f $_.name, $keyVaultName) -Verbose
}
