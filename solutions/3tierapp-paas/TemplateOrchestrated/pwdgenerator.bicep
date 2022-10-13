resource pwdGenerator_psql 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'password-generator_psql'
  location: 'UK South'
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '3.0'
    retentionInterval: 'P1D'
    scriptContent: '''
        function Get-RandomCharacters($length, $characters) {
        $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
        $private:ofs = ''
        return [String]$characters[$random]
      }
      function Scramble-String([string]$inputString) {
        $characterArray = $inputString.ToCharArray()
        $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length
        $outputString = -join $scrambledStringArray
        return $outputString
      }

      $password = Get-RandomCharacters -length 5 -characters 'abcdefghiklmnoprstuvwxyz'
      $password += Get-RandomCharacters -length 2 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
      $password += Get-RandomCharacters -length 3 -characters '1234567890'
      $password += Get-RandomCharacters -length 2 -characters '@#*+'

      #not allowed character " ' ` / \ < % ~ | $ & !

      $password = Scramble-String $password

      $Bytes = [System.Text.Encoding]::Unicode.GetBytes($password)
      $EncodedText = [Convert]::ToBase64String($Bytes)


      $scriptParameters = "spadmin $EncodedText"
      #$scriptParameters = "spadmin $EncodedText"

      Write-Host 'plaintext Password:: '$password
      Write-Host 'encoded Password:: '$EncodedText
      $DeploymentScriptOutputs = @{}
      $DeploymentScriptOutputs['password'] = $password
      $DeploymentScriptOutputs['encodedPassword'] = $EncodedText
    '''
  }
}

output encodedPassword_psql string = pwdGenerator_psql.properties.outputs.encodedPassword

output passwordText_psql string = pwdGenerator_psql.properties.outputs.password

resource pwdGenerator_sql 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'password-generator_sql'
  location: 'UK South'
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '3.0'
    retentionInterval: 'P1D'
    scriptContent: '''
        function Get-RandomCharacters($length, $characters) {
        $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
        $private:ofs = ''
        return [String]$characters[$random]
      }
      function Scramble-String([string]$inputString) {
        $characterArray = $inputString.ToCharArray()
        $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length
        $outputString = -join $scrambledStringArray
        return $outputString
      }

      $password = Get-RandomCharacters -length 5 -characters 'abcdefghiklmnoprstuvwxyz'
      $password += Get-RandomCharacters -length 2 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
      $password += Get-RandomCharacters -length 3 -characters '1234567890'
      $password += Get-RandomCharacters -length 2 -characters '@#*+'

      #not allowed character " ' ` / \ < % ~ | $ & !

      $password = Scramble-String $password

      $Bytes = [System.Text.Encoding]::Unicode.GetBytes($password)
      $EncodedText = [Convert]::ToBase64String($Bytes)


      $scriptParameters = "spadmin $EncodedText"
      #$scriptParameters = "spadmin $EncodedText"

      Write-Host 'plaintext Password:: '$password
      Write-Host 'encoded Password:: '$EncodedText
      $DeploymentScriptOutputs = @{}
      $DeploymentScriptOutputs['password'] = $password
      $DeploymentScriptOutputs['encodedPassword'] = $EncodedText
    '''
  }
}

output encodedPassword_sql string = pwdGenerator_sql.properties.outputs.encodedPassword

output passwordText_sql string = pwdGenerator_sql.properties.outputs.password
