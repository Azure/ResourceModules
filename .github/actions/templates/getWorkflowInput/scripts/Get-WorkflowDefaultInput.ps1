<#
.SYNOPSIS
Retrieve input parameter default values for a specified workflow.

.DESCRIPTION
Retrieve input parameter default values for a specified workflow. Return hashtable containing <parameterName,defaultValue> pairs.

.PARAMETER workflowPath
Mandatory. The path to the github workflow file.

.EXAMPLE
Get-WorkflowDefaultInput -workflowPath 'path/to/workflow' -verbose

Retrieve input parameter default values for the 'path/to/workflow' workflow.
#>
function Get-WorkflowDefaultInput {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $workflowPath
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        #region Helper Functions

        <#
        .SYNOPSIS
        Retrieve indentation of a line.

        .PARAMETER Line
        Mandatory. The line to analyse for indentation.

        .EXAMPLE
        $Line = '    Test'
        Get-LineIndentation -Line $Line
        4

        Retrieve indentation of a line.
        #>
        function Get-LineIndentation {
            [CmdletBinding()]
            param (
                [Parameter()]
                [string] $Line
            )
            begin {}
            process {
                $indentation = 0
                for ($i = 0; $i -lt $Line.Length; $i++) {
                    $Char = $Line[$i]
                    switch -regex ($Char) {
                        '`t' {
                            Write-Verbose "[$i] $Char is tab"
                            $indentation += 2
                        }
                        ' ' {
                            Write-Verbose "[$i] $Char is space"
                            $indentation += 1
                        }
                        default {
                            Write-Verbose "[$i] $Char is character, break"
                            return $indentation
                        }
                    }
                }
                return $indentation
            }
            end {}
        }

        <#
        .SYNOPSIS
        Retrieve default value for a specified input in a workflow.

        .PARAMETER InputName
        Mandatory. The name of the input to get the default value for.

        .PARAMETER Content
        Mandatory. The content of the GitHub workflow file.

        .EXAMPLE
        $content = Get-Content -Path .\workflow.yml
        Get-DefaultValue -Text 'removeDeployment' -Content $Content

        Retrieve input default values for the 'removeDeployment' in the workflow.yml file.
        #>
        function Get-DefaultValue {
            [CmdletBinding()]
            param (
                [Parameter(Mandatory)]
                [string] $InputName,
                [Parameter(Mandatory)]
                [string[]] $Content
            )
            $Content = $Content.Split([Environment]::NewLine)
            $SectionIndex = ((0..($Content.Count - 1)) | Where-Object { $Content[$_] -match "$InputName" })[0]
            $SectionIndentation = Get-LineIndentation -Line $Content[$SectionIndex]
            Write-Verbose "Found $InputName on line: $SectionIndex - [$SectionIndentation]"
            $LineIndentation = $SectionIndentation
            for ($i = $SectionIndex + 1; $true; $i++) {
                $LineIndentation = Get-LineIndentation -Line $Content[$i]
                Write-Verbose "Processing line: $i - [$LineIndentation] - $($Content[$i])"
                if ($LineIndentation -le $SectionIndentation) {
                    break
                }
                if ($LineIndentation -gt $SectionIndentation) {
                    continue
                }
                if ($Content[$i] -match 'default:') {
                    Write-Verbose "Found 'default:' on line: $i"
                    $defaultValue = $Content[$i].trim().Split('#')[0].Split(':')[-1].Replace("'", '').Trim()
                    break
                }
            }
            Write-Verbose "Default input value for $InputName`: $defaultValue"
            return $defaultValue
        }
        #endregion
    }

    process {
        $workflowContent = Get-Content -Path $workflowPath -Raw

        $workflowParameters = @{
            removeDeployment = Get-DefaultValue -InputName 'removeDeployment' -Content $workflowContent -Verbose
            versioningOption = Get-DefaultValue -InputName 'versioningOption' -Content $workflowContent -Verbose
            customVersion    = Get-DefaultValue -InputName 'customVersion' -Content $workflowContent -Verbose
        }

        Write-Verbose 'Get workflow default input complete'

        # Return hashtable
        return $workflowParameters
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
