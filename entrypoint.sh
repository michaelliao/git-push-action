#!/bin/bash

set -eu

_log() {
    local level=${1}
    local message=${2}

    echo "::${level}::${message}";
}

_push() {
    local branch=${1}
    local repo=${2}
    _log "info" "Push to remote repository: ${repo}"
    if [[ "${repo}" =~ ^git@.*:.* ]]; then
        remote_host=$(echo "${repo}" | sed -E 's/.*@(.*):.*/\1/')
        ssh-keyscan -t rsa "${remote_host}" >> ~/.ssh/known_hosts
    else
        _log "error" "Not a valid repository: ${repo}"
        exit 1
    fi

    # do git push:
    git remote add tmp_origin_052d ${repo}
    GIT_SSH_COMMAND="ssh -i ~/.ssh/tmp_ssh_push_key_rsa" git push tmp_origin_052d ${INPUT_PUSH_OPTIONS} ${branch}

    _log "info" "Git push successfully to: ${repo}"
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

    _log "info" "Write SSH key."
    mkdir -p ~/.ssh
    echo "$PUSH_PRIVATE_KEY" > ~/.ssh/tmp_ssh_push_key_rsa
    chmod 600 ~/.ssh/tmp_ssh_push_key_rsa
    echo "$PUSH_PUBLIC_KEY" > ~/.ssh/tmp_ssh_push_key_rsa.pub

    repos="${INPUT_REMOTE_REPOSITORY}"
    for repo in $repos; do
        echo "Processing $repo."
    done
}

_main
