#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2020 Nathaniel Fitzenrider <https://github.com/nfitzen>
#
# SPDX-License-Identifier: CC0-1.0

PACK_NAME="datapack-template"

version=$(git describe --tags --dirty)

if command -v zip; then
    ZIP="zip -r";
else
    ZIP="7z a";
fi

rm -r .build/
mkdir .build releases .build/files

cp -r data/ ./pack.mcmeta .build/files/

cp -r .reuse/ LICENSE LICENSES/ README.md .build/files

# Currently only implemented for AESTD
# I plan to make this work with any datapack lib in the future and merge JSON

mkdir .build/libs
cp -r libs/AESTD/ .build/libs/

cd .build/

cp -rn libs/AESTD/data/aestd*/ files/data/
rm -rf files/data/aestd.tools/ # kinda inefficient but whatever
cp -rn libs/AESTD/data/load/ files/data/
cp -r libs/AESTD/data/minecraft/loot_tables/ files/data/minecraft/

cd files/

# a hacky workaround since `>` overwrites the file before it's read
(version=$version envsubst < ./pack.mcmeta) > ./pack.mcmeta.tmp && \
    mv ./pack.mcmeta.tmp ./pack.mcmeta

rm ../../releases/$PACK_NAME-$version.zip

$ZIP ../../releases/$PACK_NAME-$version.zip **
