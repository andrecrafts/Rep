#!/bin/python3
import base64
target_ip=str(input("Attacker's IP: "))
port_range=str(input("Port Range (4000-4100): "))
payload=f"[String] $targetip = '{target_ip}'\n"+f"[String] $portrange = '{port_range}'\n"+"""
function FireBuster{
    
    [int] $lowport = $portrange.split("-")[0]
    [int] $highport = $portrange.split("-")[1]
	
    $hostaddr = [system.net.IPAddress]::Parse($targetip)
    
    $ErrorActionPreference = 'SilentlyContinue'
    if ($verbose){ write-host "Trying to connect to $hostaddr from $lowport to $highport" }
	[int] $ports = 0
	Write-host "Sending...."
	for($ports=$lowport; $ports -le $highport ; $ports++){
        try{
            $Socket = New-Object System.Net.Sockets.TCPClient($hostaddr,$ports)
			$Stream = $Socket.GetStream()
			$Writer = New-Object System.IO.StreamWriter($Stream)
			$Writer.AutoFlush = $true
			$Writer.NewLine = $true
			$Writer.Write("$ports")
			$Socket.Close()
        }catch { Write-Error $Error[0]}
    }        
	Write-Host "Data sent to all ports"
}

FireBuster
"""
enc_payload = "powershell -e " + base64.b64encode(payload.encode('utf16')[2:]).decode()
print(enc_payload)
