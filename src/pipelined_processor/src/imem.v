///////////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module imem
    #(  
      parameter ADDR_BUS_WIDTH = 16,
      parameter DATA_BUS_WIDTH = 32
    )
    (
        input [ADDR_BUS_WIDTH - 1:0] a,
        output  [DATA_BUS_WIDTH - 1:0] rd,
//		  output [7: 0] LEDR,
		  input enable, 
		  input [7: 0] instIn
		  
    );

    localparam MEM_DEPTH = 2 ** (ADDR_BUS_WIDTH-9);
    localparam MEM_WIDTH = 8;
      
    reg [MEM_WIDTH - 1:0] memory[MEM_DEPTH - 1:0];
    

	 integer i; // Loop variable

    initial begin
//         Initialize all memory locations to addi
         for (i = 0; i < 126; i = i + 4) begin
             memory[i] = 8'h00;
             memory[i+1] = 8'h00;
             memory[i+2] = 8'h00;
             memory[i+3] = 8'h13;
         end

//        for(i = 0; i < 64; i = i + 1) begin
//            memory[i] = 8'h00;
//        end





        memory[0]  = 8'h00; // NOP
        memory[1]  = 8'h00;
        memory[2]  = 8'h00;
        memory[3]  = 8'h13;

        memory[4]  = 8'h00; // NOP
        memory[5]  = 8'h00;
        memory[6]  = 8'h00;
        memory[7]  = 8'h13;

        memory[8]  = 8'h00; // NOP
        memory[9]  = 8'h00;
        memory[10] = 8'h00;
        memory[11] = 8'h13;

        memory[12] = 8'h00; // NOP
        memory[13] = 8'h00;
        memory[14] = 8'h00;
        memory[15] = 8'h13;


        //add x2 , x1,   x0
        memory[16] = 8'h00; 
        memory[17] = 8'h00;
        memory[18] = 8'h81;
        memory[19] = 8'h33;

        //add x3 , x2,   x0
        memory[20]  = 8'h00;
        memory[21]  = 8'h01;
        memory[22]  = 8'h01;
        memory[23]  = 8'hb3;

        //add x4 , x3,   x0
        memory[24]  = 8'h00; 
        memory[25]  = 8'h02;
        memory[26]  = 8'h02;
        memory[27]  = 8'hb3;

        //add x5 , x4,   x0
        memory[28]  = 8'h00; 
        memory[29]  = 8'h02;
        memory[30]  = 8'h83;
        memory[31]  = 8'h33;

        //add x6 , x5,   x0
        memory[32]  = 8'h00; 
        memory[33]  = 8'h03;
        memory[34]  = 8'h03;
        memory[35]  = 8'hb3;

        //add x7 , x6,   x0
        memory[36]  = 8'h00; 
        memory[37]  = 8'h00;
        memory[38]  = 8'h00;
        memory[39]  = 8'h13;
        
        // Assign the specific memory values
        // lw x6 -4(x9)
        memory[40]  = 8'h00;
        memory[41]  = 8'h03;
        memory[42]  = 8'h03;
        memory[43]  = 8'hb3;

        // sw x6, 8(x9)
        memory[44]  = 8'h00;
        memory[45]  = 8'h03;
        memory[46] = 8'h84;
        memory[47] = 8'h33;

        // or x4, x5, x6
        memory[48] = 8'h00;
        memory[49] = 8'h62;
        memory[50] = 8'hE2;
        memory[51] = 8'h33;

        // beq x4, x4, 24 = ff5ff06f
        memory[52] = 8'hff;  
        memory[53] = 8'h5f;
        memory[54] = 8'hf0;  
        memory[55] = 8'h6f;  
        
        ///////// dummy
        memory[56] = 8'h01;  
        memory[57] = 8'h01;
        memory[58] = 8'h01;  
        memory[59] = 8'h01;  
                
                
        ///////// dummy
        memory[60] = 8'h01;  
        memory[61] = 8'h01;
        memory[62] = 8'h01;  
        memory[63] = 8'h01;  


        ///////// dummy
        memory[64] = 8'h01;  
        memory[65] = 8'h01;
        memory[66] = 8'h01;  
        memory[67] = 8'h01;  
                
                
        ///////// dummy
        memory[68] = 8'h01;  
        memory[69] = 8'h01;
        memory[70] = 8'h01;  
        memory[71] = 8'h01;  

        ///////// dummy
        memory[72] = 8'h01; 
        memory[73] = 8'h01;
        memory[74] = 8'h01; 
        memory[75] = 8'h01; 


        // memory[76] = 8'h01; 
        // memory[77] = 8'h01;
        // memory[78] = 8'h01; 
        // memory[79] = 8'h01; 


        // // or x4, x5, x6
        // memory[64] = 8'h00;
        // memory[65] = 8'h62;
        // memory[66] = 8'hE2;
        // memory[67] = 8'h33;

        // // Addi x12, x5(17)
        // memory[68] = 8'h01;
        // memory[69] = 8'h12;
        // memory[70] = 8'h86;
        // memory[71] = 8'h13;

        // // lui x7, 4560
        // memory[72] = 8'h01;
        // memory[73] = 8'h1d;
        // memory[74] = 8'h03;
        // memory[75] = 8'hb7;

        // jal x2, -40
        memory[76] = 8'hfd;
        memory[77] = 8'h9f;
        memory[78] = 8'hf1;
        memory[79] = 8'h6f;
    end
        
