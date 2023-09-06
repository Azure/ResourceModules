<#
.SYNOPSIS
Get a formatted list of all Pull-Request titles that contributed to a given release.

.DESCRIPTION
Get a formatted list of all Pull-Request titles that contributed to a given release.
Pull Request titles should have the format '[<Category>] <Title>'. Any Pull Request that does not followed this format is printed to the invoking terminal with a warning.

.PARAMETER TargetReleaseTag
Mandatory. The intended release tag. This Tag must be newer than the latest in the target repository. For example 'v1.0.0'.

.PARAMETER PersonalAccessToken
Mandatory. The Token used to fetch the Pull Request information from GitHub.

.PARAMETER RepositoryOwner
Optional. The owning organization of the target repository. For example 'Azure'.

.PARAMETER RepositoryName
Optional. The target repository name. For example 'Resource Modules'.

.PARAMETER TargetBranch
Optional. The target branch to fetch the Pull Request information for. For example 'main'.

.PARAMETER PreviousReleaseTag
Optional. The previous release tag to get the diff in Pull Requests for. Defaults to the latest release. For eaxample 'v0.0.0'

.EXAMPLE
Get-FormattedGitHubRelease -TargetReleaseTag 'v0.6.0' -PersonalAccessToken '<A PAT>'

Get the formatted release notes for a future release with tag 'v0.6.0'.

.EXAMPLE
Get-FormattedGitHubRelease -TargetReleaseTag 'v1.0.0' -PreviousReleaseTag 'v0.4.0' -PersonalAccessToken '<A PAT>'

Get the formatted release notes for a future release with tag 'v1.0.0' - containing all the Pull Requests in between tag 'v0.4.0' and 'v1.0.0'.
#>
function Get-FormattedGitHubRelease {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TargetReleaseTag,

        [Parameter(Mandatory = $true)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $false)]
        [string] $RepositoryOwner = 'Azure',

        [Parameter(Mandatory = $false)]
        [string] $RepositoryName = 'ResourceModules',

        [Parameter(Mandatory = $false)]
        [string] $TargetBranch = 'main',

        [Parameter(Mandatory = $false)]
        [string] $PreviousReleaseTag = ''
    )

    # =============================== #
    #   Get generated release notes   #
    # =============================== #
    $requestInputObject = @{
        Method  = 'POST'
        Uri     = "https://api.github.com/repos/$RepositoryOwner/$RepositoryName/releases/generate-notes"
        Headers = @{
            Authorization = "Bearer $PersonalAccessToken"
        }
        Body    = @{
            tag_name          = $TargetReleaseTag
            target_commitish  = $TargetBranch
            previous_tag_name = $PreviousReleaseTag
        } | ConvertTo-Json
    }
    $response = Invoke-RestMethod @requestInputObject

    if (-not $response.Body) {
        Write-Error "Request failed. Reponse: [$response]"
    }

    $changedContent = $response.Body -split '\n' | Where-Object {
        $_ -like '`**' -and # For example: * [Modules] Update scope @carml in https://github.com/Azure/ResourceModules/pull/0
        $_ -notlike '`* @*' -and # For example: @carml made their first contribution in https://github.com/Azure/ResourceModules/pull/0
        $_ -notlike '`*`**' # For example: **Full Changelog**: https://github.com/Azure/ResourceModules/compare/v0.0.0...v1.0.0
    }

    $newContributorsContent = $response.Body -split '\n' | Where-Object {
        $_ -like '`* @*' # For example: @carml made their first contribution in https://github.com/Azure/ResourceModules/pull/0
    }

    # =================== #
    #   Analyze content   #
    # =================== #
    $correctlyFormatted = $changedContent | Where-Object { $_ -match '$* \[.*' }
    $incorrectlyFormatted = $changedContent | Where-Object { $_ -notmatch '$* \[.*' }

    if ($incorrectlyFormatted.Count -gt 0) {
        Write-Verbose '#############################' -Verbose
        Write-Verbose '#   Incorrectly formatted   #' -Verbose
        Write-Verbose '#############################' -Verbose
        Write-Verbose ($incorrectlyFormatted | Out-String) -Verbose
        Write-Verbose '#############################' -Verbose
    }

    # =================== #
    #   Process content   #
    # =================== #
    $categories = @()
    $contributors = @()
    foreach ($line in $correctlyFormatted) {
        $matchCategory = [regex]::Match($line, '\[(.+?)\].+')
        $categories += $matchCategory.Captures.Groups[1].Value
        $matchContributor = [regex]::Match($line, 'by \@(.*?)\s')
        $contributors += $matchContributor.Value
    }
    $foundCategories = $categories | Select-Object -Unique
    $foundContributors = $contributors | Where-Object { -not [String]::IsNullOrEmpty($_) } | Select-Object -Unique

    $newContributors = @()
    foreach ($line in $newContributorsContent) {
        $matchNewContributor = [regex]::Match($line, '\@(.*?)\s')
        $newContributors += $matchNewContributor.Value
    }

    $output = @()

    #   PRs by category   #
    # =================== #
    $output += ''
    $output += '### Highlights'
    $output += ''
    foreach ($category in $foundCategories) {
        $output += "***$category***"
        $categoryItems = $correctlyFormatted | Where-Object { $_ -imatch ".+\[$category\].+" }
        foreach ($categoryItem in $categoryItems) {
            $simplifiedItem = $categoryItem -replace "\* \[$category\]"
            $simplifiedItem = $simplifiedItem -replace 'by @.*', ''
            if ($simplifiedItem -like ':*') {
                $simplifiedItem = $simplifiedItem.Substring(1, ($simplifiedItem.Length - 1))
            }
            $output += '* {0}' -f $simplifiedItem.Trim()
        }
        $output += ''
    }

    #   Contributors   #
    # ================ #
    $output += ''
    $output += '### Contributors'
    $output += ''
    $output += '| GH handle | GH name |'
    $output += '| :-- | :-- |'
    foreach ($contributor in $foundContributors) {
        $contributorHandle = $contributor -replace 'by @', ''
        $requestInputObject = @{
            Method  = 'GET'
            Uri     = "https://api.github.com/users/$contributorHandle"
            Headers = @{
                Authorization = "Bearer $PersonalAccessToken"
            }
        }
        try {
            $response = Invoke-RestMethod @requestInputObject
            $contributorName = $response.name
            $contributorNames += $contributorName + ', '
            $output += ('| {0} | {1} |' -f $contributorHandle, $contributorName)
        } catch {
            Write-Error ("Failed for [$contributor]. Error: $_")
        }
    }

    $output += ''
    $output += '* CC: ' + $contributorNames

    #   Statistics   #
    # ================ #
    $output += ''
    $output += '### Statistics'
    $output += ''
    $output += "* Count of Merged PRs: $($changedContent.count)"
    $output += "* Count of Contributors: $($foundContributors.count)"
    $output += "* Count of New Contributors: $($newContributors.count)"
    $output += ''
    return $output
}
