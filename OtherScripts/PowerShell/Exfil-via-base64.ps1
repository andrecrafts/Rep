function encode_b64 ($file_path, $newfile_path) {
    $content = Get-Content -Path $file_path -Raw
    $byte_array = [System.Text.Encoding]::UTF8.GetBytes($content)
    $base64 = [System.Convert]::ToBase64String($byte_array)
	  $base64 > $newfile_path
	  Write-Host "Encoded base64 to $newfile_path"
}
function decode_b64 ($file_path, $newfile_path) {
	$content = Get-Content -Path $file_path -Raw
	$decodedbase64 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($content))
	$decodedbase64 > $newfile_path
	Write-Host "Decoded base64 to $newfile_path"
}
