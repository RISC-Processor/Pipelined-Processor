module processor
    #(  
        parameter BUS_WIDTH = 32
    )
    (input wire clk);
    
    localparam DATA_MEMORY_ADDR_BUS_WIDTH = 32;
    localparam DATA_MEMORY_DATA_BUS_WIDTH = 32;
    localparam REG_FILE_ADDR_BUS_WIDTH = 5;
    localparam REG_FILE_DATA_BUS_WIDTH = 32;
    localparam INST_MEMORY_ADDR_BUS_WIDTH = 16;
    localparam INST_MEMORY_DATA_BUS_WIDTH = 32;
     
    // Wires for module instantiation, and connections
    wire [INST_MEMORY_ADDR_BUS_WIDTH - 1:0] pc_out;
    wire [INST_MEMORY_ADDR_BUS_WIDTH - 1:0] pc_4;
    wire [INST_MEMORY_DATA_BUS_WIDTH - 1:0] instr;
    wire [BUS_WIDTH - 1:0] imm_ext;
    wire [DATA_MEMORY_ADDR_BUS_WIDTH - 1:0] alu_result;
    wire [DATA_MEMORY_DATA_BUS_WIDTH - 1:0] read_data;
    wire [REG_FILE_DATA_BUS_WIDTH - 1:0] read_data_1;
    wire [REG_FILE_DATA_BUS_WIDTH - 1:0] read_data_2;
    wire [REG_FILE_DATA_BUS_WIDTH - 1:0] write_data;
    wire [BUS_WIDTH - 1:0] src_a;
    wire [BUS_WIDTH - 1:0] src_b;
    wire [BUS_WIDTH - 1:0] pc_target;
    wire [BUS_WIDTH - 1:0] pc_next;

    wire zero;
    wire pc_src;
    wire [1:0] result_src;
    wire mem_write;
    wire [2:0] alu_control;
    wire alu_src;
    wire [2:0] imm_src;
    wire reg_write;

    assign src_a = read_data_1;
    assign src_b = alu_src ? imm_ext : read_data_2;
    assign write_data = result_src == 2'b00 ? alu_result : (result_src == 2'b01 ? read_data : {{BUS_WIDTH - INST_MEMORY_ADDR_BUS_WIDTH{1'b0}}, pc_4});
    assign pc_next = pc_src ? pc_target[INST_MEMORY_ADDR_BUS_WIDTH - 1:0] : pc_4;

    // Instantiate control module
    control # (BUS_WIDTH) control_inst (
        .zero(zero),
        .instr(instr),
        .pc_src(pc_src),
        .result_src(result_src),
        .mem_write(mem_write),
        .alu_control(alu_control),
        .alu_src(alu_src),
        .imm_src(imm_src),
        .reg_write(reg_write)
    );

    // Instantiate program counter
    pc # (INST_MEMORY_ADDR_BUS_WIDTH) pc_inst (
        .clk(clk),
        .pc_next(pc_next),
        .pc(pc_out)
    );

    // Instantiate adder for adding 4 to pc
    adder # (INST_MEMORY_ADDR_BUS_WIDTH) adder_inst1 (
        .a(pc_out),
        .b({{12{1'b0}}, 4'b0100}),
        .y(pc_4)
    );

    // Instantiate adder for adding pc and imm_ext
    adder # (BUS_WIDTH) adder_inst2 (
        .a({{BUS_WIDTH - INST_MEMORY_ADDR_BUS_WIDTH{1'b0}}, pc_out}),
        .b(imm_ext),
        .y(pc_target)
    );
    
    // Instantiate instruction memory module
    imem # (INST_MEMORY_ADDR_BUS_WIDTH, INST_MEMORY_DATA_BUS_WIDTH) imem_inst (
        .a(pc_out),
        .rd(instr)
    );

    // Insntiate register_file module
    register_file #(REG_FILE_ADDR_BUS_WIDTH, REG_FILE_DATA_BUS_WIDTH) register_file_inst (
        .clk(clk),
        .addr1(instr[19:15]),
        .addr2(instr[24:20]),
        .addr3(instr[11:7]),
        .write_data(write_data),
        .write_en(reg_write),
        .read_data1(read_data_1),
        .read_data2(read_data_2)
    );

    // Insntiate extend module
    extend #(BUS_WIDTH) extend_inst (
        .imm_src(imm_src),
        .instr(instr),
        .extended_imm(imm_ext)
    );

    // Insntiate alu module
    alu #(BUS_WIDTH) alu_inst (
        .src_a(src_a),
        .src_b(src_b),
        .alu_op(alu_control),
        .alu_result(alu_result),
        .zero(zero)
    );

    // Insntiate data_memory module
    data_memory #(DATA_MEMORY_ADDR_BUS_WIDTH, DATA_MEMORY_DATA_BUS_WIDTH) data_memory_inst (
        .clk(clk),
        .addr(alu_result),
        .write_data(read_data_2),
        .write_en(mem_write),
        .read_data(read_data)
    );
endmodule