param(
    [string] $StorageAccountName,
    [string] $ResourceGroupName,
    [string] $ContainerName,
    [string] $FileName
)

Write-Verbose "Create file [$FileName]" -Verbose
$file = New-Item -Value "Write-Host 'I am content'" -Path $FileName -Force

Write-Verbose "Getting storage account [$StorageAccountName|$ResourceGroupName] context." -Verbose
$storageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -StorageAccountName $StorageAccountName -ErrorAction 'Stop'

Write-Verbose 'Uploading file [$fileName]' -Verbose
Set-AzStorageBlobContent -File $file.FullName -Container $ContainerName -Context $storageAccount.Context -Force -ErrorAction 'Stop' | Out-Null
