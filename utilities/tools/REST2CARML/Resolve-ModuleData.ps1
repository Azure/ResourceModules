function FilterParameters ($putObj, $definitions) {
    # TODO: recheck params
    $obj = {}
    $putObj.parameters | ForEach-Object {
        if ($_.name -eq 'parameters') {
            $newObj = Get-NestedParams($_.schema.$ref, $definitions)
            # $obj | Add-Member -MemberType NoteProperty -Name $newObj.name -Value $newObj
        } elseif ($null -ne $_.name) {
            $paramItem = [PSCustomObject]@{
                name        = $_.name
                type        = $_.type
                description = $_.description
            }

            $obj | Add-Member -MemberType NoteProperty -Name $paramItem.name -Value $paramItem
        } elseif ($null -ne $_.$ref) {
            $newObj = Get-NestedParams($_.$ref, $definitions)
            # $obj | Add-Member -MemberType NoteProperty -Name $newObj.name -Value $newObj
        }
    }
    return $obj
}

function Get-NestedParams {
    # TODO: check why ref is null here
    Param($params)
    $ref = $params[0]
    $definitions = $params[1]
    $refDef = Split-Path $ref -LeafBase
    if ($refDef -notin $definitions) {
        throw 'ref is not contained in definition'
    } else {
        #TODO: strip $definitions.$refDef and return
    }
}


function Resolve-ModuleData {


    $dummyObject = @(
        @{
        jsonFilePath = 'C:\dev\ip\azure-rest-api-specs\azure-rest-api-specs\specification\keyvault\resource-manager\Microsoft.KeyVault\stable\2022-07-01\keyvault.json'
        jsonKeyPath = '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}' # PUT path
    }
    )
}
