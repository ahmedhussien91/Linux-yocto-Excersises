#!/bin/bash
# Usage: ./parse_config.sh <TARGET>
TARGET="$1"
CONF_FILE="targets.conf"

if [[ -z "$TARGET" ]]; then
    echo "No target specified"
    exit 1
fi

# Extract the section for the target and export variables
in_section=0
while IFS= read -r line; do
    # Start of section
    if [[ "$line" =~ ^\[$TARGET\]$ ]]; then
        in_section=1
        continue
    fi
    # Start of another section
    if [[ "$line" =~ ^\[.*\]$ ]]; then
        in_section=0
    fi
    # If in section, export key=value
    if [[ $in_section -eq 1 && "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
        export "$line"
    fi
done < "$CONF_FILE"