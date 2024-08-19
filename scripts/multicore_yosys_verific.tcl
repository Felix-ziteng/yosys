# 设置 Verilog 源文件路径
set PROP_PATH /home/felix/Documents/rtl2uspec/multicore_vscale_rtl2uspec_ae/src/main/verilog
# 设置顶层模块名称
set TOP_MOD vscale_sim_top
set GETSTAT 0

# 打印日志信息
yosys log "PROP_PATH ${PROP_PATH}"
yosys log "TOP_MOD ${TOP_MOD}"

# 读取 Verilog 文件

yosys log "--------full processor--------"

# 读取 Verilog 源文件
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

    # 进行层次检查
    yosys hierarchy -check -top ${TOP_MOD};

    # 选择模块
    yosys select -module vscale_core;

    # 执行不同的验证步骤
    yosys log "---------- scc -----------------"
    yosys scc

    yosys log "---------- ltp -----------------"
    yosys ltp

    yosys log "----------- fsm ----------------"
    yosys fsm_detectls

    # 退出脚本
    exit
} else {

    # 进行层次检查
    yosys hierarchy -check -top ${TOP_MOD};

    # 执行处理和优化
    yosys dump -o ./build/dump/${TOP_MOD}rtliil_preproc.txt
    yosys proc  # 替换设计中的过程为 MUXs、FFs、Latches

    if {$GETSTAT == 1} {
        yosys flatten  # 扁平化设计
        yosys stat  # 获取统计信息
        yosys ff_stat  # 获取触发器统计
        exit 
    }

    yosys memory -nomap -nordff  # 处理内存
    yosys stat  # 获取统计信息

    # 设置参数
    set INTRAHBI -a
    set INTERHBI -b

    # 执行 rtl2uspec_cdfg
    yosys "rtl2uspec_cdfg" ${INTRAHBI} ${INTERHBI}
}
