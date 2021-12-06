function Remove-DeployedModule {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $deploymentName,

        [Parameter(Mandatory = $true)]
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
        'virtualMachines' {
            Write-Verbose 'Run virtual machine removal script' -Verbose
            # Load function
            . (Join-Path $PSScriptRoot 'helper' 'Remove-VirtualMachine.ps1')

            # Invoke removal
            $inputObject = @{
                deploymentName    = $deploymentName
                ResourceGroupName = $ResourceGroupName
            }
            Remove-VirtualMachine @inputObject -Verbose
        }
        'automationAccounts' {
            Write-Verbose 'Run automation account removal script' -Verbose
            # Load function
            . (Join-Path $PSScriptRoot 'helper' 'Remove-AutomationAccount.ps1')

            # Invoke removal
            $inputObject = @{
                deploymentName    = $deploymentName
                ResourceGroupName = $ResourceGroupName
            }
            Remove-VirtualMachine @inputObject -Verbose
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
