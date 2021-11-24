function Remove-DeployedModule {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'deploymentName')]
        [string] $deploymentName,

        [Parameter(Mandatory, ParameterSetName = 'deploymentName')]
        [string] $templateFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName = 'validation-rg'
    )


    $moduleName = Split-Path (Split-Path $templateFilePath -Parent) -LeafBase

    switch ($moduleName) {
        'virtualWans' {
            Write-Verbose 'Run vWAN removal script' -Verbose
            # Load function
            . (Join-Path $PSScriptRoot 'helper' 'Remove-vWan.ps1')

            # Invoke removal
            $inputObject = @{
                deploymentName    = $deploymentName
                ResourceGroupName = $ResourceGroupName
            }
            Remove-vWan @inputObject -Verbose
        }
        default {
            Write-Verbose 'Run default removal script' -Verbose
            # Load function
            . (Join-Path $PSScriptRoot 'helper' 'Remove-GeneralModule.ps1')

            # Invoke removal
            $inputObject = @{
                deploymentName    = $deploymentName
                ResourceGroupName = $ResourceGroupName
                templateFilePath  = $templateFilePath
            }
            Remove-GeneralModule @inputObject -Verbose
        }
    }
}
