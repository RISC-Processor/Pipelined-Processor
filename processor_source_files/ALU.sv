moduel ALU (
    input logic [31:0] srcA,
    input logic [31:0] srcB,
    input logic [2:0] ALUControl,
    output logic [31:0] ALUResult
);

assign ALUResult = (ALUOp == 3'b010) ? srcA + srcB ;

endmodule