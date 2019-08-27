#!/bin/bash
set -x


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


rsync -avu --checksum --delete "${DIR}/folder_a/" "${DIR}/folder_b"


if ! git diff-index --quiet HEAD --; then
    git push --delete origin bot_sync

    git checkout -b bot_sync

    git add "${DIR}/folder_b"
    git commit -m "bot: syncing folder a with b"
    git push --set-upstream origin bot_sync

    hub pull-request -F PULLREQUEST.MD -h bot_sync

    git checkout master
    git branch -D bot_sync # Only for local testing

fi
