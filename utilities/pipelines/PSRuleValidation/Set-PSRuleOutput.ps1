function Set-PSRuleOutput {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [String] $inputFilePath,

        [Parameter(Mandatory = $false)]
        [string] $outputFilePath = './output.md',

        [Parameter(Mandatory = $false)]
        [switch] $skipPassedRulesReport
    )

    ###########################################
    # Import CSV output and filter by results #
    ###########################################

    $results = Import-Csv -Path $inputFilePath

    $passedRules = @()
    $failedRules = @()

    $passedRules += $results | Where-Object { $_.Outcome -EQ 'Pass' }
    $failedRules += $results | Where-Object { $_.Outcome -EQ 'Fail' }

    ######################
    # Set output content #
    ######################

    # Header //TBD: Remove?
    $header = [System.Collections.ArrayList]@(
        '# PSRule pre-flight validation summary ',
        ''
    )
    Out-File -FilePath $outputFilePath -NoClobber -InputObject $header

    if ($failedRules.Count -eq 0) {
        # No failure content
        $noFailuresContent = ('## :rocket: All {0} rules passed, YAY! :rocket:' -f $results.Count)
        Out-File -FilePath $outputFilePath -Append -NoClobber -InputObject $noFailuresContent
    } else {
        # Failure content

        ## Header table
        $headerTable = [System.Collections.ArrayList]@(
            '| Total No. of Processed Rules| Passed Rules :white_check_mark: | Failed Rules :x: |',
            '| :-- | :-- | :-- |'
            ('| {0} | {1} | {2} |' -f $results.Count, $passedRules.Count , $failedRules.Count),
            ''
        )
        Out-File -FilePath $outputFilePath -Append -NoClobber -InputObject $headerTable

        ## List of failed rules
        $failContent = [System.Collections.ArrayList]@(
            '',
            '<details>',
            '<summary>List of Failed Rules</summary>',
            '',
            '## Failed Rules',
            '',
            '| RuleName | TargetName |  Synopsis |',
            '| :-- | :-- | :-- |'
        )
        foreach ($content in $failedRules ) {
            # Shorten the target name for deployment resoure type
            if ($content.TargetType -eq 'Microsoft.Resources/deployments') {
                $content.TargetName = $content.TargetName.replace('/home/runner/work/ResourceModules/ResourceModules/modules/', '')
            }

            # Build hyperlinks to PSrule documentation for the rules
            $TemplatesBaseUrl = 'https://azure.github.io/PSRule.Rules.Azure/en/rules'
            try {
                $PSRuleReferenceUrl = '{0}/{1}' -f $TemplatesBaseUrl, $content.RuleName
                $null = Invoke-WebRequest -Uri $PSRuleReferenceUrl
                $resourceLink = '[' + $content.RuleName + '](' + $PSRuleReferenceUrl + ')'
            } catch {
                Write-Warning "Unable to build url for $content.RuleName"
                $resourceLink = $content.RuleName
            }
            $failContent += ('| {0} | {1} | {2} | ' -f $resourceLink, $content.TargetName, $content.Synopsis)
        }
        $failContent += [System.Collections.ArrayList]@(
            '',
            '</details>',
            ''
        )
        # Append to output
        Out-File -FilePath $outputFilePath -Append -NoClobber -InputObject $failContent
    }

    if (($passedRules.Count -gt 0) -and -not $skipPassedRulesReport) {
        # List of passed rules
        $passContent = [System.Collections.ArrayList]@(
            '',
            '<details>',
            '<summary>List of Passed Rules</summary>',
            '',
            '## Passed Rules',
            '',
            '| RuleName | TargetName |  Synopsis |',
            '| :-- | :-- |  :-- |'
        )
        foreach ($content in $passedRules ) {
            # Shorten the target name for deployment resoure type
            if ($content.TargetType -eq 'Microsoft.Resources/deployments') {
                $content.TargetName = $content.TargetName.replace('/home/runner/work/ResourceModules/ResourceModules/modules/', '')
            }

            # Build hyperlinks to PSrule documentation for the rules
            $TemplatesBaseUrl = 'https://azure.github.io/PSRule.Rules.Azure/en/rules'
            try {
                $PSRuleReferenceUrl = '{0}/{1}' -f $TemplatesBaseUrl, $content.RuleName
                $null = Invoke-WebRequest -Uri $PSRuleReferenceUrl
                $resourceLink = '[' + $content.RuleName + '](' + $PSRuleReferenceUrl + ')'
            } catch {
                Write-Warning "Unable to build url for $content.RuleName"
                $resourceLink = $content.RuleName
            }
            $passContent += ('| {0} | {1} | {2} |  ' -f $resourceLink, $content.TargetName, $content.Synopsis)

        }
        $passContent += [System.Collections.ArrayList]@(
            '',
            '</details>',
            ''
        )
        # Append to output
        Out-File -FilePath $outputFilePath -Append -NoClobber -InputObject $passContent
    }
}
