# Sources:
# - https://github.com/Azure/CARML-Lab/wiki/v0.4.0%20-%20Lab%207%20-%20Contribution
# - https://github.com/Azure/ResourceModules/wiki/Contribution%20guide

# Create or pick up an issue
# - Check the boards for bugs and new issues                       https://github.com/Azure/ResourceModules/projects?type=classic
# - Use labels to find issues. "good first issue" is a good start. https://github.com/Azure/ResourceModules/labels/good%20first%20issue




# Environment setup
# - We did that last session




# Implement the contribution

### Create a contribution branch. Leave all your custom changes to settings remain in main!
### Implement the change the issue requires.
### Validate the change locally or use the CI environment.

$TemplateFilePath = 'D:\Repos\MariusStorhaug\ResourceModules\modules\Microsoft.KeyVault\vaults\deploy.bicep'


. 'D:\Repos\MariusStorhaug\ResourceModules\utilities\tools\Test-ModuleLocally.ps1'
$TestModuleLocallyInput = @{
    templateFilePath = $TemplateFilePath
    PesterTest       = $true
}
Test-ModuleLocally @TestModuleLocallyInput




# Re-generate the readme?
. 'D:\Repos\MariusStorhaug\ResourceModules\utilities\tools\Set-ModuleReadMe.ps1'
Set-ModuleReadMe -TemplateFilePath $TemplateFilePath





# Dont PR off your forks main branch, if you want to contribute more than once.
# Do your change towards main to confirm all it working, then create a branch off your main for the PR.

# Reset your branch
git remote add upstream https://github.com/Azure/ResourceModules.git
git fetch upstream
git restore --source upstream/main * ':!*Microsoft.KeyVault\vaults*'

# Push the branch to your fork
git commit -a -m 'Reset settings files'
git push

# Create a pull request
