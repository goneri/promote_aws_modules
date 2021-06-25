#!/usr/bin/env bash
set -euo pipefail

git checkout -B promote_aws_branch origin/main
# --topo-order to be consistent with git filter-branch behavior
git log --pretty=tformat:%H --topo-order > /tmp/change_sha1.txt
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --msg-filter 'python3 /home/goneri/git_repos/promote_aws_modules/rewrite.py'

git format-patch -10000 promote_aws_branch -- plugins/modules/ec2_vpc*
