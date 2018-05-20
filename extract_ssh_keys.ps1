$path = "HKCU:\Software\OpenSSH\Agent\Keys\"

$regkeys = Get-ChildItem $path | Get-ItemProperty

if ($regkeys.Length -eq 0) {
    Write-Host "No keys in registry"
    exit
}

$keys = @()

Add-Type -AssemblyName System.Security;

$regkeys | ForEach-Object {
    $key = @{}
    $comment = [System.Text.Encoding]::ASCII.GetString($_.comment)
    Write-Host "Pulling key: " $comment
    $encdata = $_.'(default)'
    $decdata = [Security.Cryptography.ProtectedData]::Unprotect($encdata, $null, 'CurrentUser')
    $b64key = [System.Convert]::ToBase64String($decdata)
    $key[$comment] = $b64key
    $keys += $key
}

ConvertTo-Json -InputObject $keys | Out-File -FilePath './extracted_keyblobs.json' -Encoding ascii
Write-Host "extracted_keyblobs.json written. Use Python script to reconstruct private keys: python extractPrivateKeys.py extracted_keyblobs.json"




