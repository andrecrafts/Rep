# Use the first argument as the file path
$path = $args[0]

# Get the file version information
$file = Get-Item $path
$versionInfo = $file.VersionInfo

# Iterate over all the properties of $versionInfo
foreach ($property in $versionInfo.PSObject.Properties) {
    Write-Output "VALUE `"$($property.Name)`", `"$($property.Value)`""
}
