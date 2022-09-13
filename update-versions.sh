#!/bin/bash

version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/nzbget/nzbget/releases" | jq -r .[0].name | sed s/v//g)
[[ -z ${version} ]] && exit 0
old_version=$(jq -r '.version_short' < VERSION.json)
changelog=$(jq -r '.changelog' < VERSION.json)
[[ "${old_version}" != "${version//-testing/}" ]] && changelog="https://github.com/nzbget/nzbget/compare/v${old_version}...v${version//-testing/}"
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'" | .version_short = "'"${version//-testing/}"'" | .changelog = "'"${changelog}"'"' <<< "${version_json}" > VERSION.json
