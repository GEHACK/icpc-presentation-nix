#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if [ $# -ne 1 ]; then
  echo "usage: $0 <icpctools version, e.g. 2.7.1401>" >&2
  exit 1
fi

version=${1#v}
owner=$(jq -r .owner source.json)
repo=$(jq -r .repo source.json)
url="https://github.com/$owner/$repo/releases/download/v$version/resolver-$version.zip"
hash=$(nix store prefetch-file --json --hash-type sha256 "$url" | jq -r .hash)

jq --arg version "$version" --arg hash "$hash" '.version = $version | .hash = $hash' source.json > source.json.tmp
mv source.json.tmp source.json
echo "pinned $owner/$repo to $version"
