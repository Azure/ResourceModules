

function Add-ModuleFileStructure{
    param(
         [Parameter(Mandatory)]
         [string] $ProviderNamespace,

         [Parameter(Mandatory)]
         [string] $ResourceType,



         $filesArray=@('deploy.bicep', 'readme.md', 'version.json'),

         $gitHubWorkflowYAMLPath = "github/workflows/",
         $azDevOpsModulePipelineYAMLPath = ".azureDevOps/modulePipelines/"

    )

    try{
        $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent
        $ModulePath = Join-path -path $repoRootPath 'modules'

        $ModuleName = "$ProviderNamespace\$ResourceType"
        $ProviderDir = New-Item -Path $ModulePath -Name $ModuleName -ItemType "directory"

       write-Host $ProviderDir


        if($filesArray){
            foreach($fileName in $filesArray){
                if($fileName){
                    write-Host "Creating File: $fileName"
                    New-Item -Path $ProviderDir -Name $fileName -ItemType "file"
                }
            }
        }

        $workflowYAMLPath = Join-path -path $repoRootPath $gitHubWorkflowYAMLPath
        write-Host $workflowYAMLPath

    }catch{
        Write-Host "An error occurred:"
        Write-Host $_
    }

}

 Add-ModuleFileStructure
