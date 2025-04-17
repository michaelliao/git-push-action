#!/bin/bash

set -eu

_log() {
    local level=${1}
    local message=${2}

    echo "::$level::$message";
}

_main() {
    _log "info" "Git checkout at: ${INPUT_REPOSITORY}";
    cd "$INPUT_REPOSITORY";

    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null);
    if [ -z "$current_branch" ] || [ "$current_branch" == "HEAD" ]; then
        _log "error" "Not a valid branch: ${current_branch}";
        exit 1
    fi

    _log "info" "Get full history of branch: ${current_branch}";
    git fetch --unshallow origin ${current_branch};

    _log "info" "Push to remote repository: ${INPUT_REMOTE_REPOSITORY}";

    #     _add_files

    #     # Check dirty state of repo again using git-diff.
    #     # (git-diff detects better if CRLF of files changes and does NOT
    #     # proceed, if only CRLF changes are detected. See #241 and #265
    #     # for more details.)
    #     if [ -n "$(git diff --staged)" ] || "$INPUT_SKIP_DIRTY_CHECK"; then
    #         _local_commit

    #         _tag_commit

    #         _push_to_github
    #     else
    #         _set_github_output "changes_detected" "false"

    #         echo "Working tree clean. Nothing to commit.";
    #     fi
    # else
    #     _set_github_output "changes_detected" "false"

    #     echo "Working tree clean. Nothing to commit.";
    # fi
}


# _git_is_dirty() {
#     echo "INPUT_STATUS_OPTIONS: ${INPUT_STATUS_OPTIONS}";
#     _log "debug" "Apply status options ${INPUT_STATUS_OPTIONS}";

#     echo "INPUT_FILE_PATTERN: ${INPUT_FILE_PATTERN}";
#     read -r -a INPUT_FILE_PATTERN_EXPANDED <<< "$INPUT_FILE_PATTERN";

#     # capture stderr
#     gitStatusMessage="$((git status -s $INPUT_STATUS_OPTIONS -- ${INPUT_FILE_PATTERN_EXPANDED:+${INPUT_FILE_PATTERN_EXPANDED[@]}} >/dev/null ) 2>&1)";
#     # shellcheck disable=SC2086
#     gitStatus="$(git status -s $INPUT_STATUS_OPTIONS -- ${INPUT_FILE_PATTERN_EXPANDED:+${INPUT_FILE_PATTERN_EXPANDED[@]}})";
#     if [ $? -ne 0 ]; then
#         _log "error" "git-status failed with:<$gitStatusMessage>";
#         exit 1;
#     fi
#     [ -n "$gitStatus" ]
# }



# _push_to_github() {

#     echo "INPUT_PUSH_OPTIONS: ${INPUT_PUSH_OPTIONS}";
#     _log "debug" "Apply push options ${INPUT_PUSH_OPTIONS}";

#     # shellcheck disable=SC2206
#     INPUT_PUSH_OPTIONS_ARRAY=( $INPUT_PUSH_OPTIONS );

#     if [ -z "$INPUT_BRANCH" ]
#     then
#         # Only add `--tags` option, if `$INPUT_TAGGING_MESSAGE` is set
#         if [ -n "$INPUT_TAGGING_MESSAGE" ]
#         then
#             _log "debug" "git push origin --tags";
#             git push origin --follow-tags --atomic ${INPUT_PUSH_OPTIONS:+"${INPUT_PUSH_OPTIONS_ARRAY[@]}"};
#         else
#             _log "debug" "git push origin";
#             git push origin ${INPUT_PUSH_OPTIONS:+"${INPUT_PUSH_OPTIONS_ARRAY[@]}"};
#         fi

#     else
#         _log "debug" "Push commit to remote branch $INPUT_BRANCH";
#         git push --set-upstream origin "HEAD:$INPUT_BRANCH" --follow-tags --atomic ${INPUT_PUSH_OPTIONS:+"${INPUT_PUSH_OPTIONS_ARRAY[@]}"};
#     fi
# }

_main
