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

Generate a markdown file 'output.md' in the current folder, out of the 'C:/testResults.xml' input, listing all passed and failed rules.

.EXAMPLE
Set-PesterGitHubOutput -inputFilePath 'C:/testResults.xml' -outputFilePath 'C:/Pester-output.md' -SkipPassedTestsReport

Generate a markdown file 'C:/Pester-output.md', out of the 'C:/testResults.xml' input, listing only the failed rules.
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

        $results = Get-Content -Path $InputFilePath -Raw | Select-Xml -XPath 'testsuites'

        $passedRules += $results | Where-Object { $_.status -EQ 'Passed' }
        $skippedRules += $results | Where-Object { $_.status -EQ 'Skipped' }
        $failedRules += $results | Where-Object { $_.status -EQ 'Failed' }

        ######################
        # Set output content #
        ######################

        # Header
        $fileContent = [System.Collections.ArrayList]@(
            '# Pester validation summary ',
            ''
        )

        if ($failedRules.Count -eq 0) {
            # No failure content
            $fileContent += ('## :rocket: All [{0}] rules passed, YAY! :rocket:' -f $results.Count)
        } else {
            # Failure content

            ## Header table
            $fileContent += [System.Collections.ArrayList]@(
                '| Total No. of Processed Rules| Passed Rules :white_check_mark: | Failed Rules :x: |',
                '| :-- | :-- | :-- |'
            ('| {0} | {1} | {2} |' -f $results.Count, $passedRules.Count , $failedRules.Count),
                ''
            )

            ## List of failed rules
            $fileContent += [System.Collections.ArrayList]@(
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

                # Build hyperlinks to Pester documentation for the rules
                $TemplatesBaseUrl = 'https://azure.github.io/Pester.Rules.Azure/en/rules'
                try {
                    $PesterReferenceUrl = '{0}/{1}' -f $TemplatesBaseUrl, $content.RuleName
                    $null = Invoke-WebRequest -Uri $PesterReferenceUrl
                    $resourceLink = '[{0}]({1})' -f $content.RuleName, $PesterReferenceUrl
                } catch {
                    Write-Warning ('Unable to build url for rule [{0}]' -f $content.RuleName)
                    $resourceLink = $content.RuleName
                }
                $fileContent += ('| {0} | `{1}` | {2} | ' -f $resourceLink, $content.TargetName, $content.Synopsis)
            }
            $fileContent += [System.Collections.ArrayList]@(
                '',
                '</details>',
                ''
            )
        }

        if (($passedRules.Count -gt 0) -and -not $SkipPassedTestsReport) {
            # List of passed rules
            $fileContent += [System.Collections.ArrayList]@(
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

                # Build hyperlinks to Pester documentation for the rules
                $TemplatesBaseUrl = 'https://azure.github.io/Pester.Rules.Azure/en/rules'
                try {
                    $PesterReferenceUrl = '{0}/{1}' -f $TemplatesBaseUrl, $content.RuleName
                    $null = Invoke-WebRequest -Uri $PesterReferenceUrl
                    $resourceLink = '[{0}]({1})' -f $content.RuleName, $PesterReferenceUrl
                } catch {
                    Write-Warning 'Unable to build url for rule [{0}]' -f $content.RuleName
                    $resourceLink = $content.RuleName
                }
                $fileContent += ('| {0} | `{1}` | {2} |  ' -f $resourceLink, $content.TargetName, $content.Synopsis)

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
Set-PesterGitHubOutput -InputFilePath 'C:\dev\ip\Azure-ResourceModules\ResourceModules\testResults.xml' -Verbose -WhatIf
