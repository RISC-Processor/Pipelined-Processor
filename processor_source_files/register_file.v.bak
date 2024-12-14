module register_file
    #(
        parameter ADDR_BUS_WIDTH = 5,
        parameter DATA_BUS_WIDTH = 32
    )
    (
        input clk,
        input [ADDR_BUS_WIDTH - 1:0] addr1,
        input [ADDR_BUS_WIDTH - 1:0] addr2,
        input [ADDR_BUS_WIDTH - 1:0] addr3,
        input [DATA_BUS_WIDTH - 1:0] write_data,
        input write_en,
        output [DATA_BUS_WIDTH - 1:0] read_data1,
        output [DATA_BUS_WIDTH - 1:0] read_data2
    );

    localparam MEM_DEPTH = 32;

    reg [DATA_BUS_WIDTH - 1:0] mem [0:MEM_DEPTH - 1];
    
    // Register 0 is always 0.
    assign read_data1 = addr1 == 5'b00000 ? {32{1'b0}} : mem[addr1];
    assign read_data2 = addr2 == 5'b00000 ? {32{1'b0}} : mem[addr2];
	 
	initial
	begin
        mem[5] = 32'h00000006;
        mem[9] = 32'h00002004;
	end

    always @(negedge clk)
    begin
        if(write_en)
        begin
            mem[addr3] <= write_data;
        end
    end

endmodule