$url="https://repo.msys2.org/distrib/msys2-x86_64-latest.exe"
$dest="C:\msys2-x86_64-latest.exe"
Invoke-WebRequest -Uri $url -OutFile $dest
cmd /c "C:\msys2-x86_64-latest.exe in --confirm-command --accept-messages --root C:/cygwin64"
