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
archives=$(nix eval --json --file tools.nix --apply 'tools: map (tool: tool.archive) (builtins.attrValues tools)' | jq -r '.[]')

hashes='{}'
for archive in $archives; do
  url="https://github.com/$owner/$repo/releases/download/v$version/$archive-$version.zip"
  hash=$(nix store prefetch-file --json --hash-type sha256 "$url" | jq -r .hash)
  hashes=$(jq --arg archive "$archive" --arg hash "$hash" '.[$archive] = $hash' <<<"$hashes")
done

jq --arg version "$version" --argjson hashes "$hashes" '.version = $version | .hashes = $hashes | del(.hash)' source.json > source.json.tmp
mv source.json.tmp source.json
echo "pinned $owner/$repo to $version"
