<#
.SYNOPSIS
Retrieve indentation of a line.

.DESCRIPTION
Retrieve indentation of a line.

.PARAMETER Line
Mandatory. The line to analyse for indentation.

.EXAMPLE
Get-LineIndentation -Line '    Test'

Retrieve indentation of line '    Test'. Would return 4.
#>
function Get-LineIndentation {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $Line
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

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

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
