This repo was forked from [wei/git-sync](https://github.com/wei/git-sync) to add git-lfs support by using a recent version of Alpine Linux.

# Git Sync

A GitHub Action for syncing between two independent repositories using **force push**.

## Features

- Sync branches between two GitHub repositories
- Sync branches to/from a remote repository
- GitHub action can be triggered on a timer or on push (branches and tags)
- Support for GIT LFS (PULL ALL from source then PUSH ALL to destination)

## Quick Setup Step-by-Step

Please see the [SSH Step-by-Step Guide](README-SSH-Step-by-Step-Guide.md) for step-by-step instructions using SSH.

## Usage

> Always make a full backup of your repo (`git clone --mirror`) before using this action.

### GitHub Actions

```yml
# .github/workflows/git-sync.yml

on:
  push:
    # Be sure to include all the relevant branching roots or this repo!
    branches:
      - main
      - release-*
    # Sync all tags, and generally limit tags to ONLY the branches being synced
    tags:
      - '*'

jobs:
  git-sync:
    runs-on: ubuntu-latest
    steps:
      - name: git-sync
        uses: valtech-sd/git-sync@v9
        with:
          source_repo: "git@github.com:source-org/source-repo.git"
          source_branch: "${{ github.event.ref }}"
          destination_repo: "git@github.com:destination-org/destination-repo.git"
          destination_branch: "${{ github.event.ref }}"
          source_ssh_private_key: ${{ secrets.SOURCE_SSH_PRIVATE_KEY }}
          destination_ssh_private_key: ${{ secrets.DESTINATION_SSH_PRIVATE_KEY }}

```

##### Using shorthand

You can use GitHub repo shorthand like `username/repository.git`.

##### Using ssh

> The `ssh_private_key`, or `source_ssh_private_key` and `destination_ssh_private_key` must be supplied if using ssh clone urls.

```yml
source_repo: "git@github.com:username/repository.git"
```
or
```yml
source_repo: "git@gitlab.com:username/repository.git"
```

##### Using https

> The `ssh_private_key`, `source_ssh_private_key` and `destination_ssh_private_key` can be omitted if using authenticated https urls.

```yml
source_repo: "https://username:personal_access_token@github.com/username/repository.git"
```

#### Set up deploy keys

> You only need to set up deploy keys if the repository is private and the ssh clone url is used.

- Either generate different SSH keys for both source and destination repositories or use the same one for both, leave the passphrase empty (note that GitHub deploy keys must be unique for each repository)

```sh
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

- In GitHub, either:

  - Add the unique public keys (`key_name.pub`) to _Repo Settings > Deploy keys_ for each repository respectively and allow write access for the destination repository

  or

  - add the single public key (`key_name.pub`) to _Personal Settings > SSH keys_

- Add the private key(s) to _Repo > Settings > Secrets_ for the repository containing the action (`SSH_PRIVATE_KEY`, or `SOURCE_SSH_PRIVATE_KEY` and `DESTINATION_SSH_PRIVATE_KEY`)

#### Advanced: Sync all branches

To Sync all branches from source to destination, use the wildcard branch filter on the **push** event of your action. But be careful, branches with the same name including `master` will be overwritten.

```yml
on:
  push:
    branches:
      - '*'
```

#### Advanced: Sync all tags

To Sync all tags from source to destination, use the wildcard tag filter on the **push** event of your action. But be careful, tags with the same name will be overwritten.

```yml
on:
  push:
    tags:
      - '*'
```

### Docker

You can run this in Docker locally for testing and development.

```sh
$ docker run --rm -e "SSH_PRIVATE_KEY=$(cat ~/.ssh/id_rsa)" $(docker build -q .) \
  $SOURCE_REPO $SOURCE_BRANCH $DESTINATION_REPO $DESTINATION_BRANCH
```

## Author

Original Author:
[Wei He](https://github.com/wei) _github@weispot.com_

Fork Author:
[Valtech SD](https://github.com/valtech-sd) _us.san_diego_engineering@valtech.com_

## License

[MIT](https://wei.mit-license.org)
