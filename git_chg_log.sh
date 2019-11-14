#!/usr/bin/env bash

logFormat="[%cd] %h by %cn(%ae) %n============%n %s %n"
dateFormat="%Y-%m-%d %H:%M:%S"
lastCountIfNoTag=5
set -exo pipefail

# shellcheck disable=SC2207
tag_arr=($(git tag -l --sort=committerdate | tac | tr "\n" " "))

tag_arr_len=${#tag_arr[@]}

function tag_sha1_id() {
  if [ -z "${1}" ]; then
    echo "name of commit is required"
    exit 1
  fi
  git show -s "${1}" --format="%h"
}

if [ "${tag_arr_len}" == "0" ] || [ "$(tag_sha1_id "HEAD")" == "$(latest_tag_id "${tag_arr[0]}")" ]; then
  git log -n${lastCountIfNoTag} --pretty=format:"${logFormat}" --date=format:"${dateFormat}" | cat
else
  git log --pretty=format:"${logFormat}" --date=format:"${dateFormat}" "${tag_arr[0]}"..HEAD | cat
fi
