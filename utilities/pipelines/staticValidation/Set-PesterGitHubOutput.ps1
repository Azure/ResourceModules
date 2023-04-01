<#
.SYNOPSIS
Parse an Pester output containing checks & results and generate formatted markdown file out of it.

.DESCRIPTION
Parse an Pester output containing checks & results and generate formatted markdown file out of it.

.PARAMETER PesterTestResults
Mandatory. The Pester tests results to parse. Can be fetched by running Pester with the `-PassThru` parameter. For example:

@{
    Containers            = '[+] C:/ResourceModules/utilities/pipelines/staticValidation/module.tests.ps1'
    Result                = 'Passed'
    FailedCount           = 0
    FailedBlocksCount     = 0
    FailedContainersCount = 0
    PassedCount           = 36
    SkippedCount          = 1
    NotRunCount           = 0
    TotalCount            = 37
    Duration              = '00:00:41.8816077'
    Executed              = true
    ExecutedAt            = '2023-04-01T12:27:19.5807422+02:00'
    Version               = '5.4.0'
    PSVersion             = '7.3.3'
    PSBoundParameters     = 'System.Management.Automation.PSBoundParametersDictionary'
    Plugins               = null
    PluginConfiguration   = null
    PluginData            = null
    Configuration         = 'PesterConfiguration'
    DiscoveryDuration     = '00:00:16.1489218'
    UserDuration          = '00:00:22.4714890'
    FrameworkDuration     = '00:00:03.2611969'
    Failed                = ''
    FailedBlocks          = ''
    FailedContainers      = ''
    Passed                = '[+] [Microsoft.KeyVault/vaults/secrets] Module should contain a [deploy.json/deploy.bicep] file. [+] ...'
    NotRun                = ''
    Tests                 = '[+] [Microsoft.KeyVault/vaults/secrets] Module should contain a [deploy.json/deploy.bicep] file. [+] ...'
    CodeCoverage          = null
}

.PARAMETER OutputFilePath
Optional. The path to the formatted .md file to be created.

.PARAMETER SipPassedTestsReport
Optional. Whether to add the detail of passed tests to the output markdown file or to limit the list to the failed & skipped ones.

.EXAMPLE
Set-PesterGitHubOutput -PesterTestResults @{...}

Generate a markdown file 'output.md' in the current folder, out of the Pester test results input, listing all passed and failed tests.

.EXAMPLE
Set-PesterGitHubOutput -PesterTestResults @{...} -OutputFilePath 'C:/Pester-output.md' -SkipPassedTestsReport

