# Alt: https://docs.microsoft.com/en-us/azure/templates
$response = Invoke-WebRequest -Uri 'https://docs.microsoft.com/en-us/rest/api/azure/toc.json'

if (-not $response.Content) {
    throw 'Fetch failed'
}

$menu = ($response.Content | ConvertFrom-Json -Depth 99 -AsHashtable).items

$topLevelResourceTypes = $menu.toc_title | Where-Object { $_ -notlike 'Getting Started with REST' }

foreach ($resourceType in $topLevelResourceTypes) {
    # Fetch children
    # Filter down by 'CREATE' commands
    # Run recursively
}
