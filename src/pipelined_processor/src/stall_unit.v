module stall_unit (
    input  wire [31:0] IF_ID_instr,
    input  wire [31:0] ID_EX_instr,
    input  wire [31:0] EX_MEM_instr,
    input  wire [31:0] MEM_WB_instr,
    output wire        stall
);
    wire [4:0] RSd = IF_ID_instr[19:15];
    wire [4:0] RTd = IF_ID_instr[24:20];

    wire RE1d, RE2d;

    wire [4:0] WSe = ID_EX_instr[11:7];
    wire [4:0] WSm = EX_MEM_instr[11:7];
    wire [4:0] WSw = MEM_WB_instr[11:7];

    wire WEe, WEm, WEw;

    wire IF_ID_instr_is_nop, IF_ID_instr_is_zeros, ID_EX_instr_is_nop, ID_EX_instr_is_zeros, EX_MEM_instr_is_nop, EX_MEM_instr_is_zeros, MEM_WB_instr_is_nop, MEM_WB_instr_is_zeros;

    // Instantiate the RE module for IF_ID_instr
    RE RE1 (
        .instrOp(IF_ID_instr[6:0]),
        .re1(RE1d),
        .re2(RE2d)
    );

    // Instantiate the WE module for various stages
    WE WE1 (
        .instrOp(ID_EX_instr[6:0]),
        .we(WEe)
    );
    WE WE2 (
        .instrOp(EX_MEM_instr[6:0]),
        .we(WEm)
    );
    WE WE3 (
        .instrOp(MEM_WB_instr[6:0]),
        .we(WEw)
    );

    
    assign IF_ID_instr_is_nop = IF_ID_instr    == 32'b00000000000000000000000000010011;
    assign IF_ID_instr_is_zero = IF_ID_instr   == 32'b00000000000000000000000000000000;
    assign ID_EX_instr_is_nop = ID_EX_instr    == 32'b00000000000000000000000000010011;
    assign ID_EX_instr_is_zero = ID_EX_instr   == 32'b00000000000000000000000000000000;
    assign EX_MEM_instr_is_nop = EX_MEM_instr  == 32'b00000000000000000000000000010011;
    assign EX_MEM_instr_is_zero = EX_MEM_instr == 32'b00000000000000000000000000000000;
    assign MEM_WB_instr_is_nop = MEM_WB_instr  == 32'b00000000000000000000000000010011;
    assign MEM_WB_instr_is_zero = MEM_WB_instr == 32'b00000000000000000000000000000000;

    assign nop_or_zero = IF_ID_instr_is_nop || IF_ID_instr_is_zero || ID_EX_instr_is_nop || ID_EX_instr_is_zero || EX_MEM_instr_is_nop || EX_MEM_instr_is_zero || MEM_WB_instr_is_nop || MEM_WB_instr_is_zero;
    // Stall logic
    assign stall = 
        ((RSd == WSe) && WEe && (RE1d || RE2d)) && !nop_or_zero || 
        ((RSd == WSm) && WEm && (RE1d || RE2d)) && !nop_or_zero || 
        ((RSd == WSw) && WEw && (RE1d || RE2d)) && !nop_or_zero || 
        ((RTd == WSe) && WEe && (RE1d || RE2d)) && !nop_or_zero || 
        ((RTd == WSm) && WEm && (RE1d || RE2d)) && !nop_or_zero || 
        ((RTd == WSw) && WEw && (RE1d || RE2d)) && !nop_or_zero ;

//    assign stall = 0;

    // assign stall = (RSd == WSe) && !IF_ID_instr_is_nop && !IF_ID_instr_is_zero || 
    //                (RSd == WSm) && !IF_ID_instr_is_nop && !IF_ID_instr_is_zero || 
    //                (RSd == WSw) && !IF_ID_instr_is_nop && !IF_ID_instr_is_zero || 
    //                (RTd == WSe) && !IF_ID_instr_is_nop && !IF_ID_instr_is_zero || 
    //                (RTd == WSm) && !IF_ID_instr_is_nop && !IF_ID_instr_is_zero || 
    //                (RTd == WSw) && !IF_ID_instr_is_nop && !IF_ID_instr_is_zero ;

//    assign stall = 1;
endmodule

module RE (
    input wire [6:0] instrOp,
    output reg re1,
    output reg re2
);
    always @(*) begin
        case (instrOp)
            7'd3: begin       // lw (I type)
                re1 = 1;
                re2 = 0;
            end
            7'd35: begin      // sw (S type)
                re1 = 1;
                re2 = 1;
            end
            7'd51: begin      // R-type (e.g., or)
                re1 = 1;
                re2 = 1;
            end
            7'd99: begin      // beq (B type)
                re1 = 1;
                re2 = 1;
            end
            7'd19: begin      // addi (I type)
                re1 = 1;
                re2 = 0;
            end
            7'd111: begin     // jal (J type)
                re1 = 0;
                re2 = 0;
            end
            7'd55: begin      // lui (U type)
                re1 = 0;
                re2 = 0;
            end
            default: begin
                re1 = 0;
                re2 = 0;
            end
        endcase
    end
endmodule

module WE (
    input wire [6:0] instrOp,
    output reg we
);
    always @(*) begin
        case (instrOp)
            7'd3: begin       // lw (I type)
                we = 1;
            end
            7'd35: begin      // sw (S type)
                we = 0;
            end
            7'd51: begin      // R-type (e.g., or)
                we = 1;
            end
            7'd99: begin      // beq (B type)
                we = 0;
            end
            7'd19: begin      // addi (I type)
                we = 1;
            end
            7'd111: begin     // jal (J type)
                we = 1;
            end
            7'd55: begin      // lui (U type)
                we = 1;
            end
            default: begin
                we = 0;
            end
        endcase
    end
endmodule
