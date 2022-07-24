#!/usr/bin/env sh
source `dirname $0`/var.sh

hostos=`go env GOHOSTOS`
os=`go env GOOS`

echo "Building target $hostos on host $hostos"
if [ "$os" != "$hostos" ]; then
  go env -w GOOS=$hostos
fi
go build -ldflags "-s -w -X $pkg.BuildVersion=$BuildVersion -X '$pkg.BuildName=$BuildName'" -o $bin.$hostos ./cmd/$bin
./$bin.$hostos -V

if [ "$os" != "$hostos" ]; then
  echo "Restore to $os"
  go env -w GOOS=$os
fi
