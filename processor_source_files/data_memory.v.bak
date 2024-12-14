`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: RISC_Processor
// Engineer: Linuka Ratnayake
// 
// Create Date: 10/03/2024 07:10:57 PM
// Design Name: 
// Module Name: data_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_memory
    #(  
        parameter ADDR_BUS_WIDTH = 32,
        parameter DATA_BUS_WIDTH = 32)
    (
        input clk,
        input [ADDR_BUS_WIDTH - 1:0] addr,
        input [DATA_BUS_WIDTH - 1:0] write_data,
        input write_en,
        output [DATA_BUS_WIDTH - 1:0] read_data
    );
        
    localparam MEM_DEPTH = 64;
    localparam MEM_WIDTH = 8;

    reg [MEM_WIDTH - 1:0] mem [0:MEM_DEPTH - 1];

    assign read_data = {mem[addr], mem[addr + 1], mem[addr + 2], mem[addr + 3]};
	 
	 initial
	 begin
		mem[0] = 8'h00;
		mem[1] = 8'h00;
		mem[2] = 8'h00;
		mem[3] = 8'd10;
	 end

    always @(negedge clk)
    begin
        if(write_en)
        begin
            mem[addr] <= write_data[4 * MEM_WIDTH - 1: 3 * MEM_WIDTH];
            mem[addr + 1] <= write_data[3 * MEM_WIDTH - 1: 2 * MEM_WIDTH];
            mem[addr + 2] <= write_data[2 * MEM_WIDTH - 1: MEM_WIDTH];
            mem[addr + 3] <= write_data[MEM_WIDTH - 1: 0];
        end
    end
    
endmodule
