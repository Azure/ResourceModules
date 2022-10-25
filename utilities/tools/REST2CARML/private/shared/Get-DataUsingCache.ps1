<#
.SYNOPSIS
Execute the given script block and store its output in a cached value, unless it is already in the cache. Then return its value.

.DESCRIPTION
Execute the given script block and store its output in a cached value, unless it is already in the cache. Then return its value.

.PARAMETER Key
Mandatory. The identifier for the cache. Will receive a suffix '_cached'.

.PARAMETER ScriptBlock
Mandatory. The script block to execute and store the return value of, if no value is found in the cache.

.EXAMPLE
Get-DataUsingCache -Key 'customCacheTest' -ScriptBlock { (Get-AzResourceGroup).ResourceGroupName }

Get a value with the name 'customCacheTest' from the cache, unless its not existing. In that case, the script block is executed, a new cache value with identifier 'customCacheTest_cached' with its value is created and the result returned.
#>
function Get-DataUsingCache {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Key,

        [Parameter(Mandatory = $true)]
        [ScriptBlock] $ScriptBlock
    )

    if ($cache = Get-Variable -Name ('{0}_cached' -f $key) -Scope 'Global' -ErrorAction 'SilentlyContinue') {
        return $cache.Value
    } else {
        $newValue = & $ScriptBlock
        Set-Variable -Name ('{0}_cached' -f $key) -Scope 'Global' -Value $newValue
        return $newValue
    }
}
