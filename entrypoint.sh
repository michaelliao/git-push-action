#!/bin/bash

set -eu

_log() {
    local level=${1}
    local message=${2}

    echo "::${level}::${message}";
}

_main() {
    _log "info" "Git checkout at: ${INPUT_REPOSITORY}"
    cd "${INPUT_REPOSITORY}"

    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -z "${current_branch}" ] || [ "${current_branch}" == "HEAD" ]; then
        _log "error" "Not a valid branch: ${current_branch}"
        exit 1
    fi

    _log "info" "Get full history of branch: ${current_branch}"
    git fetch --unshallow origin ${current_branch}

    _log "info" "Push to remote repository: ${INPUT_REMOTE_REPOSITORY}"
    if [[ "${INPUT_REMOTE_REPOSITORY}" =~ ^git@.*:.* ]]; then
        remote_host=$(echo "${INPUT_REMOTE_REPOSITORY}" | sed -E 's/.*@(.*):.*/\1/')
        mkdir -p ~/.ssh
        ssh-keyscan -t rsa "${remote_host}" >> ~/.ssh/known_hosts
    else
        _log "error" "Not a valid repository: ${INPUT_REMOTE_REPOSITORY}"
        exit 1
    fi

    # write ssh key:
    echo "$PUSH_PRIVATE_KEY" > ~/.ssh/tmp_ssh_push_key_rsa
    chmod 600 ~/.ssh/tmp_ssh_push_key_rsa
    echo "$PUSH_PUBLIC_KEY" > ~/.ssh/tmp_ssh_push_key_rsa.pub

    # do git push:
    git remote add tmp_origin ${INPUT_REMOTE_REPOSITORY}
    GIT_SSH_COMMAND="ssh -i ~/.ssh/tmp_ssh_push_key_rsa" git push tmp_origin ${INPUT_PUSH_OPTIONS} ${current_branch}

    _log "info" "Git push successfully."
}

_main
