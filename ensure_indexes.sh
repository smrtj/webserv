#!/bin/bash
# Copy default index page to each html subdirectory if missing

set -e
TEMPLATE="$(dirname "$0")/index_template.html"
HTML_DIR="$(dirname "$0")/html"

for dir in "$HTML_DIR"/*; do
    [ -d "$dir" ] || continue
    target="$dir/index.html"
    if [ ! -f "$target" ]; then
        cp "$TEMPLATE" "$target"
        echo "Created $target"
    fi
done
