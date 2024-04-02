# Made by WafflesExploits
# > Encode any type of file, and decoded as text or as a file.

function encode_b64 ([Parameter(Mandatory)] [string] $file_path, [Parameter(Mandatory)] [string] $newfile_path) {
	$byte_array = [System.IO.File]::ReadAllBytes($file_path)
	$base64 = [System.Convert]::ToBase64String($byte_array)
	$base64 > $newfile_path
	Write-Host "Encoded Base64 to $newfile_path"
}
function b64_totext ([Parameter(Mandatory)] [string] $file_path, [Parameter(Mandatory)] [string] $newfile_path) {
	$content = Get-Content -Path $file_path -Raw
	$decodedbase64 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($content))
	$decodedbase64 > $newfile_path
	Write-Host "Decoded Base64 to $newfile_path"
}
function b64_tofile ([Parameter(Mandatory)] [string] $file_path, [Parameter(Mandatory)] [string] $newfile_path) {
	$base64String = Get-Content -Path $file_path -Raw
	$fileBytes = [System.Convert]::FromBase64String($base64String)
	[System.IO.File]::WriteAllBytes($newfile_path, $fileBytes)
	Write-Host "Created $newfile_path from Base64"
}
function list_commands () {
 	Write-Host "> encode_b64 <file_path> <newfile_path>"
	Write-Host "> b64_totext <file_path> <newfile_path>"
	Write-Host "> b64_tofile <file_path> <newfile_path>"
}
