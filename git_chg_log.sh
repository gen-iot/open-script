#!/usr/bin/env bash

logFormat="[%cd] %h by %cn(%ae) %n============%n %s %n"
dateFormat="%Y-%m-%d %H:%M:%S"
lastCountIfNoTag=5
set -exo pipefail

# shellcheck disable=SC2207
tag_arr=($(git tag -l --sort=committerdate | tac | tr "\n" " "))

tag_arr_len=${#tag_arr[@]}

head_tag_id=$(git show -s HEAD --format="%h")

function latest_tag_id() {
  git show -s "${tag_arr[0]}" --format="%h"
}

if [ "${tag_arr_len}" == "0" ] || [ "${head_tag_id}" == "$(latest_tag_id)" ]; then
  git log -n${lastCountIfNoTag} --pretty=format:"${logFormat}" --date=format:"${dateFormat}"  |cat
else
  git log --pretty=format:"${logFormat}" --date=format:"${dateFormat}" ${tag_arr[0]}.. HEAD | cat
fi
