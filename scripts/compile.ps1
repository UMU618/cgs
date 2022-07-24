$var = Join-Path $PSScriptRoot "var.ps1"
. $var

$hostos=(go env GOHOSTOS)
$os=(go env GOOS)

Write-Output "Building target $hostos on host $hostos"
if ($os -ne $hostos) {
  go env -w GOOS=$hostos
}

$srcdir = Join-Path "." "cmd" "$bin"
$exe = Join-Path "." "$bin.exe"
go build -ldflags "-s -w -X '$pkg.BuildVersion=$BuildVersion' -X '$pkg.BuildName=$BuildName'" -o "$exe" "$srcdir"
&"$exe" -V

if ($os -ne $hostos) {
  Write-Output "Restore to $os"
  go env -w GOOS=$os
}
