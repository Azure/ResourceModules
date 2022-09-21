<#
.SYNOPSIS
Get hash of the ARM deployment JSON template using only 'resources' tag

.DESCRIPTION
Get hash of the ARM deployment JSON template using only 'resources' tag

.PARAMETER TemplatePath
Required. Path to the ARM JSON template

.EXAMPLE
Get-TemplateHash -TemplatePath .\deploy.json

#>

function Get-TemplateHash {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $TemplatePath
    )

    try {
        $templateContent = Get-Content $TemplatePath -Raw | ConvertFrom-Json -Depth 100
        # if no resouces tag, quit
        if ($templateContent.resources.Count -eq 0) {
            return ''
        }

        # remove all except resouces tag
        foreach ($property in $templateContent.PSObject.Properties) {
            if ($property.Name.ToLower() -ne 'resources') {
                $templateContent.PSObject.Properties.Remove($property.Name)
            }
        }
        # rrder resources properties alphabetically
        $templateContent.resources = $templateContent.resources | Select-Object ($templateContent.resources | Get-Member -MemberType NoteProperty).Name

        # create temp file and esport
        $tmpPath = Join-Path $PSScriptRoot ('HASH-{0}.json' -f (New-Guid))
        $templateContent | ConvertTo-Json -Depth 100 | Out-File $tmpPath

        # create hash
        $azHash = (Get-FileHash -Path $tmpPath -Algorithm SHA256).Hash

        return $azHash
    } catch {
        throw $_
    } finally {
        # Remove temp files
        if ((-not [String]::IsNullOrEmpty($tmpPath)) -and (Test-Path $tmpPath)) {
            Remove-Item -Path $tmpPath -Force
        }
    }
}

<#
.SYNOPSIS
Create a new table in the Storage Account provided

.DESCRIPTION
Create a new table in the Storage Account provided

.PARAMETER StorageAccountName
Required. Storage account name

.PARAMETER ResourceGroup
Required. Resource group name

.PARAMETER TableName
Required. Table name


.EXAMPLE
New-StorageAccountTable -StorageAccountName 'stgstore01' -ResourceGroup 'data-rg' -TableName 'data'

#>

function New-StorageAccountTable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $StorageAccountName,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroup,

        [Parameter(Mandatory = $false)]
        [string] $TableName
    )

    try {
        # get storage Account and context
        $storageAccount = Get-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroup
        $ctx = $storageAccount.Context

        # create the table
        New-AzStorageTable -Name $TableName -Context $ctx | Out-Null
        $table = (Get-AzStorageTable -Name $TableName -Context $ctx).CloudTable

        Write-Output "Table created successfully"

        return $table
    } catch {
        # get storage Account and context
        $storageAccount = Get-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroup
        $ctx = $storageAccount.Context
        $table = (Get-AzStorageTable -Name $TableName -Context $ctx).CloudTable
        return $table

        Write-Output "Table already exists"
    }
}

<#
.SYNOPSIS
Adds a new row to the Storage Account table

.DESCRIPTION
Adds a new row to the Storage Account table

.PARAMETER Table
Required. Stoage Account Table object

.PARAMETER PartitionKey
Required. PartitionKey of the row to be added, usualy deployment Id

.PARAMETER DeploymentName
Required. Name of the deployment

.PARAMETER Hash
Required. Hash value

.EXAMPLE
New-StorageAccountTableRow -Table $table -PartitionKey '/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Resources/deployments/main-bcb4-0fd963ffbd82-z4h2pdgyedqg6/operations/08585380170111792859' -DeploymentName 'main-bcb4-0fd963ffbd82-z4h2pdgyedqg6' -Hash 'B448693A6E15F3E3512E6C6A4C72E34856B28412227184280997579DD3A767CE'

#>

function New-StorageAccountTableRow {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $Table,

        [Parameter(Mandatory = $false)]
        [string] $PartitionKey,

        [Parameter(Mandatory = $false)]
        [string] $DeploymentName,

        [Parameter(Mandatory = $false)]
        [string] $Hash
    )

    try {
        $extractionDate = Get-Date -Format 'yyyy-mm-dd hh:mm:ss'
        Add-AzTableRow -table $Table -partitionKey $PartitionKey -rowKey $DeploymentName -property @{'Hash' = $Hash; 'Time' = $extractionDate } -UpdateExisting | Out-Null
    } catch {
        throw $_
    }
}

Export-ModuleMember -Function 'Get-TemplateHash'
Export-ModuleMember -Function 'New-StorageAccountTable'
Export-ModuleMember -Function 'New-StorageAccountTableRow'
