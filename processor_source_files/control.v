module control
    #(parameter INSTR_WIDTH = 32)
    (
        input zero,
        input [INSTR_WIDTH - 1: 0] instr,
        output pc_src,
        output [1:0] result_src,
        output mem_write,
        output [2:0] alu_control,
        output alu_src,
        output [2:0] imm_src,
        output reg_write
    );

    wire [6:0] opcode = instr[6:0];
    wire [6:0] funct7 = instr[31:25];
    wire [2:0] funct3 = instr[14:12];

    wire [1:0] alu_op;

    wire branch;
    wire jump;

    control_main_decoder control_main_decoder_inst (
        .opcode(opcode),
        .branch(branch),
        .result_src(result_src),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .imm_src(imm_src),
        .reg_write(reg_write),
        .alu_op(alu_op),
        .jump(jump)
    );

    control_alu_decoder control_alu_decoder_inst (
        .opcode(opcode),
        .funct7_5(funct7[5]),
        .funct3(funct3),
        .alu_op(alu_op),
        .alu_control(alu_control)
    );

    reg pc_src_reg;

    always @(*) begin
        if (jump)
            pc_src_reg = 1'b1;
        else
            pc_src_reg = zero & branch;
    end
    
    assign pc_src = pc_src_reg;

endmodule