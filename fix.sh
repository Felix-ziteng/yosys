#!/bin/bash

FIX_DIR="./fix"

for script in fix1.sh fix2.sh fix3.sh; do
    if [ -f "$FIX_DIR/$script" ]; then
        echo "Running $script..."
        bash "$FIX_DIR/$script"
    else
        echo "Error: $FIX_DIR/$script not found."
        exit 1
    fi
done

echo "All scripts executed successfully."