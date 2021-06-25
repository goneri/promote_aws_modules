# Script to promote modules from community.aws to amazon.aws


## step 1 - with run.sh in community.aws

.1 in community.aws, we prepare a promote_aws_branch that is a copy of origin/main
.2 we rewrite the commits with:
    - a `[promoted]` prefix in the commit title
    - a footer with a reference pointing on a the original commit
.3 we call `git format-patch` to extract the commits of interest as .patch files

## step 2 - in amazon.aws

.1 in amazon.aws, we use `git am ~/.ansible/collections/ansible_collections/community/aws/*.patch*` to apply the patch files

## step 3 - grab a coffee and enjoy

Well, not really, there is still a couple of stuff to improve :-).

- generate some changelog fragments
- generate a clean up commit in the community.aws collection
