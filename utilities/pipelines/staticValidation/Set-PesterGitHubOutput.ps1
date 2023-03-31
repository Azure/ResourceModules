<#
.SYNOPSIS
Parse an input xml file containing the output of the Pester checks and generate formatted markdown file out of it.

.DESCRIPTION
Parse input xml file containing the output of the Pester checks and generate formatted markdown file out of it.

.PARAMETER inputFilePath
Mandatory. The path to the output file created by Pester in xml format.

.PARAMETER outputFilePath
Optional. The path to the formatted .md file to be created.

.PARAMETER skipPassedTestsReport
Optional. Whether to add the detail of passed Pester to the output markdown file or to limit the list to the failed ones.

.EXAMPLE
Set-PesterGitHubOutput -inputFilePath 'C:/testResults.xml'

Generate a markdown file 'output.md' in the current folder, out of the 'C:/testResults.xml' input, listing all passed and failed tests.

.EXAMPLE
Set-PesterGitHubOutput -inputFilePath 'C:/testResults.xml' -outputFilePath 'C:/Pester-output.md' -SkipPassedTestsReport

Generate a markdown file 'C:/Pester-output.md', out of the 'C:/testResults.xml' input, listing only the failed tests.
#>
function Set-PesterGitHubOutput {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject] $PesterTestResults,

        [Parameter(Mandatory = $false)]
        [string] $OutputFilePath = './output.md',

        [Parameter(Mandatory = $false)]
        [switch] $SkipPassedTestsReport
    )

    ###########################################
    # Import xml output and filter by results #
    ###########################################

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
        $fileContent += [System.Collections.ArrayList]@(
            '',
            '<details>',
            '<summary>List of Failed Tests</summary>',
            '',
            '## Failed Tests',
            '',
            '| Name | Error | Source |',
            '| :-- | :-- | :-- |'
        )
        foreach ($failedTest in $failedTests ) {

            $intermediateNameElements = $failedTest.Path
            $intermediateNameElements[-1] = '***{0}***' -f $failedTest.ExpandedName
            $testName = $intermediateNameElements -join '</p>' | Out-String

            $errorTestLine = $failedTest.ErrorRecord.TargetObject.Line
            $errorTestFile = Split-Path $failedTest.ErrorRecord.TargetObject.File -Leaf
            $errorMessage = $failedTest.ErrorRecord.TargetObject.Message


            $fileContent += '| {0} | {1} | `{2}:{3}` |' -f $testName.Trim(), $errorMessage.Trim(), $errorTestFile.Trim(), $errorTestLine.Trim()
        }
        $fileContent += [System.Collections.ArrayList]@(
            '',
            '</details>',
            ''
        )

        ######################
        ##   Passed Tests   ##
        ######################
        if (($passedTests.Count -gt 0) -and -not $SkipPassedTestsReport) {
            # List of passed tests
            $fileContent += [System.Collections.ArrayList]@(
                '',
                '<details>',
                '<summary>List of Passed Tests</summary>',
                '',
                '## Passed Tests',
                '',
                '| Name | Source |',
                '| :-- | :-- |'
            )
            foreach ($passedTest in $passedTests ) {

                $intermediateNameElements = $passedTest.Path
                $intermediateNameElements[-1] = '***{0}***' -f $passedTest.ExpandedName
                $testName = $intermediateNameElements -join '</p>' | Out-String

                $testLine = $passedTest.ScriptBlock.StartPosition.StartLine
                $testFile = Split-Path $passedTest.ScriptBlock.File -Leaf

                $fileContent += '| {0} | `{1}:{2}` |' -f $testName.Trim(), $testFile.Trim(), $testLine
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
            # List of passed tests
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
            foreach ($skippedTest in $skippedTests ) {

                $intermediateNameElements = $skippedTest.Path
                $intermediateNameElements[-1] = '***{0}***' -f $skippedTest.ExpandedName
                $testName = $intermediateNameElements -join '</p>' | Out-String

                $reason = 'Test {0}' -f $skippedTest.ErrorRecord.Exception.Message

                $testLine = $passedTest.ScriptBlock.StartPosition.StartLine
                $testFile = Split-Path $passedTest.ScriptBlock.File -Leaf

                $fileContent += '| {0} | {1} | `{2}:{3}` |' -f $testName.Trim(), $reason, $testFile.Trim(), $testLine
            }
            $fileContent += [System.Collections.ArrayList]@(
                '',
                '</details>',
                ''
            )
        }

        if ($PSCmdlet.ShouldProcess("Test results file in path [$OutputFilePath]", 'Create')) {
            $null = New-Item -Path $OutputFilePath -Force -Value $fileContent
        }
        Write-Verbose "Create results file [$outputFilePath]"
    }
}
