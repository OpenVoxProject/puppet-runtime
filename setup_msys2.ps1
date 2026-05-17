$url="https://github.com/msys2/msys2-installer/releases/download/nightly-x86_64/msys2-x86_64-latest.exe"
$dest="C:\msys2-setup-x86_64.exe"
Invoke-WebRequest -Uri $url -OutFile $dest
cmd /c "C:\msys2-setup-x86_64.exe in --confirm-command --accept-messages --root C:/msys64"
