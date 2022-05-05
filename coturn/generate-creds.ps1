# https://datatracker.ietf.org/doc/html/draft-uberti-behave-turn-rest-00

$secret = "1234"
$user = "xvbqert"
$ttl = 3600
$unixTimestamp = [int](Get-Date -UFormat %s)
$expiryTime = $unixTimestamp + $ttl

$username = "${expiryTime}:${user}"

#base64(hmac(secret key, username))

$hmacSha = New-Object System.Security.Cryptography.HMACSHA1
$hmacSha.Key = [System.Text.Encoding]::ASCII.GetBytes($secret)
$signature = $hmacSha.ComputeHash([System.Text.Encoding]::ASCII.GetBytes($username))
$signature = [System.Convert]::ToBase64String($signature)

# Tesy the TURN server using https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/
Write-Output $username
Write-Output $signature
Write-Output $ttl
