#!/usr/bin/env bash

function test_command () {
    if [ -z $(command -v "$1") ]; then
        echo "Error: $1 is not installed." >&2
        exit 1
    fi
}

test_command git
test_command west

# get project list from west
manifest_project_list=$(west list)
# remove first line
manifest_project_list=${manifest_project_list#*$'\n'}

submodule_list=$(git submodule status)

while IFS= read -r line; do
    commit_id=$(echo ${line} | cut -d " " -f 3)
    submodule_dir=$(echo ${line} | cut -d " " -f 2)
    submodule_url=$(echo ${line} | cut -d " " -f 4)
    current_commit_id=$(git submodule status | grep "${submodule_dir}" | cut -d " " -f 2)
    current_url=$(git submodule status | grep "${submodule_dir}" | cut -d " " -f 2)

    if [ -z "${current_commit_id}" ]; then
        echo "Add ${submodule_dir} submodule"
        git submodule add --force ${submodule_url} ${submodule_dir}
        pushd ${submodule_dir}
        git fetch --all
        git checkout --quiet ${commit_id}
        popd
    else
        if [ "${commit_id}" != "${current_commit_id}" ]; then
            echo "Update ${submodule_dir} submodule"
            git submodule set-url ${submodule_dir} ${submodule_url}
            if [ ! -d ${submodule_dir} ]; then
                git submodule update ${submodule_dir}
            fi
            pushd ${submodule_dir}
            git fetch --all
            git checkout --quiet ${commit_id}
            popd
        else
            echo "${submodule_dir} submodule already up to date"
        fi
    fi
done <<< ${manifest_project_list}
