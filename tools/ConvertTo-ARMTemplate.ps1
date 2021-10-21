[CmdletBinding(SupportsShouldProcess)]
param (
    [string] $Path,
    [switch] $CleanUp
)

$Path = 'C:\Repos\Azure\ResourceModules\tools'

#Start-Transcript -Path "./ConvertTo-ARMJson-Log.txt"
#Only remove if there is a deploy.bicep file to convert
Get-ChildItem -Filter deploy.json -Recurse | ForEach-Object {
    if (Test-Path -Path "$($_.Directory.FullName)/deploy.bicep") {
        Remove-Item -Path $_ -Force
    }
}

$CleanUp = $true

$Files = Get-ChildItem -Filter 'deploy.bicep' -Recurse
$Files | ForEach-Object -ThrottleLimit 25 -Parallel {
    Write-Verbose "Processing: '$($_.FullName)'"
    $outFile = Join-Path $_.Directory.FullName 'deploy.json'
    az bicep build --file $($_.FullName) --outfile $outFile
    Write-Verbose "Converted to: '$outFile'"
    if ($CleanUp) {
        $bicepFolder = Join-Path $_.Directory.FullName '.bicep'
        Remove-Item -Path $_.FullName -Force -Verbose
        Remove-Item -Path $bicepFolder -Force -Recurse -Verbose
    }
}


#Stop-Transcript
#
#$LogContent = Get-Content -Path "./ConvertTo-ARMJson-Log.txt"
#
#foreach ($line in $LogContent) {
#
#}
#
#
#$KnownWarnings = @(
#    "Warning BCP174: Type validation is not available for resource types declared containing a '/providers/' segment."
#    "Warning BCP037: The property '*' is not allowed on objects of type '*'. Permissible properties include *."
#    "Warning BCP187: The property '*' does not exist in the resource definition, although it might still be valid."
#    "Warning BCP036: The property '*' expected a value of type '*' but the provided value is of type '*'."
#    "Warning secure-parameter-default: Secure parameters should not have hardcoded defaults (except for empty or newGuid())."
#)
#
#$Issues = @(
#    "Warning BCP073: The property '*' is read-only. Expressions cannot be assigned to read-only properties."
#    "Warning no-unused-params: Parameter '*' is declared but never used."
#    "Warning no-unused-vars: Variable '*' is declared but never used."
#    "Warning BCP035: The specified '*' declaration is missing the following required properties: '*'."
#    "Warning BCP081: Resource type '*' does not have types available."
#)
