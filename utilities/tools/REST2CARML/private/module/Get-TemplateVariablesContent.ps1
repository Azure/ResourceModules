function Get-TemplateVariablesContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array] $ModuleData,

        [Parameter(Mandatory = $false)]
        [array] $ExistingTemplateContent = @()
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {

        ########################
        ##   Create Content   ##
        ########################

        $templateContent = @(
            '// ============= //'
            '//   Variables   //'
            '// ============= //'
            ''
        )

        foreach ($variable in $ModuleData.variables) {
            if ($existingTemplateContent.variables.name -notcontains $variable.name) {
                $templateContent += $variable.content
            } else {
                $matchingExistingVar = $existingTemplateContent.variables | Where-Object { $_.name -eq $variable.name }
                $templateContent += $matchingExistingVar.content
            }
            $templateContent += ''
        }

        # Add telemetry variable
        if ($linkedChildren.Count -gt 0) {
            if ($existingTemplateContent.variables.name -notcontains 'enableReferencedModulesTelemetry') {
                $templateContent += @(
                    'var enableReferencedModulesTelemetry = false'
                    ''
                )
            } else {
                $matchingExistingVar = $existingTemplateContent.variables | Where-Object { $_.name -eq 'enableReferencedModulesTelemetry' }
                $templateContent += $matchingExistingVar.content
            }
            $templateContent += ''
        }

        # Add additional parameters to only exist in a pre-existing template at the end
        foreach ($extraVariable in ($existingTemplateContent.variables | Where-Object { $ModuleData.variables.name -notcontains $_.name -and $_.name -ne 'enableReferencedModulesTelemetry' })) {
            $templateContent += $extraVariable.content
            $templateContent += ''
        }

        # Only add the section if any content was added
        if ($templateContent.count -eq 4) {
            return @()
        } else {
            return $templateContent
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
