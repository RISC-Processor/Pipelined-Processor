`timescale 1ns / 1ps

module pc_tb
	# (parameter BUS_WIDTH = 16);
	
	  reg clk = 1'b0;
	  wire [BUS_WIDTH - 1:0] pc_next;
	  wire [BUS_WIDTH - 1:0] pc;

	  // Clock generation
	  always begin
         #10 clk = ~clk;
     end
	  
	  pc # (BUS_WIDTH) pc_inst (
	      .clk(clk),
			.pc_next(pc_next),
			.pc(pc)
	  );
	  
	  adder # (BUS_WIDTH) adder_inst (
		   .a(pc),
			.b({{12{1'b0}}, 4'b0100}),
			.y(pc_next)
	  );
	 
endmodule