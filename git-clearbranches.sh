#!/bin/bash

if [ "$1" = '' ] ; then
    basebranch="master"
else
    basebranch="$1"
fi
git checkout $basebranch
git fetch
echo "pruning remote branches..."
git remote prune origin
# remove all local branches merged into master

for branch in $(git branch --merged $basebranch | grep -v 'master$') ; do
    echo "removing $branch"
    git branch -d $branch
done
