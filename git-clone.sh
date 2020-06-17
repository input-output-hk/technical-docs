#!/bin/bash
git clone https://github.com/input-output-hk/technical-docs.git source

while IFS=" " read -r repo dest remainder; do
    git clone --branch "robcohen/docs" "$repo" "$dest"
done < repo-list.txt
