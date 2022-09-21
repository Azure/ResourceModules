# [CmdletBinding(SupportsShouldProcess)]
# param (
#     # [Parameter(Mandatory)]
#     # [hashtable] $TemplateFileContent,

#     # [Parameter(Mandatory)]
#     # [object[]] $ReadMeFileContent,

#     # [Parameter(Mandatory = $false)]
#     # [string] $SectionStartIdentifier = '## Resource Types',

#     # [Parameter(Mandatory = $false)]
#     # [string[]] $ResourceTypesToExclude = @('Microsoft.Resources/deployments')
# )

$SectionContent = [System.Collections.ArrayList]@(
    '| RuleName | TargetName | Outcome | OutcomeReason |  Synopsis |Recommendation|',
    '| :-- | :-- | :-- | :-- | :-- | :-- |'
)

$header = 'RuleName', 'TargetName', 'TargetType', 'Outcome', 'OutcomeReason', 'Synopsis', 'Recommendation'

$results = Import-Csv -Path .\output.csv
#-Header $header
$header = $results[0]

#$results | Format-Table
$fail = 0
$pass = 0

foreach ($content in $results) {
    $SectionContent += ('| {0} | {1} | {2} | {3} | {4} | {5} |' -f $content.RuleName, $content.TargetName, $content.Outcome, $content.OutcomeReason , $content.Synopsis, $content.Recommendation)
    # end region
}

#$SectionContent
$pass = $results | Where-Object { $_.Outcome -EQ 'Pass' }
$fail = $results | Where-Object { $_.Outcome -eq 'Fail' }

$passContent = [System.Collections.ArrayList]@(
    '# Passing Rules',
    '',
    '| RuleName | TargetName | Outcome  | OutcomeReason |  Synopsis |Recommendation|',
    '| :-- | :-- | :-- | :-- | :-- | :-- |'
)

foreach ($content in $pass ) {
    $passContent += ('| {0} | {1} | :white_check_mark: | {3} | {4} | {5} |' -f $content.RuleName, $content.TargetName, $content.Outcome, $content.OutcomeReason , $content.Synopsis, $content.Recommendation)
    # end region
}

$passContent += [System.Collections.ArrayList]@(
    '')

$failContent = [System.Collections.ArrayList]@(
    '# Failing Rules',
    '',
    '| RuleName | TargetName | Outcome | OutcomeReason |  Synopsis |Recommendation|',
    '| :-- | :-- | :-- | :-- | :-- | :-- |'
)

foreach ($content in $fail ) {
    $failContent += ('| {0} | {1} | :x: | {3} | {4} | {5} |' -f $content.RuleName, $content.TargetName, $content.Outcome, $content.OutcomeReason , $content.Synopsis, $content.Recommendation)
    # end region
}


$fail.Count
$pass.Count

#Out-File -FilePath './output.md' -Append -NoClobber -InputObject $SectionContent
Out-File -FilePath './output.md' -Append -NoClobber -InputObject $passContent



Out-File -FilePath './output.md' -Append -NoClobber -InputObject $failContent
