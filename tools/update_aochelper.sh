#!/bin/bash

REPO_URL="https://github.com/linderlake/AoCHelper.git"
CLONE_DIR="/home/vscode/AoCHelper"

if ! git ls-remote "$REPO_URL" &>/dev/null; then
    echo "-> Failed to access the repository. Check your SSH keys for repo $REPO_URL"
    exit 1
fi

if [ ! -d "$CLONE_DIR" ]; then
    echo "AoCHelper not found, cloning..."
    git clone "$REPO_URL" "$CLONE_DIR" || echo "-> Failed to clone AoCHelper"
fi

echo "Updating AoCHelper..."
git -C "$CLONE_DIR" pull || echo "-> Failed to update AoCHelper"

echo "Verifying symlinks..."
mkdir -p ../lib/AocHelper
if [ ! -L "../lib/AocHelper/libAoCHelper.a" ]; then
    echo "Creating symlink to libAoCHelper.a"
    ln -s "$CLONE_DIR/build/libAoCHelper.a" ../lib/AocHelper/libAoCHelper.a
fi

mkdir -p ../lib/AocHelper/include

if [ ! -L "../lib/AocHelper/include/AoCHelper.h" ]; then
    echo "Creating symlink to AoCHelper.h"
    ln -s "$CLONE_DIR/src/AoCHelper.h" ../lib/AocHelper/include/AoCHelper.h
fi

if [ ! -L "../lib/AocHelper/include/helper_functions.h" ]; then
    echo "Creating symlink to helper_functions.h"
    ln -s "$CLONE_DIR/src/helper_functions.h" ../lib/AocHelper/include/helper_functions.h
fi