//  assign LEDG = memory[5];
    assign rd = {memory[a], memory[a + 1], memory[a + 2], memory[a + 3]};

	 reg [6: 0] j = 0;
	 
	 always @(posedge enable) begin
			memory[j] <= instIn;
			j <= j + 1;
	 end
	 
//	 assign LEDR = memory[0];
	 
endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////////////


// `timescale 1ns / 1ps
//
// module imem
//     #(  
//       parameter ADDR_BUS_WIDTH = 16,
//       parameter DATA_BUS_WIDTH = 32
//     )
//     (
//         input [ADDR_BUS_WIDTH - 1:0] a,
//         output  [DATA_BUS_WIDTH - 1:0] rd,
// 		  //output [7: 0] LEDR,
// 		  input enable, 
// 		  input [7: 0] instIn
//		  
//     );
//
//     localparam MEM_DEPTH = 2 ** (ADDR_BUS_WIDTH-9);
//     localparam MEM_WIDTH = 8;
//      
//     reg [MEM_WIDTH - 1:0] memory[MEM_DEPTH - 1:0];
//    
//
// 	 integer i; // Loop variable
//
//     initial begin
// //         Initialize all memory locations to addi
//          for (i = 0; i < 126; i = i + 4) begin
//              memory[i] = 8'h00;
//              memory[i+1] = 8'h00;
//              memory[i+2] = 8'h00;
//              memory[i+3] = 8'h13;
//          end
//
// //        for(i = 0; i < 64; i = i + 1) begin
// //            memory[i] = 8'h00;
// //        end
//
//         memory[0]  = 8'h00; // NOP
//         memory[1]  = 8'h00;
//         memory[2]  = 8'h00;
//         memory[3]  = 8'h13;
//
//         memory[4]  = 8'h00; // NOP
//         memory[5]  = 8'h00;
//         memory[6]  = 8'h00;
//         memory[7]  = 8'h13;
//
//         memory[8]  = 8'h00; // NOP
//         memory[9]  = 8'h00;
//         memory[10] = 8'h00;
//         memory[11] = 8'h13;
//
//         memory[12] = 8'h00; // NOP
//         memory[13] = 8'h00;
//         memory[14] = 8'h00;
//         memory[15] = 8'h13;
//
//         memory[16] = 8'h00; // NOP
//         memory[17] = 8'h00;
//         memory[18] = 8'h00;
//         memory[19] = 8'h13;
//
//        
//         // Assign the specific memory values
//         // lw x6 -4(x9)
//         memory[20]  = 8'hFF;
//         memory[21]  = 8'hC4;
//         memory[22]  = 8'hA3;
//         memory[23]  = 8'h03;
//
//         // sw x6, 8(x9)
//         memory[24]  = 8'h00;
//         memory[25]  = 8'h64;
//         memory[26] = 8'hA4;
//         memory[27] = 8'h23;
//
//         // or x4, x5, x6
//         memory[28] = 8'h00;
//         memory[29] = 8'h62;
//         memory[30] = 8'hE2;
//         memory[31] = 8'h33;
//
//         // beq x4, x4, 24
//         memory[32] = 8'h00;  // 8'hFE;
//         memory[33] = 8'h42;
//         memory[34] = 8'h0C;  // 8'h0A;
//         memory[35] = 8'h63;  // 8'hE3;
//        
//         ///////// dummy
//         memory[36] = 8'h01;  // 8'hFE;
//         memory[37] = 8'h01;
//         memory[38] = 8'h01;  // 8'h0A;
//         memory[39] = 8'h01;  // 8'hE3;
//                
//                
//         ///////// dummy
//         memory[40] = 8'h01;  // 8'hFE;
//         memory[41] = 8'h01;
//         memory[42] = 8'h01;  // 8'h0A;
//         memory[43] = 8'h01;  // 8'hE3;
//
//
//
//
//         // or x4, x5, x6
//         memory[56] = 8'h00;
//         memory[57] = 8'h62;
//         memory[58] = 8'hE2;
//         memory[59] = 8'h33;
//
//         // Addi x12, x5(17)
//         memory[60] = 8'h01;
//         memory[61] = 8'h12;
//         memory[62] = 8'h86;
//         memory[63] = 8'h13;
//
//         // lui x7, 4560
//         memory[64] = 8'h01;
//         memory[65] = 8'h1d;
//         memory[66] = 8'h03;
//         memory[67] = 8'hb7;
//
//         // jal x2, -40
//         memory[68] = 8'hfd;
//         memory[69] = 8'h9f;
//         memory[70] = 8'hf1;
//         memory[71] = 8'h6f;
//     end
//        
// //  assign LEDG = memory[5];
//     assign rd = {memory[a], memory[a + 1], memory[a + 2], memory[a + 3]};
//
// 	 reg [6: 0] j = 0;
//	 
// 	 always @(posedge enable) begin
// 			memory[j] <= instIn;
// 			j <= j + 1;
// 	 end
//	 
// 	 //assign LEDR = memory[0];
//	 
// endmodule


