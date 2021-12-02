<#
.SYNOPSIS
Upload a set of source locations to a Storage Accounts blob containers.

.DESCRIPTION
This cmdlet uploads files specifiied in the contentDirectories parameter to the blob specified in the targetContainer parameter to the specified Azure Storage Account.

.PARAMETER ResourceGroupName
Mandatory. Name of the resource group that contains the Storage account to update.

.PARAMETER StorageAccountName
Mandatory. Name of the Storage account to update.

.PARAMETER contentDirectories
Mandatory. The paths to the content to upload

.PARAMETER targetContainer
Optional. The container to push the content  to

.PARAMETER Confirm
Will promt user to confirm the action to create invasible commands

.PARAMETER WhatIf
Dry run of the script
#>
function Export-ContentToBlob {

    [CmdletBinding(SupportsShouldProcess = $True)]
    param(
        [Parameter(
            Mandatory,
            HelpMessage = 'Specifies the name of the resource group that contains the Storage account to update.'
        )]
        [string] $ResourceGroupName,

        [Parameter(
            Mandatory,
            HelpMessage = 'Specifies the name of the Storage account to update.'
        )]
        [string] $StorageAccountName,

        [Parameter(
            Mandatory,
            HelpMessage = 'The paths to the content to upload.'
        )]
        [string[]] $contentDirectories,

        [Parameter(
            Mandatory,
            HelpMessage = 'The name of the container to upload to.'
        )]
        [string] $targetContainer
    )

    Write-Verbose 'Getting storage account context.' -Verbose
    $storageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -StorageAccountName $StorageAccountName -ErrorAction Stop
    $ctx = $storageAccount.Context

    foreach ($contentDirectory in $contentDirectories) {

        try {
            Write-Verbose "Processing content in path: [$contentDirectory]" -Verbose

            Write-Verbose 'Testing local path'
            If (-Not (Test-Path -Path $contentDirectory)) {
                throw "Testing local paths FAILED: Cannot find content path to upload [$contentDirectory]"
            }
            Write-Verbose 'Getting files to be uploaded...' -Verbose
            $filesToUpload = Get-ChildItem -Path $contentDirectory -ErrorAction 'Stop'
            Write-Verbose 'Files to be uploaded:' -Verbose
            Write-Verbose ($scriptsToUpload.Name | Format-List | Out-String) -Verbose

            Write-Verbose 'Testing blob container' -Verbose
            Get-AzStorageContainer -Name $targetContainer -Context $ctx -ErrorAction 'Stop' | Out-Null
            Write-Verbose 'Testing blob container SUCCEEDED' -Verbose

            foreach ($file in $filesToUpload) {
                if ($PSCmdlet.ShouldProcess("Files to the '$targetContainer' container", 'Upload')) {
                    Write-Verbose "Uploading file $file to container $targetContainer" -Verbose
                    Set-AzStorageBlobContent -File $file -Container $targetContainer -Context $ctx -Force -ErrorAction 'Stop' -Verbose:$false | Out-Null
                }
            }
            Write-Verbose ('[{0}] files in directory [{1}] uploaded to container [{2}]' -f $filesToUpload.Count, $contentDirectory, $targetContainer) -Verbose
        } catch {
            Write-Error "Upload FAILED: $_"
        }
    }
}
