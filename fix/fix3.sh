#!/bin/bash
cp -rf ./fix/*.h ./src_revised/.
cp -rf ./fix/*.v ../multicore_vscale_rtl2uspec_ae/src/main/verilog/.
cp -rf ./fix/*.tcl ./scripts/.

echo "fix3 done"


