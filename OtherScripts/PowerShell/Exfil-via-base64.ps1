# Made by WafflesExploits
# > Encode any type of file, and decoded as text or as a file.

function file_to_b64 ([Parameter(Mandatory)] [string] $file_path, [Parameter(Mandatory)] [string] $newfile_path) {
	$byte_array = [System.IO.File]::ReadAllBytes($file_path)
	$base64 = [System.Convert]::ToBase64String($byte_array)
	$base64 > $newfile_path
	Write-Host "Encoded Base64 to $newfile_path"
}
function b64_to_file ([Parameter(Mandatory)] [string] $file_path, [Parameter(Mandatory)] [string] $newfile_path) {
    $content = [System.IO.File]::ReadAllText($file_path)
	$fileBytes = [System.Convert]::FromBase64String($content)
	[System.IO.File]::WriteAllBytes($newfile_path, $fileBytes)
	Write-Host "Created $newfile_path from Base64"
}
function text_to_unicode_b64 ([Parameter(Mandatory)] [string] $payload) {
	$Bytes = [System.Text.Encoding]::Unicode.GetBytes($payload)
	$Base64_payload =[Convert]::ToBase64String($Bytes)
	Write-Host "$Base64_payload"
}
function decode_unicode_b64 ([Parameter(Mandatory)] [string] $base64String) {
	$fileBytes = [System.Convert]::FromBase64String($base64String)
	$decoded_text = [System.Text.Encoding]::Unicode.GetString($fileBytes)
	Write-Host "$decoded_text"
}
function list_commands () {
	Write-Host "> text_to_unicode_b64 <text>"
    Write-Host "> decode_unicode_b64 <base64>"
 	Write-Host "> file_to_b64 <file_path> <newfile_path>"
	Write-Host "> b64_to_file <file_path> <newfile_path>"
}
