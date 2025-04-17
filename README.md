# git-push-action

Execute classic `git push` to any remote git repository to keep automatically sync from GitHub repository.

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
        uses: michaelliao/git-push-action@v2
        env:
          PUSH_PRIVATE_KEY: ${{ secrets.PUSH_PRIVATE_KEY }}
          PUSH_PUBLIC_KEY: ${{ secrets.PUSH_PUBLIC_KEY }}
        with:
          remote_repository: "git@gitlab.com:cryptomichael/git-push-action.git"
          push_options: "--force"
```

You must add environment secrets `PUSH_SSH_KEY`: your SSH private key file content.

It is highly recommended to generate an SSH key that only used for sync:

```
$ ssh-keygen -N "" -t rsa -C "sync-from-github@github.com" -f "github_sync_ssh_key"
```

And don't forget add your SSH pub key to the remote repository.
