#!/bin/bash
VERSION="${1}"
[ -z "${VERSION}" ] &&
  echo "You need to pass a semver version string i.e. (1.0.3)!" &&
  exit 1
git tag "v${VERSION}"
sed -i 's/.*version =.*/	version = "'"${VERSION}"'"/' pkg/davfs/davfs.go
make all
