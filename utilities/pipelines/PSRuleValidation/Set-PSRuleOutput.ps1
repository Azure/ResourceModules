function Set-PSRuleOutput {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [String] $inputFilePath,

        [Parameter(Mandatory = $false)]
        [string] $outputFilePath = './output.md'
    )

    # Import CSV output and filter by results

    $results = Import-Csv -Path $inputFilePath

    $passedRules = @()
    $failedRules = @()

    $passedRules += $results | Where-Object { $_.Outcome -EQ 'Pass' }
    $failedRules += $results | Where-Object { $_.Outcome -EQ 'Fail' }


    #Create Summary table

    $headerTable = [System.Collections.ArrayList]@(
        '# Output Summary ',
        '',
        '| Total No. of Rules Processed | Rules Passed :white_check_mark: | Rules Failed :x: |',
        '| :-- | :-- | :-- |'
    )

    $headerTable += ('| {0} | {1} | {2} |' -f $results.Count, $passedRules.Count , $failedRules.Count)
    $headerTable += [System.Collections.ArrayList]@(
        '')

    # Create markdown file with header table
    Out-File -FilePath $outputFilePath -NoClobber -InputObject $headerTable


    if ($failedRules.Count -gt 0) {

        #Create Failing table
    
        $failContent = [System.Collections.ArrayList]@(
            '# Rules Failed',
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
                $resourceLink = "[" + $content.RuleName + "](" + $PSRuleReferenceUrl + ")"
            }
            catch {
                Write-Warning "Unable to build url for $content.RuleName"
                $resourceLink = $content.RuleName
            }
            $failContent += ('| {0} | {1} | {2} | ' -f $resourceLink, $content.TargetName, $content.Synopsis)
        
        }
        #Append markdown with failed rules table
        Out-File -FilePath $outputFilePath -Append -NoClobber -InputObject $failContent
    }

    # Create Passing table
    if ($passedRules.Count -gt 0) {

        $passContent = [System.Collections.ArrayList]@(
            '# Rules Passed',
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
                $resourceLink = "[" + $content.RuleName + "](" + $PSRuleReferenceUrl + ")"
            }
            catch {
                Write-Warning "Unable to build url for $content.RuleName"
                $resourceLink = $content.RuleName
            }
        
            $passContent += ('| {0} | {1} |  {2} |  ' -f $resourceLink, $content.TargetName, $content.Synopsis)

        }

        $passContent += [System.Collections.ArrayList]@(
            '')

        #Append markdown with passed rules table
        Out-File -FilePath $outputFilePath -Append -NoClobber -InputObject $passContent

    }


}

 

