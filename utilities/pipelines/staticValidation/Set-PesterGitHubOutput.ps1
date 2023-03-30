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
        [String] $InputFilePath,

        [Parameter(Mandatory = $false)]
        [string] $OutputFilePath = './output.md',

        [Parameter(Mandatory = $false)]
        [switch] $SkipPassedTestsReport
    )

    ###########################################
    # Import xml output and filter by results #
    ###########################################

    if (-not (Test-Path $inputFilePath)) {
        Write-Warning ('Input File [{0}] not found' -f $inputFilePath)
        return ''
    } else {

        $results = ([xml](Get-Content -Path $InputFilePath)).testsuites.testsuite.testcase

        $passedTests += $results | Where-Object { $_.status -EQ 'Passed' }
        $skippedTests += $results | Where-Object { $_.status -EQ 'Skipped' }
        $failedTests += $results | Where-Object { $_.status -EQ 'Failed' }

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
                '| Total No. of Processed Tests| Passed Tests :white_check_mark: | Failed Tests :x: | Skipped Tests :x: |',
                '| :-- | :-- | :-- | :-- |'
            ('| {0} | {1} | {2} |' -f $results.Count, $passedTests.Count , $failedTests.Count, $skippedTests.Count),
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
                '| TestName | TargetName |  Synopsis |',
                '| :-- | :-- | :-- |'
            )
            foreach ($failedTest in $failedTests ) {

                # TODO: Add formatted failed tests
                $testName = $failedTest.Name
                $errorMessage = $fAiledTest.failure.message
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
                    '| TestName | TargetName |  Synopsis |',
                    '| :-- | :-- |  :-- |'
                )
                foreach ($content in $passedTests ) {

                    if ($content.TargetType -eq 'Microsoft.Resources/deployments') {
                        # TODO: Make less depending on absolute path (same below)
                        $content.TargetName = $content.TargetName.replace('/home/runner/work/ResourceModules/ResourceModules/modules/', '')
                    }

                    # TODO: Add formatted failed tests
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
                    '## Passed Tests',
                    '',
                    '| TestName | TargetName |  Synopsis |',
                    '| :-- | :-- |  :-- |'
                )
                foreach ($content in $skippedTests ) {

                    if ($content.TargetType -eq 'Microsoft.Resources/deployments') {
                        # TODO: Make less depending on absolute path (same below)
                        $content.TargetName = $content.TargetName.replace('/home/runner/work/ResourceModules/ResourceModules/modules/', '')
                    }

                    # TODO: Add formatted skipped tests
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
}
Set-PesterGitHubOutput -InputFilePath 'C:\dev\ip\Azure-ResourceModules\ResourceModules\testResults.xml' -Verbose -WhatIf
