#!/bin/bash

# Check if there are files matching the pattern
shopt -s nullglob
files=(create_*.sql)
shopt -u nullglob

# Run psql command if matching files exist
if [ ${#files[@]} -gt 0 ]; then
    for file in "${files[@]}"; do
        psql -d postgresql://postgres:edward@localhost:5432/cse132b -f "$file"
    done
else
    echo "No files found matching the pattern create_*.SQL"
fi