Generate a markdown file 'C:/Pester-output.md', out of the Pester test results input, listing only the failed & skipped tests.
#>
function Set-PesterGitHubOutput {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject] $PesterTestResults,

        [Parameter(Mandatory = $false)]
        [string] $OutputFilePath = './output.md',

        [Parameter(Mandatory = $false)]
        [switch] $SkipPassedTestsReport
    )

    $passedTests = $PesterTestResults.Passed
    $failedTests = $PesterTestResults.Failed
    $skippedTests = $PesterTestResults.Skipped

    ######################
    # Set output content #
    ######################

    # Header
    $fileContent = [System.Collections.ArrayList]@(
        '# Pester validation summary ',
        ''
    )

    if ($failedTests.Count -eq 0) {
        # No failure content
        $fileContent += ('## :rocket: All [{0}] tests passed, YAY! :rocket:' -f $passedTests.Count)
    } else {
        # Failure content

        ## Header table
        $fileContent += [System.Collections.ArrayList]@(
            '| Total No. of Processed Tests| Passed Tests :white_check_mark: | Failed Tests :x: | Skipped Tests :paperclip: |',
            '| :-- | :-- | :-- | :-- |'
            ('| {0} | {1} | {2} | {3} |' -f $PesterTestResults.TotalCount, $passedTests.count , $failedTests.count, $skippedTests.count),
            ''
        )

        ######################
        ##   Failed Tests   ##
        ######################
        if ($failedTests.Count -gt 0) {
            Write-Verbose 'Adding failed tests'
            $fileContent += [System.Collections.ArrayList]@(
                '',
                '<details>',
                '<summary>List of failed Tests</summary>',
                '',
                '## Failed Tests',
                '',
                '| Name | Error | Source |',
                '| :-- | :-- | :-- |'
            )
            foreach ($failedTest in ($failedTests | Sort-Object -Property { $PSItem.ExpandedName })) {

                $intermediateNameElements = $failedTest.Path
                $intermediateNameElements[-1] = '**{0}**' -f $failedTest.ExpandedName
                $testName = (($intermediateNameElements -join ' / ' | Out-String) -replace '\|', '\|').Trim()

                $errorTestLine = $failedTest.ErrorRecord.TargetObject.Line
                $errorTestFile = (Split-Path $failedTest.ErrorRecord.TargetObject.File -Leaf).Trim()
                $errorMessage = $failedTest.ErrorRecord.TargetObject.Message.Trim()


                $fileContent += '| {0} | {1} | `{2}:{3}` |' -f $testName, $errorMessage, $errorTestFile, $errorTestLine
            }
            $fileContent += [System.Collections.ArrayList]@(
                '',
                '</details>',
                ''
            )
        }

        ######################
        ##   Passed Tests   ##
        ######################
        if (($passedTests.Count -gt 0) -and -not $SkipPassedTestsReport) {
            Write-Verbose 'Adding passed tests'

            $fileContent += [System.Collections.ArrayList]@(
                '',
                '<details>',
                '<summary>List of passed Tests</summary>',
                '',
                '## Passed Tests',
                '',
                '| Name | Source |',
                '| :-- | :-- |'
            )
            foreach ($passedTest in ($passedTests | Sort-Object -Property { $PSItem.ExpandedName }) ) {

                $intermediateNameElements = $passedTest.Path
                $intermediateNameElements[-1] = '**{0}**' -f $passedTest.ExpandedName
                $testName = (($intermediateNameElements -join ' / ' | Out-String) -replace '\|', '\|').Trim()

                $testLine = $passedTest.ScriptBlock.StartPosition.StartLine
                $testFile = (Split-Path $passedTest.ScriptBlock.File -Leaf).Trim()

                $fileContent += '| {0} | `{1}:{2}` |' -f $testName, $testFile, $testLine
            }
            $fileContent += [System.Collections.ArrayList]@(
                '',
                '</details>',
                ''
            )
        }

        #######################
        ##   Skipped Tests   ##
        #######################
        if ($skippedTests.Count -gt 0) {
            Write-Verbose 'Adding skipped tests'

            $fileContent += [System.Collections.ArrayList]@(
                '',
                '<details>',
                '<summary>List of skipped Tests</summary>',
                '',
                '## Skipped Tests',
                '',
                '| Name | Reason | Source |',
                '| :-- | :-- | :-- |'
            )
            foreach ($skippedTest in ($skippedTests | Sort-Object -Property { $PSItem.ExpandedName }) ) {

                $intermediateNameElements = $skippedTest.Path
                $intermediateNameElements[-1] = '**{0}**' -f $skippedTest.ExpandedName
                $testName = (($intermediateNameElements -join ' / ' | Out-String) -replace '\|', '\|').Trim()

                $reason = ('Test {0}' -f $skippedTest.ErrorRecord.Exception.Message -replace '\|', '\|').Trim()

                $testLine = $passedTest.ScriptBlock.StartPosition.StartLine
                $testFile = (Split-Path $passedTest.ScriptBlock.File -Leaf).Trim()

                $fileContent += '| {0} | {1} | `{2}:{3}` |' -f $testName, $reason, $testFile, $testLine
            }
            $fileContent += [System.Collections.ArrayList]@(
                '',
                '</details>',
                ''
            )
        }

        if ($PSCmdlet.ShouldProcess("Test results file in path [$OutputFilePath]", 'Create')) {
            $null = New-Item -Path $OutputFilePath -Force -Value ($fileContent | Out-String)
        }
        Write-Verbose "Create results file [$outputFilePath]"
    }
}
