#!/usr/bin/env bash
set -euo pipefail


c_a_path=~/.ansible/collections/ansible_collections/community/aws/
a_a_path=~/.ansible/collections/ansible_collections/amazon/aws/
filter="ec2_vpc*.py"

cd ${c_a_path}

git checkout -B promote_aws_branch origin/main
# --topo-order to be consistent with git filter-branch behavior
git log --pretty=tformat:%H --topo-order > /tmp/change_sha1.txt
# add an URL pointing on the original commit in the commit message
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --msg-filter 'python3 /home/goneri/git_repos/promote_aws_modules/rewrite.py'
# remove all the files, except the modules we want to keep
env FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --tree-filter "find . -not -type d -and -not -path '*/\.git/*' -not -name '$filter' -exec rm {} \;" --prune-empty
# generate the patch files
git format-patch -10000 promote_aws_branch


cd ${a_a_path}
git checkout -B promote_aws_branch origin/main
git am ${c_a_path}/*.patch

./tests/sanity/refresh_ignore_files
git add tests/sanity/*.txt
git commit -m "refresh ignore files" tests/sanity/*.txt
