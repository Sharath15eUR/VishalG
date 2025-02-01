#!/bin/bash

echo "Executable file: $0"

directory=""
keyword=""
list=()
found_list=()

for arg in "$@"; do
    if [[ "$arg" == "--help" ]]; then
        cat help.txt
    fi
done

while getopts ":d:k:" opt; do
    case "$opt" in
        d)
            directory="$OPTARG"
            ;;
        k)
            keyword="$OPTARG"
            ;;
esac
done

if [[ -z "$directory" || -z "$keyword" ]]; then
    echo "Error: Both -d <directory> and -k <keyword> are required." > error.log
    exit 1
fi

if [[ ! -d "$directory" ]]; then
    echo "Error: No such directory '$directory'" > error.log
    exit 1
fi


recur() {
    local dir="$1"

    # Loop through files and directories
    for file in "$dir"/*; do
        if [[ -d "$file" ]]; then
            recur "$file"
        elif [[ -f "$file" ]]; then
            list+=("$file")
            if grep -q "$keyword" "$file"; then
		found_list+=("$file")
                echo "Keyword found in: $file"
            fi
        fi

    done
}


recur "$directory"


echo "List of searched files:"
for file in "${list[@]}"; do
    echo "$file"
done

if [ ${#found_list[@]} -eq 0 ]; then
echo "Keyword not found in $directory" > error.log
fi  
