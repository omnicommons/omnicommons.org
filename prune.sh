#!/bin/bash

# always execute in THIS dir
self=$(readlink -e "$0") || exit 1
self=$(dirname "${self}") || exit 1
cd "$self"

# print the names of files which aren't linked to anywhere
find . \( -path './.git' -prune -o -true \) -type f -iregex '.*\.\(jpe?g\|png\|svg\)$' | \
    while read; do
        grep -rq "${REPLY#*/}" . || echo "Unlinked file: ${REPLY}"
    done
