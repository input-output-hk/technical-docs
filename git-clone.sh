#!/bin/bash

# Clone cardano-tutorials
git clone --depth=1 --branch "robcohen/docs" https://github.com/input-output-hk/cardano-tutorials.git source/cardano-tutorials
rm -rf source/cardano-tutorials/.git

while IFS=" " read -r name repo remainder; do
    git clone --depth=1 --branch "robcohen/docs" "$repo" "git/$name"
    mkdir -p "source/cardano-components/$name"
    mv "git/$name/doc" "source/cardano-components/$name/doc"
    mv "git/$name/README.rst" "source/cardano-components/$name/"
    rm -rf git
done < repo-list.txt
