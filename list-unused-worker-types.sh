#!/bin/bash

remote=git://github.com/mozilla/gecko-dev
repo=/tmp/gecko-dev

echo "Getting list of worker types..."
worker_types=$(python get-worker-types.py)

if [ -d $repo/.git ]; then
    pushd $repo > /dev/null
    echo "Updating repository..."
    git fetch -q origin
    popd > /dev/null
else
    echo "Cloning repository..."
    rm -rf $repo
    git clone -q $remote $repo
fi

echo "Listing worker types not used..."
echo

pushd $repo > /dev/null
for i in $worker_types; do
    if ! git for-each-ref --format='%(refname)' \
        | egrep -iv 'RELBRANCH|RELEASE|MERGEDAY|B2G|esr[0-9]+|loop-ser|tiling' \
        | grep origin \
        | awk '{print $0":taskcluster"}' \
        | xargs git grep -q $i; then
        echo $i
    fi
done
popd > /dev/null

echo
echo "Done!"
