$var = Join-Path $PSScriptRoot "var.ps1"
. $var

$hostos=(go env GOHOSTOS)
$os=(go env GOOS)
$targetos="windows"

Write-Output "Building target $targetos on host $hostos"
if ($os -ne $targetos) {
  go env -w GOOS=$targetos
}

$srcdir = Join-Path "." "cmd" "$bin"
$exe = Join-Path "." "$bin.exe"
go build -ldflags "-s -w -X '$pkg.BuildVersion=$BuildVersion' -X '$pkg.BuildName=$BuildName'" -o "$exe" "$srcdir"
if ("$hostos" -eq "$targetos") {
  &"$exe" -V
}

if ($os -ne $targetos) {
  Write-Output "Restore to $os"
  go env -w GOOS=$os
}
