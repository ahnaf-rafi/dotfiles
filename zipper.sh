#!/bin/bash
# Create a dated zip of the project.
# Excludes git, results, and tmp directories.
# Run from project root: bash zipper.sh

OUTFILE="dotfiles_$(date +%Y%m%d)_$(date +%H%M%S).zip"

zip -r "$OUTFILE" . \
    --exclude ".git/*" \
    --exclude "*.zip" \
    --exclude "*tmp*"

echo "Written to $OUTFILE"
