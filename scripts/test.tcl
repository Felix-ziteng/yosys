# set PROP_PATH <path to verilog src>
set PROP_PATH /home/felix/Documents/rtl2uspec/multicore_vscale_rtl2uspec_ae/src/main/verilog
# set TOP_MOD <top design module name>
set TOP_MOD vscale_sim_top
set GETSTAT 0

yosys log "PROP_PATH ${PROP_PATH}";
yosys log "TOP_MOD ${TOP_MOD}";

# 使用 Yosys 的 read_verilog 指令加载 Verilog 文件
yosys log "--------full processor--------"
# full processor verilog lists
yosys read_verilog -sv \
${PROP_PATH}/vscale_sim_top_unmod.v \
${PROP_PATH}/vscale_alu.v \
${PROP_PATH}/vscale_ctrl.v \
${PROP_PATH}/vscale_mul_div.v \
${PROP_PATH}/vscale_regfile.v \
${PROP_PATH}/vscale_core.v \
${PROP_PATH}/vscale_hasti_bridge.v \
${PROP_PATH}/vscale_PC_mux.v \
${PROP_PATH}/vscale_src_a_mux.v \
${PROP_PATH}/vscale_csr_file.v \
${PROP_PATH}/vscale_imm_gen.v \
${PROP_PATH}/vscale_pipeline.v \
${PROP_PATH}/vscale_src_b_mux.v \
${PROP_PATH}/vscale_arbiter.v \
${PROP_PATH}/vscale_multicore_constants.vh \
${PROP_PATH}/vscale_dp_hasti_sram.v \
${PROP_PATH}/vscale_ctrl_constants.vh \
${PROP_PATH}/rv32_opcodes.vh \
${PROP_PATH}/vscale_alu_ops.vh \
${PROP_PATH}/vscale_md_constants.vh \
${PROP_PATH}/vscale_hasti_constants.vh \
${PROP_PATH}/vscale_csr_addr_map.vh

set TEST 0
if {$TEST == 1} {
    # 直接使用 Yosys 指令处理综合后的网表文件
    yosys dump -o ./build/vscale.ilang ; 
    yosys hierarchy -check -top ${TOP_MOD};  
    yosys select -module vscale_core;
    yosys log "---------- scc -----------------"
    yosys scc 
    yosys log "---------- ltp -----------------"
    yosys ltp
    yosys log "----------- fsm ----------------"
    yosys fsm_detectls
    exit
} else {
    # 使用 Yosys 处理综合后的网表文件
    yosys hierarchy -check -top ${TOP_MOD};  

    yosys dump -o ./build/dump/${TOP_MOD}rtliil_preproc.txt;
    yosys proc; # replace processes in the design with MUXs, FFs, Latches

    if {$GETSTAT == 1} {
        yosys flatten;
        yosys stat;
        yosys ff_stat;
        exit; 
    }

    yosys memory -nomap -nordff; 
    yosys stat;
    set INTRAHBI -a
    set INTERHBI -b
    yosys rtl2uspec_cdfg ${INTRAHBI} ${INTERHBI};
}
