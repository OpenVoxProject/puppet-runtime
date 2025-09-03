$url="https://cygwin.com/setup-x86_64.exe"
$dest="C:\setup-x86_64.exe"
Invoke-WebRequest -Uri $url -OutFile $dest
cmd /c "C:\setup-x86_64.exe -s https://cygwin.osuosl.org -q -P ruby,ruby-devel,gcc-core,make,git,libyaml-devel"
