module datapath(input  logic        clk, reset,
                input  logic [1:0] memtoreg,
                input  logic       pcsrc, alusrc,
                input  logic       regwrite,
                input  logic       immrsrc,
                input  logic [2:0] alucontrol,
                input  logic       zero,
                output logic [31:0] pc,
                input  logic [31:0] instr,
                output logic [31:0] aluresult, writedata,
                input  logic [31:0] readdata);

logic [4:0]  writereg;
logic [31:0] pcnext, pcplus4, pcbranch;
logic [31:0] srca, srcb, result;
logic [31:0] immext;

// next PC logic
flopr #(32) pcreg(clk, reset, pcnext, pc);
adder pcadd4(pc, 32'd4, pcplus4);
adder pcaddbranch(immext, pc, pcbranch);
mux2 #(32) pcsrcmux(pcplus4, pcbranch, pcsrc, pcnext);

// register file logic
regfile rf(clk, regwrite, instr[19:15], instr[24:20],
           writereg, result, srca, writedata);
mux2 #(32) srcbmux(writedata, immext, alusrc, srcb);
immextnd immextunit(instr[31:7], immrsrc, immext);

// ALU logic
alu alu(srca, srcb, alucontrol, aluresult, zero);
mux3 #(32) resmux(aluresult, readdata, pcplus4, memtoreg, result);

endmodule
