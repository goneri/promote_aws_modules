#!/usr/bin/env bash
set -euo pipefail

git checkout -B promote_aws_branch origin/main
# --topo-order to be consistent with git filter-branch behavior
git log --pretty=tformat:%H --topo-order > /tmp/change_sha1.txt
# add an URL pointing on the original commit in the commit message
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --msg-filter 'python3 /home/goneri/git_repos/promote_aws_modules/rewrite.py'
# remove all the files, except the modules we want to keep
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --tree-filter "find . -type f  -not -path '*/\.git/*' -not -name 'ec2_vpc*.py' -exec rm {} \;" --prune-empty
# generate the patch files
git format-patch -10000 promote_aws_branch
