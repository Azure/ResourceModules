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
        Install-Module -Name powershell-yaml -Repository PSGallery -Force
        Import-Module -Name powershell-yaml -Verbose
    }

    process {
        #$content = Get-Content $workflowPath
        $content = Get-Content $workflowPath -Raw
        $obj = ConvertFrom-Yaml -Yaml $content

        # Get 'removeDeployment' default input value
        # $removeDeploymentRowIndex = ((0..($content.Count - 1)) | Where-Object { $content[$_] -like '*removeDeployment:*' })[0]
        # $removeDeployment = $content[$removeDeploymentRowIndex + 3].trim().Split(':')[1].Trim().Replace("'", '').Replace('"', '')
        $removeDeployment = $obj.On.workflow_dispatch.inputs.removeDeployment.default
        Write-Verbose "Default input value for removeDeployment: $removeDeployment"

        # Get 'versioningOption' default input value
        # $versioningOptionRowIndex = ((0..($content.Count - 1)) | Where-Object { $content[$_] -like '*versioningOption:*' })[0]
        # $versioningOption = $content[$versioningOptionRowIndex + 3].trim().Split(':')[1].Trim().Replace("'", '').Replace('"', '')
        $versioningOption = $obj.On.workflow_dispatch.inputs.versioningOption.default
        Write-Verbose "Default input value for versioningOption: $versioningOption"

        # Get 'customVersion' default input value
        # $customVersionRowIndex = ((0..($content.Count - 1)) | Where-Object { $content[$_] -like '*customVersion:*' })[0]
        # $customVersion = $content[$customVersionRowIndex + 3].trim().Split(':')[1].Trim().Replace("'", '').Replace('"', '')
        $customVersion = $obj.On.workflow_dispatch.inputs.customVersion.default
        Write-Verbose "Default input value for customVersion: $customVersion"

        # Define hashtable to contain workflow parameters
        $workflowParameters = @{}
        $workflowParameters.Add('removeDeployment', $removeDeployment)
        $workflowParameters.Add('versioningOption', $versioningOption)
        $workflowParameters.Add('customVersion', $customVersion)
        Write-Verbose 'Get workflow default input complete'

        # Return hashtable
        return $workflowParameters
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
