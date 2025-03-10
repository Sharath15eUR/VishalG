#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 <source_directory> <backup_directory> <file_extension>"
    exit 1
fi

SRC_DIR="$1"
BACKUP_DIR="$2"
FILE_EXT="$3"

if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR" || { echo "Failed to create backup directory"; exit 1; }
fi

FILES=("$SRC_DIR"/*"$FILE_EXT")

if [ ! -e "${FILES[0]}" ]; then
    echo "No files with extension $FILE_EXT found in $SRC_DIR"
    exit 1
fi

export BACKUP_COUNT=0
TOTAL_SIZE=0

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then  # Only process regular files
        FILENAME=$(basename "$file")
        DEST_FILE="$BACKUP_DIR/$FILENAME"

        # Check if file exists in backup directory and compare timestamps
        if [ -e "$DEST_FILE" ] && [ "$file" -ot "$DEST_FILE" ]; then
            echo "Skipping $FILENAME (backup is newer)"
            continue
        fi

        cp "$file" "$DEST_FILE"
        echo "Copied: $FILENAME"

        FILE_SIZE=$(stat -c%s "$file")
        TOTAL_SIZE=$((TOTAL_SIZE + FILE_SIZE))
        ((BACKUP_COUNT++))
    fi
done

REPORT_FILE="$BACKUP_DIR/backup_report.log"
echo "Backup Report" > "$REPORT_FILE"
echo "Total files backed up: $BACKUP_COUNT" >> "$REPORT_FILE"
echo "Total size: $TOTAL_SIZE bytes" >> "$REPORT_FILE"
echo "Backup location: $BACKUP_DIR" >> "$REPORT_FILE"

echo "Backup completed successfully. Report saved at: $REPORT_FILE"

