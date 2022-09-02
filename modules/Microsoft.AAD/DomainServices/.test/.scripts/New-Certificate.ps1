param(
    [string] $KeyVaultName,
    [string] $ResourceGroupName,
    [string] $CertPWSecretName,
    [string] $CertName
)

$password = ConvertTo-SecureString -String "$ResourceGroupName/$KeyVaultName/$CertName" -AsPlainText -Force

apt-get install openssl
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes

Get-ChildItem

Import-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -FilePath './key.pem' -Password $Password

# # Generate values

# $policyInputObject = @{
#     SecretContentType = 'application/x-pkcs12'
#     SubjectName       = 'CN=contoso.com'
#     IssuerName        = 'Self'
#     ValidityInMonths  = 3
#     ReuseKeyOnRenewal = $true
# }

# $Policy = New-AzKeyVaultCertificatePolicy @policyInputObject

# $null = Add-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -CertificatePolicy $Policy

# while (-not (Get-AzKeyVaultCertificateOperation -VaultName $KeyVaultName -Name $CertName).Status -eq 'completed') {
#     Write-Verbose 'Waiting 10 seconds for certificate creation' -Verbose
#     Start-Sleep 10
# }

# Write-Verbose 'Certificate created' -Verbose

# $cert = Get-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName

# Import-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -FilePath

# # $certInputObject = @{
# #     Subject           = 'CN=*.{0}.onmicrosoft.com' -f 'contoso'
# #     DnsName           = '*.{0}.onmicrosoft.com' -f 'contoso'
# #     CertStoreLocation = 'cert:\LocalMachine\My'
# #     KeyExportPolicy   = 'Exportable'
# #     Provider          = 'Microsoft Enhanced RSA and AES Cryptographic Provider'
# #     NotAfter          = (Get-Date).AddMonths(3)
# #     HashAlgorithm     = 'SHA256'
# # }
# # $rawCert = New-SelfSignedCertificate @certInputObject
# # Export-PfxCertificate -Cert ('Cert:\localmachine\my\' + $rawCert.Thumbprint) -FilePath "$home/aadds.pfx" -Password $password -Force
# # $rawCertByteStream = Get-Content "$home/aadds.pfx" -AsByteStream
# # $pfxCertificate = ConvertTo-SecureString -String ([System.Convert]::ToBase64String($rawCertByteStream)) -AsPlainText -Force

# # # Set values
# # @(
# #     @{ name = $CertPWSecretName; secretValue = $password }
# #     @{ name = $CertSecretName; secretValue = $pfxCertificate }
# # ) | ForEach-Object {
# #     $null = Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $_.name -SecretValue $_.secretValue
# #     Write-Verbose ('Added secret [{0}] to key vault [{1}]' -f $_.name, $keyVaultName) -Verbose
# # }
