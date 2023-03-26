#!/bin/bash

GITHUB_REPO=$GITHUB_REPO
ACCESS_TOKEN=$ACCESS_TOKEN

REG_TOKEN=$(curl -s -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/${GITHUB_REPO}/actions/runners/registration-token)

cd /home/runner/actions-runner

./config.sh --url https://github.com/${GITHUB_REPO} --token ${REG_TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
