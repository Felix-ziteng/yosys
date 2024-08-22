#!/bin/bash

MAKEFILE="Makefile.revised"

sed -i 's|/home/yosys_include|/usr/local/share/yosys/include|g' "$MAKEFILE"

sed -i 's|-DYOSYS_ENABLE_COVER -o ./build/obj/$(SRC).so|-DYOSYS_ENABLE_COVER|g' "$MAKEFILE"

sed -i 's|-std=c++11|-std=c++17|g' "$MAKEFILE"

echo "fix done"
