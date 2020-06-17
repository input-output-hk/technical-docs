#!/bin/bash
while IFS=" " read -r repo dest remainder; do
    git clone --branch "robcohen/docs" "$repo" "$dest"
done < repo-list.txt
