<#
.SYNOPSIS
Retrieve input parameter default values for a specified workflow.

.DESCRIPTION
Retrieve input parameter default values for a specified workflow. Return hashtable containing <parameterName,defaultValue> pairs.

.PARAMETER workflowPath
Mandatory. The path to the github workflow file.

.EXAMPLE
Get-GitHubWorkflowDefaultInput -workflowPath 'path/to/workflow' -verbose

Retrieve input parameter default values for the 'path/to/workflow' workflow.
#>
function Get-GitHubWorkflowDefaultInput {
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
                [Parameter(Mandatory = $false)]
                [string] $Line
            )
            begin {}
            process {
                $indentation = 0
                for ($i = 0; $i -lt $Line.Length; $i++) {
                    $Char = $Line[$i]
                    switch -regex ($Char) {
                        '`t' {
                            $indentation += 2
                        }
                        ' ' {
                            $indentation += 1
                        }
                        default {
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
            $SectionStartLine = ((0..($Content.Count - 1)) | Where-Object { $Content[$_] -match "$InputName" })[0]
            $SectionStartIndentation = Get-LineIndentation -Line $Content[$SectionStartLine]
            $CurrentLineIndentation = $SectionStartIndentation
            for ($i = $SectionStartLine + 1; $i -lt $Content.Count; $i++) {
                $CurrentLineIndentation = Get-LineIndentation -Line $Content[$i]
                if ($CurrentLineIndentation -le $SectionStartIndentation) {
                    # Outside of start section, jumping out
                    break
                }
                if ($CurrentLineIndentation -gt $SectionStartIndentation + 2) {
                    # In child section, ignoring
                    continue
                }
                if ($Content[$i] -match 'default:') {
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
            removeDeployment = Get-DefaultValue -InputName 'removeDeployment' -Content $workflowContent
        }

        Write-Verbose 'Get workflow default input complete'

        # Return hashtable
        return $workflowParameters
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
