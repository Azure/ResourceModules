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
        Retrieve default value for a specified input in a workflow.

        .PARAMETER InputName
        Mandatory. The name of the input to get the default value for.

        .PARAMETER Content
        Mandatory. The content of the GitHub workflow file.

        .PARAMETER Lines
        Mandatory. The number of lines to check after finding the specified input.

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
                [string[]] $Content,
                [Parameter()]
                [int] $Lines = 3
            )
            $Content = $Content.Split([Environment]::NewLine)
            $RowIndex = ((0..($Content.Count - 1)) | Where-Object { $Content[$_] -match "$InputName" })[0]
            Write-Verbose "Found $InputName on line: $RowIndex"
            for ($i = $RowIndex; $i -le ($RowIndex+$Lines); $i++) {
                if ($Content[$i] -match 'default:') {
                    Write-Verbose "Found 'default:' on line: $i"
                    $defaultValue = $Content[$i].trim().Split('#')[0].Split(':')[-1].Replace("'",'').Trim()
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
        $workflowParameters

        Write-Verbose 'Get workflow default input complete'

        # Return hashtable
        return $workflowParameters
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
