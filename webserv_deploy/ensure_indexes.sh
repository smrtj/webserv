#!/bin/bash

# ensure_indexes.sh - Ensure default index.html is present for each subdomain
# Copies assets/index_template.html into each subdomain's public_html directory
# if index.html is missing. Existing files containing the signature <img> line
# are skipped to preserve custom content.

set -e

TEMPLATE="$(dirname "$0")/../assets/index_template.html"
WEBROOT="$(dirname "$0")/../html"

if [ ! -f "$TEMPLATE" ]; then
    echo "Template $TEMPLATE not found" >&2
    exit 1
fi

for dir in "$WEBROOT"/*/public_html; do
    [ -d "$dir" ] || continue
    index="$dir/index.html"

    if [ -f "$index" ]; then
        if grep -q '<img.*cto\.sig\.png' "$index"; then
            echo "Skipping $index (signature present)"
            continue
        else
            echo "Skipping $index (custom content)"
            continue
        fi
    fi

    cp "$TEMPLATE" "$index"
    echo "Created $index"
done

