#!/usr/bin/env bash

set -e

if [ "$#" -ne 1 ]; then
    echo "Error: Missing URL prefix argument." >&2
    echo "Usage: $0 <url_prefix>" >&2
    exit 1
fi

URL_PREFIX="$1"
URL_PREFIX_CLEAN="${URL_PREFIX%/}/"

OUT="aria2-manifest.txt"
echo "# Aria2 manifest generated on $(date)" > "$OUT"
echo "" >> "$OUT"

for file in *; do
    if [ ! -f "$file" ] || [ "$file" == "$OUT" ]; then
        continue
    fi

    HASH=$(sha256sum "$file" | cut -d' ' -f1)
    FULL_URL="${URL_PREFIX_CLEAN}${file}"

    echo "$file: $HASH"

    {
        echo "$FULL_URL"
        echo "  checksum=sha-256=$HASH"
        echo "  out=$file"
        echo ""
    } >> "$OUT"
done
