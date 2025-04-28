# git-push-action

The `git-push-action` is a GitHub Action designed to synchronize GitHub repositories with one or more remote Git repositories. This action executes standard Git push operations to automatically keep third-party repositories in sync with your GitHub repository.

## Usage

Add a workflow file (e.g. `.github/workflows/sync-to-remote.yml`) to use `git-push-action` to sync a GitHub repository with any remote git repository:

```
# set branch name you want to push:
on:
  push:
    branches: ["main"]
  pull_request:
    branches: ["main"]

  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Push to remote repo
        uses: michaelliao/git-push-action@v3
        env:
          PUSH_SSH_KEY: ${{ secrets.PUSH_SSH_KEY }}
        with:
          remote_repository: "git@gitlab.com:cryptomichael/git-push-action.git"
          # optinal: set push options, default to "":
          push_options: "--force"
```

Multiple remote repositories can be added:

```
      - name: Push to remote repo
        uses: michaelliao/git-push-action@v3
        env:
          PUSH_SSH_KEY: ${{ secrets.PUSH_SSH_KEY }}
        with:
          remote_repository: |
            git@gitlab.com:cryptomichael/git-push-action.git
            git@gitee.com:liaoxuefeng/git-push-action.git
```

## Note

You must add environment secrets `PUSH_SSH_KEY` to your SSH private key file content.

It is highly recommended to generate an SSH key that only used for sync:

```
$ ssh-keygen -N "" -t rsa -C "sync-from-github@github.com" -f "github_sync_ssh_key"
```

And don't forget add your SSH pub key to all remote repositories you want to push to.
