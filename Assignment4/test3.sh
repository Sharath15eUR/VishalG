#!/bin/bash

INPUT_FILE="$1"
OUTPUT_FILE="$2"

> "$OUTPUT_FILE"

while IFS= read -r line; do
    if echo "$line" | grep -qE '"frame.time"|"wlan.fc.type"|"wlan.fc.subtype"'; then
        echo "$line" >> "$OUTPUT_FILE"
    fi
done < "$INPUT_FILE"

echo "Filtering complete. Only specific keys are saved in $OUTPUT_FILE."

