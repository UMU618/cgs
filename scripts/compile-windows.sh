#!/usr/bin/env sh
source `dirname $0`/var.sh

hostos=`go env GOHOSTOS`
os=`go env GOOS`
targetos="windows"

echo "Building target $targetos on host $hostos"
if [ "$os" != "$targetos" ]; then
  go env -w GOOS=$targetos
fi
exe="./$bin.exe"
go build -ldflags "-s -w -X $pkg.BuildVersion=$BuildVersion -X '$pkg.BuildName=$BuildName'" -o $exe ./cmd/$bin
if [ "$hostos" == "$targetos" ]; then
  $exe -V
fi

if [ "$os" != "$targetos" ]; then
  echo "Restore to $os"
  go env -w GOOS=$os
fi
