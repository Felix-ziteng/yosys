#!/bin/bash

SEARCH_DIR="src_revised"

OLD_INCLUDE='#include "backends/ilang/ilang_backend.h"'
NEW_INCLUDE='#include "/usr/share/yosys/include/backends/ilang/ilang_backend.h"'


find "$SEARCH_DIR" -type f -exec sed -i "s|$OLD_INCLUDE|$NEW_INCLUDE|g" {} +

echo "fix2 done"
