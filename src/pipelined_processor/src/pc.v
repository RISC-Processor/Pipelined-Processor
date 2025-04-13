module pc
    #(parameter BUS_WIDTH = 16)
    (
//		output [7: 0] LEDG,
		input stall,
        input clk,
		input rst,
      input [BUS_WIDTH - 1:0] pc_next,
        output reg [BUS_WIDTH - 1:0] pc
    );
	 
	 initial
	 begin
		  pc = 16'h0000;
	 end
    
    always @(posedge clk) begin
		if (~rst) begin 
			pc <= 0;
		end else begin
			if (!stall) begin
				pc <= pc_next;
			end else begin
				pc <= pc;
			end
		end
	 end
	
//	assign LEDG = pc[7: 0];
endmodule
